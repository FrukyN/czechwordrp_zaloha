ESX = exports["es_extended"]:getSharedObject()

-- Function to send Discord webhook
function sendDiscordWebhook(applicationData)
    if not WeaponLicenseConfig.DiscordWebhook.enabled or not WeaponLicenseConfig.DiscordWebhook.url then
        return
    end

    local genderDisplay = _U('unknown')
    if applicationData.gender then
        if string.lower(applicationData.gender) == "m" then
            genderDisplay = _U('male')
        elseif string.lower(applicationData.gender) == "f" then
            genderDisplay = _U('female')
        else
            genderDisplay = applicationData.gender
        end
    end
    
    local embed = {
        {
            title = _U('new_weapon_license_application'),
            color = WeaponLicenseConfig.DiscordWebhook.color,
            fields = {
                {
                    name = _U('applicant'),
                    value = genderDisplay .. " | " .. applicationData.firstname .. " " .. applicationData.lastname,
                    inline = false
                },
                {
                    name = _U('date_of_birth'),
                    value = applicationData.dateofbirth,
                    inline = true
                },
                {
                    name = _U('submitted'),
                    value = applicationData.formatted_date or os.date("%m/%d/%Y %H:%M"),
                    inline = true
                },
                {
                    name = _U('player_identifier'),
                    value = applicationData.identifier,
                    inline = false
                }
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local payload = {
        username = WeaponLicenseConfig.DiscordWebhook.botName,
        embeds = embed
    }
    
    PerformHttpRequest(WeaponLicenseConfig.DiscordWebhook.url, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

-- Create database tables
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `weapon_license_applications` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `firstname` varchar(50) NOT NULL,
            `lastname` varchar(50) NOT NULL,
            `dateofbirth` varchar(10) NOT NULL,
            `discord` varchar(50) NOT NULL DEFAULT '',
            `submitted_date` timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])
    
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `weapon_license_accepted` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `firstname` varchar(50) NOT NULL,
            `lastname` varchar(50) NOT NULL,
            `dateofbirth` varchar(10) NOT NULL,
            `discord` varchar(50) NOT NULL DEFAULT '',
            `submitted_date` timestamp NULL,
            `accepted_date` timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])
    
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `weapon_license_bans` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `banned_date` timestamp DEFAULT CURRENT_TIMESTAMP,
            `banned_by` varchar(60) NOT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `identifier` (`identifier`)
        )
    ]])
    
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `weapon_licenses` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `firstname` varchar(50) NOT NULL,
            `lastname` varchar(50) NOT NULL,
            `dateofbirth` varchar(10) NOT NULL,
            `gender` varchar(10) NOT NULL,
            `discord` varchar(50) NOT NULL DEFAULT '',
            `issued_date` timestamp DEFAULT CURRENT_TIMESTAMP,
            `strikes` int(11) DEFAULT 0,
            `revoked` tinyint(1) DEFAULT 0,
            `revoked_date` timestamp NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `identifier` (`identifier`)
        )
    ]])
    
    MySQL.Async.fetchAll("SHOW COLUMNS FROM weapon_license_applications LIKE 'discord'", {}, function(result)
        if #result == 0 then
            MySQL.Async.execute('ALTER TABLE weapon_license_applications ADD COLUMN discord VARCHAR(50) NOT NULL DEFAULT ""', {}, function() end)
        end
    end)
    
    MySQL.Async.fetchAll("SHOW COLUMNS FROM weapon_license_accepted LIKE 'discord'", {}, function(result)
        if #result == 0 then
            MySQL.Async.execute('ALTER TABLE weapon_license_accepted ADD COLUMN discord VARCHAR(50) NOT NULL DEFAULT ""', {}, function() end)
        end
    end)
end)

