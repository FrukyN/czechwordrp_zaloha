local ESX = exports["es_extended"]:getSharedObject()

local Cfg = {
    RequiredPolice = 2,
    GlobalCooldown = 60,
    CashReward = { min = 3000, max = 7000 },
    SafeReward = { min = 15000, max = 25000 },
    AdminRanks = {
        ['owner'] = true, ['admin'] = true, ['dev'] = true, ['staff'] = true, 
        ['trial'] = true, ['junior'] = true, ['senior'] = true, ['hos'] = true,
        ['managment'] = true, ['cowner'] = true
    },
    GPSTrackerDuration = 120, -- s (Doba trvání GPS po opuštění oblasti)
    GPSRefreshTime = 1500,    -- ms (Plynulost pohybu blipu)
    MaxDistance = 50.0        -- Vzdálenost od kasy, kdy se spustí GPS
}

local lastRobbery = 0
local activeRobberies = {} 
local activeSafePins = {} 
local usedShelves = {} 

-- ŽÁDOST O SCHVÁLENÍ
lib.callback.register('gr_robbery:server:requestApproval', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPolice = ESX.GetExtendedPlayers('job', 'police')
    local currentTime = os.time() / 60

    if #xPolice < Cfg.RequiredPolice then return false, "Málo policistů." end
    if (currentTime - lastRobbery) < Cfg.GlobalCooldown then return false, "Obchody jsou vybrané." end

    local allPlayers = ESX.GetExtendedPlayers()
    local onlineAdmins = {}
    for _, p in ipairs(allPlayers) do
        if Cfg.AdminRanks[p.getGroup()] and p.source ~= source then 
            table.insert(onlineAdmins, p.source) 
        end
    end

    if #onlineAdmins == 0 then return true end

    local adminSrc = onlineAdmins[1]
    local decision = lib.callback.await('gr_robbery:client:adminDecision', adminSrc, xPlayer.getName(), source)
    
    if decision then
        activeRobberies[source] = { approved = true }
    end

    return decision
end)

-- START LOUPEŽE (Alarm na místě)
RegisterNetEvent('gr_robbery:server:startRobbery', function(coords)
    local src = source
    local pin = math.random(1111, 9999)
    activeSafePins[src] = pin 
    activeRobberies[src] = { coords = coords, inArea = true, trackerStarted = false }
    usedShelves[src] = {} 
    
    -- CD_DISPATCH VOLÁNÍ
    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'}, -- jobs, které to uvidí
        coords = coords,
        title = "10-90 - Přepadení",
        message = "Tichý alarm v prodejně!",
        flash = 0,
        unique_id = "alarm_"..tostring(src),
        blip = {
            sprite = 161, 
            scale = 1.2, 
            colour = 1, 
            flashes = true, 
            text = "Loupež v prodejně",
            time = 5, -- jak dlouho blip zůstane na mapě v minutách
            radius = 0, -- pokud chceš oblast místo tečky, dej např. 50
        }
    })
    
    -- Notifikace pro hráče
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Heist zahájen',
        description = 'Kód k trezoru nalezen: ' .. pin,
        type = 'success',
        duration = 10000
    })
end)

