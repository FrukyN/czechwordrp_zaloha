local isNearElevator = false
local currentBuilding = nil
local currentFloor = nil
local showui = false

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearestElevator, nearestDist, nearestBuilding, nearestFloor

        for _, building in ipairs(Config.Buildings) do
            if building.floors then
                for _, floor in ipairs(building.floors) do
                    local dist = #(playerCoords - vector3(floor.coords.x, floor.coords.y, floor.coords.z))
                    if not nearestDist or dist < nearestDist then
                        nearestDist = dist
                        nearestElevator = floor
                        nearestBuilding = building
                        nearestFloor = floor
                    end
                end
            end
        end

        if nearestDist and nearestDist < 1.8 then
            if not isNearElevator then
                isNearElevator = true
                currentBuilding = nearestBuilding
                currentFloor = nearestFloor
            end
        else
            isNearElevator = false
            currentBuilding = nil
            currentFloor = nil
        end

        Wait(500)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if isNearElevator then
			if not showui then
				MessageUpLeftCorner("Press ~INPUT_CONTEXT~ to use the elevator")
				if IsControlJustReleased(0, 38) then
					OpenElevatorUI(currentBuilding, currentFloor)
				end
			end
        else
			Wait(500)
		end
    end
end)

function OpenElevatorUI(building, currentFloor)
    local sendData = {
        action = "open",
        building = building,
        currentFloor = currentFloor
    }
    SendNUIMessage(sendData)
    SetNuiFocus(true, true)
	showui = true
end

function CloseElevatorUI()
    SetNuiFocus(false, false)
	showui = false
end

RegisterNUICallback('close', function(data, cb)
    CloseElevatorUI()
    cb('OK')
	showui = false
end)

RegisterNUICallback('setNuiFocus', function(data, cb)
    SetNuiFocus(data.focus, data.cursor)
    cb('OK')
end)

RegisterNUICallback('floorSelected', function(data, cb)
    local coords = data.coords
    if coords then
        local ped = PlayerPedId()
		FreezeEntityPosition(ped, true)
        SetNuiFocus(false, false)
        Wait(1000)
        PlaySoundFrontend(-1, "CLOSED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);
        Wait(1500)
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
        Wait(500)
        PlaySoundFrontend(-1, "OPENED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);
        SetEntityCoords(ped, coords.x, coords.y, coords.z -1)
		SetEntityHeading(ped, coords.w)
		FreezeEntityPosition(ped, false)
		showui = false
    end
    cb('OK')
end)

function MessageUpLeftCorner(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end