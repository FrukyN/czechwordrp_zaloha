local ESX = exports["es_extended"]:getSharedObject()
local activeBuyer = nil

-- Kontrola klenotů před hovorem
RegisterNetEvent('kleno_sell:requestCall', function()
    local src = source
    local hasAny = false

    -- Hledáme itemy definované v Configu
    for itemName, _ in pairs(Config.SellItems) do
        local count = exports.ox_inventory:Search(src, 'count', itemName)
        if count and count > 0 then
            hasAny = true
            break
        end
    end

    if hasAny then
        -- Pokud má itemy, vybereme náhodnou lokaci a spustíme dialog
        if activeBuyer and activeBuyer ~= src then
            TriggerClientEvent('ox_lib:notify', src, {description = 'Linka je obsazena.', type = 'error'})
            return
        end

        local coords = Config.BuyerLocations[math.random(1, #Config.BuyerLocations)]
        activeBuyer = src 
        TriggerClientEvent('kleno_sell:startPhoneDialog', src, coords)
    else
        -- Pokud nemá itemy
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Budka',
            description = 'Zkousis volat, ale nikdo to nebere (Nemas klenoty).',
            type = 'error'
        })
    end
end)

-- Finální prodej u NPC
RegisterNetEvent('kleno_sell:sellItems', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local totalMoney = 0
    local soldAny = false

    for itemName, priceRange in pairs(Config.SellItems) do
        local count = exports.ox_inventory:Search(src, 'count', itemName)
        if count and count > 0 then
            local price = math.random(priceRange.min, priceRange.max) * count
            if exports.ox_inventory:RemoveItem(src, itemName, count) then
                totalMoney = totalMoney + price
                soldAny = true
            end
        end
    end

    if soldAny then
        xPlayer.addMoney(totalMoney)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Obchod',
            description = 'Prodano za $'..totalMoney, 
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {description = 'Nemas nic k prodeji.', type = 'error'})
    end
    
    activeBuyer = nil
end)

AddEventHandler('playerDropped', function()
    if activeBuyer == source then activeBuyer = nil end
end)