ESX = exports['es_extended']:getSharedObject()

-- Odstranili jsme obří tabulku Keys, použijeme rovnou ID kláves (21 = LSHIFT, 47 = G)
local PlayerData        = {}
local PoliceJob         = 'police'

local isTackling        = false
local isGettingTackled  = false

local tackleLib         = 'missmic2ig_11'
local tackleAnim        = 'mic_2_ig_11_intro_goon'
local tackleVictimAnim  = 'mic_2_ig_11_intro_p_one'

local lastTackleTime    = 0

-- Načtení dat při startu scriptu (ochrana proti chybám, pokud hráč ještě nemá job)
Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Pomocná funkce pro bezpečné a čisté načítání animací
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
    isGettingTackled = true

    local playerPed = PlayerPedId() -- Rychlejší než GetPlayerPed(-1)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

    LoadAnimDict(tackleLib)

    AttachEntityToEntity(playerPed, targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
    TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

    Citizen.Wait(3000)
    DetachEntity(playerPed, true, false)

    -- Optimalizovaný ragdoll: místo nekonečného vlákna použijeme dočasný cyklus
    local ragdollEndTime = GetGameTimer() + 3000
    while GetGameTimer() < ragdollEndTime do
        Citizen.Wait(0)
        SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
    end

    isGettingTackled = false
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
    local playerPed = PlayerPedId()

    LoadAnimDict(tackleLib)

    TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)
    Citizen.Wait(3000)

    isTackling = false
end)

-- Hlavní vlákno (Main thread)
Citizen.CreateThread(function()
    while true do
        local sleep = 500 -- Dynamický sleep (šetří výkon, pokud hráč není polda)

        -- Kód se spustí (a sníží tickrate), pouze pokud má hráč roli policisty
        if PlayerData and PlayerData.job and PlayerData.job.name == PoliceJob then
            sleep = 0 

            -- 21 = LSHIFT, 47 = G
            if IsControlPressed(0, 21) and IsControlPressed(0, 47) and not isTackling then
                if GetGameTimer() - lastTackleTime > 10000 then -- 10 vteřin cooldown
                    local playerPed = PlayerPedId()

                    if not isGettingTackled and not IsPedInAnyVehicle(playerPed, false) then
                        local closestPlayer, distance = ESX.Game.GetClosestPlayer()

                        -- Přidána kontrola, aby Config nedělal problémy, a ověření cíle
                        if distance ~= -1 and distance <= Config.TackleDistance then
                            local targetPed = GetPlayerPed(closestPlayer)
                            
                            if not IsPedInAnyVehicle(targetPed, false) then
                                isTackling = true
                                lastTackleTime = GetGameTimer()
                                TriggerServerEvent('esx_kekke_tackle:tryTackle', GetPlayerServerId(closestPlayer))
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)