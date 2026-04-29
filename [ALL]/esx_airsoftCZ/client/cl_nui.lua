-- Otevírání menu arény
function OpenArenaMenu(arenaId)
    local arena = Config.Arenas[arenaId]
    SendNUIMessage({
        action = "openLobby",
        label = arena.label,
        price = arena.price,
        arenaId = arenaId
    })
    SetNuiFocus(true, true)
end

-- Callbacky z NUI
RegisterNUICallback('joinTeam', function(data, cb)
    SetNuiFocus(false, false)
    Airsoft:Join(data.arenaId, data.team)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Synchronizace skóre do UI
RegisterNetEvent('airsoft:client:syncScore')
AddEventHandler('airsoft:client:syncScore', function(score)
    SendNUIMessage({
        action = "updateScore",
        blue = score.blue,
        red = score.red
    })
end)