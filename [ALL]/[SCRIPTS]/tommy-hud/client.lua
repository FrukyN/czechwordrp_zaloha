ESX = exports['es_extended']:getSharedObject()

local PlayerData = {}
local stats, cstats = {}, {}
local lastStats, lastCstats = {}, {}
local hidden = false
local config = Config
local speedMultiplier = config.UseMPH and 2.23694 or 3.6
local show = false
local postal = "000"
local directions = {
    S = 360, 0,
    SV = 315,
    V = 270,
    JV = 225,
    V = 180,
    JZ = 135,
    Z = 90,
    SZ = 45
}
-- Aktualizace HUDu (s kontrolou změn pro úsporu výkonu)
local function updateHud()
    -- Kontrola, zda se něco reálně změnilo. Pokud ne, ušetříme NUI zprávu (obrovský boost výkonu)
    if lastStats.postal == stats.postal and
       lastStats.street == stats.street and
       lastStats.zone == stats.zone and
       lastStats.heading == stats.heading and
       lastStats.health == stats.health and
       lastStats.hunger == stats.hunger and
       lastStats.thirst == stats.thirst and
       lastStats.armour == stats.armour and
       lastStats.time == stats.time then
        return
    end

    lastStats.postal = stats.postal
    lastStats.street = stats.street
    lastStats.zone = stats.zone
    lastStats.heading = stats.heading
    lastStats.health = stats.health
    lastStats.hunger = stats.hunger
    lastStats.thirst = stats.thirst
    lastStats.armour = stats.armour
    lastStats.time = stats.time

    SendNUIMessage({
        action = 'update',
        postal = stats.postal or false,
        street = stats.street or "",
        zone = stats.zone or "",
        heading = stats.heading or "",
        health = stats.health or 1.0,
        hunger = stats.hunger or 1.0,
        thirst = stats.thirst or 1.0,
        armour = stats.armour or 0.0,
        time = stats.time or "00:00",
    })
end

-- POSTALY
Citizen.CreateThread(function()
    postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
    if postals then
        postals = json.decode(postals)
        for i, p in ipairs(postals) do
            postals[i] = { vec2(p.x, p.y), code = p.code }
        end
    end
end)

Citizen.CreateThread(function()
    while not postals do Wait(300) end
    local _total = #postals
    local lastPostalCoords = vec2(0, 0)
    
    while config.usePostals do
        local coords = GetEntityCoords(PlayerPedId())
        local coords2d = vec2(coords.x, coords.y)
        
        if #(coords2d - lastPostalCoords) > 15.0 then
            local _nearestIndex, _nearestD
            for i = 1, _total do
                local D = #(coords2d - postals[i][1])
                if not _nearestD or D < _nearestD then
                    _nearestIndex = i
                    _nearestD = D
                end
            end
            if _nearestIndex then
                postal = postals[_nearestIndex].code
            end
            lastPostalCoords = coords2d
        end
        Wait(1500)
    end
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
    show = true
    hidden = false
    Citizen.SetTimeout(2500, function()
        SendNUIMessage({ action = 'show' })
        DisplayRadar(true)
        SendNUIMessage({
            action = 'color',
            main = config.uiColor,
            accent = config.accentColor,
        })
        updateHud()
    end)
end)

AddEventHandler('playerSpawned', function()
    if not show then
        Citizen.SetTimeout(3000, function()
            SendNUIMessage({ action = 'show' })
            hidden = false
            show = true
            updateHud()
        end)
    end
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    PlayerData = {}
    show = false
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
end)

-- Toggle HUD
RegisterNetEvent('hud:client:toggle', function()
    hidden = not hidden
    if hidden then
        SendNUIMessage({ action = 'hide' })
        DisplayRadar(false)
    else
        SendNUIMessage({ action = 'show' })
        DisplayRadar(true)
    end
end)

--[[
-- Radio
RegisterNetEvent('hud:client:recieveTalkingPlayers', function(players)
    SendNUIMessage({
        action = 'radio',
        enabled = players and true or false,
        list = json.encode(players or {}),
    })
end)

-- Notify
RegisterNetEvent('hud:client:notify', function(type, title, desc, icon)
    SendNUIMessage({
        action = 'notify',
        type = type,
        title = title or "Oznámení",
        desc = desc or "",
        icon = icon or nil
    })
end)
--]]


