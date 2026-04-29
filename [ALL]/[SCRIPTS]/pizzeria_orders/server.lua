local ActiveOrders = {}
local orderCounter = 1

RegisterNetEvent('pizzeria_orders:server:addOrder')
AddEventHandler('pizzeria_orders:server:addOrder', function(items, customerId)
    -- Pokud customerId nepřijde (třeba z jiného scriptu), zkusíme source
    local target = customerId or source 
    
    local orderId = string.format("%02d", orderCounter)
    orderCounter = orderCounter + 1
    if orderCounter > 99 then orderCounter = 1 end

    local newOrder = {
        id = orderId,
        items = items,
        status = 'preparing',
        owner = target
    }

    table.insert(ActiveOrders, newOrder)
    TriggerClientEvent('pizzeria_orders:client:updateBoard', -1, ActiveOrders)
    
    -- Teď pošleme lístek přesně tomu, kdo platil v pizzerii
    if target then
        TriggerClientEvent('pizzeria_orders:client:startMyTicket', target, orderId, items)
    end
end)

RegisterNetEvent('pizzeria_orders:server:setReady', function(orderId)
    for _, order in ipairs(ActiveOrders) do
        if order.id == orderId then
            order.status = 'ready'
            break
        end
    end
    TriggerClientEvent('pizzeria_orders:client:updateBoard', -1, ActiveOrders)
end)

RegisterNetEvent('pizzeria_orders:server:removeOrder', function(orderId)
    for i, order in ipairs(ActiveOrders) do
        if order.id == orderId then
            table.remove(ActiveOrders, i)
            break
        end
    end
    TriggerClientEvent('pizzeria_orders:client:updateBoard', -1, ActiveOrders)
end)

lib.callback.register('pizzeria_orders:server:getOrders', function()
    return ActiveOrders
end)