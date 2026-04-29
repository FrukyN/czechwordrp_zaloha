-- Breathalyzer (upraveno pro ox_inventory)
RegisterNetEvent('breathalyzer.server:doBacTest', function(target)
    TriggerClientEvent('breathalyzer.client:requestBac', target, source, target)
end)

RegisterNetEvent('breathalyzer.server:returnBac', function(bac, leo)
    -- Využití ternárního operátoru pro čistší kód
    local color = bac > 0.08 and '--color-red' or '--color-black'
    TriggerClientEvent('breathalyzer.client:displayBac', leo, bac, color)
end)

RegisterNetEvent('breathalyzer.server:refusedBac', function(leo, target)
    TriggerClientEvent('breathalyzer.client:bacRefused', leo, target)
end)

RegisterNetEvent('breathalyzer.server:acceptedBac', function(leo, target)
    TriggerClientEvent('breathalyzer.client:acceptedBac', leo, target)
end)