-- Get license records for police
RegisterServerEvent('weaponlicense:getLicenseRecords')
AddEventHandler('weaponlicense:getLicenseRecords', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    local hasRankAccess = false
    
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            
            if WeaponLicenseConfig.RankRequirements.enabled then
                local requiredGrade = WeaponLicenseConfig.RankRequirements.records[job]
                if requiredGrade and xPlayer.job.grade >= requiredGrade then
                    hasRankAccess = true
                end
            else
                hasRankAccess = true
            end
            break
        end
    end
    
    if not isPolice then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('access_denied'),
            description = _U('access_denied_desc'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    if not hasRankAccess then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('insufficient_rank'),
            description = _U('insufficient_rank_records'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    -- MySQL query remains the same...
    MySQL.Async.fetchAll([[
        SELECT 
            COALESCE(ul.owner, wlb.identifier) as identifier,
            u.sex as gender,
            u.firstname,
            u.lastname,
            u.dateofbirth,
            wla.discord,
            DATE_FORMAT(wla.accepted_date, "%m/%d/%Y %H:%i") as issued_date,
            CASE WHEN wlb.identifier IS NOT NULL THEN 1 ELSE 0 END as is_banned
        FROM (
            SELECT DISTINCT owner as identifier FROM user_licenses WHERE type = ?
            UNION
            SELECT DISTINCT identifier FROM weapon_license_bans
        ) AS all_identifiers
        LEFT JOIN user_licenses ul ON all_identifiers.identifier = ul.owner AND ul.type = ?
        LEFT JOIN users u ON all_identifiers.identifier = u.identifier
        LEFT JOIN weapon_license_accepted wla ON all_identifiers.identifier = wla.identifier
        LEFT JOIN weapon_license_bans wlb ON all_identifiers.identifier = wlb.identifier
        ORDER BY u.firstname, u.lastname
    ]], {WeaponLicenseConfig.LicenseType, WeaponLicenseConfig.LicenseType}, function(result)
        TriggerClientEvent('weaponlicense:showLicenseRecords', src, result)
    end)
end)

-- Revoke weapon license
RegisterServerEvent('weaponlicense:revokeLicense')
AddEventHandler('weaponlicense:revokeLicense', function(targetIdentifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            break
        end
    end
    
    if not isPolice then return end
    
    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = ? AND type = ?', {
        targetIdentifier,
        WeaponLicenseConfig.LicenseType
    }, function(rowsChanged)
        if rowsChanged > 0 then
            local targetPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
            if targetPlayer and WeaponLicenseConfig.GiveItem then
                exports.ox_inventory:RemoveItem(targetPlayer.source, WeaponLicenseConfig.ItemName, 1)
            end
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('license_revoked'),
                description = _U('license_revoked_desc'),
                type = 'success',
                position = 'top'
            })
            
            TriggerClientEvent('weaponlicense:refreshRecords', -1)
        end
    end)
end)

-- Ban player from applications
RegisterServerEvent('weaponlicense:banPlayer')
AddEventHandler('weaponlicense:banPlayer', function(targetIdentifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            break
        end
    end
    
    if not isPolice then return end
    
    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = ? AND type = ?', {
        targetIdentifier,
        WeaponLicenseConfig.LicenseType
    }, function(licenseRowsChanged)
        if licenseRowsChanged > 0 then
            local targetPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
            if targetPlayer and WeaponLicenseConfig.GiveItem then
                exports.ox_inventory:RemoveItem(targetPlayer.source, WeaponLicenseConfig.ItemName, 1)
            end
        end
        
        MySQL.Async.execute('DELETE FROM weapon_license_accepted WHERE identifier = ?', {
            targetIdentifier
        }, function()
            MySQL.Async.execute('DELETE FROM weapon_license_applications WHERE identifier = ?', {
                targetIdentifier
            }, function()
                MySQL.Async.execute('INSERT INTO weapon_license_bans (identifier, banned_by) VALUES (?, ?) ON DUPLICATE KEY UPDATE banned_date = CURRENT_TIMESTAMP, banned_by = ?', {
                    targetIdentifier,
                    xPlayer.identifier,
                    xPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        local message = licenseRowsChanged > 0 and _U('player_banned_revoked_desc') or _U('player_banned_desc')
                        
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('player_banned'),
                            description = message,
                            type = 'success',
                            position = 'top'
                        })
                        
                        TriggerClientEvent('weaponlicense:refreshRecords', -1)
                    end
                end)
            end)
        end)
    end)
