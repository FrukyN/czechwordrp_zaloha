local ESX = exports['es_extended']:getSharedObject()

local isCameraActive = false
local heliCam = nil
local visionState = 0
local spotlightActive = false
local currentAlt = 0
local zoom = 80.0
local requiredJob = "police"
local allowedVehicleModel = GetHashKey("supervolito") -- Změň na svůj model
local lastCamDir = vector3(0.0, 0.0, -1.0)
local heliCheckpoints = {}
local isHeliHeadsetPluggedIn = false

-- Tabulka pro ukládání checkpointů (bodů)
local remoteSpotlights = {}
local activeCheckpoints = {}

-- POMOCNÉ FUNKCE
function GetCameraDirection(cam)
    local rot = GetCamRot(cam, 2)
    local tX = (math.pi / 180) * rot.x
    local tZ = (math.pi / 180) * rot.z
    local num = math.abs(math.cos(tX))
    return vector3(-math.sin(tZ) * num, math.cos(tZ) * num, math.sin(tX))
end

-- FUNKCE PRO ZJIŠTĚNÍ BODU NA ZEMI (Raycast)
function GetCameraGroundPoint(cam)
    local coords = GetCamCoord(cam)
    local forwardVec = GetCameraDirection(cam)
    -- Paprsek poletí 1000 jednotek daleko
    local destination = coords + (forwardVec * 1000.0)
    
    -- StartShapeTestRay(x1, y1, z1, x2, y2, z2, flags, ignoreEntity, p8)
    -- flag 17 = země, budovy, objekty
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z, 17, GetVehiclePedIsIn(PlayerPedId(), false), 0)
    local _, hit, endCoords, _, _ = GetShapeTestResult(rayHandle)
    
    if hit then return endCoords end
    return nil
end

function GetVehicleInView(cam)
    local coords = GetCamCoord(cam)
    local forwardVec = GetCameraDirection(cam)
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x + (forwardVec.x * 500.0), coords.y + (forwardVec.y * 500.0), coords.z + (forwardVec.z * 500.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
    if hit and IsEntityAVehicle(entityHit) then return entityHit end
    return nil
end

-- LOGIKA KAMERY
function StartCamera(veh)
    isCameraActive = true
    heliCam = CreateCamWithParams("DEFAULT_SCRIPTED_FLY_CAMERA", GetEntityCoords(veh), 0.0, 0.0, 0.0, zoom, false, 0)
    AttachCamToEntity(heliCam, veh, 0.0, 2.5, -1.0, true)
    SetCamActive(heliCam, true)
    RenderScriptCams(true, true, 1000, true, false)
    
    SetTimecycleModifier("heli_cam_filter")
    SetTimecycleModifierStrength(0.8)
    StartAudioScene("DLC_HELISTAT_HELI_SCENE")

    DisplayRadar(false)
    SendNUIMessage({action = "showUI", state = true})

    Citizen.CreateThread(function()
        while isCameraActive do
            local vehPos = GetEntityCoords(veh)
            currentAlt = vehPos.z * 3.28084 
            local speed = GetEntitySpeed(veh) * 1.94384
            local camRot = GetCamRot(heliCam, 2)
            local heading = camRot.z
            if heading < 0 then heading = heading + 360.0 end

            local mouseX = GetControlNormal(0, 1)
            local mouseY = GetControlNormal(0, 2)
            local newX = camRot.x - (mouseY * 10.0)
            if newX > 10.0 then newX = 10.0 elseif newX < -80.0 then newX = -80.0 end
            SetCamRot(heliCam, newX, 0.0, camRot.z - (mouseX * 10.0), 2)

            if IsControlJustPressed(0, 241) then zoom = math.max(10.0, zoom - 5.0); SetCamFov(heliCam, zoom) end
            if IsControlJustPressed(0, 242) then zoom = math.min(80.0, zoom + 5.0); SetCamFov(heliCam, zoom) end

            SendNUIMessage({action = "update", alt = currentAlt, speed = speed, heading = heading})

            local targetVeh = GetVehicleInView(heliCam)
            if targetVeh then
                local plate = GetVehicleNumberPlateText(targetVeh)
                local modelName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(targetVeh)))
                SendNUIMessage({action = "updateTarget", model = modelName, plate = plate})
            else
                SendNUIMessage({action = "updateTarget", model = nil, plate = nil})
            end

            -- KLÁVESA X (Bod zájmu)
            if IsControlJustPressed(0, 73) then 
                local groundPoint = GetCameraGroundPoint(heliCam)
                if groundPoint then
                    local netId = NetworkGetNetworkIdFromEntity(veh)
                    TriggerServerEvent('heli:addCheckpoint', netId, groundPoint)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                end
            end

            if IsControlJustPressed(0, 38) then 
                spotlightActive = not spotlightActive
                TriggerServerEvent('heli:toggleSpotlight', NetworkGetNetworkIdFromEntity(veh), spotlightActive)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                SendNUIMessage({action = "updateStatus", spotlight = spotlightActive})
            end

            if spotlightActive then
                local camPos = GetCamCoord(heliCam)
                lastCamDir = GetCameraDirection(heliCam)
                DrawSpotLightWithShadow(camPos.x, camPos.y, camPos.z, lastCamDir.x, lastCamDir.y, lastCamDir.z, 255, 255, 255, 500.0, 50.0, 0.0, 15.0, 25.0, 1)
                TriggerServerEvent('heli:updateDir', NetworkGetNetworkIdFromEntity(veh), lastCamDir)
            end

            if IsControlJustPressed(0, 47) then visionState = (visionState + 1) % 3; SetVision(visionState) end

            if IsControlJustPressed(0, 177) then 
                isCameraActive = false
                RenderScriptCams(false, true, 1000, true, false)
                DestroyCam(heliCam, true)
                ClearTimecycleModifier()
                StopAudioScene("DLC_HELISTAT_HELI_SCENE")
                SetVision(0)
                DisplayRadar(true)
                SendNUIMessage({action = "showUI", state = false})
            end
            Wait(0)
        end
    end)
