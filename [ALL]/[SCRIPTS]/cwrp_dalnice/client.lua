local ResourceName = GetCurrentResourceName()

CreateThread(function()
    exports.ox_inventory:displayMetadata('spz', 'SPZ')
    exports.ox_inventory:displayMetadata('zakoupeno', 'Zakoupeno')
    exports.ox_inventory:displayMetadata('vyprsi', 'Vyprsi')
    exports.ox_inventory:displayMetadata('typ', 'Typ')
end)

local function notify(type, title, description)
    lib.notify({
        title = title,
        description = description,
        type = type
    })
end

local function openPlateMenu(pointId, vignetteType, vignetteData)
    local vehicles = lib.callback.await('cwrp_dalnice:server:getOwnedVehiclePlates', false)

    if not vehicles or #vehicles == 0 then
        notify('error', 'Dalnicni znamka', 'Nevlastnis zadne vozidlo se SPZ.')
        return
    end

    local options = {}

    for i = 1, #vehicles do
        local plate = vehicles[i]
        options[#options + 1] = {
            title = ('SPZ: %s'):format(plate),
            description = ('Zakoupit %s za $%s'):format(vignetteData.label, vignetteData.price),
            icon = 'car',
            onSelect = function()
                TriggerServerEvent('cwrp_dalnice:server:buyVignette', pointId, vignetteType, plate)
            end
        }
    end

    lib.registerContext({
        id = ('%s_plate_menu_%s_%s'):format(ResourceName, pointId, vignetteType),
        title = 'Vyber SPZ pro znamku',
        options = options
    })

    lib.showContext(('%s_plate_menu_%s_%s'):format(ResourceName, pointId, vignetteType))
end

local function openBuyMenu(pointId)
    local options = {}

    for vignetteType, data in pairs(Config.Vignettes) do
        options[#options + 1] = {
            title = data.label,
            description = ('%s | Cena: $%s'):format(data.description, data.price),
            icon = 'receipt',
            onSelect = function()
                openPlateMenu(pointId, vignetteType, data)
            end
        }
    end

    lib.registerContext({
        id = ('%s_buy_menu_%s'):format(ResourceName, pointId),
        title = 'Nakup dalnicni znamky',
        options = options
    })

    lib.showContext(('%s_buy_menu_%s'):format(ResourceName, pointId))
end

CreateThread(function()
    for i = 1, #Config.BuyPoints do
        local point = Config.BuyPoints[i]

        exports.ox_target:addSphereZone({
            coords = point.coords,
            radius = point.radius,
            debug = Config.Debug,
            options = {
                {
                    name = ('%s_target_%s'):format(ResourceName, point.id),
                    icon = point.icon,
                    label = point.label,
                    onSelect = function()
                        openBuyMenu(point.id)
                    end
                }
            }
        })
    end
end)

RegisterNetEvent('cwrp_dalnice:client:notify', function(type, text)
    notify(type, 'Dálniční známka', text)
end)
