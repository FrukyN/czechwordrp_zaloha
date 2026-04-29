local inventory = exports.ox_inventory

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for _, tray in pairs(Config.Trays) do
        inventory:RegisterStash(tray.id, tray.label, tray.slots, tray.maxWeight)
        print(("^2[BarTrays] ^7Registrovan stash: %s"):format(tray.id))
    end
end)