end

-- SYNCHRONIZACE CHECKPOINTŮ
RegisterNetEvent('heli:syncCheckpoint')
AddEventHandler('heli:syncCheckpoint', function(netId, coords, num)
    if not activeCheckpoints[netId] then activeCheckpoints[netId] = {} end
    table.insert(activeCheckpoints[netId], {pos = coords, label = num})
end)

RegisterNetEvent('heli:syncSpotlight')
AddEventHandler('heli:syncSpotlight', function(netId, state)
    remoteSpotlights[netId] = { active = state, dir = vector3(0,0,-1) }
end)

RegisterNetEvent('heli:syncDir')
AddEventHandler('heli:syncDir', function(netId, dir)
    if remoteSpotlights[netId] then remoteSpotlights[netId].dir = dir end
end)

RegisterNetEvent('heli:syncCheckpoint')
AddEventHandler('heli:syncCheckpoint', function(netId, coords, num)
    -- Pokud by náhodou tabulka neexistovala, vytvoříme ji (jistota)
    if not heliCheckpoints then heliCheckpoints = {} end
    table.insert(heliCheckpoints, {vehNet = netId, pos = coords, label = num})
end)

-- HLAVNÍ SMYČKA PRO VYKRESLOVÁNÍ VŠEHO (Světla + Checkpointy)
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
        --local myNetId = NetworkGetNetworkIdFromEntity(playerVeh)

        -- 1. Kreslení světla (vlastní i cizí)
        if spotlightActive and not isCameraActive and playerVeh ~= 0 then
            sleep = 0
            local vc = GetEntityCoords(playerVeh)
            local vf = GetEntityForwardVector(playerVeh)
            local lightPos = vc + (vf * 1.5) - vector3(0, 0, 0.8)
            DrawSpotLightWithShadow(lightPos.x, lightPos.y, lightPos.z, lastCamDir.x, lastCamDir.y, lastCamDir.z, 255, 255, 255, 500.0, 50.0, 0.0, 15.0, 25.0, 1)
        end

        for netId, data in pairs(remoteSpotlights) do
            if data.active then
                if NetworkDoesNetworkIdExist(netId) then
                    local v = NetToVeh(netId)
                    if DoesEntityExist(v) and not (v == playerVeh and isCameraActive) then
                        sleep = 0
                        local vc = GetEntityCoords(v)
                        local vf = GetEntityForwardVector(v)
                        local pos = vc + (vf * 1.5) - vector3(0, 0, 0.8)
                        local finalDir = data.dir or GetEntityForwardVector(v)
                        DrawSpotLightWithShadow(pos.x, pos.y, pos.z, finalDir.x, finalDir.y, finalDir.z, 255, 255, 255, 500.0, 50.0, 0.0, 15.0, 25.0, 1)
                    end
                end
            end
        end