end)

-- Unban player from applications
RegisterServerEvent('weaponlicense:unbanPlayer')
AddEventHandler('weaponlicense:unbanPlayer', function(targetIdentifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            break
        end
    end
    
    if not isPolice then return end
    
    MySQL.Async.execute('DELETE FROM weapon_license_bans WHERE identifier = ?', {
        targetIdentifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('player_unbanned'),
                description = _U('player_unbanned_desc'),
                type = 'success',
                position = 'top'
            })
            
            TriggerClientEvent('weaponlicense:refreshRecords', -1)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('error'),
                description = _U('player_not_banned'),
                type = 'error',
                position = 'top'
            })
        end
    end)
end)

-- Submit application
RegisterServerEvent('weaponlicense:submitApplication')
AddEventHandler('weaponlicense:submitApplication', function(firstname, lastname, dob, discord)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if not string.match(dob, "^%d%d/%d%d/%d%d%d%d$") then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('invalid_date_format'),
            description = _U('invalid_date_format_desc'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    if not discord or string.len(discord) < 2 or string.len(discord) > 50 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('invalid_discord'),
            description = _U('invalid_discord_desc'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    if WeaponLicenseConfig.ApplicationCost.enabled then
        local cost = WeaponLicenseConfig.ApplicationCost.amount
        local playerMoney = xPlayer.getMoney()
        local playerBank = xPlayer.getAccount('bank').money
        
        if (playerMoney + playerBank) < cost then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('insufficient_funds'),
                description = _U('insufficient_funds_application', cost),
                type = 'error',
                position = 'top'
            })
            return
        end
    end
    
    MySQL.Async.fetchAll('SELECT * FROM weapon_license_applications WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if #result > 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('application_already_submitted'),
                description = _U('application_already_submitted_desc'),
                type = 'error',
                position = 'top'
            })
            return
        end
        
        MySQL.Async.fetchAll('SELECT * FROM weapon_license_accepted WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(acceptedResult)
            if #acceptedResult > 0 then
                TriggerClientEvent('ox_lib:notify', src, {
                    title = _U('already_approved'),
                    description = _U('already_approved_desc'),
                    type = 'error',
                    position = 'top'
                })
                return
            end
            
            MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier AND type = @type', {
                ['@identifier'] = xPlayer.identifier,
                ['@type'] = WeaponLicenseConfig.LicenseType
            }, function(licenseResult)
                if #licenseResult > 0 then
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = _U('license_already_owned'),
                        description = _U('license_already_owned_desc'),
                        type = 'error',
                        position = 'top'
                    })
                    return
                end
                
                if WeaponLicenseConfig.ApplicationCost.enabled then
                    local cost = WeaponLicenseConfig.ApplicationCost.amount
                    local playerMoney = xPlayer.getMoney()
                    
                    if playerMoney >= cost then
                        xPlayer.removeMoney(cost)
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('payment_processed'),
                            description = _U('payment_processed_cash', cost),
                            type = 'info',
                            position = 'top'
                        })
                    else
                        local remainingCost = cost - playerMoney
                        if playerMoney > 0 then
                            xPlayer.removeMoney(playerMoney)
                        end
                        xPlayer.removeAccountMoney('bank', remainingCost)
                        
                        local cashUsed = playerMoney
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('payment_processed'),
                            description = _U('payment_processed_mixed', cost, cashUsed, remainingCost),
                            type = 'info',
                            position = 'top'
                        })
                    end
                end
                
                MySQL.Async.execute('INSERT INTO weapon_license_applications (identifier, firstname, lastname, dateofbirth, discord) VALUES (@identifier, @firstname, @lastname, @dob, @discord)', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@firstname'] = firstname,
                    ['@lastname'] = lastname,
                    ['@dob'] = dob,
                    ['@discord'] = discord
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        sendDiscordWebhook({
                            identifier = xPlayer.identifier,
                            firstname = firstname,
                            lastname = lastname,
                            dateofbirth = dob,
                            gender = xPlayer.get('sex'),
                            formatted_date = os.date("%m/%d/%Y %H:%M", os.time() - (6 * 3600))
                        })
                        
                        local message = WeaponLicenseConfig.ApplicationCost.enabled and 
                            _U('application_submitted_cost', WeaponLicenseConfig.ApplicationCost.amount) or 
                            _U('application_submitted_desc')
                        
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('application_submitted'),
                            description = message,
                            type = 'success',
                            position = 'top'
                        })
                    end
                end)
            end)
        end)
    end)
