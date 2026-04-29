local lastBlackout = 0
local blackoutDuration = 30 * 60 * 1000 -- 30 minut
local cooldownTime = 60 * 60 * 1000 -- 1 hodina
local minPolice = 10 -- Počet policistů potřebných pro blackout
GlobalState.BlackoutNpcDead = false

-- Event pro získání karty
RegisterNetEvent('blackout:server:giveCard')
AddEventHandler('blackout:server:giveCard', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.ox_inventory:AddItem(source, 'access_card', 1)
end)

-- Pokus o Blackout (nyní přijímá hodinu od klienta)
RegisterNetEvent('blackout:server:attemptBlackout')
AddEventHandler('blackout:server:attemptBlackout', function(clientHour)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local currentTime = os.time() * 1000
    local policeCount = #ESX.GetExtendedPlayers('job', 'police')
    
    -- Hodina kterou nám poslal klient
    local hour = clientHour or 0

-- 1. Kontrola policistů (OPRAVENO: nyní používá proměnnou minPolice)
    if policeCount < minPolice then 
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Chyba', 
            description = 'Ve městě není dostatek policistů (potřeba '..minPolice..').', 
            type = 'error'
        })
        return
    end

    -- 2. Kontrola času (Noc je 21:00 až 05:00)
    if hour >= 5 and hour < 21 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Chyba', 
            description = 'Vypnutí lze provést pouze v noci! (Ve hře je nyní '..hour..' hod.)', 
            type = 'error'
        })
        return
    end

    -- 3. Kontrola Cooldownu
    if currentTime - lastBlackout < cooldownTime and lastBlackout ~= 0 then
        local remaining = math.ceil((cooldownTime - (currentTime - lastBlackout)) / 60000)
        TriggerClientEvent('ox_lib:notify', src, {title = 'Chyba', description = 'Generátory jsou přehřáté. Zkuste to za '..remaining..' min.', type = 'error'})
        return
    end

    -- ÚSPĚŠNÉ SPUŠTĚNÍ
    lastBlackout = currentTime
    exports.ox_inventory:RemoveItem(src, 'access_card', 1)
    
    TriggerClientEvent('blackout:client:setLightState', -1, true)
    
    -- Vypnutí bankomatů (používá GlobalState pro tvou informaci)
    GlobalState.BankomatyVypnuty = true

    SetTimeout(blackoutDuration, function()
        TriggerClientEvent('blackout:client:setLightState', -1, false)
        GlobalState.BankomatyVypnuty = false
        print("^2[Blackout]^7 Elektřina byla obnovena.")
    end)
end)

RegisterNetEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local src = source
    local coords = GetEntityCoords(GetPlayerPed(src))
    -- Tento event pošle zvuk všem (-1), kteří jsou v dosahu maxDistance od hráče, co to spustil
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, coords, maxDistance, soundFile, soundVolume)
end)

-- Event pro synchronizaci smrti NPC
RegisterNetEvent('blackout:server:npcKilled')
AddEventHandler('blackout:server:npcKilled', function()
    local src = source
    if not GlobalState.BlackoutNpcDead then
        GlobalState.BlackoutNpcDead = true -- Zablokuje target pro všechny
        
        -- Dáme kartu hráči, který to spustil
        exports.ox_inventory:AddItem(src, 'access_card', 1)
        
        -- Řekneme všem klientům, aby u sebe pracovníka zabili
        TriggerClientEvent('blackout:client:syncNpcDeath', -1)
        
        -- Resetujeme NPC stav po hodině (aby se mohl objevit nový při restartu/ensure)
        SetTimeout(60 * 60 * 1000, function()
            GlobalState.BlackoutNpcDead = false
        end)
    end
end)

RegisterNetEvent('blackout:server:failEffects')
AddEventHandler('blackout:server:failEffects', function(coords)
    TriggerClientEvent('blackout:client:createFire', -1, coords)
end)

-- Nový event pro tichou synchronizaci dveří přes serverové exporty
RegisterNetEvent('blackout:server:doorSyncSilent', function(doorId, state)
    -- exports.ox_doorlock:setDoorState(id, stav)
    -- stav 0 = odemčeno, stav 1 = zamčeno
    -- Volání přes export na serveru neposílá notifikace hráčům
    if exports.ox_doorlock then
        exports.ox_doorlock:setDoorState(doorId, state)
    else
        print("^1[Blackout Error]^7 ox_doorlock export nenalezen na serveru!")
    end
end)

-- Event pro odložený alarm (3 minuty)
RegisterNetEvent('blackout:server:startDelayedAlarm', function(coords)
    local _source = source
    print("^3[Blackout]^7 Alarm u dveri ID 553 bude spusten za 3 minuty.")
    
    -- Wait 3 minuty (3 * 60 * 1000 ms)
    Wait(180000)
    
    -- Po 3 minutách pošleme dispatch všem policistům
    -- Poznámka: Pokud tvůj cd_dispatch vyžaduje "data.unique_id", server ho nemusí mít.
    -- Většinou se na serveru používá jednodušší verze dispatch triggeru:
    TriggerClientEvent('cd_dispatch:AddNotification', -1, {
        job_table = {'police'},
        coords = coords,
        title = 'ALARM - NAPADENÍ OBJEKTU',
        message = 'Narušení bezpečnosti v hlavní budově rozvodny! Pachatel je uvnitř!', 
        flash = 1,
        sound = 1,
        blip = {
            sprite = 161, 
            scale = 1.4, 
            colour = 1,
            flashes = true, 
            text = 'ALARM ROZVODNA', 
            time = 5,
            radius = 0,
        }
    })
end)

-- Registrace callbacku pro klienta
lib.callback.register('blackout:server:getPoliceCount', function(source)
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    
    if #xPlayers >= minPolice then
        return true
    else
        return false
    end
end)