ESX = exports['es_extended']:getSharedObject() --[cite: 5]

local PlayerData = {} --[cite: 5]
local stats, cstats = {}, {} --[cite: 5]
local lastStats, lastCstats = {}, {} --[cite: 5]
local hidden = false --[cite: 5]
local config = Config --[cite: 5]
local speedMultiplier = config.UseMPH and 2.23694 or 3.6 --[cite: 5]
local show = false --[cite: 5]
local postal = "000" --[cite: 5]
local postals = nil

-- OPRAVENO: Správné úhly pro světové strany v GTA V
local directions = {
    [0]   = 'S',
    [45]  = 'SZ',
    [90]  = 'Z',
    [135] = 'JZ',
    [180] = 'V',
    [225] = 'JV',
    [270] = 'V',
    [315] = 'SV',
    [360] = 'S'
}

-- Pomocná funkce pro převod stupňů na string světové strany
local function getHeadingDirection(heading)
    if not heading then return "N" end
    -- Otočení azimutu, aby odpovídal GTA kompasu (0 = Sever, 90 = Západ...)
    local angle = (heading + 22.5) % 360
    local index = math.floor(angle / 45) * 45
    return directions[index] or "N"
end

-- Aktualizace HUDu (s kontrolou změn pro úsporu výkonu) --[cite: 5]
local function updateHud() --[cite: 5]
    -- Kontrola, zda se něco reálně změnilo. Pokud ne, ušetříme NUI zprávu --[cite: 5]
    if lastStats.postal == stats.postal and --[cite: 5]
       lastStats.street == stats.street and --[cite: 5]
       lastStats.zone == stats.zone and --[cite: 5]
       lastStats.heading == stats.heading and --[cite: 5]
       lastStats.health == stats.health and --[cite: 5]
       lastStats.hunger == stats.hunger and --[cite: 5]
       lastStats.thirst == stats.thirst and --[cite: 5]
       lastStats.armour == stats.armour and --[cite: 5]
       lastStats.time == stats.time then --[cite: 5]
        return --[cite: 5]
    end --[cite: 5]

    lastStats.postal = stats.postal --[cite: 5]
    lastStats.street = stats.street --[cite: 5]
    lastStats.zone = stats.zone --[cite: 5]
    lastStats.heading = stats.heading --[cite: 5]
    lastStats.health = stats.health --[cite: 5]
    lastStats.hunger = stats.hunger --[cite: 5]
    lastStats.thirst = stats.thirst --[cite: 5]
    lastStats.armour = stats.armour --[cite: 5]
    lastStats.time = stats.time --[cite: 5]

    SendNUIMessage({ --[cite: 5]
        action = 'update', --[cite: 5]
        postal = stats.postal or false, --[cite: 5]
        street = stats.street or "", --[cite: 5]
        zone = stats.zone or "", --[cite: 5]
        heading = stats.heading or "", --[cite: 5]
        health = stats.health or 1.0, --[cite: 5]
        hunger = stats.hunger or 1.0, --[cite: 5]
        thirst = stats.thirst or 1.0, --[cite: 5]
        armour = stats.armour or 0.0, --[cite: 5]
        time = stats.time or "00:00", --[cite: 5]
    }) --[cite: 5]
end --[cite: 5]

-- POSTALY --[cite: 5]
Citizen.CreateThread(function() --[cite: 5]
    postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file')) --[cite: 5]
    if postals then --[cite: 5]
        postals = json.decode(postals) --[cite: 5]
        for i, p in ipairs(postals) do --[cite: 5]
            postals[i] = { vec2(p.x, p.y), code = p.code } --[cite: 5]
        end --[cite: 5]
    end --[cite: 5]
end) --[cite: 5]

Citizen.CreateThread(function() --[cite: 5]
    while not postals do Wait(300) end --[cite: 5]
    local _total = #postals --[cite: 5]
    local lastPostalCoords = vec2(0, 0) --[cite: 5]
    
    while config.usePostals do --[cite: 5]
        local coords = GetEntityCoords(PlayerPedId()) --[cite: 5]
        local coords2d = vec2(coords.x, coords.y) --[cite: 5]
        
        if #(coords2d - lastPostalCoords) > 15.0 then --[cite: 5]
            local _nearestIndex, _nearestD --[cite: 5]
            for i = 1, _total do --[cite: 5]
                local D = #(coords2d - postals[i][1]) --[cite: 5]
                if not _nearestD or D < _nearestD then --[cite: 5]
                    _nearestIndex = i --[cite: 5]
                    _nearestD = D --[cite: 5]
                end --[cite: 5]
            end --[cite: 5]
            if _nearestIndex then --[cite: 5]
                postal = postals[_nearestIndex].code --[cite: 5]
            end --[cite: 5]
            lastPostalCoords = coords2d --[cite: 5]
        end --[cite: 5]
        Wait(1500) --[cite: 5]
    end --[cite: 5]
end) --[cite: 5]

