local ox_inventory = exports.ox_inventory

RegisterNetEvent('nbs_item_tags:client:wrightTag', function(slot)
    if not slot then return end -- slot je číslo

    local input = lib.inputDialog('Přejmenovat předmět', {
        { type = 'input', label = 'Nový název', description = 'Zadej nový název pro předmět (3–30 znaků)', required = true, min = 3, max = 30 }
    })

    if input then
        lib.callback('nbs_item_tags:server:addTag', false, function(success)
            if success then
                lib.notify({ title = 'Úspěch', description = 'Předmět byl přejmenován.', type = 'success' })
            else
                lib.notify({ title = 'Chyba', description = 'Přejmenování se nepodařilo.', type = 'error' })
            end
        end, slot, input[1])
    end
end)

RegisterNetEvent('nbs_item_tags:client:removeTag', function(slot)
    if not slot then return end

    lib.callback('nbs_item_tags:server:removeTag', false, function(success)
        if success then
            lib.notify({ title = 'Úspěch', description = 'Název byl odstraněn.', type = 'success' })
        else
            lib.notify({ title = 'Chyba', description = 'Odstranění názvu se nepodařilo.', type = 'error' })
        end
    end, slot)
end)
