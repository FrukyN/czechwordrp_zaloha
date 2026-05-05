ESX = exports["es_extended"]:getSharedObject()
local currentApplications = {}
local examInProgress = false
local currentQuestionIndex = 1
local examAnswers = {}
local examQuestions = {}
local replacementNPC = nil
local currentLicenseDisplay = nil


-- Initialize targets when resource starts
Citizen.CreateThread(function()
    spawnReplacementNPC()
    
    for _, location in pairs(WeaponLicenseConfig.ApplicationLocations) do
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = location.size,
            rotation = location.rotation,
            debug = location.debug,
            options = {
                {
                    name = 'weapon_license_application',
                    icon = 'fas fa-clipboard',
                    label = _U('weapon_license_application'),
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:checkApplicationEligibility')
                    end
                },
                {
                    name = 'weapon_license_police',
                    icon = 'fas fa-clipboard',
                    label = _U('review_applications_police'),
                    groups = WeaponLicenseConfig.PoliceJobs,
                    canInteract = function()
                        if not WeaponLicenseConfig.RankRequirements.enabled then
                            return true
                        end
                        
                        local playerData = ESX.GetPlayerData()
                        if not playerData or not playerData.job then return false end
                        
                        local requiredGrade = WeaponLicenseConfig.RankRequirements.applications[playerData.job.name]
                        if requiredGrade and playerData.job.grade >= requiredGrade then
                            return true
                        end
                        return false
                    end,
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:getApplications')
                    end
                }
            }
        })
    end
    
    for _, location in pairs(WeaponLicenseConfig.RecordsLocations) do
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = location.size,
            rotation = location.rotation,
            debug = location.debug,
            options = {
                {
                    name = 'weapon_license_records',
                    icon = 'fas fa-folder-open',
                    label = _U('weapon_license_records_police'),
                    groups = WeaponLicenseConfig.PoliceJobs,
                    canInteract = function()
                        if not WeaponLicenseConfig.RankRequirements.enabled then
                            return true
                        end
                        
                        local playerData = ESX.GetPlayerData()
                        if not playerData or not playerData.job then return false end
                        
                        local requiredGrade = WeaponLicenseConfig.RankRequirements.records[playerData.job.name]
                        if requiredGrade and playerData.job.grade >= requiredGrade then
                            return true
                        end
                        return false
                    end,
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:getLicenseRecords')
                    end
                }
            }
        })
    end
    
    for _, location in pairs(WeaponLicenseConfig.ExamLocations) do
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = location.size,
            rotation = location.rotation,
            debug = location.debug,
            options = {
                {
                    name = 'weapon_license_exam',
                    icon = 'fas fa-clipboard-check',
                    label = _U('take_weapon_license_exam'),
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:checkExamEligibility')
                    end
                }
            }
        })
    end
end)

-- Open application menu
function openApplicationMenu()
    TriggerServerEvent('weaponlicense:checkApplicationEligibility')
end

-- Show applications to police
RegisterNetEvent('weaponlicense:showApplications')
AddEventHandler('weaponlicense:showApplications', function(applications)
    currentApplications = applications
    
    if #applications == 0 then
        lib.notify({
            title = _U('no_applications'),
            description = _U('no_applications_desc'),
            type = 'info',
            position = 'top'
        })
        return
    end
    
    local options = {}
    
    for _, app in pairs(applications) do
        local genderDisplay = _U('unknown')
        if app.gender then
            if string.lower(app.gender) == "m" then
                genderDisplay = _U('male')
            elseif string.lower(app.gender) == "f" then
                genderDisplay = _U('female')
            else
                genderDisplay = app.gender
            end
        end

        local titleText = genderDisplay .. " | " .. app.firstname .. " " .. app.lastname
        
        table.insert(options, {
            title = titleText,
            description = _U('dob_display', app.dateofbirth) .. ' | ' .. _U('submitted') .. ': ' .. (app.formatted_date or _U('unknown')),
            icon = 'user',
            onSelect = function()
                showApplicationActions(app.id, app.firstname .. ' ' .. app.lastname)
            end
        })
    end
    
    lib.registerContext({
        id = 'weapon_license_applications',
        title = _U('weapon_license_applications'),
        options = options
    })
    
    lib.showContext('weapon_license_applications')
end)

