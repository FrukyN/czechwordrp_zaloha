-- Local variables
local originalPed = nil
local originalModel = nil
local isFemale = false
local currentPed = nil

-- Function to check if illenium-appearance is available
local function IsIlleniumAppearanceAvailable()
    return GetResourceState('illenium-appearance') == 'started'
end

-- Function to save the original ped state
local function SaveOriginalPed()
    originalPed = PlayerPedId()
    originalModel = GetEntityModel(originalPed)
    
    -- Check if the player is using a female character
    isFemale = (originalModel == GetHashKey('mp_f_freemode_01'))
    
    if Config.Debug then
        print('[ZX-PedMenu] Original ped saved. Model: ' .. originalModel .. ', Is Female: ' .. tostring(isFemale))
    end
end

-- Function to reset to original ped
local function ResetToPed()
    local modelHash = isFemale and GetHashKey(Config.DefaultPed.female) or GetHashKey(Config.DefaultPed.model)
    
    if IsModelInCdimage(modelHash) and IsModelValid(modelHash) then
        RequestModel(modelHash)
        
        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
        
        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)
        
        -- Use /reloadskin command as requested
        ExecuteCommand('reloadskin')
        
        -- Also keep the illenium-appearance compatibility as fallback
        if IsIlleniumAppearanceAvailable() then
            TriggerEvent('illenium-appearance:client:reloadSkin')
        end
        
        currentPed = nil
        
        -- Show notification
        lib.notify(Config.Notifications.pedReset)
    else
        lib.notify({
            title = Config.Notifications.error.title,
            description = string.format(Config.Notifications.error.description, 'Invalid model'),
            type = Config.Notifications.error.type
        })
    end
end

-- Function to change to a specific ped
local function ChangeToPed(pedModel)
    if not originalPed then
        SaveOriginalPed()
    end
    
    local modelHash = GetHashKey(pedModel)
    
    if IsModelInCdimage(modelHash) and IsModelValid(modelHash) then
        RequestModel(modelHash)
        
        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
        
        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)
        
        -- Fix for invisible animal ped issue
        local playerPed = PlayerPedId()
        SetPedComponentVariation(playerPed, 0, 0, 0, 0) -- Force component update
        SetEntityVisible(playerPed, true, false) -- Ensure ped is visible
        SetPedCanRagdoll(playerPed, true) -- Enable ragdoll for physics
        SetPedDefaultComponentVariation(playerPed) -- Reset clothing to defaults
        
        -- Find the ped label for notification
        local pedLabel = pedModel
        for _, ped in ipairs(Config.Peds) do
            if ped.model == pedModel then
                pedLabel = ped.label
                break
            end
        end
        
        currentPed = pedModel
        
        -- Show notification
        lib.notify({
            title = Config.Notifications.pedChanged.title,
            description = string.format(Config.Notifications.pedChanged.description, pedLabel),
            type = Config.Notifications.pedChanged.type
        })
    else
        lib.notify({
            title = Config.Notifications.error.title,
            description = string.format(Config.Notifications.error.description, 'Invalid model'),
            type = Config.Notifications.error.type
        })
    end
end

-- Function to open the ped menu
local function OpenPedMenu()
    -- Create a list of peds to display as a list
    local items = {}
    
    -- Add a simple button for each ped option
    for _, ped in ipairs(Config.Peds) do
        table.insert(items, {
            label = ped.label,
            args = { model = ped.model }
        })
    end
    
    -- This creates the exact style of menu shown in the screenshot
    lib.registerMenu({
        id = 'zx_ped_menu',
        title = 'ZX-PedMenu',
        position = 'top-right',
        options = items
    }, function(selected, scrollIndex, args)
        -- When a menu item is clicked, change to that ped
        if args and args.model then
            ChangeToPed(args.model)
        end
    end)
    
    -- Show the menu
    lib.showMenu('zx_ped_menu')
end

-- Register command to open the ped menu
RegisterCommand(Config.Command, function()
    -- Check if the player is authorized on the server side
    TriggerServerEvent('zx-pedmenu:server:checkAuthorization')
end, false)

-- Event triggered from server after authorization check
RegisterNetEvent('zx-pedmenu:client:openMenu')
AddEventHandler('zx-pedmenu:client:openMenu', function(isAuthorized)
    if isAuthorized then
        if not originalPed then
            SaveOriginalPed()
        end
        OpenPedMenu()
    else
        lib.notify(Config.Notifications.notAuthorized)
    end
end)

-- Save the original ped when the resource starts
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Wait a short time to ensure the player is fully loaded
    Wait(1000)
    SaveOriginalPed()
end)

-- Listen for player spawn to handle respawns correctly
AddEventHandler('playerSpawned', function()
    -- If the player was using a custom ped, reapply it
    if currentPed then
        Wait(1000) -- Wait a short time to ensure the spawn is complete
        ChangeToPed(currentPed)
    end
end)
