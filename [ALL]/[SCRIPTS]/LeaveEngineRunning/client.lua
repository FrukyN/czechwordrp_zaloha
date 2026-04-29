------------------------------------------- 
--- Leave Engine Running, Made by FAXES ---
--- Úprava: notifikace přes ox_lib, překlad ---
--- Optimalizace: Dynamický sleep, DRY kód ---
-------------------------------------------

--- Config ---
local RestrictEmer = false -- Pouze pro služební vozidla (emergency)
local keepDoorOpen = false -- Nechat dveře otevřené při vystoupení

--- Code ---
local notified = false
local leaveFlag = keepDoorOpen and 256 or 0 -- Předkalkulace flagu pro vystoupení

local function ShowNotification(text)
    lib.notify({
        title = 'Motor vozidla',
        description = text,
        type = 'inform'
    })
end

Citizen.CreateThread(function()
    while true do
        local sleep = 500 -- Pokud hráč není v autě, vlákno se zpomalí (šetří výkon)
        local ped = PlayerPedId()

        -- Zjistíme, jestli je hráč v autě (nepočítáme nastupování)
        if IsPedInAnyVehicle(ped, false) then
            sleep = 0 -- Hráč je v autě, potřebujeme okamžitou odezvu na klávesy
            local veh = GetVehiclePedIsIn(ped, false)

            -- Jednorázová notifikace
            if not notified then
                ShowNotification("Drž F při vystupování, aby zůstal motor zapnutý.")
                notified = true
            end

            -- Kontrola, zda má hráč oprávnění nechat motor běžet
            local canLeaveRunning = true
            if RestrictEmer and GetVehicleClass(veh) ~= 18 then
                canLeaveRunning = false
            end

            -- Logika vystupování
            if canLeaveRunning and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                Citizen.Wait(150) -- Krátká prodleva pro ověření podržení klávesy
                
                -- Opětovná kontrola po uplynutí 150ms
                if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                    SetVehicleEngineOn(veh, true, true, false)
                    TaskLeaveVehicle(ped, veh, leaveFlag)
                    
                    -- Počkáme sekundu, aby se loop nespustil znovu, než postava stihne vystoupit
                    Citizen.Wait(1000) 
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)