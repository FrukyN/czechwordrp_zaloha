local ESX = exports["es_extended"]:getSharedObject()

lib.addCommand('givemenu', {
    help = 'Otevře menu pro dávání věcí hráčům',
    restricted = 'group.admin' -- Zablokuje přístup všem kromě adminů
}, function(source, args, raw)
    TriggerClientEvent('admin_give:openMenu', source)
end)

-- Callback pro zjištění jména hráče
lib.callback.register('admin_give:getPlayerName', function(source, targetId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if xTarget then
        return xTarget.getName()
    end
    return nil
end)

-- Pomocná funkce pro ověření práv při triggerování eventů
local function isAdmin(xPlayer)
    local group = xPlayer.getGroup()
    return group == 'admin' or group == 'dev' -- Přidej další skupiny, pokud potřebuješ
end

-- Event pro ONLINE hráče
RegisterNetEvent('admin_give:giveOnline', function(targetId, itemName, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not isAdmin(xPlayer) then return end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if xTarget then
        -- Použití ox_inventory exportu pro přidání itemu
        exports.ox_inventory:AddItem(targetId, itemName, count)
        TriggerClientEvent('ox_lib:notify', source, {title = 'Úspěch', description = ('Předmět přidán hráči %s'):format(xTarget.getName()), type = 'success'})
    else
        TriggerClientEvent('ox_lib:notify', source, {title = 'Chyba', description = 'Hráč se mezitím odpojil.', type = 'error'})
    end
end)

-- Event pro OFFLINE hráče
RegisterNetEvent('admin_give:giveOffline', function(identifier, itemName, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not isAdmin(xPlayer) then return end

    -- Kontrola, jestli hráč náhodou zrovna není online
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    if xTarget then
        exports.ox_inventory:AddItem(xTarget.source, itemName, count)
        TriggerClientEvent('ox_lib:notify', source, {title = 'Úspěch', description = 'Hráč je aktuálně online. Item mu byl přidán rovnou do kapsy.', type = 'success'})
        return
    end

    -- Úprava databáze (oxmysql)
    local result = MySQL.query.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })
    
    if result and result[1] then
        local inventory = json.decode(result[1].inventory) or {}
        local slotsUsed = {}
        local stacked = false

        -- Ox_inventory většinou ukládá inventář jako array struktur (tabulek)
        for _, item in pairs(inventory) do
            slotsUsed[item.slot] = true
            -- Pokud item už má a stackuje se, přidáme jen počet
            if item.name == itemName then
                item.count = item.count + count
                stacked = true
                break
            end
        end

        -- Pokud item ještě nemá, najdeme první volný slot
        if not stacked then
            local emptySlot = 1
            while slotsUsed[emptySlot] do
                emptySlot = emptySlot + 1
            end
            
            -- Vložíme nový item do inventáře
            if #inventory > 0 or next(inventory) == nil then
                table.insert(inventory, {name = itemName, count = count, slot = emptySlot, metadata = {}})
            else
                inventory[tostring(emptySlot)] = {name = itemName, count = count, slot = emptySlot, metadata = {}}
            end
        end

        -- Uložíme zpět do DB
        MySQL.update.await('UPDATE users SET inventory = ? WHERE identifier = ?', { json.encode(inventory), identifier })
        TriggerClientEvent('ox_lib:notify', source, {title = 'Úspěch', description = 'Item byl úspěšně nahrán do databáze offline hráče.', type = 'success'})
    else
        TriggerClientEvent('ox_lib:notify', source, {title = 'Chyba', description = 'Hráč s touto licencí nebyl nalezen v databázi!', type = 'error'})
    end
end)