end)

-- Get applications for police
RegisterServerEvent('weaponlicense:getApplications')
AddEventHandler('weaponlicense:getApplications', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    local hasRankAccess = false
    
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            
            if WeaponLicenseConfig.RankRequirements.enabled then
                local requiredGrade = WeaponLicenseConfig.RankRequirements.applications[job]
                if requiredGrade and xPlayer.job.grade >= requiredGrade then
                    hasRankAccess = true
                end
            else
                hasRankAccess = true
            end
            break
        end
    end
    
    if not isPolice then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('access_denied'),
            description = _U('access_denied_desc'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    if not hasRankAccess then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('insufficient_rank'),
            description = _U('insufficient_rank_applications'),
            type = 'error',
            position = 'top'
        })
        return
    end
    
    -- MySQL query remains the same
    MySQL.Async.fetchAll([[
        SELECT 
            wla.*, 
            DATE_FORMAT(DATE_SUB(wla.submitted_date, INTERVAL 4 HOUR), "%m/%d/%Y %H:%i") as formatted_date,
            u.sex as gender
        FROM weapon_license_applications wla
        LEFT JOIN users u ON wla.identifier = u.identifier
        ORDER BY wla.submitted_date DESC
    ]], {}, function(result)
        TriggerClientEvent('weaponlicense:showApplications', src, result)
    end)
end)

-- Validate license ownership
RegisterServerEvent('weaponlicense:validateLicenseOwnership')
AddEventHandler('weaponlicense:validateLicenseOwnership', function(targetSrc, licenseMetadata)
    local src = source
    local targetPlayer = ESX.GetPlayerFromId(targetSrc)
    
    if not targetPlayer then 
        TriggerClientEvent('weaponlicense:updateLicenseOwnership', src, false)
        return 
    end
    
    MySQL.Async.fetchAll('SELECT ul.owner FROM user_licenses ul WHERE ul.owner = ? AND ul.type = ?', {
        targetPlayer.identifier,
        WeaponLicenseConfig.LicenseType
    }, function(licenseResult)
        if #licenseResult == 0 then
            TriggerClientEvent('weaponlicense:updateLicenseOwnership', src, false)
            return
        end
        
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex FROM users WHERE identifier = ?', {
            targetPlayer.identifier
        }, function(result)
            local isValid = false
            
            if #result > 0 then
                local playerData = result[1]
                local firstnameMatch = (licenseMetadata.firstname or ''):lower() == (playerData.firstname or ''):lower()
                local lastnameMatch = (licenseMetadata.lastname or ''):lower() == (playerData.lastname or ''):lower()
                local playerDOB = playerData.dateofbirth or ''
                if playerDOB ~= '' and string.match(playerDOB, "^%d%d/%d%d/%d%d%d%d$") then
                    local day, month, year = string.match(playerDOB, "(%d%d)/(%d%d)/(%d%d%d%d)")
                    if day and month and year then
                        playerDOB = month .. "/" .. day .. "/" .. year
                    end
                end
                
                local dobMatch = (licenseMetadata.dateofbirth or '') == playerDOB
                local playerGender = "Unknown"
                if playerData.sex then
                    if string.lower(playerData.sex) == "m" then
                        playerGender = "Male"
                    elseif string.lower(playerData.sex) == "f" then
                        playerGender = "Female"
                    else
                        playerGender = playerData.sex
                    end
                end
                
                local genderMatch = (licenseMetadata.gender or '') == playerGender
                isValid = firstnameMatch and lastnameMatch and dobMatch and genderMatch
            end
            TriggerClientEvent('weaponlicense:updateLicenseOwnership', src, isValid)
        end)
    end)
