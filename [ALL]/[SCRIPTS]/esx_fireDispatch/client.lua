local ESX = exports["es_extended"]:getSharedObject()
local isAlarming = false
local currentDispatch = nil
local monitorObj, printerObj = nil, nil

-- 1. SPAWN OBJEKTŮ (Monitor a Tiskárna)
function SpawnStationProps()
    local models = { Config.Locations.Monitor.model, Config.Locations.Printer.model }

    for _, modelName in ipairs(models) do
        local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        RequestModel(modelHash)
        local timer = 0
        while not HasModelLoaded(modelHash) and timer < 100 do
            Citizen.Wait(10)
            timer = timer + 1
        end
    end

    if DoesEntityExist(monitorObj) then DeleteEntity(monitorObj) end
    if DoesEntityExist(printerObj) then DeleteEntity(printerObj) end

    monitorObj = CreateObject(GetHashKey(Config.Locations.Monitor.model), Config.Locations.Monitor.coords.x, Config.Locations.Monitor.coords.y, Config.Locations.Monitor.coords.z, false, false, false)
    SetEntityHeading(monitorObj, Config.Locations.Monitor.coords.w)
    FreezeEntityPosition(monitorObj, true)

    printerObj = CreateObject(GetHashKey(Config.Locations.Printer.model), Config.Locations.Printer.coords.x, Config.Locations.Printer.coords.y, Config.Locations.Printer.coords.z, false, false, false)
    SetEntityHeading(printerObj, Config.Locations.Printer.coords.w)
    FreezeEntityPosition(printerObj, true)

    exports.ox_target:addLocalEntity(printerObj, {
        {
            name = 'print_dispatch',
            icon = 'fa-solid fa-print',
            label = 'Vytisknout výjezdový lístek',
            onSelect = function()
                if currentDispatch then
                    TriggerServerEvent('esx_fireDispatch:printTicket', currentDispatch)
                else
                    exports.ox_lib:notify({type = 'error', description = 'Žádný aktivní výjezd k tisku!'})
                end
            end
        }
    })
end

-- 2. POMOCNÉ FUNKCE
function GetCurrentStreet()
    local pCoords = GetEntityCoords(PlayerPedId())
    local s1, s2 = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)
    return GetStreetNameFromHashKey(s1)
end

function StartAlarmEffects()
    if isAlarming then return end
    isAlarming = true
    Citizen.CreateThread(function()
        local timer = 60 
        while isAlarming and timer > 0 do
            DrawLightWithRange(Config.Locations.Monitor.coords.x, Config.Locations.Monitor.coords.y, Config.Locations.Monitor.coords.z + 1.2, 255, 0, 0, 15.0, 150.0)
            DrawLightWithRange(Config.FireStation.coords.x, Config.FireStation.coords.y, Config.FireStation.coords.z + 5.0, 255, 0, 0, 20.0, 100.0)
            Citizen.Wait(500)
            timer = timer - 1
        end
        isAlarming = false
    end)
end

-- 3. JEDNOTNÝ SYNC EVENT (Zobrazení panelu a zvuk jen pro HZS)
RegisterNetEvent('esx_fireDispatch:syncAlarmForAll')
AddEventHandler('esx_fireDispatch:syncAlarmForAll', function(data)
    local xPlayer = ESX.GetPlayerData()
    local playerJob = xPlayer.job and xPlayer.job.name or nil

    if playerJob == 'hzs' then
        local pCoords = GetEntityCoords(PlayerPedId())
        local stationPos = vector3(Config.FireStation.coords.x, Config.FireStation.coords.y, Config.FireStation.coords.z)
        local dist = #(pCoords - stationPos)

        if dist <= Config.AlarmRange then
            currentDispatch = {
                display_code = data.display_code or "150",
                title = (data.display_code or "150") .. " - " .. (data.description or "Poplach"),
                location = data.street or "Neznámá adresa",
                msg = data.message or ""
            }

            SendNUIMessage({
                action = "playAlarm",
                info = currentDispatch
            })

            StartAlarmEffects() 
        end
    end
end)

-- 4. VLASTNÍ PŘÍKAZY /150 a /112 (Pro všechny hráče)
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

        local dispatchData = {
            display_code = cmd,
            description = (cmd == "150" and "POŽÁR" or "TÍSŇOVÉ VOLÁNÍ"),
            street = data.street,
            message = voiceMessage
        }
        TriggerServerEvent('esx_fireDispatch:passToServer', dispatchData)

    end, false)
