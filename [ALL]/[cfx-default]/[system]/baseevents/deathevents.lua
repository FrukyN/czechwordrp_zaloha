Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false
    local diedAt

    while true do
        Wait(50) -- Wait(50) je pro detekci smrti naprosto dostačující a ušetří výkon oproti Wait(0)

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedFatallyInjured(ped) and not isDead then
                isDead = true
                if not diedAt then
                    diedAt = GetGameTimer()
                end

                local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                local killerentitytype = GetEntityType(killer)
                local killertype = -1
                local killerinvehicle = false
                local killervehiclename = ''
                local killervehicleseat = 0

                if killerentitytype == 1 then
                    killertype = GetPedType(killer)
                    if IsPedInAnyVehicle(killer, false) then
                        killerinvehicle = true
                        local killerVehicle = GetVehiclePedIsUsing(killer)
                        killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(killerVehicle))
                        killervehicleseat = GetPedVehicleSeat(killer)
                    end
                end

                -- OPTIMALIZACE: Použití nativní funkce místo vlastního iterování 32 IDček
                local killerid = NetworkGetPlayerIndexFromPed(killer)
                
                if killer ~= ped and killerid ~= -1 and NetworkIsPlayerActive(killerid) then 
                    killerid = GetPlayerServerId(killerid)
                else 
                    killerid = -1
                end

                if killer == ped or killer == -1 then
                    local coords = GetEntityCoords(ped)
                    TriggerEvent('baseevents:onPlayerDied', killertype, { coords.x, coords.y, coords.z })
                    TriggerServerEvent('baseevents:onPlayerDied', killertype, { coords.x, coords.y, coords.z })
                    hasBeenDead = true
                else
                    local coords = GetEntityCoords(ped)
                    local data = {
                        killertype = killertype, 
                        weaponhash = killerweapon, 
                        killerinveh = killerinvehicle, 
                        killervehseat = killervehicleseat, 
                        killervehname = killervehiclename, 
                        killerpos = { coords.x, coords.y, coords.z }
                    }
                    TriggerEvent('baseevents:onPlayerKilled', killerid, data)
                    TriggerServerEvent('baseevents:onPlayerKilled', killerid, data)
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end

            -- check if the player has to respawn in order to trigger an event
            if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
                local coords = GetEntityCoords(ped)
                TriggerEvent('baseevents:onPlayerWasted', { coords.x, coords.y, coords.z })
                TriggerServerEvent('baseevents:onPlayerWasted', { coords.x, coords.y, coords.z })
                hasBeenDead = true
            elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
                hasBeenDead = false
            end
        end
    end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ped then 
            return i 
        end
    end
    return -2
end