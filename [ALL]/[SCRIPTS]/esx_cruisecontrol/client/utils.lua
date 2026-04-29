Utils = {
    ped = nil,
    vehicle = nil,
    driver = false,

    DriverCheck = function(self)
        return self.driver
    end,

    IsSteering = function(self)
        if not self.vehicle then return false end
        return math.abs(GetVehicleSteeringAngle(self.vehicle)) > 10.0
    end,

    GetSpeed = function(self)
        if not self.driver or not self.vehicle then return 0 end
        local curSpeed = GetEntitySpeed(self.vehicle)
        return math.floor(curSpeed * 3.6)
    end
}

-- hlavní updater (nahrazuje rozbitý ESX eventy)
CreateThread(function()
    while true do
        Utils.ped = PlayerPedId()

        local veh = GetVehiclePedIsIn(Utils.ped, false)
        Utils.vehicle = veh ~= 0 and veh or nil

        if Utils.vehicle then
            Utils.driver = GetPedInVehicleSeat(Utils.vehicle, -1) == Utils.ped
        else
            Utils.driver = false
        end

        Wait(400)
    end
end)