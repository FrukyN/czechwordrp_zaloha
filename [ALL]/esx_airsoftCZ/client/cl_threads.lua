local ESX = exports["es_extended"]:getSharedObject()
local timeLeft = 0

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if Airsoft and Airsoft.Active then
            sleep = 0
            local health = GetEntityHealth(ped)

            -- 1. ZÁCHRANNÁ BRZDA: Pokud zdraví klesne moc nízko, hned healujeme
            -- GTA ped umírá při 100 HP. My ho zachráníme už při 150.
            if health < 198 then 
                SetEntityHealth(ped, 200) -- Okamžitě zpět na max
                
                -- Spustíme hit pouze pokud hráč už není OUT
                if not Airsoft.IsEliminated then
                    TriggerEvent('airsoft:registerHit')
                end
            end

            -- 2. KONSTRUKČNÍ OCHRANA: Hráč nemůže umřít (SetEntityCanBeDamaged)
            -- Vypneme headshoty
            SetPedSuffersCriticalHits(ped, false)
            -- Nastavíme, že hráč nesmí klesnout pod určitou mez (v některých verzích funguje)
            SetEntityCanBeDamaged(ped, true) 

            -- Vykreslování OUT nad ostatními
            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if targetPed ~= ped then
                    if IsEntityPlayingAnim(targetPed, "random@mugging3", "handsup_standing_base", 3) then
                        local tCoords = GetEntityCoords(targetPed)
                        DrawText3D(vector3(tCoords.x, tCoords.y, tCoords.z + 1.2), "~r~OUT")
                    end
                end
            end

            -- Zákaz střelby v OUT stavu
            if Airsoft.IsEliminated then
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 25, true) -- Aim
            end
        else
            -- Lobby logika (šipka)
            local coords = GetEntityCoords(ped)
            for k, v in pairs(Config.Arenas) do
                local dist = #(coords - v.lobby)
                if dist < 10.0 then
                    sleep = 0
                    DrawMarker(20, v.lobby.x, v.lobby.y, v.lobby.z, 0,0,0, 0,180.0,0, 0.5,0.5,0.5, 255,204,0, 150, true, true, 2)
                    if dist < 1.5 then
                        DrawText3D(v.lobby, "~y~[E]~w~ Airsoft Lobby")
                        if IsControlJustReleased(0, 38) then OpenArenaMenu(k) end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)