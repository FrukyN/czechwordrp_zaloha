-- Function to check if a player is authorized
local function IsPlayerAuthorized(source)
    local identifier = GetPlayerIdentifierByType(source, Config.IdentifierType)
    
    if not identifier then
        if Config.Debug then
            print('[ZX-PedMenu] Unable to get ' .. Config.IdentifierType .. ' identifier for player ' .. source)
        end
        return false
    end
    
    for _, authId in ipairs(Config.AuthorizedIdentifiers) do
        if identifier == authId then
            if Config.Debug then
                print('[ZX-PedMenu] Player ' .. source .. ' is authorized with identifier ' .. identifier)
            end
            return true
        end
    end
    
    if Config.Debug then
        print('[ZX-PedMenu] Player ' .. source .. ' is not authorized. Identifier: ' .. identifier)
    end
    
    return false
end

-- Event to check authorization and open the menu
RegisterNetEvent('zx-pedmenu:server:checkAuthorization')
AddEventHandler('zx-pedmenu:server:checkAuthorization', function()
    local source = source
    local isAuthorized = IsPlayerAuthorized(source)
    
    TriggerClientEvent('zx-pedmenu:client:openMenu', source, isAuthorized)
end)

-- Framework specific initialization
local function InitializeFramework()
    local esxStarted = GetResourceState('es_extended') == 'started'
    local qbStarted = GetResourceState('qb-core') == 'started'
    
    if esxStarted then
        print('[ZX-PedMenu] ESX framework detected on server')
    elseif qbStarted then
        print('[ZX-PedMenu] QB framework detected on server')
    else
        print('[ZX-PedMenu] No supported framework detected (ESX/QB). Using fallback authorization.')
    end
end

-- Initialize when resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    InitializeFramework()
    print('[ZX-PedMenu] Server-side initialized.')
end)
