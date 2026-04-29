RegisterNetEvent('esx_vehicle_damage:triggerImpact')
AddEventHandler('esx_vehicle_damage:triggerImpact', function(targetId)
    -- Pošle efekt konkrétnímu hráči v autě
    TriggerClientEvent('esx_vehicle_damage:applyImpact', targetId)
end)