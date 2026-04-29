local function getPlayerJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.job.name or nil
end

-- Export pro OX Inventory (volá se při použití itemu)
exports('drugtest', function(data, slot)
    local source = data.inv.id
    local job = getPlayerJob(source)

    if Config.AllowedJobs[job] then
        TriggerClientEvent('av_drugtest:startTest', source)
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Nejsi ve službě nebo nemáš oprávnění!'})
    end
end)

-- Žádost o výsledek od podezřelého
RegisterNetEvent('av_drugtest:requestResult', function(targetId)
    local policista = source
    if GetPlayerName(targetId) then
        TriggerClientEvent('av_drugtest:showTargetMenu', targetId, policista)
    else
        TriggerClientEvent('ox_lib:notify', policista, {type = 'error', description = 'Hráč s tímto ID není ve městě!'})
    end
end)

-- Přeposlání výsledku zpět policistovi
RegisterNetEvent('av_drugtest:sendBackToPolice', function(policistaId, isPositive)
    TriggerClientEvent('av_drugtest:finalDisplay', policistaId, isPositive)
end)