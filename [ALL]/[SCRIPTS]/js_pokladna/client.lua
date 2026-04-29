local ESX = exports["es_extended"]:getSharedObject()
local currentSeller = nil -- Zde si zákazník uloží ID prodavače pro platbu do society

-- KONFIGURACE POLOŽEK
-- Tady si můžeš libovolně měnit nebo přidávat jídla
local MenuItems = {
    {label = "KungPao", price = 1800, name = "KungPao"},
    {label = "Čínská polévka", price = 1500, name = "Čínská polévka"},
    {label = "Shushi", price = 2100, name = "shushi"},
    {label = "Coca-Cola", price = 1200, name = "cola"},
    {label = "Nudle", price = 2500, name = "Nudle"},
    {label = "Káva", price = 1100, name = "coffee"}
}

-- 1. OTEVŘENÍ KASY (PRODAVAČ)
-- Funguje na jakýkoliv prop kasy (prop_till_01) přes ox_target
exports.ox_target:addModel(`apache_noodle_till`, {
    {
        name = 'restaurace_pos',
        icon = 'fa-solid fa-cash-register',
        label = 'Otevřít pokladnu',
        -- groups = { ['burgershot'] = 0, ['mechanic'] = 0 }, -- Volitelně: odkomentuj pro omezení na joby
        onSelect = function()
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "openPOS",
                items = MenuItems
            })
        end
    }
})

-- 2. CALLBACK: PRODAVAČ POTVRDIL ÚČTENKU
-- Najde nejbližšího hráče a pošle mu data přes server
RegisterNUICallback('confirmBill', function(data, cb)
    local player, distance = ESX.Game.GetClosestPlayer()
    
    if player ~= -1 and distance <= 3.0 then
        local targetId = GetPlayerServerId(player)
        
        -- Debug do F8 pro kontrolu
        print("^2[POS]^7 Posílám účet ID: " .. targetId .. " | Celkem: " .. data.total .. " CZK")
        
        TriggerServerEvent('pos:server:sendToCustomer', targetId, data.items, data.total)
    else
        -- Pokud nikoho nenajde
        exports.ox_lib:notify({
            type = 'error', 
            description = 'V blízkosti není žádný zákazník!',
            position = 'top'
        })
    end
    cb('ok')
end)

-- 3. EVENT: ZÁKAZNÍK DOSTAL ÚČTENKU
-- Tento event se spustí u hráče, kterému prodavač účet poslal
RegisterNetEvent('pos:client:receiveBill', function(items, total, sellerId)
    currentSeller = sellerId -- Zapamatujeme si ID prodavače pro server
    
    print("^2[POS]^7 Přijata účtenka od ID: " .. sellerId)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openCustomerReceipt",
        items = items,
        total = total
    })
end)

-- 4. CALLBACK: PLATBA (ZÁKAZNÍK KLIKL NA HOTOVOST/KARTU)
RegisterNUICallback('payBill', function(data, cb)
    if currentSeller ~= nil then
        -- Pošleme metodu, částku a ID prodavače (aby server věděl, kterému jobu dát peníze)
        TriggerServerEvent('pos:server:completePayment', data.method, data.total, currentSeller)
        currentSeller = nil -- Resetujeme po platbě
    else
        print("^1[POS ERROR]^7 Chybí ID prodavače pro dokončení platby!")
    end
    cb('ok')
end)

-- 5. CALLBACK: ZAVŘENÍ UI
RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    currentSeller = nil
    cb('ok')
end)

-- POJISTKA: Pokud se hráč bugne, může použít /closekasa (volitelné)
RegisterCommand('closekasa', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" }) -- Musíš mít v JS ošetřeno
end)