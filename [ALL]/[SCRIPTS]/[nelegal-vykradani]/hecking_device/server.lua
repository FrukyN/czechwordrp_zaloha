-- Načtení ESX objektu (Tohle opraví tu chybu "nil value ESX")
local ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local scavengeCooldowns = {} -- Tabulka pro ukládání cooldownů

-- Event pro dávání součástek při sběru
RegisterNetEvent('my_crafting:giveItem', function(itemName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then 
        print("^1[Hacking-Craft] Chyba: Nepodarilo se najit xPlayer pro ID: " .. source .. "^7")
        return 
    end

    local playerIdentifier = xPlayer.getIdentifier()
    local currentTime = os.time()

    -- Inicializace tabulky pro hráče, pokud ji ještě nemá
    if not scavengeCooldowns[playerIdentifier] then
        scavengeCooldowns[playerIdentifier] = {}
    end

    -- KONTROLA COOLDOWNU PRO KONKRÉTNÍ POLOŽKU
    if scavengeCooldowns[playerIdentifier][itemName] and scavengeCooldowns[playerIdentifier][itemName] > currentTime then
        local timeLeft = math.ceil((scavengeCooldowns[playerIdentifier][itemName] - currentTime) / 60)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Prázdné místo',
            description = 'Tady už jsi všechno pobral. Zkus to znovu za ' .. timeLeft .. ' minut.',
            type = 'error'
        })
        return
    end

    -- Kontrola, zda hráč unese další věc (přidáme 3 kusy)
    local amount = 3
    if ox_inventory:CanCarryItem(source, itemName, amount) then
        ox_inventory:AddItem(source, itemName, amount)
        
        -- NASTAVENÍ COOLDOWNU JEN PRO TENTO ITEM
        scavengeCooldowns[playerIdentifier][itemName] = currentTime + (30 * 60)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Nalezeno',
            description = 'Získal jsi součástky: ' .. amount .. 'x ' .. itemName,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Plný inventář',
            description = 'Tohle už neuneseš!',
            type = 'error'
        })
    end
end)
-- Event pro výrobu Hacking Device
RegisterNetEvent('my_crafting:assembleDevice', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    -- Recept
    local ingredients = {
        {name = 'processor', count = 1},
        {name = 'broken_phone', count = 1},
        {name = 'antenna', count = 1}
    }

    -- Kontrola surovin (hledáme v ox_inventory)
    local hasAll = true
    for _, item in pairs(ingredients) do
        local count = ox_inventory:Search(source, 'count', item.name)
        if count < item.count then
            hasAll = false
            break
        end
    end

    if hasAll then
        -- Odebrání surovin
        for _, item in pairs(ingredients) do
            ox_inventory:RemoveItem(source, item.name, item.count)
        end

        -- Přidání výsledku
        ox_inventory:AddItem(source, 'hackingdevice', 1)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Výroba',
            description = 'Úspěšně jsi sestavil Hacking Device!',
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Chyba',
            description = 'Chybí ti součástky!',
            type = 'error'
        })
    end
end)

-- Event pro hacknutí alarmu
RegisterNetEvent('my_crafting:hackAlarm', function(doorId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- 1. ODEMKNUTÍ DVEŘÍ (0 = odemčeno)
    exports.ox_doorlock:setDoorState(doorId, 0)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Alarm vyřazen',
        description = 'Dveře jsou odemčeny na 10 minut!',
        type = 'success',
        duration = 5000
    })

    -- 2. UPOZORNĚNÍ: 1 MINUTA DO KONCE (spustí se po 9 minutách)
    SetTimeout(540000, function() -- 540 000 ms = 9 minut
        -- Zkontrolujeme, jestli je hráč pořád online (volitelné)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Varování alarmu',
            description = 'Pozor! Systém se restartuje za 60 sekund!',
            type = 'warning',
            duration = 10000 -- Necháme to svítit déle
        })
        
        -- Můžeš přidat i zvukové upozornění, pokud máš nějaký script na zvuky
        -- TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'alarm_beep', 0.5)
    end)

    -- 3. SAMOTNÉ ZAMKNUTÍ (spustí se po 10 minutách)
    SetTimeout(600000, function() -- 600 000 ms = 10 minut
        exports.ox_doorlock:setDoorState(doorId, 1) -- 1 = zamčeno
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Systém obnoven',
            description = 'Alarm je opět aktivní, dveře byly uzamčeny.',
            type = 'error'
        })
        
        print("^3[Alarm System]^7 Dvere ID " .. doorId .. " byly automaticky uzamceny.")
    end)
end)

RegisterNetEvent('my_crafting:hackAlarm', function(doorId)
    local source = source
    
    -- Odemknutí v doorlocku
    exports.ox_doorlock:setDoorState(doorId, 0)
    
    -- Řekneme všem hráčům, že alarm je vypnutý
    TriggerClientEvent('my_crafting:updateAlarmState', -1, false)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Alarm vyřazen',
        description = 'Dveře jsou odemčeny na 10 minut!',
        type = 'success'
    })

    -- Za 9 minut varování
    SetTimeout(540000, function()
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Varování',
            description = 'Alarm se aktivuje za 60 sekund!',
            type = 'warning'
        })
    end)

    -- Za 10 minut zamknutí
    SetTimeout(600000, function()
        exports.ox_doorlock:setDoorState(doorId, 1)
        -- Řekneme všem, že alarm je zase aktivní
        TriggerClientEvent('my_crafting:updateAlarmState', -1, true)
    end)
end)

RegisterNetEvent('my_crafting:playGlobalAlarm', function(coords)
    -- Pošle event všem klientům (-1)
    TriggerClientEvent('my_crafting:clientPlayAlarm', -1, coords)
end)

RegisterNetEvent('my_crafting:failedCrafting', function()
    local source = source
    local ox_inventory = exports.ox_inventory
    local ingredients = {{name = 'processor', count = 1}, {name = 'broken_phone', count = 1}, {name = 'antenna', count = 1}}

    for _, item in pairs(ingredients) do
        ox_inventory:RemoveItem(source, item.name, item.count)
    end
end)

-- Při startu skriptu všechno zamkneme a zapneme alarm
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    -- Zamkneme dveře (stav 1)
    exports.ox_doorlock:setDoorState(552, 1) 
    -- Nastavíme alarm jako aktivní pro všechny
    TriggerClientEvent('my_crafting:updateAlarmState', -1, true)
    
    print("^2[Alarm System]^7 Skript restartovan, dvere ID 552 uzamceny a alarm aktivovan.")
end)