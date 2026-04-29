local ESX = exports["es_extended"]:getSharedObject()
local ActiveOrders = {}

-- Funkce pro synchronizaci (posílá data všem pro okamžitý update UI)
function SyncOrders()
    TriggerClientEvent('foodora:client:syncOrders', -1, ActiveOrders)
end

-- Kontrola dostupnosti restaurací (kdo je online)
ESX.RegisterServerCallback('foodora:getShopStatus', function(source, cb)
    local shopStatus = {}
    if Config.Shops then
        for job, data in pairs(Config.Shops) do
            local xPlayers = ESX.GetExtendedPlayers('job', job)
            local hasCourier = false
            for _, xPlayer in pairs(xPlayers) do
                if xPlayer.job.grade >= (data.deliveryGrade or 0) then
                    hasCourier = true
                    break
                end
            end
            shopStatus[job] = { label = data.label, online = hasCourier }
        end
    end
    cb(shopStatus)
end)

RegisterNetEvent('foodora:server:placeOrder', function(shopId, cart, total)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- 1. KONTROLA, JESTLI UŽ HRÁČ NEMÁ AKTIVNÍ OBJEDNÁVKU
    for id, order in pairs(ActiveOrders) do
        if order.customer == src then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Chyba',
                description = 'Již máš jednu aktivní objednávku! Počkej na doručení.',
                type = 'error'
            })
            return -- Ukončíme funkci, objednávka se nevytvoří
        end
    end

    -- 2. KONTROLA PENĚZ
    local playerBank = xPlayer.getAccount('bank').money

    if playerBank >= total then
        -- Stržení peněz hráči
        xPlayer.removeAccountMoney('bank', total)
        
        -- PŘIPSÁNÍ PENĚZ DO FIREMNÍ KASY (SOCIETY)
        -- Předpokládáme, že shopId odpovídá názvu jobu (např. 'burger' -> 'society_burger')
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..shopId, function(account)
            if account then
                account.addMoney(total)
            else
                print("^1[Foodora] Varování: Nepodařilo se najít society účet pro: society_"..shopId.."^7")
            end
        end)

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Platba úspěšná',
            description = 'Zaplatil jsi $' .. total .. ' a restaurace obdržela platbu.',
            type = 'success'
        })

        -- 3. VYTVOŘENÍ OBJEDNÁVKY
        local id = tostring(math.random(1000, 9999))
        ActiveOrders[id] = {
            id = id,
            customer = src,
            customerName = xPlayer.getName(),
            shopId = shopId,
            items = cart,
            total = total,
            status = 'waiting'
        }

        SyncOrders()

        -- Notifikace pro kuchaře
        local xPlayers = ESX.GetExtendedPlayers()
        for _, xP in pairs(xPlayers) do
            local job = xP.getJob().name
            if job == 'pizza' or job == 'burger' or job == 'pizzeria' or job == shopId then
                TriggerClientEvent('foodora:client:newOrderAlert', xP.source, id)
            end
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Platba selhala',
            description = 'Nemáš dostatek peněz v bance!',
            type = 'error'
        })
    end
end)

-- Změna stavu objednávky (OPRAVENO)
RegisterNetEvent('foodora:server:updateStatus', function(data)
    local src = source
    if not data or not data.id then return end

    local orderId = tostring(data.id) 
    local newStatus = data.status
    local order = ActiveOrders[orderId]

    if not order then 
        print("^1[Foodora] Server nenasel objednavku s ID: " .. tostring(orderId) .. "^7")
        return 
    end

    -- Definujeme si zákazníka hned na začátku, aby s ním kód mohl pracovat
    local targetCustomer = order.customer

if newStatus == 'rejected' then
        local xCustomer = ESX.GetPlayerFromId(targetCustomer)
        
        if xCustomer then
            -- Vrátíme peníze hráči
            xCustomer.addAccountMoney('bank', order.total)
            
            -- ODEBEREME PENÍZE Z FIRMY (protože se objednávka nekoná)
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..order.shopId, function(account)
                if account then
                    account.removeMoney(order.total)
                end
            end)

            TriggerClientEvent('ox_lib:notify', targetCustomer, {
                title = 'Objednávka zrušena',
                description = 'Objednávka byla zamítnuta. Přijeď na kamenou prodejnu. Peníze byly vráceny z firemního účtu na váš účet.',
                type = 'error'
            })
        end

        ActiveOrders[orderId] = nil
        SyncOrders()
        return 
    end

    -- 2. AKTUALIZACE STAVU
    order.status = newStatus

    -- Logika pro kurýra (GPS cesta k zákazníkovi)
    if newStatus == 'shipping' then
        order.courierSource = src
        local customerPed = GetPlayerPed(targetCustomer)
        if DoesEntityExist(customerPed) then
            local coords = GetEntityCoords(customerPed)
            TriggerClientEvent('foodora:client:setRoute', src, coords)
        end
    end

    -- 3. PŘÍPRAVA OZNÁMENÍ
    local msg = "Tvoje objednávka změnila stav!"
    if newStatus == 'accepted' then 
        msg = "Restaurace přijala tvou objednávku a začala vařit! 🍳"
    elseif newStatus == 'ready' then 
        msg = "Jídlo je hotové a zabalené! 📦"
    elseif newStatus == 'shipping' then 
        msg = "Kurýr vyzvedl jídlo a jede k tobě! Sleduj mapu. 🛵"
    elseif newStatus == 'delivered' then 
        msg = "Dobrou chuť! Objednávka doručena. ✅"
        TriggerClientEvent('foodora:client:removeCourierBlip', targetCustomer)
        ActiveOrders[orderId] = nil -- Smazání hotové objednávky
    end

    -- Poslání oznámení zákazníkovi
    TriggerClientEvent('foodora:client:statusNotify', targetCustomer, msg, newStatus)
    
    -- Synchronizace všech tabletů (aby zmizela karta nebo se změnil status)
    SyncOrders()
end)

-- Callback pro získání aktivních zakázek (při otevření NUI)
ESX.RegisterServerCallback('foodora:getActiveOrders', function(source, cb)
    cb(ActiveOrders)
end)

-- LIVE BLIP (Kurýr -> Zákazník)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for id, order in pairs(ActiveOrders) do
            if order.status == 'shipping' and order.courierSource then
                local courierPed = GetPlayerPed(order.courierSource)
                if DoesEntityExist(courierPed) then
                    local coords = GetEntityCoords(courierPed)
                    -- Posíláme souřadnice kurýra pouze jeho zákazníkovi
                    TriggerClientEvent('foodora:client:updateCourierMap', order.customer, coords)
                end
            end
        end
    end
end)