-- 2. KRESLENÍ CHECKPOINTŮ (Stylizované body zájmu)
if playerVeh ~= 0 and myNetId ~= 0 and activeCheckpoints[myNetId] then
    sleep = 0
    for _, cp in ipairs(activeCheckpoints[myNetId]) do
        -- 1. ČERVENÝ KRUH NA ZEMI (místo žlutého válce)
        -- DrawMarker(typ, x,y,z, dirX,dirY,dirZ, rotX,rotY,rotZ, scaleX,scaleY,scaleZ, R, G, B, A...)
        DrawMarker(23, cp.pos.x, cp.pos.y, cp.pos.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 0, 0, 200, false, false, 2, nil, nil, false)

        -- 2. STYLIZOVANÉ ČÍSLO VE VZDUCHU
        local onScreen, _x, _y = GetScreenCoordFromWorldCoord(cp.pos.x, cp.pos.y, cp.pos.z + 1.0) -- Číslo je metr nad zemí
        
        if onScreen then
            -- Pozadí/Stín pro efekt (trochu posunuté černé číslo)
            SetTextScale(1.5, 1.5) -- Hodně velké měřítko
            SetTextFont(1) -- Jiný styl fontu (zkus 0, 1, 4 nebo 7)
            SetTextColour(0, 0, 0, 255) -- Černý stín
            SetTextEntry("STRING")
            AddTextComponentString(tostring(cp.label))
            DrawText(_x + 0.002, _y + 0.002)

            -- Hlavní červené číslo (přesně jako na screenu)
            SetTextScale(1.5, 1.5)
            SetTextFont(1) 
            SetTextColour(255, 0, 0, 255) -- Jasně červená
            SetTextOutline() -- Přidá obrys
            SetTextEntry("STRING")
            AddTextComponentString(tostring(cp.label))
            DrawText(_x, _y)
        end
    end
end

        if spotlightActive and playerVeh == 0 then
            spotlightActive = false
        end

        Wait(sleep)
    end
end)

function SetVision(state)
    SetNightvision(state == 1)
    SetSeethrough(state == 2)
    if state == 2 then SeethroughSetFadeStartDistance(0.0); SeethroughSetFadeEndDistance(1000.0) end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 and GetEntityModel(veh) == allowedVehicleModel then
            sleep = 5 
            local job = ESX.GetPlayerData().job
            if job and job.name == requiredJob then
                if GetPedInVehicleSeat(veh, 0) == ped and not isCameraActive then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Stiskni ~INPUT_CONTEXT~ pro zapnutí palubní optiky")
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    if IsControlJustPressed(0, 38) then StartCamera(veh) end
                end
            end
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        -- KLÍČOVÁ OPRAVA: Nejdřív kontrolujeme, jestli veh není 0 a jestli existuje
        if veh ~= 0 and DoesEntityExist(veh) then
            -- Teprve TEĎ se můžeme ptát na Network ID
            local myNetId = NetworkGetNetworkIdFromEntity(veh)
            
            if heliCheckpoints ~= nil and #heliCheckpoints > 0 then
                for _, cp in ipairs(heliCheckpoints) do
                    if cp.vehNet == myNetId then
                        sleep = 0
                        -- Tady máš to kreslení markeru a textu...
                        DrawMarker(23, cp.pos.x, cp.pos.y, cp.pos.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 0, 0, 200, false, false, 2, nil, nil, false)

                        -- Stylizované červené číslo
                        local onScreen, _x, _y = GetScreenCoordFromWorldCoord(cp.pos.x, cp.pos.y, cp.pos.z + 1.2)
                        if onScreen then
                            -- Stín (černý)
                            SetTextScale(1.8, 1.8)
                            SetTextFont(1)
                            SetTextColour(0, 0, 0, 255)
                            SetTextEntry("STRING")
                            AddTextComponentString(tostring(cp.label))
                            DrawText(_x + 0.002, _y + 0.002)

                            -- Hlavní číslo (červené)
                            SetTextScale(1.8, 1.8)
                            SetTextFont(1)
                            SetTextColour(255, 0, 0, 255)
                            SetTextOutline()
                            SetTextEntry("STRING")
                            AddTextComponentString(tostring(cp.label))
                            DrawText(_x, _y)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

