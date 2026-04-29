Framework = {}
Framework.Name = nil
Framework.PlayerData = nil
Framework.PlayerLoaded = false

-- Function to detect and initialize the framework
function Framework.Init()
    if GetResourceState('es_extended') == 'started' then
        Framework.Name = 'ESX'
        Framework.LoadESX()
    elseif GetResourceState('qb-core') == 'started' then
        Framework.Name = 'QB'
        Framework.LoadQB()
    else
        print('[ZX-PedMenu] No supported framework detected (ESX/QB). Some features may not work correctly.')
        Framework.Name = 'None'
    end
    
    print('[ZX-PedMenu] Detected framework: ' .. Framework.Name)
end

-- Function to load ESX framework
function Framework.LoadESX()
    ESX = exports['es_extended']:getSharedObject()
    
    if Config.Debug then
        print('[ZX-PedMenu] ESX framework loaded')
    end
    
    -- ESX player loaded event
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        Framework.PlayerData = xPlayer
        Framework.PlayerLoaded = true
        
        if Config.Debug then
            print('[ZX-PedMenu] Player loaded in ESX framework')
        end
    end)
    
    -- ESX player data update event
    RegisterNetEvent('esx:setPlayerData')
    AddEventHandler('esx:setPlayerData', function(key, val)
        if Framework.PlayerData then
            Framework.PlayerData[key] = val
        end
    end)
end

-- Function to load QB framework
function Framework.LoadQB()
    QBCore = exports['qb-core']:GetCoreObject()
    
    if Config.Debug then
        print('[ZX-PedMenu] QB framework loaded')
    end
    
    -- QB player loaded event
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        Framework.PlayerData = QBCore.Functions.GetPlayerData()
        Framework.PlayerLoaded = true
        
        if Config.Debug then
            print('[ZX-PedMenu] Player loaded in QB framework')
        end
    end)
    
    -- QB player data update event
    RegisterNetEvent('QBCore:Player:SetPlayerData')
    AddEventHandler('QBCore:Player:SetPlayerData', function(data)
        Framework.PlayerData = data
    end)
end

-- Function to get player identifier
function Framework.GetIdentifier()
    local playerId = GetPlayerServerId(PlayerId())
    return playerId
end

-- Initialize the framework
Framework.Init()
