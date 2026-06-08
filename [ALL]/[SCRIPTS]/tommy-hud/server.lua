ESX = exports['es_extended']:getSharedObject()

RegisterCommand('hud', function(source, args)
    TriggerClientEvent('hud:client:toggle', source)
end, false)