local function ApplyHeliAudioEffects(state)
    if state then
        -- 1. Zkusíme filtr 'CHOP', který má v sobě silný 'Low-Pass' (dusivý zvuk)
        SetTimecycleModifier("CHOP") 
        SetTimecycleModifierStrength(0.15) -- Nízká síla, aby to nezkreslilo barvy moc

        -- 2. Scéna pro utlumení ÚPLNĚ VŠEHO (včetně motorů)
        StartAudioScene("WANTED_SCENE") -- Scéna, když tě honí policie (vytváří napětí a tlumí okolí)
        
        -- 3. Pokus o totální ořezání frekvencí
        SetAudioSpecialEffectMode(1) 
        
        isHeliHeadsetPluggedIn = true
    else
        ClearTimecycleModifier()
        StopAudioScene("WANTED_SCENE")
        SetAudioSpecialEffectMode(0)
        isHeliHeadsetPluggedIn = false
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and DoesEntityExist(veh) then
            local model = GetEntityModel(veh)
            
            -- DEBUG: Vypíše do F8 model auta, ve kterém sedíš
            -- print("Sedíš v autě, model hash: " .. model)

            -- Tady je ta chyba! Pokud allowedVehicleModel není přesně tohle číslo, nespustí se to.
            if model == allowedVehicleModel then
                if not isHeliHeadsetPluggedIn then
                    ApplyHeliAudioEffects(true)
                end
                sleep = 500
            else
                if isHeliHeadsetPluggedIn then 
                    ApplyHeliAudioEffects(false) 
                end
            end
        else
            if isHeliHeadsetPluggedIn then 
                ApplyHeliAudioEffects(false) 
            end
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        -- 1. Kontrola, jestli sedíme v našem vrtulníku
        if veh ~= 0 and GetEntityModel(veh) == allowedVehicleModel then
            sleep = 0 -- Musíme kontrolovat neustále, aby rádio neproskočilo

            -- 2. Kontrola pohledu (Cam Mode)
            -- Většina helikoptérových kamer v GTA používá mód 4 (First Person / Camera)
            local camMode = GetFollowVehicleCamViewMode()
            
            -- Pokud je zapnutý speciální pohled (kamera), zablokujeme ovládání
            -- Můžeš zkusit i podmínku (camMode == 4), pokud by to blokovalo rádio pořád
            if camMode == 4 then 
                -- Zablokuje Q (kolečko rádia)
                DisableControlAction(0, 85, true) 
                -- Zablokuje kolečko myši (přepínání stanic a zbraní)
                DisableControlAction(0, 81, true) 
                DisableControlAction(0, 82, true)
                DisableControlAction(0, 99, true)
                DisableControlAction(0, 100, true)
                
                -- Pokusíme se rádio úplně vypnout (tento příkaz je starý, měl by jít)
                SetUserRadioControlEnabled(false)
            else
                -- Pokud nejsme v kameře, rádio zase povolíme
                SetUserRadioControlEnabled(true)
            end
        else
            -- Nesedíme v helině, dáme skriptu pauzu
            sleep = 1000
        end
        
        Wait(sleep)
    end
end)