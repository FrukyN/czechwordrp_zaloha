local damageThreshold = 180.0  -- Pod tuto mez je auto nepojízdné (černý kouř)
local smokeThreshold = 450.0   -- Pod tuto mez začíná motor bíle kouřit
local isDead = false           -- Stav vozidla
local isInjured = false        -- Stav hráče (zranění/šok)
local oldSpeed = 0.0

-- Inicializace ESX
local ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    print("^2[esx_vehicle_damage] ^0Hardcore script spuštěn (Všichni pasažéři + Blokace jízdy).")

    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            sleep = 50 
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Logika pouze pro řidiče (detekce nárazu a poškození motoru)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                local engineHealth = GetVehicleEngineHealth(vehicle)
                local currentSpeed = GetEntitySpeed(vehicle) * 3.6 

                -----------------------------------------------------------
                -- 1. DETEKCE NÁRAZU (SYNCHRONIZACE PRO POSÁDKU)
                -----------------------------------------------------------
                local speedDrop = oldSpeed - currentSpeed
                
                -- Aktivuje se při nárazu nad 40 km/h a náhlém zastavení o 25+ km/h
                if (speedDrop > 60.0) and oldSpeed > 60.0 then
                    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                    for i = -1, maxSeats - 1 do
                        local occupant = GetPedInVehicleSeat(vehicle, i)
                        if occupant ~= 0 and IsPedAPlayer(occupant) then
                            local targetPlayer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(occupant))
                            TriggerServerEvent('esx_vehicle_damage:triggerImpact', targetPlayer)
                        end
                    end
                    
                    -- Okamžité zastavení auta po nárazu (fyzika)
                    SetVehicleEngineOn(vehicle, false, true, true)
                    SetVehicleForwardSpeed(vehicle, 0)
                end
                oldSpeed = currentSpeed

                -----------------------------------------------------------
                -- 2. STAV MOTORU A VIZUÁLNÍ EFEKTY (KOUŘ)
                -----------------------------------------------------------
                if engineHealth <= damageThreshold then
                    -- Převzetí kontroly nad entitou pro synchronizaci kouře
                    if not NetworkHasControlOfEntity(vehicle) then
                        NetworkRequestControlOfEntity(vehicle)
                    end

                    SetVehicleEngineHealth(vehicle, -10.0) -- Vynutí hustý černý kouř/oheň
                    SetVehicleEngineOn(vehicle, false, true, true)
                    SetVehicleUndriveable(vehicle, true)
                    SetVehicleFuelLevel(vehicle, 0.0) -- Odstaví palivo
                    
                    if not isDead then
                        lib.notify({
                            title = 'Vozidlo KO',
                            description = 'Motor explodoval a je nepojízdný!',
                            type = 'error',
                            duration = 10000
                        })
                        isDead = true
                    end
                elseif engineHealth <= smokeThreshold then
                    SetVehicleEngineCanDegrade(vehicle, true)
                else
                    if isDead then isDead = false end
                end
            end
        else
            -- Reset hodnot mimo vozidlo
            oldSpeed = 0.0
            isDead = false
            sleep = 1000
        end

        -----------------------------------------------------------
        -- 3. TVRDÁ BLOKACE V PRVNÍ FÁZI (ŠOK)
        -----------------------------------------------------------
        if isInjured then
            sleep = 0
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Zablokování plynu a brzdy (aby auto neujelo ani ze setrvačnosti)
            if vehicle ~= 0 then
                SetVehicleForwardSpeed(vehicle, 0)
                SetVehicleBrake(vehicle, true)
            end

            -- Zákaz ovládání (Plyn, Brzda, Vystoupení, Zbraně, Inventář)
            DisableControlAction(0, 71, true) -- W
            DisableControlAction(0, 72, true) -- S
            DisableControlAction(0, 75, true) -- F
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 37, true) -- Tab (Inventory)
            
            -- Vynucení ragdollu (zhroucení postavy na sedačce)
            if not IsPedRagdoll(playerPed) and IsPedInAnyVehicle(playerPed, false) then
                SetPedToRagdoll(playerPed, 2000, 2000, 0, 0, 0, 0)
            end
        end

        Citizen.Wait(sleep)
    end
end)

-----------------------------------------------------------
-- LOGIKA EFEKTŮ (Aplikuje se na každého v autě)
-----------------------------------------------------------
RegisterNetEvent('esx_vehicle_damage:applyImpact')
AddEventHandler('esx_vehicle_damage:applyImpact', function()
    local playerPed = PlayerPedId()
    if isInjured then return end 

    isInjured = true
    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 2.0)
    DoScreenFadeOut(200)
    
    -- FÁZE 1: Totální bezmoc (15 sekund)
    SetPedToRagdoll(playerPed, 15000, 15000, 0, 0, 0, 0)
    
    Citizen.Wait(2000)
    DoScreenFadeIn(2000)
    
    lib.notify({
        title = 'TĚŽKÝ NÁRAZ',
        description = 'Utrpěli jste šok. Jste paralyzováni a nemůžete vystoupit!',
        type = 'error',
        duration = 15000,
        position = 'top'
    })
    
    SetTimecycleModifier("spectator5") -- Rozmazání zraku
    SetTimecycleModifierStrength(1.5)
    
    Citizen.Wait(13000) -- Čas do konce paralýzy
    
    isInjured = false -- KONEC FÁZE 1 (Hráč už může vystoupit)
    
    lib.notify({
        description = 'Šok pominul, ale tvá postava kulhá zraněním.',
        type = 'warning',
        duration = 8000
    })
    
    -- FÁZE 2: Kulhání (30 sekund)
    RequestAnimSet("move_m@injured")
    while not HasAnimSetLoaded("move_m@injured") do Citizen.Wait(0) end
    SetPedMovementClipset(playerPed, "move_m@injured", 1.0)
    
    Citizen.Wait(30000)
    
    -- Návrat do normálu
    ResetPedMovementClipset(playerPed, 0.0)
    ClearTimecycleModifier()
    
    lib.notify({
        description = 'Stav stabilizován.',
        type = 'inform'
    })
end)