end)

-- Process application (approve/deny)
RegisterServerEvent('weaponlicense:processApplication')
AddEventHandler('weaponlicense:processApplication', function(applicationId, action)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            break
        end
    end
    
    if not isPolice then return end
    
    if action == 'approve' then
        MySQL.Async.fetchAll('SELECT * FROM weapon_license_applications WHERE id = @id', {
            ['@id'] = applicationId
        }, function(result)
            if #result > 0 then
                local app = result[1]
                
                MySQL.Async.execute('INSERT INTO weapon_license_accepted (identifier, firstname, lastname, dateofbirth, discord, submitted_date) VALUES (@identifier, @firstname, @lastname, @dob, @discord, NOW())', {
                    ['@identifier'] = app.identifier,
                    ['@firstname'] = app.firstname,
                    ['@lastname'] = app.lastname,
                    ['@dob'] = app.dateofbirth,
                    ['@discord'] = app.discord
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        MySQL.Async.execute('DELETE FROM weapon_license_applications WHERE id = @id', {
                            ['@id'] = applicationId
                        })
                        
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('application_approved'),
                            description = _U('application_approved_desc'),
                            type = 'success',
                            position = 'top'
                        })
                        
                        TriggerClientEvent('weaponlicense:refreshApplications', -1)
                    end
                end)
            end
        end)
    elseif action == 'deny' then
        MySQL.Async.execute('DELETE FROM weapon_license_applications WHERE id = @id', {
            ['@id'] = applicationId
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('ox_lib:notify', src, {
                    title = _U('application_denied'),
                    description = _U('application_denied_desc'),
                    type = 'success',
                    position = 'top'
                })
                
                TriggerClientEvent('weaponlicense:refreshApplications', -1)
            end
        end)
    end
end)

-- Check if player can take exam
RegisterServerEvent('weaponlicense:checkExamEligibility')
AddEventHandler('weaponlicense:checkExamEligibility', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local isPolice = false
    for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
        if xPlayer.job.name == job then
            isPolice = true
            break
        end
    end
    
    if isPolice then
        TriggerClientEvent('weaponlicense:startExam', src)
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM weapon_license_accepted WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if #result > 0 then
            MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier AND type = @type', {
                ['@identifier'] = xPlayer.identifier,
                ['@type'] = WeaponLicenseConfig.LicenseType
            }, function(licenseResult)
                if #licenseResult > 0 then
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = _U('license_already_owned'),
                        description = _U('license_already_owned_desc'),
                        type = 'error',
                        position = 'top'
                    })
                    return
                end
                
                TriggerClientEvent('weaponlicense:startExam', src)
            end)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('not_eligible'),
                description = _U('not_eligible_exam'),
                type = 'error',
                position = 'top'
            })
        end
    end)
end)

-- Check application eligibility before showing form
RegisterServerEvent('weaponlicense:checkApplicationEligibility')
AddEventHandler('weaponlicense:checkApplicationEligibility', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    MySQL.Async.fetchAll('SELECT * FROM weapon_license_bans WHERE identifier = ?', {
        xPlayer.identifier
    }, function(banResult)
        if #banResult > 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('application_banned'),
                description = _U('application_banned_desc'),
                type = 'error',
                position = 'top'
            })
            return
        end

        MySQL.Async.fetchAll('SELECT * FROM weapon_license_applications WHERE identifier = ?', {
            xPlayer.identifier
        }, function(result)
            if #result > 0 then
                TriggerClientEvent('ox_lib:notify', src, {
                    title = _U('application_already_submitted'),
                    description = _U('application_already_submitted_patient'),
                    type = 'error',
                    position = 'top'
                })
                return
            end

            MySQL.Async.fetchAll('SELECT * FROM weapon_license_accepted WHERE identifier = ?', {
                xPlayer.identifier
            }, function(acceptedResult)
                if #acceptedResult > 0 then
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = _U('already_approved'),
                        description = _U('already_approved_desc'),
                        type = 'error',
                        position = 'top'
                    })
                    return
                end

                MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = ? AND type = ?', {
                    xPlayer.identifier,
                    WeaponLicenseConfig.LicenseType
                }, function(licenseResult)
                    if #licenseResult > 0 then
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('license_already_owned'),
                            description = _U('license_already_owned_desc'),
                            type = 'error',
                            position = 'top'
                        })
                        return
                    end
                    TriggerClientEvent('weaponlicense:showApplicationForm', src)
                end)
            end)
        end)
    end)
