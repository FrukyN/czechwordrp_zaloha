local ESX = exports["es_extended"]:getSharedObject()
local courierBlip = nil
local CurrentOrders = {}

-- Hlavní příkaz pro hráče (Zákazník)
RegisterCommand('foodora', function()
    ESX.TriggerServerCallback('foodora:getShopStatus', function(shops)
        ESX.TriggerServerCallback('foodora:getActiveOrders', function(orders)
            SetNuiFocus(true, true)
            SendNUIMessage({ 
                action = "openCustomer", 
                shops = shops,
                orders = orders 
            })
        end)
    end)
end)

-- Příkaz pro portál (Zaměstnanec)
RegisterCommand('foodoraportal', function()
    local job = ESX.GetPlayerData().job
    if job and (job.name == 'pizza' or job.name == 'burger' or job.name == 'pizzeria') then 
        ESX.TriggerServerCallback('foodora:getActiveOrders', function(orders)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openStaff",
                orders = orders,
                job = job
            })
        end)
    else
        ESX.ShowNotification("~r~K tomuto portálu nemáš přístup!")
    end
end)

RegisterNetEvent('foodora:client:syncOrders', function(orders)
    local myId = GetPlayerServerId(PlayerId())
    local myOrder = nil
    
    -- Najdeme naši objednávku v datech ze serveru
    for id, order in pairs(orders) do
        if order.customer == myId then
            myOrder = order
            break
        end
    end
    
    -- Pokud naše objednávka už neexistuje (smazána/zamítnuta), smažeme blip kurýra
    if not myOrder and courierBlip then
        RemoveBlip(courierBlip)
        courierBlip = nil
    end

    SendNUIMessage({
        action = "syncOrders",
        orders = orders,
        myOrder = myOrder
    })
end)

-- HEZKÉ OZNÁMENÍ (Zpět přes ox_lib)
RegisterNetEvent('foodora:client:newOrderAlert', function(orderId)
    SendNUIMessage({ action = "playSound" })
    
    -- Pokud máš na serveru ox_lib, použije se toto:
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({
            title = 'NOVÁ OBJEDNÁVKA #'..orderId,
            description = 'Otevři portál pro přijetí!',
            type = 'warning',
            duration = 15000,
            position = 'top-right'
        })
    else
        -- Pokud ox_lib nemáš, použije se nouzově ESX, aby skript nespadl
        ESX.ShowNotification("Nová objednávka #"..orderId)
    end
end)

RegisterNetEvent('foodora:client:updateCourierMap', function(coords)
    -- Pokud blip ještě neexistuje, vytvoříme ho
    if not courierBlip then
        courierBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(courierBlip, 648) -- Ikona motorky
        SetBlipScale(courierBlip, 0.9)
        SetBlipColour(courierBlip, 5) -- Žlutá/Oranžová
        SetBlipAsShortRange(courierBlip, false) -- Aby byl vidět i z dálky
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Kurýr Foodora")
        EndTextCommandSetBlipName(courierBlip)
        
        -- Oznámení pro zákazníka
        if GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:notify({
                title = 'Kurýr je na cestě!',
                description = 'Sleduj žlutou ikonu na mapě.',
                type = 'inform'
            })
        end
    else
        -- Pokud už existuje, jen aktualizujeme pozici
        SetBlipCoords(courierBlip, coords.x, coords.y, coords.z)
    end
end)

RegisterNetEvent('foodora:client:removeCourierBlip', function()
    if courierBlip then
        RemoveBlip(courierBlip)
        courierBlip = nil
    end
end)

-- GPS TRASA
RegisterNetEvent('foodora:client:setRoute', function(coords)
    if coords then
        SetNewWaypoint(coords.x, coords.y)
        ESX.ShowNotification("GPS nastavena na zákazníka!")
    end
end)

-- NUI CALLBACKY
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('placeOrder', function(data, cb)
    TriggerServerEvent('foodora:server:placeOrder', data.shopId, data.cart, data.total)
    cb('ok')
end)

RegisterNUICallback('updateStatus', function(data, cb)
    if data.id and data.status then
        TriggerServerEvent('foodora:server:updateStatus', data.id, data.status)
    end
    cb('ok')
end)

RegisterNetEvent('foodora:client:statusNotify', function(message, status)
    local nType = 'inform'
    if status == 'rejected' then nType = 'error' 
    elseif status == 'delivered' or status == 'ready' then nType = 'success' end

    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({
            title = 'FOODORA',
            description = message,
            type = nType,
            position = 'top-right',
            duration = 10000
        })
    else
        ESX.ShowNotification(message)
    end
end)

-- Přidej do client.lua (pokud tam není)
RegisterNUICallback('updateStatus', function(data, cb)
    if data and data.id then
        TriggerServerEvent('foodora:server:updateStatus', data)
    end
    cb('ok')
end)