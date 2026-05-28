local detectedFramework = nil
local detectedInventory = nil
local detectedProgressBar = nil
local detectedAmbulance = nil
local isRobbing = false
local lastRobTime = 0
local isHandsUp = false
local robberyCancelled = false
local commandsRegistered = false

local inventoryResources = {
    'ox_inventory',
    'qb-inventory',
    'qs-inventory',
    'ps-inventory',
    'lj-inventory',
    'codem-inventory',
    'core_inventory',
    'origen_inventory',
    'tgiann-inventory'
}

local progressBarResources = {
    'ox_lib',
    'qb-progressbar',
    'mythic_progbar'
}

local ambulanceResources = {
    'wasabi_ambulance',
    'cd_ambulance',
    'esx_ambulancejob',
    'qb-ambulancejob',
    'ars_ambulancejob',
    'mythic_hospital',
    'pickle_deathscreen',
    'Starter_Hospital',
    'linden_ambulance',
    'mh-ambulancejob',
    'codem-ambulance',
    'qbx_medical',
    'Renewed-Ambulance'
}

local InventoryHandlers = {
    ['ox_inventory'] = function()
        exports.ox_inventory:openNearbyInventory()
    end,
    ['qb-inventory'] = function(targetId)
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', targetId)
    end,
    ['qs-inventory'] = function(targetId)
        TriggerServerEvent('qs-inventory:server:OpenInventory', 'otherplayer', targetId)
    end,
    ['ps-inventory'] = function(targetId)
        TriggerServerEvent('ps-inventory:server:OpenInventory', 'otherplayer', targetId)
    end,
    ['lj-inventory'] = function(targetId)
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', targetId)
    end,
    ['codem-inventory'] = function(targetId)
        TriggerServerEvent('codem-inventory:server:OpenInventory', 'otherplayer', targetId)
    end,
    ['core_inventory'] = function(targetId)
        TriggerServerEvent('core_inventory:server:openInventory', 'otherplayer', targetId)
    end,
    ['origen_inventory'] = function(targetId)
        TriggerServerEvent('origen_inventory:OpenInventory', 'otherplayer', targetId)
    end,
    ['tgiann-inventory'] = function(targetId)
        exports['tgiann-inventory']:openTargetInventory(targetId)
    end
}

local function DetectResource(configValue, resourceList)
    if configValue ~= 'auto' then
        if GetResourceState(configValue) == 'started' then
            return configValue
        end
        return nil
    end
    for i = 1, #resourceList do
        if GetResourceState(resourceList[i]) == 'started' then
            return resourceList[i]
        end
    end
    return nil
end

local function InitializeFramework()
    if Config.Framework == 'qbcore' or Config.Framework == 'qb-core' then
        if GetResourceState('qb-core') == 'started' then
            detectedFramework = 'qbcore'
        end
    elseif Config.Framework == 'qbx' or Config.Framework == 'qbx_core' then
        if GetResourceState('qbx_core') == 'started' then
            detectedFramework = 'qbx'
        end
    elseif Config.Framework == 'esx' or Config.Framework == 'es_extended' then
        if GetResourceState('es_extended') == 'started' then
            detectedFramework = 'esx'
        end
    elseif Config.Framework == 'standalone' or Config.Framework == 'none' then
        detectedFramework = 'standalone'
    elseif Config.Framework == 'auto' then
        if GetResourceState('qbx_core') == 'started' then
            detectedFramework = 'qbx'
        elseif GetResourceState('qb-core') == 'started' then
            detectedFramework = 'qbcore'
        elseif GetResourceState('es_extended') == 'started' then
            detectedFramework = 'esx'
        else
            detectedFramework = 'standalone'
        end
    end

    detectedInventory = DetectResource(Config.Inventory, inventoryResources)
    detectedProgressBar = DetectResource(Config.ProgressBar, progressBarResources)
    detectedAmbulance = DetectResource(Config.Ambulance, ambulanceResources)

    print('^2[FEARX-OXROB-V2] Framework: ^3' .. (detectedFramework or 'none') .. '^0')
    print('^2[FEARX-OXROB-V2] Inventory: ^3' .. (detectedInventory or 'none') .. '^0')
    print('^2[FEARX-OXROB-V2] Progress Bar: ^3' .. (detectedProgressBar or 'none') .. '^0')
    print('^2[FEARX-OXROB-V2] Ambulance: ^3' .. (detectedAmbulance or 'none') .. '^0')
end

local function IsPlayerHandsUp(serverId)
    local player = GetPlayerFromServerId(serverId)
    if player == -1 then return false end
    local ped = GetPlayerPed(player)
    if not ped or ped == 0 then return false end

    for i = 1, #Config.HandsUpAnims do
        local data = Config.HandsUpAnims[i]
        if IsEntityPlayingAnim(ped, data.dict, data.anim, 3) then
            return true
        end
    end
    return false
