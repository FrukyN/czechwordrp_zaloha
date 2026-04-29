local ESX = exports["es_extended"]:getSharedObject()
local itemsOnCounter = {} -- Tabulka pro uložení nákupů na pásu

-- 1. ZÁKAZNÍK: Položí věci na pás
RegisterNetEvent('tesco:placeItemsOnCounter', function(items)
    local src = source
    local total = 0
    for _, v in ipairs(items) do 
        total = total + v.price 
    end
    
    itemsOnCounter[src] = {
        owner = src,
        items = items,
        total = total
    }
    -- Debug print do konzole serveru (můžeš smazat)
    print(string.format("^2[Tesco]^0 Hráč %s položil nákup na pás (Celkem: %s Kč)", src, total))
end)

-- 2. PRODAVAČ: Otevře menu pro konkrétní ID zákazníka
RegisterNetEvent('tesco:openRegister', function(targetId)
    local src = source
    local targetId = tonumber(targetId)
    local customerData = itemsOnCounter[targetId]

    if not customerData then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Tesco Pokladna',
            description = 'Hráč s ID '..targetId..' nemá na pásu žádné zboží!', 
            type = 'error'
        })
        return
    end

    -- Příprava dat pro menu prodavače
    local options = {}
    for _, item in ipairs(customerData.items) do
        table.insert(options, {
            title = item.label,
            description = "Cena: " .. item.price .. " Kč",
            icon = "barcode"
        })
    end
    
    -- Pošleme data prodavačovi, aby si vykreslil menu
    TriggerClientEvent('tesco:client:openCashierMenu', src, options, targetId, customerData.total, customerData.items)
end)

-- 3. PRODAVAČ -> ZÁKAZNÍK: Vyžádání platby
-- Tento event propojí prodavače se zákazníkem a pošle mu účet k potvrzení
RegisterNetEvent('tesco:server:requestFinalPayment', function(targetId, total, items)
    local cashierId = source
    local targetId = tonumber(targetId)

    if itemsOnCounter[targetId] then
        -- Pošleme účet přímo zákazníkovi
        TriggerClientEvent('tesco:client:receiveBill', targetId, total, items, cashierId)
        
        -- Vymažeme nákup z pásu (protože se už zpracovává u zákazníka)
        itemsOnCounter[targetId] = nil
    else
        TriggerClientEvent('ox_lib:notify', cashierId, {description = 'Nákup už na pásu není nebo byl zrušen.', type = 'error'})
    end
end)

-- 4. ZÁKAZNÍK: Finální stržení peněz a předání věcí
RegisterNetEvent('tesco:server:finalPayment', function(total, items)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() >= total then
        -- Kontrola váhy v OX Inventory
        local canCarry = true
        for _, v in ipairs(items) do
            if not exports.ox_inventory:CanCarryItem(src, v.name, 1) then
                canCarry = false
                break
            end
        end

        if canCarry then
            -- Strhneme peníze
            xPlayer.removeMoney(total)
            
            -- Přidáme všechny položky do inventáře
            for _, v in ipairs(items) do
                exports.ox_inventory:AddItem(src, v.name, 1)
            end
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Tesco', 
                description = 'Zaplaceno: '..total..' Kč. Věci máš v inventáři.', 
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Tesco',
                description = 'Máš příliš těžký nákup, neuneseš ho!', 
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Tesco',
            description = 'Nedostatek peněz v hotovosti!', 
            type = 'error'
        })
    end
end)