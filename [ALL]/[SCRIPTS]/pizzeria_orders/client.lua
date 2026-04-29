local ActiveOrders = {}
local myOrderId = nil
local PIZZA_JOB = 'pizza'


local Config = {
    Monitor = vec3(-1342.886353,-1064.535400,8.109581), -- Souřadnice pro monitor (ZÁKAZNÍK)
    ChefTablet = vec3(-1340.732056,-1062.576172,8.133099) -- Souřadnice pro tablet (KUCHAŘ)
}

RegisterNetEvent('pizzeria_orders:client:updateBoard', function(orders)
    ActiveOrders = orders
    if myOrderId then
        local found = false
        for _, o in ipairs(orders) do
            if o.id == myOrderId then
                found = true
                SendNUIMessage({ action = 'update_ticket', status = o.status })
                if o.status == 'ready' then
                    PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
                end
            end
        end
        if not found then
            SendNUIMessage({ action = 'hide_ticket' })
            myOrderId = nil
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    SendNUIMessage({ action = 'hide_ticket' }) -- Resetuje schování při startu
end)

RegisterNetEvent('pizzeria_orders:client:startMyTicket', function(id, items)
    print("DEBUG: Dostal jsem event pro listek! ID: " .. id) -- Tohle uvidíš v F8
    myOrderId = id
    SendNUIMessage({ 
        action = 'show_ticket', 
        id = id, 
        items = items, 
        status = 'preparing' 
    })
end)

-- MONITOR PRO ZÁKAZNÍKY
exports.ox_target:addSphereZone({
    coords = Config.Monitor,
    radius = 1.0,
    options = {{
        label = 'Sledovat stav objednávek',
        icon = 'fa-solid fa-display',
        onSelect = function()
            local preparing, ready = "", ""
            for _, o in ipairs(ActiveOrders) do
                if o.status == 'preparing' then preparing = preparing .. " [ #"..o.id.." ] "
                else ready = ready .. " [ **#"..o.id.."** ] " end
            end
            lib.alertDialog({
                header = '🍕 STATUS OBJEDNÁVEK',
                content = "### ⏳ PŘIPRAVUJEME\n" .. (preparing ~= "" and preparing or "---") .. 
                          "\n\n---\n### ✅ K VYZVEDNUTÍ\n" .. (ready ~= "" and ready or "---"),
                centered = true
            })
        end
    }}
})

-- TABLET PRO KUCHAŘE
exports.ox_target:addSphereZone({
    coords = Config.ChefTablet,
    radius = 0.5,
    options = {{
        label = 'Seznam objednávek',
        icon = 'fa-solid fa-list-check',
        groups = PIZZA_JOB,
        onSelect = function()
            local elements = {}
            for _, o in ipairs(ActiveOrders) do
                table.insert(elements, {
                    title = "#" .. o.id .. " - " .. table.concat(o.items, ", "),
                    description = "Stav: " .. (o.status == 'preparing' and "V přípravě" or "HOTOVO"),
                    onSelect = function()
                        lib.registerContext({
                            id = 'order_manage_'..o.id,
                            title = 'Objednávka #'..o.id,
                            options = {
                                { title = 'Označit jako HOTOVÉ', icon = 'check', onSelect = function() TriggerServerEvent('pizzeria_orders:server:setReady', o.id) end },
                                { title = 'Vydat a smazat', icon = 'trash', onSelect = function() TriggerServerEvent('pizzeria_orders:server:removeOrder', o.id) end },
                            }
                        })
                        lib.showContext('order_manage_'..o.id)
                    end
                })
            end
            lib.registerContext({ id = 'chef_orders_list', title = '📦 OBJEDNÁVKY', options = #elements > 0 and elements or {{title = 'Žádné objednávky', disabled = true}} })
            lib.showContext('chef_orders_list')
        end
    }}
})