end

local function IsPlayerDeadByAmbulance(serverId, player, ped)
    if not detectedAmbulance then return nil end

    if detectedAmbulance == 'wasabi_ambulance' then
        local ok, result = pcall(exports.wasabi_ambulance.isPlayerDead, exports.wasabi_ambulance, serverId)
        if ok then return result end
    end

    if detectedAmbulance == 'cd_ambulance' and player == PlayerId() then
        local ok, result = pcall(exports.cd_ambulance.isPlayerDead, exports.cd_ambulance)
        if ok then return result end
    end

    if detectedAmbulance == 'mythic_hospital' then
        local ok, result = pcall(exports.mythic_hospital.IsPlayerDead, exports.mythic_hospital)
        if ok and player == PlayerId() then return result end
    end

    if detectedAmbulance == 'Renewed-Ambulance' then
        local ok, result = pcall(exports['Renewed-Ambulance'].isPlayerDead, exports['Renewed-Ambulance'])
        if ok and player == PlayerId() then return result end
    end

    return nil
end

local function IsPlayerDead(serverId)
    local player = GetPlayerFromServerId(serverId)
    if player == -1 then return false end
    local ped = GetPlayerPed(player)
    if not ped or ped == 0 then return false end

    local ambulanceResult = IsPlayerDeadByAmbulance(serverId, player, ped)
    if ambulanceResult ~= nil then return ambulanceResult end

    if IsEntityDead(ped) or GetEntityHealth(ped) <= 0 then
        return true
    end

    if player == PlayerId() then
        if LocalPlayer.state.isDead then return true end
        if LocalPlayer.state.dead then return true end
        if LocalPlayer.state.isDown then return true end
        if LocalPlayer.state.inLaststand then return true end
        return false
    end

    local state = Player(player).state
    if state then
        if state.isDead then return true end
        if state.dead then return true end
        if state.isDown then return true end
        if state.inLaststand then return true end
    end

    return false
end

local function GetClosestPlayer()
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local players = GetActivePlayers()
    local closestDist = Config.RobDistance
    local closestId = nil

    for i = 1, #players do
        local player = players[i]
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if ped and ped ~= 0 then
                local dist = #(myCoords - GetEntityCoords(ped))
                if dist < closestDist then
                    closestDist = dist
                    closestId = GetPlayerServerId(player)
                end
            end
        end
    end

    return closestId
end

local function DoProgressBar(duration, label, animData)
    if detectedProgressBar == 'ox_lib' then
        return lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {car = true, move = true, combat = true},
            anim = {dict = animData.dict, clip = animData.anim, flag = animData.flag}
        })
    elseif detectedProgressBar == 'mythic_progbar' then
        local success = false
        exports['mythic_progbar']:Progress({
            name = 'robbery',
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {disableMovement = true, disableCarMovement = true, disableCombat = true},
            animation = {animDict = animData.dict, anim = animData.anim, flags = animData.flag}
        }, function(cancelled) success = not cancelled end)

        local timeout = GetGameTimer() + duration + 500
        while exports['mythic_progbar']:isDoingSomething() and GetGameTimer() < timeout do
            Wait(50)
        end
        return success
    elseif detectedProgressBar == 'qb-progressbar' then
        local success = false
        local finished = false
        exports['qb-progressbar']:Progress({
            name = 'robbery',
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {disableMovement = true, disableCarMovement = true, disableCombat = true},
            animation = {animDict = animData.dict, anim = animData.anim, flags = animData.flag}
        }, function(cancelled)
            finished = true
            success = not cancelled
        end)

        local timeout = GetGameTimer() + duration + 500
        while not finished and GetGameTimer() < timeout do
            Wait(50)
        end
        return success
    end

    return false
end

local function OpenTargetInventory(targetId)
    if not detectedInventory then return end
    local handler = InventoryHandlers[detectedInventory]
    if handler then
        handler(targetId)
    end
end

