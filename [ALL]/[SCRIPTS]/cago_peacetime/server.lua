ESX = exports["es_extended"]:getSharedObject()

local manualPeacetime = false
local currentState = nil 

function getPoliceCount()
    if ESX == nil then return 0 end
    local count = 0
    local xPlayers = ESX.GetExtendedPlayers()
    
    for _, xPlayer in pairs(xPlayers) do
        local job = xPlayer.getJob()
        if job and (job.name == "police" or job.name == "policie_mp") then
            count = count + 1
        end
    end
    return count 
end

function updatePeacetime()
    local policeCount = getPoliceCount()
    
    -- Limit 2: Pokud je 0 nebo 1 policista, Peacetime svítí.
    local autoState = (policeCount < 2) 
    
    local newState = manualPeacetime or autoState
    
    if newState ~= currentState then
        currentState = newState
        TriggerClientEvent('peacetime:update', -1, currentState)
    end
end

-- FIX: Pošle aktuální stav nově připojenému hráči
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if currentState ~= nil then
        TriggerClientEvent('peacetime:update', playerId, currentState)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        updatePeacetime()
        Citizen.Wait(5000) 
    end
end)

RegisterCommand('peacetime', function(source, args, rawCommand)
    -- Podpora pro konzoli
    if source == 0 then
        manualPeacetime = not manualPeacetime
        updatePeacetime()
        print("[PEACETIME] Změněno přes konzoli na: " .. tostring(manualPeacetime))
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local group = xPlayer.getGroup()
        
        -- Kontrola všech tvých ranků z tags v2
        if group == 'tester' or group == 'trial' or group == 'admin' or group == 'junior' or 
           group == 'staff' or group == 'senior' or group == 'hos' or group == 'cardev' or 
           group == 'dev' or group == 'managment' or group == 'cowner' or group == 'owner' then
            
            manualPeacetime = not manualPeacetime
            updatePeacetime()
            
            local status = manualPeacetime and '^2ZAPNUT' or '^1VYPNUT'
            TriggerClientEvent('chat:addMessage', -1, { 
                args = { '^3[SYSTEM]', 'Peacetime: ' .. status .. ' ^7(nastavil ^3' .. GetPlayerName(source) .. '^7)' } 
            })
        else
            -- Pro hráče bez oprávnění
            TriggerClientEvent('chat:addMessage', source, { 
                args = { '^1[ERROR]', 'Na tento příkaz nemáš práva!' } 
            })
        end
    end
end, false)