-- ZMĚNA: PlayerLoaded teď pouze ukládá tabulku, nespouští UI hned
RegisterNetEvent("esx:playerLoaded", function(xPlayer) --[cite: 5]
    PlayerData = xPlayer --[cite: 5]
end) --[cite: 5]

-- ZMĚNA: HUD se probudí k životu až při reálném spawnutí postavy do světa
AddEventHandler('playerSpawned', function() --[cite: 5]
    if not show then --[cite: 5]
        Citizen.SetTimeout(3000, function() --[cite: 5]
            SendNUIMessage({ action = 'show' }) --[cite: 5]
            DisplayRadar(true) --[cite: 5]
            SendNUIMessage({ --[cite: 5]
                action = 'color', --[cite: 5]
                main = config.uiColor, --[cite: 5]
                accent = config.accentColor, --[cite: 5]
            }) --[cite: 5]
            hidden = false --[cite: 5]
            show = true --[cite: 5]
            updateHud() --[cite: 5]
        end) --[cite: 5]
    end --[cite: 5]
end) --[cite: 5]

RegisterNetEvent("esx:onPlayerLogout", function() --[cite: 5]
    PlayerData = {} --[cite: 5]
    show = false --[cite: 5]
    SendNUIMessage({ action = 'hide' })
    DisplayRadar(false)
end) --[cite: 5]

RegisterNetEvent("esx:setJob", function(job) --[cite: 5]
    PlayerData.job = job --[cite: 5]
end) --[cite: 5]

-- Toggle HUD --[cite: 5]
RegisterNetEvent('hud:client:toggle', function() --[cite: 5]
    hidden = not hidden --[cite: 5]
    if hidden then --[cite: 5]
        SendNUIMessage({ action = 'hide' }) --[cite: 5]
        DisplayRadar(false) --[cite: 5]
    else --[cite: 5]
        SendNUIMessage({ action = 'show' }) --[cite: 5]
        DisplayRadar(true) --[cite: 5]
    end --[cite: 5]
end) --[cite: 5]

-- Car HUD --[cite: 5]
local function updateCarHud() --[cite: 5]
    if lastCstats.incar == cstats.incar and --[cite: 5]
       lastCstats.speed == cstats.speed and --[cite: 5]
       lastCstats.fuel == cstats.fuel and --[cite: 5]
       lastCstats.vehhealth == cstats.vehhealth and --[cite: 5]
       lastCstats.brake == cstats.brake and --[cite: 5]
       lastCstats.lock == cstats.lock and --[cite: 5]
       lastCstats.rpm == cstats.rpm and --[cite: 5]
       lastCstats.seatbelt == cstats.seatbelt then --[cite: 5]
        return --[cite: 5]
    end --[cite: 5]

    lastCstats.incar = cstats.incar --[cite: 5]
    lastCstats.speed = cstats.speed --[cite: 5]
    lastCstats.fuel = cstats.fuel --[cite: 5]
    lastCstats.vehhealth = cstats.vehhealth --[cite: 5]
    lastCstats.brake = cstats.brake --[cite: 5]
    lastCstats.lock = cstats.lock --[cite: 5]
    lastCstats.rpm = cstats.rpm --[cite: 5]
    lastCstats.seatbelt = cstats.seatbelt --[cite: 5]

    SendNUIMessage({ --[cite: 5]
        action = 'carhud', --[cite: 5]
        incar = cstats.incar, --[cite: 5]
        fuel = cstats.fuel, --[cite: 5]
        speed = cstats.speed, --[cite: 5]
        useMPH = config.UseMPH, --[cite: 5]
        vehhealth = cstats.vehhealth, --[cite: 5]
        brake = cstats.brake, --[cite: 5]
        lock = cstats.lock, --[cite: 5]
        rpm = cstats.rpm, --[cite: 5]
        seatbelt = cstats.seatbelt, --[cite: 5]
    }) --[cite: 5]
end --[cite: 5]

