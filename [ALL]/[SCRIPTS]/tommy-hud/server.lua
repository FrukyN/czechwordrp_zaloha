ESX = exports['es_extended']:getSharedObject()

-- /togglehud
RegisterCommand('hud', function(source, args)
    TriggerClientEvent('hud:client:toggle', source)
end, false)