-- Car HUD
local function updateCarHud()
    -- Opět ověříme, jestli se data auta reálně změnila
    if lastCstats.incar == cstats.incar and
       lastCstats.speed == cstats.speed and
       lastCstats.fuel == cstats.fuel and
       lastCstats.vehhealth == cstats.vehhealth and
       lastCstats.brake == cstats.brake and
       lastCstats.lock == cstats.lock and
       lastCstats.rpm == cstats.rpm and
       lastCstats.seatbelt == cstats.seatbelt then
        return
    end

    lastCstats.incar = cstats.incar
    lastCstats.speed = cstats.speed
    lastCstats.fuel = cstats.fuel
    lastCstats.vehhealth = cstats.vehhealth
    lastCstats.brake = cstats.brake
    lastCstats.lock = cstats.lock
    lastCstats.rpm = cstats.rpm
    lastCstats.seatbelt = cstats.seatbelt

    SendNUIMessage({
        action = 'carhud',
        incar = cstats.incar,
        fuel = cstats.fuel,
        speed = cstats.speed,
        useMPH = config.UseMPH,
        vehhealth = cstats.vehhealth,
        brake = cstats.brake,
        lock = cstats.lock,
        rpm = cstats.rpm,
        seatbelt = cstats.seatbelt,
    })
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000 
        if ESX.IsPlayerLoaded() then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) and config.showSpeedometer then
                sleep = 100 
                local veh = GetVehiclePedIsIn(ped, false)
                cstats["incar"] = true
                -- Zaokrouhlujeme na celá čísla, aby to neposílalo updaty zbytečně při každé setině
                cstats["fuel"] = math.floor(GetVehicleFuelLevel(veh))
                cstats["speed"] = math.floor(GetEntitySpeed(veh) * speedMultiplier)
                cstats["vehhealth"] = math.floor(GetVehicleEngineHealth(veh))
                -- RPM zjednodušíme, ať se nespamuje (krokování)
                cstats["rpm"] = math.floor(GetVehicleCurrentRpm(veh) * 20) / 20
                cstats["brake"] = GetVehicleHandbrake(veh)
                cstats["lock"] = GetVehicleDoorLockStatus(veh)
                cstats["seatbelt"] = seatbelt 
                
                updateCarHud()
            else
                if cstats["incar"] then
                    cstats["incar"] = false
                    seatbelt = false
                    updateCarHud()
                end
            end
        end
        Wait(sleep)
    end
end)

-- Player stats + čas
Citizen.CreateThread(function()
    while true do
        if ESX.IsPlayerLoaded() then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local street = GetStreetNameFromHashKey(var1)
            local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
            local heading = GetEntityHeading(ped)

            for k, v in pairs(directions) do
                if (math.abs(heading - v) < 22.5) then
                    heading = k
                    break
                end
            end

            stats["postal"] = config.usePostals and postal or false
            
            -- Zaokrouhlení stavů na 2 desetinná místa, zabrání spamování při setinové změně regenerace
            stats["health"] = math.floor((GetEntityHealth(ped) / 200) * 100) / 100
            stats["armour"] = math.floor((GetPedArmour(ped) / 100) * 100) / 100

            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                stats["hunger"] = math.floor((status.getPercent() / 100) * 100) / 100
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                stats["thirst"] = math.floor((status.getPercent() / 100) * 100) / 100
            end)

            stats["street"] = street
            stats["zone"] = zone
            stats["heading"] = heading

            local hour = GetClockHours()
            local minute = GetClockMinutes()
            stats["time"] = string.format("%02d:%02d", hour, minute)

            updateHud()
        end
        Wait(1500)
    end
end)

RegisterCommand('edithud', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'editMode' })
    --TriggerEvent('hud:client:notify', 'info', 'Editace HUDu', 'Nyní můžeš myší přesouvat elementy HUDu. Pro uložení klikni na tlačítko uprostřed obrazovky.')
end, false)

-- /togglehud
RegisterCommand('hud', function(source, args)
    TriggerClientEvent('hud:client:toggle', source)
end, false)


RegisterNUICallback('closeEdit', function(data, cb)
    SetNuiFocus(false, false)
    --TriggerEvent('hud:client:notify', 'success', 'Editace HUDu', 'Pozice byla úspěšně uložena.')
    cb('ok')
end)