-- LOGIKA ČEKÁNÍ NA ÚTĚK A NÁSLEDNÉ GPS
RegisterNetEvent('gr_robbery:server:completeCash', function()
    local src = source
    if not activeRobberies[src] then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addAccountMoney('black_money', math.random(Cfg.CashReward.min, Cfg.CashReward.max))
    lastRobbery = os.time() / 60

    -- Vlákno, které hlídá, kdy hráč opustí obchod
    Citizen.CreateThread(function()
        -- 1. FÁZE: Čekáme, až hráč opustí okruh MaxDistance
        while activeRobberies[src] and activeRobberies[src].inArea do
            local ped = GetPlayerPed(src)
            local pCoords = GetEntityCoords(ped)

            if #(pCoords - activeRobberies[src].coords) > Cfg.MaxDistance then
                activeRobberies[src].inArea = false
                activeRobberies[src].trackerStarted = true
                TriggerClientEvent('ox_lib:notify', src, { 
                    title = 'GPS AKTIVOVÁNA', 
                    description = 'V tašce vybuchla barva a aktivovala tracker! Policie tě teď vidí!', 
                    type = 'error',
                    duration = 10000
                })
            end
            Wait(1000)
        end

        -- 2. FÁZE: GPS Tracker (spustí se až po opuštění oblasti)
        if activeRobberies[src] and activeRobberies[src].trackerStarted then
            local timer = 0
            while activeRobberies[src] and timer < (Cfg.GPSTrackerDuration * 1000) do
                local ped = GetPlayerPed(src)
                if DoesEntityExist(ped) then
                    local pCoords = GetEntityCoords(ped)
                    local xPolice = ESX.GetExtendedPlayers('job', 'police')
                    for _, xp in ipairs(xPolice) do
                        TriggerClientEvent('gr_robbery:client:updateTrackerBlip', xp.source, src, pCoords)
                    end
                end
                Wait(Cfg.GPSRefreshTime)
                timer = timer + Cfg.GPSRefreshTime
            end

            -- KONEC GPS
            TriggerClientEvent('gr_robbery:client:removeTrackerBlip', -1, src)
            TriggerClientEvent('ox_lib:notify', src, { title = 'GPS vypnuta', description = 'Tracker přestal vysílat.', type = 'inform' })
            activeRobberies[src] = nil
        end
    end)
end)

-- REGÁLY (Lze vybrat jen dokud je hráč v oblasti)
RegisterNetEvent('gr_robbery:server:shelfReward', function(shelfCoords)
    local src = source
    if not activeRobberies[src] or not activeRobberies[src].inArea then 
        return TriggerClientEvent('ox_lib:notify', src, {description = 'Už jsi utekl z místa činu, nemůžeš brát regály!', type = 'error'})
    end

    for _, coords in ipairs(usedShelves[src]) do
        if #(coords - shelfCoords) < 0.5 then 
            return TriggerClientEvent('ox_lib:notify', src, {description = 'Tento regál už je prázdný!', type = 'error'})
        end
    end

    table.insert(usedShelves[src], shelfCoords)
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addMoney(math.random(100, 300))
    TriggerClientEvent('ox_lib:notify', src, {description = 'Našel jsi peníze v regálu.', type = 'success'})
end)

-- TREZOR (Jen dokud je v oblasti)
lib.callback.register('gr_robbery:server:trySafe', function(source, inputPin)
    if activeRobberies[source] and activeRobberies[source].inArea and activeSafePins[source] and tonumber(inputPin) == activeSafePins[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney('black_money', math.random(Cfg.SafeReward.min, Cfg.SafeReward.max))
        activeSafePins[source] = nil 
        return true
    end
    return false
end)

lib.callback.register('gr_robbery:server:canRobExtras', function(source)
    return activeRobberies[source] ~= nil and activeRobberies[source].inArea
end)

-- ZRUŠENÍ
RegisterNetEvent('gr_robbery:server:cancelHeist', function(reason)
    local src = source
    if activeRobberies[src] then
        activeRobberies[src] = nil
        TriggerClientEvent('gr_robbery:client:removeTrackerBlip', -1, src)
        TriggerClientEvent('ox_lib:notify', src, { title = 'Heist ukončen', description = reason, type = 'inform' })
    end
end)

RegisterCommand('throwbag', function(source) 
    TriggerEvent('gr_robbery:server:cancelHeist', 'Zahodil jsi tašku a zničil tracker.', source)
end)

AddEventHandler('playerDropped', function()
    local src = source
    TriggerClientEvent('gr_robbery:client:removeTrackerBlip', -1, src)
    activeRobberies[src] = nil
end)