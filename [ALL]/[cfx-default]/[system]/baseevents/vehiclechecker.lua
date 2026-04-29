local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50) -- Ponechán pouze jeden Wait na optimálních 50ms

        local ped = PlayerPedId()

        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            local tryingVehicle = GetVehiclePedIsTryingToEnter(ped)
            
            if tryingVehicle ~= 0 and not isEnteringVehicle then
                -- trying to enter a vehicle!
                local seat = GetSeatPedIsTryingToEnter(ped)
                local netId = VehToNet(tryingVehicle)
                isEnteringVehicle = true
                TriggerServerEvent('baseevents:enteringVehicle', tryingVehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(tryingVehicle)), netId)
            
            elseif tryingVehicle == 0 and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
                -- vehicle entering aborted
                TriggerServerEvent('baseevents:enteringAborted')
                isEnteringVehicle = false
            
            elseif IsPedInAnyVehicle(ped, false) then
                -- suddenly appeared in a vehicle, possible teleport
                isEnteringVehicle = false
                isInVehicle = true
                currentVehicle = GetVehiclePedIsUsing(ped)
                currentSeat = GetPedVehicleSeat(ped)
                local model = GetEntityModel(currentVehicle)
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(model), netId)
            end
        elseif isInVehicle then
            if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
                -- bye, vehicle
                local model = GetEntityModel(currentVehicle)
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(model), netId)
                isInVehicle = false
                currentVehicle = 0
                currentSeat = 0
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