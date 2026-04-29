RegisterServerEvent('heli:toggleSpotlight')
AddEventHandler('heli:toggleSpotlight', function(netId, state)
    -- Pošle informaci o zapnutí/vypnutí všem hráčům kromě odesílatele
    TriggerClientEvent('heli:syncSpotlight', -1, netId, state)
end)

RegisterServerEvent('heli:updateDir')
AddEventHandler('heli:updateDir', function(netId, dir)
    -- Posílá směr světla všem (včetně odesílatele, ale klient má ošetřeno, aby se to nekousalo)
    TriggerClientEvent('heli:syncDir', -1, netId, dir)
end)