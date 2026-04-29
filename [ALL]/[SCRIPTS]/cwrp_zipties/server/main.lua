local ESX = exports['es_extended']:getSharedObject()
-- Použití pásky
ESX.RegisterUsableItem(Config.ZiptieItem, function(source)
    TriggerClientEvent('pasky:useZiptie', source)
end)

-- Použití nůžek pro rozvázání
ESX.RegisterUsableItem(Config.CutterItem, function(source)
    TriggerClientEvent('pasky:useCutter', source)
end)

-- Event pro aplikaci pásek na cíl
RegisterNetEvent('pasky:tieTarget')
AddEventHandler('pasky:tieTarget', function(targetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xPlayer and xTarget then
        -- Zkontrolujeme, zda má hráč opravdu pásky
        local item = xPlayer.getInventoryItem(Config.ZiptieItem)
        if item and item.count > 0 then
            xPlayer.removeInventoryItem(Config.ZiptieItem, 1)
            TriggerClientEvent('pasky:toggleTied', targetId)
            TriggerClientEvent('ox_lib:notify', source, {title = 'Úspěch', description = 'Hráč byl svázán.', type = 'success'})
        else
            TriggerClientEvent('ox_lib:notify', source, {title = 'Chyba', description = 'Nemáš stahovací pásky!', type = 'error'})
        end
    end
end)

-- Event pro rozvázání cíle
RegisterNetEvent('pasky:untieTarget')
AddEventHandler('pasky:untieTarget', function(targetId)
    local source = source
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xTarget then
        TriggerClientEvent('pasky:toggleTied', targetId, false) -- Pošleme false pro explicitní rozvázání
        TriggerClientEvent('ox_lib:notify', source, {title = 'Úspěch', description = 'Hráč byl rozvázán.', type = 'success'})
    end
end)