end

-- 5. UNIVERZÁLNÍ ODPOSLECH PRO AUTOMATICKÉ POŽÁRY (z_fire, atd.)
RegisterNetEvent('cd_dispatch:AddNotification')
AddEventHandler('cd_dispatch:AddNotification', function(data)
    -- Převedeme texty na malá písmena pro snadnější hledání
    local title = string.lower(data.title or "")
    local desc = string.lower(data.description or "")
    local msg = string.lower(data.message or "")
    local code = tostring(data.display_code or data.dispatch_code or "")

    -- KONTROLA: Hledáme kód 150 NEBO klíčová slova jako "hoří" nebo "požár"
    if code == '150' or string.find(title, "hoří") or string.find(desc, "hoří") or string.find(msg, "hoří") or string.find(title, "požár") or string.find(desc, "požár") then
        
        local xPlayer = ESX.GetPlayerData()
        if xPlayer.job and xPlayer.job.name == 'hzs' then
            
            -- Pokud zpráva neobsahuje Scanii, přidáme ji pro hlas
            local finalMsg = data.message or data.description or "Byl detekován požár!"
            if not string.find(string.lower(finalMsg), "scania") then
                finalMsg = finalMsg .. ". K výjezdu určen vůz CAS 20 Scania."
            end

            -- Aktivujeme alarm na stanici
            TriggerServerEvent('esx_fireDispatch:passToServer', {
                display_code = "150",
                description = "AUTOMATICKÝ POPLACH",
                street = data.street or data.street_name or GetCurrentStreet(),
                message = finalMsg
            })
            
            print("^2[FireDispatch] Detekován automatický požár (z_fire/systém). Spouštím stanici.^7")
        end
    end
end)

-- 6. LÍSTEK A NUI
RegisterNetEvent('esx_fireDispatch:showTicket')
AddEventHandler('esx_fireDispatch:showTicket', function(data)
    SendNUIMessage({ action = "openTicket", info = data })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('close', function() SetNuiFocus(false, false) end)

-- Start skriptu
AddEventHandler('onResourceStart', function(res) if res == GetCurrentResourceName() then SpawnStationProps() end end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function() SpawnStationProps() end)

-- 4. INTERNÍ POPLACH PRO HZS (Jen stanice, bez cd_dispatch)
RegisterCommand("poplach", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerData()
    local playerJob = xPlayer.job and xPlayer.job.name or nil

    -- 1. KONTROLA: Pouze pro hasiče
    if playerJob == 'hzs' then
        
        -- 2. KONTROLA: Zadal velitel aspoň ten Postal?
        if not args[1] then
            exports.ox_lib:notify({type = 'error', description = 'Musíš zadat Postal! (např. /poplach 8590)'})
            return
        end

        local postalCode = args[1] -- První slovo je číslo postalu
        
        -- Zbytek textu se spojí do zprávy o události
        local msgTable = {}
        for i = 2, #args do
            table.insert(msgTable, args[i])
        end
        local msgText = (#msgTable > 0) and table.concat(msgTable, " ") or "Vyhlášen výjezd jednotky"

        -- 3. SESTAVENÍ DAT PRO TVŮJ SKRIPT (Panel + Hlas)
        -- Hlas nahlásí: "Místo události: Postal [číslo]. [Zpráva]. K výjezdu určen vůz CAS 20 Scania."
        local fullVoiceMessage = "Místo události: Postal " .. postalCode .. ". " .. msgText .. ". K výjezdu určen vůz CAS 20 Scania."

        local dispatchData = {
            display_code = "ALARM",         -- Kód, co svítí na monitoru
            description = "VÝJEZD JEDNOTKY", -- Nadpis na monitoru
            street = "Postal: " .. postalCode, -- Zobrazí se v kolonce adresa
            message = fullVoiceMessage      -- Toto přečte hlas za 25s
        }

        -- 4. ODESLÁNÍ NA SERVER (Spustí sirény a panely všem hasičům)
        TriggerServerEvent('esx_fireDispatch:passToServer', dispatchData)

        -- Notifikace pro velitele, že se to povedlo
        exports.ox_lib:notify({
            type = 'info', 
            description = 'Interní poplach na postal ' .. postalCode .. ' byl spuštěn!'
        })

    else
        -- Pokud to napíše někdo jiný
        exports.ox_lib:notify({type = 'error', description = 'Tento příkaz je určen pouze pro velitele HZS!'})
    end
end, false)