-- Show the actual application form
function showApplicationForm()
    local dialogTitle = _U('weapon_license_application_form')
    if WeaponLicenseConfig.ApplicationCost.enabled then
        dialogTitle = _U('weapon_license_application_cost', WeaponLicenseConfig.ApplicationCost.amount)
    end
    
    local input = lib.inputDialog(dialogTitle, {
        {
            type = 'input',
            label = _U('first_name'),
            description = _U('first_name_desc'),
            required = true,
            max = 50
        },
        {
            type = 'input',
            label = _U('last_name'),
            description = _U('last_name_desc'),
            required = true,
            max = 50
        },
        {
            type = 'input',
            label = _U('date_of_birth'),
            description = _U('date_of_birth_desc'),
            required = true,
            max = 10
        },
        {
            type = 'input',
            label = _U('discord_username'),
            description = _U('discord_username_desc'),
            required = true,
            max = 50
        }
    })
    
    if input then
        local firstname = input[1]
        local lastname = input[2]
        local dob = input[3]
        local discord = input[4]
        
        if firstname and lastname and dob and discord then
            TriggerServerEvent('weaponlicense:submitApplication', firstname, lastname, dob, discord)
        end
    end
end

-- Event to show the application form if eligible
RegisterNetEvent('weaponlicense:showApplicationForm')
AddEventHandler('weaponlicense:showApplicationForm', function()
    showApplicationForm()
end)

function showApplicationActions(applicationId, playerName)
    lib.registerContext({
        id = 'weapon_license_actions',
        title = _U('application_title', playerName),
        menu = 'weapon_license_applications',
        options = {
            {
                title = _U('approve_application'),
                description = _U('approve_application_desc'),
                icon = 'check',
                iconColor = 'green',
                onSelect = function()
                    TriggerServerEvent('weaponlicense:processApplication', applicationId, 'approve')
                end
            },
            {
                title = _U('deny_application'),
                description = _U('deny_application_desc'),
                icon = 'times',
                iconColor = 'red',
                onSelect = function()
                    TriggerServerEvent('weaponlicense:processApplication', applicationId, 'deny')
                end
            }
        }
    })
    
    lib.showContext('weapon_license_actions')
end

-- Refresh applications
RegisterNetEvent('weaponlicense:refreshApplications')
AddEventHandler('weaponlicense:refreshApplications', function()
    lib.hideContext()
end)

-- Start exam
RegisterNetEvent('weaponlicense:startExam')
AddEventHandler('weaponlicense:startExam', function()
    if examInProgress then return end
    examQuestions = {}
    local allQuestions = {}
    
    for i, question in pairs(WeaponLicenseConfig.ExamQuestions) do
        table.insert(allQuestions, question)
    end
    
    for i = #allQuestions, 2, -1 do
        local j = math.random(i)
        allQuestions[i], allQuestions[j] = allQuestions[j], allQuestions[i]
    end
    
    for i = 1, WeaponLicenseConfig.ExamSettings.totalQuestions do
        if allQuestions[i] then
            table.insert(examQuestions, allQuestions[i])
        end
    end
    
    examInProgress = true
    currentQuestionIndex = 1
    examAnswers = {}
    
    showExamQuestion()
end)

-- Show exam question
function showExamQuestion()
    if currentQuestionIndex > #examQuestions then
        finishExam()
        return
    end
    
    local question = examQuestions[currentQuestionIndex]
    
    local selectOptions = {}
    for letter, answer in pairs(question.answers) do
        table.insert(selectOptions, {
            value = letter,
            label = letter .. ") " .. answer
        })
    end
    
    local isMultiple = string.find(question.correct, ',')
    local description = isMultiple and _U('choose_best_answer') or _U('choose_correct_answer')
    
    local input = lib.inputDialog(_U('exam_question_header', currentQuestionIndex, #examQuestions), {
        {
            type = 'select',
            label = question.question,
            description = description,
            required = true,
            options = selectOptions
        }
    })
    
    if input and input[1] then
        examAnswers[currentQuestionIndex] = input[1]
        currentQuestionIndex = currentQuestionIndex + 1
        
        Citizen.Wait(500)
        showExamQuestion()
    else
        examInProgress = false
        lib.notify({
            title = _U('exam_cancelled'),
            description = _U('exam_cancelled_desc'),
            type = 'error',
            position = 'top'
        })
    end
end

