-- server/main.lua
local ESX = exports["es_extended"]:getSharedObject() -- PŘIDEJ TENTO ŘÁDEK
local GlobalPatientData = {}

RegisterServerEvent('ems_script:syncInjury')
AddEventHandler('ems_script:syncInjury', function(data)
    local src = source
    GlobalPatientData[src] = data
end)

-- Speciální Revive System
ESX.RegisterServerCallback('ems_script:getDetailedStatus', function(source, cb, targetId)
    cb(GlobalPatientData[targetId] or {})
end)

RegisterServerEvent('ems_script:revivePlayer')
AddEventHandler('ems_script:revivePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
        -- Po revive hráč stále není 100% ok - musí se doléčit v nemocnici
        TriggerClientEvent('ems_script:applyPostReviveDebuff', targetId)
    end
end)

ESX.RegisterServerCallback('skrp_ems_system:getPatientInjuries', function(source, cb, targetId)
    -- Zeptáme se klienta pacienta na jeho data
    TriggerClientEvent('skrp_ems_system:requestData', targetId, source)
    
    -- Tady malý trik: počkáme chvíli na odpověď nebo použijeme dočasnou tabulku
    -- Pro jednoduchost teď předpokládejme, že data posíláme zpět přímo
end)

-- Event pro příjem dat od pacienta a přeposlání doktorovi
RegisterServerEvent('skrp_ems_system:sendDataToDoctor')
AddEventHandler('skrp_ems_system:sendDataToDoctor', function(doctorId, data)
    -- Tady by se to poslalo zpět do UI doktora
end)

-- Tabulka pro dočasné uložení požadavků
local PendingRequests = {}

ESX.RegisterServerCallback('skrp_ems_system:getPatientDataFromClient', function(source, cb, targetId)
    local doctorId = source
    local patientId = targetId

    -- Pokud je targetId neplatné nebo hráč neexistuje
    if not GetPlayerName(patientId) then 
        cb(nil) 
        return 
    end

    PendingRequests[doctorId] = cb

    -- Pošleme výzvu pacientovi
    TriggerClientEvent('skrp_ems_system:requestClientData', patientId, doctorId)

    -- Pokud pacient neodpoví do 2 vteřin, vrátíme nil, aby se doktorovi nezasekla hra
    SetTimeout(2000, function()
        if PendingRequests[doctorId] then
            PendingRequests[doctorId](nil)
            PendingRequests[doctorId] = nil
        end
    end)
end)

RegisterServerEvent('skrp_ems_system:respondWithData')
AddEventHandler('skrp_ems_system:respondWithData', function(doctorId, data)
    if PendingRequests[doctorId] then
        PendingRequests[doctorId](data) -- Tady vracíme data doktorovi
        PendingRequests[doctorId] = nil
    end
end)

-- server/main.lua

RegisterServerEvent('skrp_ems_system:removeItem')
AddEventHandler('skrp_ems_system:removeItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemName, 1)
end)

RegisterServerEvent('skrp_ems_system:removeInjury')
AddEventHandler('skrp_ems_system:removeInjury', function(targetId, injuryIndex)
    -- Pošleme příkaz klientovi pacienta, aby si smazal ránu z tabulky
    TriggerClientEvent('skrp_ems_system:syncRemoveInjury', targetId, injuryIndex)
end)

-- server/main.lua

RegisterServerEvent('skrp_ems_system:completeTreatment')
AddEventHandler('skrp_ems_system:completeTreatment', function(targetId, injuryIndex, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- 1. Odebereme item lékaři (ox_inventory)
    exports.ox_inventory:RemoveItem(source, item, 1)
    
    -- 2. Pošleme zprávu pacientovi, aby si smazal ránu z jeho tabulky
    TriggerClientEvent('skrp_ems_system:syncRemoveInjury', targetId, injuryIndex)
    
    -- 3. Notifikace pro doktora
    TriggerClientEvent('esx:showNotification', source, "~g~Rána byla úspěšně ošetřena.")
end)