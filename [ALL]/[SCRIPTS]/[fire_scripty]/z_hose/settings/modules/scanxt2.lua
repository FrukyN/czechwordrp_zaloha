---@docus: Please refer to our resource documentation for assistance with configuring this resource: docs.zeadevelopment.com.

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

return {
    ---@section tanks
    ---@description: This table facilitates the configuration of the vehicles' foam and water tanks.
    ['tanks'] = {
        canCarryWater = true,
        canCarryFoam = true,

        ['water'] = {start = 4000.0, capacity = 4000.0}, ---|> Measured in liters
        ['foam'] = {start = 240.0, capacity = 240.0}, ---|> Measured in liters
    },

    ---@section panelOffset
    ---@description: This parameter enables the configuration of the panel interaction position on the vehicle.
    panelOffset = vector3(0.060000, -4.230002, 0.859999),

    ---@section valves
    ---@description: This table facilitates the addition and configuration of valves, including intakes and discharges, along with their offsets.
    ['valves'] = {
        intakes = {
            -- # Index Start # --
            {
                label = 'DOPLŇOVÁNÍ 1',
                offset = vector3(-1.119999, -3.509997, -0.080000)
            },
            -- # Index End # --
            -- # Index Start # --
            {
                label = 'DOPLŇOVÁNÍ 2',
                offset = vector3(1.139999, -3.509997, -0.080000)
            }
            -- # Index End # --
        },

        discharges = {
            -- # Index Start # --
            {
                label = 'VÝTLAK 1',
                offset = vector3(1.129999, -3.989997, 0.120000),
                type = 'water&foam' ---|> 'water' | 'foam' | 'water&foam' | 'relay'
            },
            -- # Index End # --
            -- # Index Start # --
            {
                label = 'VÝTLAK 2',
                offset = vector3(-1.139999, -3.989997, 0.120000),
                type = 'water&foam' ---|> 'water' | 'foam' | 'water&foam' | 'relay'
            },
            -- # Index End # --
            -- # Index Start # --
            {
                label = 'VÝTLAK 3 - DOPLŇOVÁNÍ',
                offset = vector3(-1.139999, -3.759997, 0.050000),
                type = 'relay' ---|> 'water' | 'foam' | 'water&foam' | 'relay'
            },
            -- # Index End # --
            -- # Index Start # --
            {
                label = 'VÝTLAK 4 - DOPLŇOVÁNÍ',
                offset = vector3(1.139999, -3.759997, 0.050000),
                type = 'relay' ---|> 'water' | 'foam' | 'water&foam' | 'relay'
            },
            -- # Index End # --
            -- # Index Start # --
            {
                label = 'VYSOKOTLAK',
                offset = vector3(1.089999, -3.879997, 1.049999),
                type = 'water' ---|> 'water' | 'foam' | 'water&foam' | 'relay'
            },
            -- # Index End # --            
        }
    },

    ---@section misc
    ---@description: This table facilitates the customization of the vehicle page data within the Pump UI.
    ['misc'] = {
        ---@param vehicle integer
        ---@return boolean
        areLockersOpen = function(vehicle)
            local extras = {1}
            local isOpen = false

            for _, extra in pairs(extras) do
                if DoesExtraExist(vehicle, extra) then
                    if IsVehicleExtraTurnedOn(vehicle, extra) then isOpen = true break end
                end
            end

           return isOpen
        end,

        ---@param vehicle integer
        ---@return boolean | nil
        areEmergencyLightsOn = function(vehicle)
            return IsVehicleSirenOn(vehicle)
        end,

        ---@param vehicle integer
        ---@return boolean | nil
        areSceneLightsOn = function(vehicle)
            local extras = {11}
            local isOn = false

            for _, extra in pairs(extras) do
                if DoesExtraExist(vehicle, extra) then
                    if IsVehicleExtraTurnedOn(vehicle, extra) then isOn = true break end
                end
            end

           return isOn
        end,

        ---@param vehicle integer
        ---@return boolean | nil
        isAdvisorLightOn = function(vehicle)
            local extras = {12}
            local isOn = false

            for _, extra in pairs(extras) do
                if DoesExtraExist(vehicle, extra) then
                    if IsVehicleExtraTurnedOn(vehicle, extra) then isOn = true break end
                end
            end

           return isOn
        end
    }
}

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------