-- Finish exam and calculate score
function finishExam()
    local score = 0
    
    for i, question in pairs(examQuestions) do
        local userAnswer = examAnswers[i]
        local correctAnswer = question.correct
        
        if string.find(correctAnswer, ',') then
            local correctAnswers = {}
            for answer in string.gmatch(correctAnswer, '([^,]+)') do
                correctAnswers[string.gsub(answer, '%s+', '')] = true
            end
            
            if correctAnswers[userAnswer] then
                score = score + 1
            end
        else
            if userAnswer == correctAnswer then
                score = score + 1
            end
        end
    end
    
    examInProgress = false
    
    TriggerServerEvent('weaponlicense:submitExamResults', score, #examQuestions)
end

RegisterNetEvent('weaponlicense:examResults')
AddEventHandler('weaponlicense:examResults', function(passed, score, totalQuestions, requiredScore)
    if passed then
        lib.notify({
            title = 'Exam Passed!',
            description = 'Congratulations! You scored ' .. score .. '/' .. totalQuestions .. ' and have been awarded a weapon license',
            type = 'success',
            duration = 8000,
            position = 'top'
        })
    else
        lib.notify({
            title = 'Exam Failed',
            description = 'You scored ' .. score .. '/' .. totalQuestions .. '. You need at least ' .. requiredScore .. ' correct answers to pass',
            type = 'error',
            duration = 8000,
            position = 'top'
        })
    end
end)

-- Show license records to police
RegisterNetEvent('weaponlicense:showLicenseRecords')
AddEventHandler('weaponlicense:showLicenseRecords', function(records)
    if #records == 0 then
        lib.notify({
            title = _U('no_records'),
            description = _U('no_records_desc'),
            type = 'info',
            position = 'top'
        })
        return
    end
    
    local options = {}
    
    for _, record in pairs(records) do
        local genderDisplay = _U('unknown')
        if record.gender then
            if string.lower(record.gender) == "m" then
                genderDisplay = _U('male')
            elseif string.lower(record.gender) == "f" then
                genderDisplay = _U('female')
            else
                genderDisplay = record.gender
            end
        end
        
        local titleText = genderDisplay .. " | " .. (record.firstname or _U('unknown')) .. " " .. (record.lastname or _U('unknown'))
        
        local description = _U('dob_display', record.dateofbirth or _U('unknown'))
        if record.discord then
            description = description .. ' | Discord: ' .. record.discord
        end
        if record.issued_date then
            description = description .. ' | ' .. _U('submitted') .. ': ' .. record.issued_date
        end
        
        if record.is_banned and record.is_banned == 1 then
            description = description .. ' | ' .. _U('status_banned')
        else
            description = description .. ' | ' .. _U('status_active')
        end
        
        table.insert(options, {
            title = titleText,
            description = description,
            icon = record.is_banned and record.is_banned == 1 and 'ban' or 'id-card',
            iconColor = record.is_banned and record.is_banned == 1 and 'red' or 'green',
            onSelect = function()
                showLicenseRecordActions(record)
            end
        })
    end
    
    lib.registerContext({
        id = 'weapon_license_records',
        title = _U('weapon_license_records'),
        options = options
    })
    
    lib.showContext('weapon_license_records')
end)

-- Show license record actions
function showLicenseRecordActions(record)
    local playerName = (record.firstname or _U('unknown')) .. " " .. (record.lastname or _U('unknown'))
    local isBanned = record.is_banned and record.is_banned == 1
    
    local options = {}
    
    if not isBanned then
        table.insert(options, {
            title = _U('revoke_license'),
            description = _U('revoke_license_desc'),
            icon = 'times-circle',
            iconColor = 'red',
            onSelect = function()
                TriggerServerEvent('weaponlicense:revokeLicense', record.identifier)
            end
        })
    end
    
    if isBanned then
        table.insert(options, {
            title = _U('unban_from_applications'),
            description = _U('unban_from_applications_desc'),
            icon = 'check-circle',
            iconColor = 'green',
            onSelect = function()
                TriggerServerEvent('weaponlicense:unbanPlayer', record.identifier)
            end
        })
    else
        table.insert(options, {
            title = _U('ban_from_applications'),
            description = _U('ban_from_applications_desc'),
            icon = 'ban',
            iconColor = 'red',
            onSelect = function()
                TriggerServerEvent('weaponlicense:banPlayer', record.identifier)
            end
        })
    end
    
    lib.registerContext({
        id = 'weapon_license_record_actions',
        title = _U('license_record_title', playerName),
        menu = 'weapon_license_records',
        options = options
    })
    
    lib.showContext('weapon_license_record_actions')
end

-- Refresh records
RegisterNetEvent('weaponlicense:refreshRecords')
AddEventHandler('weaponlicense:refreshRecords', function()
    lib.hideContext()
end)

-- Spawn replacement NPC
function spawnReplacementNPC()
    local npcConfig = WeaponLicenseConfig.ReplacementNPC
    
    RequestModel(npcConfig.model)
    while not HasModelLoaded(npcConfig.model) do
        Wait(1)
    end
    
    replacementNPC = CreatePed(4, npcConfig.model, npcConfig.coords.x, npcConfig.coords.y, npcConfig.coords.z - 1.0, npcConfig.coords.w, false, true)
    
    SetEntityHeading(replacementNPC, npcConfig.coords.w)
    FreezeEntityPosition(replacementNPC, true)
    SetEntityInvincible(replacementNPC, true)
    SetBlockingOfNonTemporaryEvents(replacementNPC, true)
    
    exports.ox_target:addLocalEntity(replacementNPC, {
        {
            name = 'weapon_license_replacement',
            icon = 'fas fa-id-card',
            label = _U('replacement_weapon_license'),
            canInteract = function()
                return checkReplacementEligibility()
            end,
            onSelect = function()
                TriggerServerEvent('weaponlicense:checkReplacementEligibility')
            end
        }
    })
end

-- Check if player is eligible for replacement (client-side check for target visibility)
function checkReplacementEligibility()
    local playerData = ESX.GetPlayerData()
    if not playerData then return false end
    return true
end

-- Show replacement menu
RegisterNetEvent('weaponlicense:showReplacementMenu')
AddEventHandler('weaponlicense:showReplacementMenu', function(playerData)
    local costText = ""
    if WeaponLicenseConfig.ReplacementCost.enabled then
        costText = " (" .. _U('cost', WeaponLicenseConfig.ReplacementCost.amount) .. ")"
    end
    
    lib.registerContext({
        id = 'weapon_license_replacement',
        title = _U('license_replacement'),
        options = {
            {
                title = _U('purchase_replacement_license'),
                description = _U('purchase_replacement_license_desc') .. costText,
                icon = 'id-card',
                onSelect = function()
                    TriggerServerEvent('weaponlicense:purchaseReplacement', playerData)
                end
            }
        }
    })
    
    lib.showContext('weapon_license_replacement')
end)

-- Export function for using weapon license item
function useWeaponLicense(data, slot)
    local input = lib.inputDialog(_U('show_license'), {
        {
            type = 'number',
            label = _U('player_server_id'),
            description = _U('player_server_id_desc'),
            required = true,
            min = 1,
            max = 1024
        }
    })
    
    if input and input[1] then
        local targetId = tonumber(input[1])
        if targetId then
            TriggerServerEvent('weaponlicense:showLicenseToPlayer', targetId, {
                metadata = data,
                slot = slot,
                owner = GetPlayerServerId(PlayerId())
            })
        end
    end
end

-- Display license to target player
RegisterNetEvent('weaponlicense:displayLicense')
AddEventHandler('weaponlicense:displayLicense', function(licenseData, ownerSrc)
    local metadata = licenseData.slot.metadata or {}
    local playerData = ESX.GetPlayerData()
    local isPolice = false
    
    if playerData and playerData.job then
        for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
            if playerData.job.name == job then
                isPolice = true
                break
            end
        end
    end
    
    _G.currentLicenseMetadata = metadata
    _G.currentLicenseOwner = ownerSrc
    _G.currentIsPolice = isPolice
    _G.currentLicenseData = licenseData
    _G.licenseMenuShown = false
    TriggerServerEvent('weaponlicense:validateLicenseOwnership', ownerSrc, metadata)
end)

-- Function to create the license menu
function createLicenseMenu(metadata, isPolice, licenseData, ownerSrc, isValid, isVerified)
    local strikesText = (metadata.strikes or 0) .. "/" .. WeaponLicenseConfig.StrikeSystem.maxStrikes
    local nameIcon = 'id-badge'
    local nameColor = nil
    local nameDescription = _U('full_legal_name')
    local nameDisabled = false
    
    if isVerified then
        if isValid then
            nameIcon = 'check-circle'
            nameColor = 'green'
            nameDescription = _U('license_verified')
        else
            nameIcon = 'exclamation-triangle'
            nameColor = 'red'
            nameDescription = _U('license_invalid_warning')
            nameDisabled = true
        end
    end

    local mainOptions = {
        {
            title = _U('license_holder_information'),
            description = _U('license_holder_information_desc'),
            icon = 'user',
            disabled = false
        },
        {
            title = _U('name_display', (metadata.firstname or _U('unknown')), (metadata.lastname or _U('unknown'))),
            description = nameDescription,
            icon = nameIcon,
            iconColor = nameColor,
            disabled = nameDisabled
        },
        {
            title = _U('dob_display', (metadata.dateofbirth or _U('unknown'))),
            description = _U('date_of_birth'),
            icon = 'calendar',
            disabled = true
        },
        {
            title = _U('gender_display', (metadata.gender or _U('unknown'))),
            description = _U('gender'),
            icon = 'venus-mars',
            disabled = true
        },
        {
            title = _U('issue_date_display', (metadata.issued_date or _U('unknown'))),
            description = _U('issue_date_desc'),
            icon = 'calendar-check',
            disabled = true
        },
        {
            title = _U('strikes_display', strikesText),
            description = _U('strikes_desc'),
            icon = 'exclamation-triangle',
            iconColor = (metadata.strikes or 0) > 0 and 'red' or 'green',
            disabled = true
        }
    }
    
    if isPolice then
        table.insert(mainOptions, {
            title = _U('police_actions'),
            description = _U('police_actions_desc'),
            icon = 'shield-alt',
            iconColor = 'blue',
            onSelect = function()
                lib.showContext('weapon_license_actions')
            end
        })
    end
    
    table.insert(mainOptions, {
        title = _U('close_license'),
        description = _U('close_license_desc'),
        icon = 'times',
        onSelect = function()
            lib.hideContext()
        end
    })
    
    lib.registerContext({
        id = 'weapon_license_display',
        title = metadata.license_type or _U('weapon_license'),
        options = mainOptions
    })
    
    if isPolice then
        lib.registerContext({
            id = 'weapon_license_actions',
            title = _U('police_actions'),
            menu = 'weapon_license_display',
            options = {
                {
                    title = _U('add_strike'),
                    description = _U('add_strike_desc'),
                    icon = 'exclamation-triangle',
                    iconColor = 'orange',
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:addStrike', ownerSrc, licenseData.slot.slot)
                        lib.hideContext()
                    end
                },
                {
                    title = _U('revoke_license'),
                    description = _U('revoke_license_inspection_desc'),
                    icon = 'times-circle',
                    iconColor = 'red',
                    onSelect = function()
                        TriggerServerEvent('weaponlicense:revokeLicenseInspection', ownerSrc, licenseData.slot.slot)
                        lib.hideContext()
                    end
                },
                {
                    title = _U('back'),
                    description = _U('back_desc'),
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('weapon_license_display')
                    end
                }
            }
        })
    end
    
    if not _G.licenseMenuShown then
        _G.licenseMenuShown = true
        lib.showContext('weapon_license_display')
    end
end

-- Handle license ownership validation result
RegisterNetEvent('weaponlicense:updateLicenseOwnership')
AddEventHandler('weaponlicense:updateLicenseOwnership', function(isValid)
    if not _G.currentLicenseMetadata then return end
    
    createLicenseMenu(
        _G.currentLicenseMetadata, 
        _G.currentIsPolice, 
        _G.currentLicenseData, 
        _G.currentLicenseOwner, 
        isValid, 
        true
    )
end)

-- Refresh license display after strike is added
RegisterNetEvent('weaponlicense:refreshLicenseDisplay')
AddEventHandler('weaponlicense:refreshLicenseDisplay', function(licenseData, ownerSrc)
    lib.hideContext()
    Citizen.Wait(100)
    TriggerEvent('weaponlicense:displayLicense', licenseData, ownerSrc)
end)

-- Close license display
RegisterNetEvent('weaponlicense:closeLicenseDisplay')
AddEventHandler('weaponlicense:closeLicenseDisplay', function()
    lib.hideContext()
end)

-- Handle exam timeout
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        if examInProgress then
            -- You can add a timer here if needed
            -- For now, we'll let the exam run without a strict time limit
            -- But you could implement a countdown timer
        end
    end
end)


-- Clean up NPC on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if replacementNPC then
            DeleteEntity(replacementNPC)
        end
    end
end)


-- Export the function for ox_inventory
exports('useWeaponLicense', useWeaponLicense)