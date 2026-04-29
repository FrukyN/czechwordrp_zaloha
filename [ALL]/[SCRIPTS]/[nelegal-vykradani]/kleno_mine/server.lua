local ESX = exports["es_extended"]:getSharedObject()
local isMineBusy = false
local lootedCoords = {} -- Tabulka pro uložení pozic vybraných sudů
local isBoothLooted = false

-- Tato část zajistí, že při restartu skriptu (ensure) pošleme všem klientům 
-- příkaz, aby si dveře znovu vytvořili, pokud tam nejsou.
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    isMineBusy = false 
    lootedCoords = {} -- Resetujeme vybrané sudy
    TriggerClientEvent('kleno_mine:resetMineClient', -1) 
end)

-- Callback pro kontrolu stavu, policie a thermitu
ESX.RegisterServerCallback('kleno_mine:canStartHeist', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end

    -- 1. KONTROLA POLICIE
    local xPlayers = ESX.GetExtendedPlayers('job', 'police', 'policie_mp')
    if #xPlayers < 3 then 
        TriggerClientEvent('ox_lib:notify', source, {description = "Není dostatek policistů!", type = 'error'})
        return cb(false) 
    end

    -- 2. KONTROLA THERMITU (Zda ho vůbec má)
    local hasThermite = false
    if exports.ox_inventory then
        hasThermite = exports.ox_inventory:GetItem(source, 'thermite', nil, true) > 0
    else
        hasThermite = xPlayer.getInventoryItem('thermite').count > 0
    end

    if not hasThermite then
        TriggerClientEvent('ox_lib:notify', source, {description = "Nemáš u sebe Thermite!", type = 'error'})
        return cb(false)
    end

    -- 3. KONTROLA STAVU (Zda už důl není vybuchnutý)
    cb(not isMineBusy)
end)

-- 2. NOVÝ CALLBACK PRO SPAWN DVEŘÍ (Kontroluje jen, jestli je důl busy, nespamuje notifikace)
ESX.RegisterServerCallback('kleno_mine:checkDoorState', function(source, cb)
    cb(not isMineBusy)
end)

-- Start Heistu (Zámek dolu a spuštění reset timeru)
RegisterNetEvent('kleno_mine:startHeistSync', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        -- ODEBRÁNÍ THERMITU (Až při úspěšném startu)
        if exports.ox_inventory then
            exports.ox_inventory:RemoveItem(src, 'thermite', 1)
        else
            xPlayer.removeInventoryItem('thermite', 1)
        end
    end

    isMineBusy = true
    lootedCoords = {} 
    
    SetTimeout(Config.ResetTime, function()
        isMineBusy = false
        lootedCoords = {} 
        TriggerClientEvent('kleno_mine:resetMineClient', -1)
        print("^2[Kleno Mine] Dul byl resetovan a je pripraven.^7")
    end)
end)

-- SYNCHRONIZACE MAZÁNÍ DVEŘÍ A POVOLENÍ SUDŮ
RegisterNetEvent('kleno_mine:removeDoorSync', function()
    TriggerClientEvent('kleno_mine:forceDeleteDoor', -1)
    TriggerClientEvent('kleno_mine:setMineExploded', -1)
end)

-- UPRAVENÝ EVENT PRO PROHLEDÁVÁNÍ (Nyní přes souřadnice)
RegisterNetEvent('kleno_mine:barrelSearched', function(coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Klíč pro tabulku založený na souřadnicích
    local posKey = tostring(coords)

    -- 1. POJISTKA: Kontrola podle pozice
    if lootedCoords[posKey] then 
        TriggerClientEvent('ox_lib:notify', src, {description = "Tento sud už je prázdný!", type = 'error'})
        return 
    end

    -- 2. ZÁPIS: Označíme pozici jako vybranou
    lootedCoords[posKey] = true

    -- 3. VÝBĚR ODMĚNY Z CONFIGU
    local chance = math.random(1, 100)
    local itemToGive = nil

    for _, reward in ipairs(Config.Rewards) do
        if chance <= reward.chance then 
            itemToGive = reward 
            break 
        end
    end

    -- 4. DÁNÍ ITEMU
    if itemToGive then
        if exports.ox_inventory then
            exports.ox_inventory:AddItem(src, itemToGive.item, itemToGive.amount)
        else
            xPlayer.addInventoryItem(itemToGive.item, itemToGive.amount)
        end
        TriggerClientEvent('ox_lib:notify', src, {description = "Našel jsi " .. itemToGive.amount .. "x " .. itemToGive.item, type = 'success'})
    else
        TriggerClientEvent('ox_lib:notify', src, {description = "V sudu nic nebylo...", type = 'info'})
    end

    -- 5. SYNCHRONIZACE SMAZÁNÍ (Podle pozice)
    TriggerClientEvent('kleno_mine:deleteBarrelAtCoords', -1, coords)
end)

RegisterNetEvent('kleno_mine:policeAlert', function(coords)
    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = Config.Police.jobs, 
        coords = coords, 
        title = 'Výbuch v dole',
        message = 'Senzory zaznamenaly silný výbuch v oblasti starého dolu.', 
        flash = 0, 
        unique_id = tostring(math.random(0000000, 9999999)),
        sound = 1,
        blip = {
            sprite = 431, 
            scale = 1.2, 
            color = 1, 
            label = 'Výbuch v dole', 
            time = 60000,
            flash = true
        }
    })
end)

ESX.RegisterServerCallback('kleno_mine:isPositionLooted', function(source, cb, coords)
    local posKey = tostring(coords)
    if lootedCoords[posKey] then
        cb(true) -- Pozice už je vybraná
    else
        cb(false) -- Pozice je volná
    end
end)

-- Callback pro kontrolu budky
ESX.RegisterServerCallback('kleno_mine:canRobBooth', function(source, cb)
    cb(not isBoothLooted)
end)

-- Event pro předání odměny (Thermite)
RegisterNetEvent('kleno_mine:giveBoothReward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or isBoothLooted then return end

    isBoothLooted = true -- Zamkneme budku

    -- Dáme hráči Thermite
    if exports.ox_inventory then
        exports.ox_inventory:AddItem(src, 'thermite', 1)
    else
        xPlayer.addInventoryItem('thermite', 1)
    end

    TriggerClientEvent('ox_lib:notify', src, {description = "Získal jsi 1x Thermite!", type = 'success'})

    -- Reset budky za 15 minut (900 000 ms)
    SetTimeout(900000, function()
        isBoothLooted = false
        print("^2[Kleno Mine] Budka s Thermitem byla resetovana.^7")
    end)
end)

-- Event pro nahlášení neúspěšného pokusu policii
RegisterNetEvent('kleno_mine:boothFailDispatch', function(coords)
    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = Config.Police.jobs, 
        coords = coords, 
        title = 'Pokus o vloupání do budky',
        message = 'Senzory v budce s materiálem zaznamenaly neoprávněný pokus o zadání kódu.', 
        flash = 0, 
        unique_id = tostring(math.random(0000000, 9999999)),
        sound = 1,
        blip = {
            sprite = 458, -- Ikona visacího zámku/budky
            scale = 1.0, 
            color = 1, -- Červená
            label = 'Pokus o vloupání', 
            time = 60000,
            flash = true
        }
    })
end)