Citizen.CreateThread(function() --[cite: 5]
    while true do --[cite: 5]
        local sleep = 1000 --[cite: 5]
        if ESX.IsPlayerLoaded() and show and not hidden then --[cite: 5]
            local ped = PlayerPedId() --[cite: 5]
            if IsPedInAnyVehicle(ped, false) and config.showSpeedometer then --[cite: 5]
                sleep = 100 --[cite: 5]
                local veh = GetVehiclePedIsIn(ped, false) --[cite: 5]
                cstats["incar"] = true --[cite: 5]
                cstats["fuel"] = math.floor(GetVehicleFuelLevel(veh)) --[cite: 5]
                cstats["speed"] = math.floor(GetEntitySpeed(veh) * speedMultiplier) --[cite: 5]
                cstats["vehhealth"] = math.floor(GetVehicleEngineHealth(veh)) --[cite: 5]
                cstats["rpm"] = math.floor(GetVehicleCurrentRpm(veh) * 20) / 20 --[cite: 5]
                cstats["brake"] = GetVehicleHandbrake(veh) --[cite: 5]
                cstats["lock"] = GetVehicleDoorLockStatus(veh) --[cite: 5]
                cstats["seatbelt"] = seatbelt --[cite: 5]
                
                updateCarHud() --[cite: 5]
            else --[cite: 5]
                if cstats["incar"] then --[cite: 5]
                    cstats["incar"] = false --[cite: 5]
                    seatbelt = false --[cite: 5]
                    updateCarHud() --[cite: 5]
                end --[cite: 5]
            end --[cite: 5]
        end --[cite: 5]
        Wait(sleep) --[cite: 5]
    end --[cite: 5]
end) --[cite: 5]

-- Player stats + čas + ZMĚNA: Kontrola Esc menu (pauzy)
Citizen.CreateThread(function() --[cite: 5]
    local isPauseMenuOpen = false

    while true do --[cite: 5]
        if ESX.IsPlayerLoaded() and show then --[cite: 5]
            
            -- Kontrola stisknutého ESC / Mapy
            if IsPauseMenuActive() then
                if not isPauseMenuOpen then
                    isPauseMenuOpen = true
                    SendNUIMessage({ action = 'hide' })
                    DisplayRadar(false)
                end
                Wait(300)
            else
                if isPauseMenuOpen then
                    isPauseMenuOpen = false
                    if not hidden then
                        SendNUIMessage({ action = 'show' })
                        DisplayRadar(true)
                    end
                end

                if not hidden then
                    local ped = PlayerPedId() --[cite: 5]
                    local coords = GetEntityCoords(ped) --[cite: 5]
                    local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z) --[cite: 5]
                    local street = GetStreetNameFromHashKey(var1) --[cite: 5]
                    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)) --[cite: 5]
                    
                    -- VÝPOČET KOMPASU: Volání bezpečné funkce místo zabugovaného for cyklu
                    local heading = getHeadingDirection(GetEntityHeading(ped))

                    stats["postal"] = config.usePostals and postal or false --[cite: 5]
                    stats["health"] = math.floor((GetEntityHealth(ped) / 200) * 100) / 100 --[cite: 5]
                    stats["armour"] = math.floor((GetPedArmour(ped) / 100) * 100) / 100 --[cite: 5]

                    TriggerEvent('esx_status:getStatus', 'hunger', function(status) --[cite: 5]
                        stats["hunger"] = math.floor((status.getPercent() / 100) * 100) / 100 --[cite: 5]
                    end) --[cite: 5]
                    TriggerEvent('esx_status:getStatus', 'thirst', function(status) --[cite: 5]
                        stats["thirst"] = math.floor((status.getPercent() / 100) * 100) / 100 --[cite: 5]
                    end) --[cite: 5]

                    stats["street"] = street --[cite: 5]
                    stats["zone"] = zone --[cite: 5]
                    stats["heading"] = heading --[cite: 5]

                    local hour = GetClockHours() --[cite: 5]
                    local minute = GetClockMinutes() --[cite: 5]
                    stats["time"] = string.format("%02d:%02d", hour, minute) --[cite: 5]

                    updateHud() --[cite: 5]
                end
                Wait(1500) --[cite: 5]
            end
        else
            Wait(1000)
        end
    end
end)

RegisterCommand('edithud', function() 
    SetNuiFocus(true, true) 
    SendNUIMessage({ action = 'editMode' }) 
end, false) 

RegisterNUICallback('closeEdit', function(data, cb) 
    SetNuiFocus(false, false) 
    cb('ok') 
end) 