local function StartRobbery(targetId)
    local robTime = math.random(Config.RobTimer.min * 1000, Config.RobTimer.max * 1000)
    local animData = Config.RobAnimations[math.random(1, #Config.RobAnimations)]

    isRobbing = true
    robberyCancelled = false
    lastRobTime = GetGameTimer()

    TriggerServerEvent('fearx-oxrob:server:startRob', targetId)

    CreateThread(function()
        while isRobbing and not robberyCancelled do
            Wait(500)

            local targetPlayer = GetPlayerFromServerId(targetId)
            if targetPlayer == -1 then
                robberyCancelled = true
                break
            end

            local targetPed = GetPlayerPed(targetPlayer)
            if not targetPed or targetPed == 0 or not DoesEntityExist(targetPed) then
                robberyCancelled = true
                break
            end

            local myPed = PlayerPedId()
            if #(GetEntityCoords(myPed) - GetEntityCoords(targetPed)) > Config.RobDistance + 2.0 then
                lib.notify({description = Config.Locales['target_moved'], type = 'error'})
                robberyCancelled = true
                break
            end

            if Config.RobMode == 'alive' and IsEntityDead(targetPed) then
                lib.notify({description = Config.Locales['target_died'], type = 'error'})
                robberyCancelled = true
                break
            end

            if Config.RequireHandsUp and Config.RobMode ~= 'dead' and not IsEntityDead(targetPed) and not IsPlayerHandsUp(targetId) then
                lib.notify({description = Config.Locales['target_hands_down'], type = 'error'})
                robberyCancelled = true
                break
            end
        end

        if robberyCancelled then
            pcall(lib.cancelProgress)
        end
    end)

    local success = DoProgressBar(robTime, Config.Locales['robbing_in_progress'], animData)

    local wasCancelled = robberyCancelled
    isRobbing = false

    ClearPedTasks(PlayerPedId())

    if wasCancelled or not success then
        lib.notify({description = Config.Locales['rob_cancelled'], type = 'error'})
        TriggerServerEvent('fearx-oxrob:server:cancelRob', targetId)
        return
    end

    TriggerServerEvent('fearx-oxrob:server:completeRob', targetId)
end

local function HandsUpCommand()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        lib.notify({description = Config.Locales['no_vehicle_handsup'], type = 'error'})
        return
    end

    if isHandsUp then
        ClearPedTasks(ped)
        isHandsUp = false
        lib.notify({description = Config.Locales['hands_down'], type = 'inform'})
        TriggerServerEvent('fearx-oxrob:server:targetHandsDown')
    else
        lib.requestAnimDict('missminuteman_1ig_2')
        TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
        isHandsUp = true
        lib.notify({description = Config.Locales['hands_up'], type = 'inform'})
    end
end

local function CustomStealCommand()
    if isRobbing then return end

    if GetGameTimer() - lastRobTime < (Config.AntiSpam * 1000) then
        lib.notify({description = Config.Locales['anti_spam'], type = 'error'})
        return
    end

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        lib.notify({description = Config.Locales['robber_in_vehicle'], type = 'error'})
        return
    end

    local targetId = GetClosestPlayer()
    if not targetId then
        lib.notify({description = Config.Locales['no_target'], type = 'error'})
        return
    end

    local targetPlayer = GetPlayerFromServerId(targetId)
    if targetPlayer == -1 then
        lib.notify({description = Config.Locales['no_target'], type = 'error'})
        return
    end

    local targetPed = GetPlayerPed(targetPlayer)
    if not targetPed or targetPed == 0 then
        lib.notify({description = Config.Locales['no_target'], type = 'error'})
        return
    end

    if IsPedInAnyVehicle(targetPed, false) then
        lib.notify({description = Config.Locales['target_in_vehicle'], type = 'error'})
        return
    end

    local isDead = IsPlayerDead(targetId)

    if Config.RobMode == 'alive' and isDead then
        lib.notify({description = Config.Locales['target_is_dead'], type = 'error'})
        return
    elseif Config.RobMode == 'dead' and not isDead then
        lib.notify({description = Config.Locales['target_not_dead'], type = 'error'})
        return
    end

    if Config.RequireHandsUp and Config.RobMode ~= 'dead' and not isDead and not IsPlayerHandsUp(targetId) then
        lib.notify({description = Config.Locales['hands_not_up'], type = 'error'})
        return
    end

    StartRobbery(targetId)
end

local function RegisterCommands()
    if commandsRegistered then return end
    commandsRegistered = true
    RegisterCommand('steal', CustomStealCommand, false)
    RegisterCommand('handsup', HandsUpCommand, false)
    RegisterKeyMapping('handsup', 'Toggle hands up', 'keyboard', 'x')
    TriggerEvent('chat:removeSuggestion', '/steal')
    TriggerEvent('chat:addSuggestion', '/steal', 'Rob a nearby player')
end

CreateThread(function()
    InitializeFramework()
    RegisterCommands()
end)

CreateThread(function()
    while true do
        if isHandsUp then
            Wait(200)
            if IsEntityDead(PlayerPedId()) then
                isHandsUp = false
                TriggerServerEvent('fearx-oxrob:server:targetHandsDown')
            end
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('fearx-oxrob:client:beingRobbed', function()
    lib.notify({description = Config.Locales['robbery_started'], type = 'error'})
end)

RegisterNetEvent('fearx-oxrob:client:cancelRobbery', function()
    if isRobbing then
        robberyCancelled = true
    end
end)

RegisterNetEvent('fearx-oxrob:client:openInventory', function(targetId)
    if type(targetId) ~= 'number' then return end
    Wait(100)
    OpenTargetInventory(targetId)
end)

RegisterNetEvent('fearx-oxrob:client:notify', function(message, msgType)
    lib.notify({description = Config.Locales[message] or message, type = msgType or 'inform'})
end)
