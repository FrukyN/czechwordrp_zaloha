local tvModel = 1036195894 -- prop_tv_flat_01
local rtName = "tvscreen" 
local isLinked = false

-- Inicializace Render Targetu (promítání na obrazovku TV)
Citizen.CreateThread(function()
    if not IsNamedRendertargetRegistered(rtName) then
        RegisterNamedRendertarget(rtName, false)
    end
    
    while true do
        local wait = 500
        local pCoords = GetEntityCoords(PlayerPedId())
        -- Najdeme nejbližší TV v okruhu 15m
        local stationTV = GetClosestObjectOfType(pCoords, 15.0, tvModel, false, false, false)

        if DoesEntityExist(stationTV) then
            wait = 0
            if not isLinked then LinkNamedRendertarget(tvModel) isLinked = true end
            
            local handle = GetNamedRendertargetRenderId(rtName)
            if handle ~= -1 then
                SetTextRenderId(handle)
                Set_2dLayer(4)
                -- Vykreslení NUI
                DrawSprite("tvscreen", "tvscreen", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(1)
            end
        else
            isLinked = false
            wait = 1000
        end
        Wait(wait)
    end
end)

-- Příjem poplachu a výpočet vzdálenosti pro zvuk
RegisterNetEvent('esx_fireDispatch:syncAlarmForAll')
AddEventHandler('esx_fireDispatch:syncAlarmForAll', function(data)
    local pCoords = GetEntityCoords(PlayerPedId())
    -- SEM DEJ SOUŘADNICE TVÉ TELEVIZE:
    local tvCoords = vector3(1219.29, -1478.98, 36.19) 
    local dist = #(pCoords - tvCoords)

    -- Aktivujeme jen pro hráče na stanici (30 metrů)
    if dist < 30.0 then
        SendNUIMessage({
            action = "playAlarm",
            info = data,
            -- Výpočet 3D zvuku: čím dál jsi, tím menší hlasitost (0.0 až 0.7)
            volume = (1.0 - (dist / 30.0)) * 0.7 
        })
    end
end)

-- Logika pro příkazy 150 a 112 (Původní logika, kterou jsi poslal)
local fireCommands = {"150", "112"}

for _, cmd in ipairs(fireCommands) do
    RegisterCommand(cmd, function(source, args, rawCommand)
        local data = exports['cd_dispatch']:GetPlayerInfo()
        local msgText = (args and #args > 0) and table.concat(args, " ") or "Tísňové volání"
        
        local voiceMessage = msgText
        if cmd == "150" then
            voiceMessage = msgText .. ". K výjezdu určen vůz CAS 20 Scania."
        elseif cmd == "112" then
            voiceMessage = msgText .. ". Prověřte situaci na místě."
        end

        -- Pošle notifikaci do CD Dispatch (pro policii, hasiče atd.)
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police', 'ambulance', 'hzs', 'fire'}, 
            coords = data.coords,
            title = cmd .. ' - Tísňové volání',
            message = msgText, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 1, 
                flashes = true, 
                text = 'Tísňové volání ' .. cmd,
                time = 5,
                radius = 0,
            }
        })

        -- Aktivuje TV a ZVUK na stanici
        TriggerServerEvent('esx_fireDispatch:passToServer', {
            title = (cmd == "150" and "POŽÁR" or "TÍSŇOVÉ VOLÁNÍ"),
            location = data.street,
            msg = voiceMessage
        })
    end, false)
end

-- Odposlech pro automatické požáry (z_fire atd.)
RegisterNetEvent('cd_dispatch:AddNotification')
AddEventHandler('cd_dispatch:AddNotification', function(data)
    local title = string.lower(data.title or "")
    local desc = string.lower(data.description or "")
    local msg = string.lower(data.message or "")
    local code = tostring(data.display_code or data.dispatch_code or "")

    -- Pokud CD Dispatch zachytí "hoří" nebo "požár"
    if code == '150' or string.find(title, "hoří") or string.find(desc, "hoří") or string.find(msg, "hoří") or string.find(title, "požár") or string.find(desc, "požár") then
        
        local xPlayer = ESX.GetPlayerData()
        if xPlayer.job and xPlayer.job.name == 'hzs' then
            
            local finalMsg = data.message or data.description or "Byl detekován požár!"
            if not string.find(string.lower(finalMsg), "scania") then
                finalMsg = finalMsg .. ". K výjezdu určen vůz CAS 20 Scania."
            end

            -- Pošle signál na server pro TV a Alarm
            TriggerServerEvent('esx_fireDispatch:passToServer', {
                title = "AUTOMATICKÝ POPLACH",
                location = data.street or data.street_name or "Neznámá lokalita",
                msg = finalMsg
            })
        end
    end
end)