end)

-- Process exam results
RegisterServerEvent('weaponlicense:submitExamResults')
AddEventHandler('weaponlicense:submitExamResults', function(score, totalQuestions)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local passed = score >= WeaponLicenseConfig.ExamSettings.questionsToPass
    
    if passed then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {
            xPlayer.identifier
        }, function(usersResult)
            MySQL.Async.fetchAll('SELECT * FROM weapon_license_accepted WHERE identifier = ?', {
                xPlayer.identifier
            }, function(acceptedResult)
                MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {
                    WeaponLicenseConfig.LicenseType,
                    xPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        if WeaponLicenseConfig.GiveItem then
                            local metadata = {
                                firstname = _U('unknown'),
                                lastname = _U('unknown'),
                                dateofbirth = _U('unknown'),
                                gender = _U('unknown'),
                                issued_date = os.date("%m/%d/%Y"),
                                license_type = _U('weapon_license'),
                                strikes = 0
                            }
                            if #usersResult > 0 then
                                local userData = usersResult[1]
                                
                                metadata.firstname = userData.firstname or _U('unknown')
                                metadata.lastname = userData.lastname or _U('unknown')
                                local dob = userData.dateofbirth or _U('unknown')
                                if dob ~= _U('unknown') and string.match(dob, "^%d%d/%d%d/%d%d%d%d$") then
                                    local day, month, year = string.match(dob, "(%d%d)/(%d%d)/(%d%d%d%d)")
                                    if day and month and year then
                                        metadata.dateofbirth = month .. "/" .. day .. "/" .. year
                                    else
                                        metadata.dateofbirth = dob
                                    end
                                else
                                    metadata.dateofbirth = dob
                                end
                                
                                if userData.sex == 'm' then
                                    metadata.gender = _U('male')
                                elseif userData.sex == 'f' then
                                    metadata.gender = _U('female')
                                else
                                    metadata.gender = _U('unknown')
                                end
                            end
                            
                            exports.ox_inventory:AddItem(src, WeaponLicenseConfig.ItemName, 1, metadata)
                        end
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = _U('exam_passed'),
                            description = _U('exam_passed_desc', score, totalQuestions),
                            type = 'success',
                            position = 'top'
                        })
                    end
                end)
            end)
        end)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('exam_failed'),
            description = _U('exam_failed_desc', score, totalQuestions, WeaponLicenseConfig.ExamSettings.questionsToPass),
            type = 'error',
            position = 'top'
        })
    end
end)

-- Check replacement eligibility
RegisterServerEvent('weaponlicense:checkReplacementEligibility')
AddEventHandler('weaponlicense:checkReplacementEligibility', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    MySQL.Async.fetchAll([[
        SELECT 
            ul.owner as identifier,
            u.sex as gender,
            u.firstname,
            u.lastname,
            u.dateofbirth,
            wla.discord,
            DATE_FORMAT(wla.accepted_date, "%m/%d/%Y") as issued_date,
            CASE WHEN wlb.identifier IS NOT NULL THEN 1 ELSE 0 END as is_banned
        FROM user_licenses ul
        LEFT JOIN users u ON ul.owner = u.identifier
        LEFT JOIN weapon_license_accepted wla ON ul.owner = wla.identifier
        LEFT JOIN weapon_license_bans wlb ON ul.owner = wlb.identifier
        WHERE ul.type = ? AND ul.owner = ?
    ]], {WeaponLicenseConfig.LicenseType, xPlayer.identifier}, function(result)
        if #result > 0 and result[1].is_banned == 0 then
            TriggerClientEvent('weaponlicense:showReplacementMenu', src, result[1])
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('not_eligible'),
                description = _U('not_eligible_replacement'),
                type = 'error',
                position = 'top'
            })
        end
    end)
end)

-- Purchase replacement license
RegisterServerEvent('weaponlicense:purchaseReplacement')
AddEventHandler('weaponlicense:purchaseReplacement', function(playerData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if WeaponLicenseConfig.ReplacementCost.enabled then
        local cost = WeaponLicenseConfig.ReplacementCost.amount
        local playerMoney = xPlayer.getMoney()
        local playerBank = xPlayer.getAccount('bank').money
        
        if (playerMoney + playerBank) < cost then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _U('insufficient_funds'),
                description = _U('insufficient_funds_replacement', cost),
                type = 'error',
                position = 'top'
            })
            return
        end
        
        if playerMoney >= cost then
            xPlayer.removeMoney(cost)
        else
            local remainingCost = cost - playerMoney
            if playerMoney > 0 then
                xPlayer.removeMoney(playerMoney)
            end
            xPlayer.removeAccountMoney('bank', remainingCost)
        end
    end
    
    MySQL.Async.fetchAll([[
        SELECT 
            u.sex as gender,
            u.firstname,
            u.lastname,
            u.dateofbirth,
            wla.discord,
            DATE_FORMAT(wla.accepted_date, "%m/%d/%Y") as issued_date
        FROM users u
        LEFT JOIN weapon_license_accepted wla ON u.identifier = wla.identifier
        WHERE u.identifier = ?
    ]], {xPlayer.identifier}, function(result)
        
        local metadata = {
            firstname = _U('unknown'),
            lastname = _U('unknown'),
            dateofbirth = _U('unknown'),
            gender = _U('unknown'),
            issued_date = os.date("%m/%d/%Y"),
            license_type = _U('weapon_license'),
            strikes = 0
        }
        
        if #result > 0 then
            local userData = result[1]
            metadata.firstname = userData.firstname or _U('unknown')
            metadata.lastname = userData.lastname or _U('unknown')
            
            local dob = userData.dateofbirth or _U('unknown')
            if dob ~= _U('unknown') and string.match(dob, "^%d%d/%d%d/%d%d%d%d$") then
                local day, month, year = string.match(dob, "(%d%d)/(%d%d)/(%d%d%d%d)")
                if day and month and year then
                    metadata.dateofbirth = month .. "/" .. day .. "/" .. year
                else
                    metadata.dateofbirth = dob
                end
            else
                metadata.dateofbirth = dob
            end

            if userData.gender then
                if string.lower(userData.gender) == "m" then
                    metadata.gender = _U('male')
                elseif string.lower(userData.gender) == "f" then
                    metadata.gender = _U('female')
                else
                    metadata.gender = userData.gender
                end
            end
            
            metadata.issued_date = userData.issued_date or os.date("%m/%d/%Y")
        end
        
        exports.ox_inventory:AddItem(src, WeaponLicenseConfig.ItemName, 1, metadata)
        
        local message = WeaponLicenseConfig.ReplacementCost.enabled and 
            _U('license_issued_replacement_cost', WeaponLicenseConfig.ReplacementCost.amount) or 
            _U('license_issued_replacement')
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('license_issued'),
            description = message,
            type = 'success',
            position = 'top'
        })
    end)
end)

-- Show license to another player
RegisterServerEvent('weaponlicense:showLicenseToPlayer')
AddEventHandler('weaponlicense:showLicenseToPlayer', function(targetId, licenseData)
    local src = source
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    
    if not targetPlayer then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('player_not_found'),
            description = _U('player_not_found_desc', targetId),
            type = 'error',
            position = 'top'
        })
        return
    end

    TriggerClientEvent('weaponlicense:displayLicense', targetId, licenseData, src)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = _U('license_shown'),
        description = _U('license_shown_desc', targetId),
        type = 'success',
        position = 'top'
    })
end)

-- Add strike to license
RegisterServerEvent('weaponlicense:addStrike')
AddEventHandler('weaponlicense:addStrike', function(targetSrc, licenseSlot)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetSrc)
    
    if not xPlayer or not targetPlayer then return end
    
    local isPolice = false
    if WeaponLicenseConfig.PoliceJobs then
        for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
            if xPlayer.job.name == job then
                isPolice = true
                break
            end
        end
    end
    
    if not isPolice then return end
    
    local item = exports.ox_inventory:GetSlot(targetSrc, licenseSlot)
    if not item or item.name ~= WeaponLicenseConfig.ItemName then return end
    
    local metadata = item.metadata or {}
    local currentStrikes = metadata.strikes or 0
    local newStrikes = currentStrikes + 1
    
    if newStrikes >= WeaponLicenseConfig.StrikeSystem.maxStrikes then
        exports.ox_inventory:RemoveItem(targetSrc, WeaponLicenseConfig.ItemName, 1, metadata, licenseSlot)
        MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = ? AND type = ?', {
            targetPlayer.identifier,
            WeaponLicenseConfig.LicenseType
        })
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('license_revoked'),
            description = _U('license_revoked_strikes', WeaponLicenseConfig.StrikeSystem.maxStrikes),
            type = 'success',
            position = 'top'
        })
        
        TriggerClientEvent('ox_lib:notify', targetSrc, {
            title = _U('license_revoked'),
            description = _U('license_revoked_player'),
            type = 'error',
            position = 'top'
        })
        
        TriggerClientEvent('weaponlicense:closeLicenseDisplay', src)
    else
        metadata.strikes = newStrikes
        exports.ox_inventory:SetMetadata(targetSrc, licenseSlot, metadata)
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('strike_added'),
            description = _U('strike_added_desc', newStrikes, WeaponLicenseConfig.StrikeSystem.maxStrikes),
            type = 'success',
            position = 'top'
        })
        
        TriggerClientEvent('ox_lib:notify', targetSrc, {
            title = _U('strike_added'),
            description = _U('strike_added_player', newStrikes, WeaponLicenseConfig.StrikeSystem.maxStrikes),
            type = 'warning',
            position = 'top'
        })
        
        TriggerClientEvent('weaponlicense:refreshLicenseDisplay', src, {
            metadata = metadata,
            slot = licenseSlot,
            owner = targetSrc
        }, targetSrc)
    end
end)

-- Revoke license via inspection
RegisterServerEvent('weaponlicense:revokeLicenseInspection')
AddEventHandler('weaponlicense:revokeLicenseInspection', function(targetSrc, licenseSlot)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetSrc)
    
    if not xPlayer or not targetPlayer then return end
    
    local isPolice = false
    if WeaponLicenseConfig.PoliceJobs then
        for _, job in pairs(WeaponLicenseConfig.PoliceJobs) do
            if xPlayer.job.name == job then
                isPolice = true
                break
            end
        end
    end
    
    if not isPolice then return end
    
    local item = exports.ox_inventory:GetSlot(targetSrc, licenseSlot)
    if not item or item.name ~= WeaponLicenseConfig.ItemName then return end
    
    exports.ox_inventory:RemoveItem(targetSrc, WeaponLicenseConfig.ItemName, 1, item.metadata, licenseSlot)
    
    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = ? AND type = ?', {
        targetPlayer.identifier,
        WeaponLicenseConfig.LicenseType
    })
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = _U('license_revoked'),
        description = _U('license_revoked_desc'),
        type = 'success',
        position = 'top'
    })
    
    TriggerClientEvent('ox_lib:notify', targetSrc, {
        title = _U('license_revoked'),
        description = _U('license_revoked_police'),
        type = 'error',
        position = 'top'
    })
    
    TriggerClientEvent('weaponlicense:closeLicenseDisplay', src)
end)