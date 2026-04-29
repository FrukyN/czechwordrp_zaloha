local spawnedProps = {}

-- Funkce pro vytvoření propu
local function spawnTrayProp(data)
    local model = GetHashKey(data.prop)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local obj = CreateObject(model, data.coords.x, data.coords.y, data.coords.z - 1.0, false, false, false)
    SetEntityHeading(obj, data.rotation)
    FreezeEntityPosition(obj, true) -- Aby tác nespadl nebo neodletěl
    SetEntityInvincible(obj, true)
    PlaceObjectOnGroundProperly(obj) -- Zarovná tác na povrch baru
    
    return obj
end

CreateThread(function()
    for _, tray in pairs(Config.Trays) do
        -- Spawnování propu
        local trayObj = spawnTrayProp(tray)
        table.insert(spawnedProps, trayObj)

        -- Target na ten konkrétní prop
        exports.ox_target:addLocalEntity(trayObj, {
            {
                name = 'open_tray_' .. tray.id,
                icon = tray.icon,
                label = tray.label,
                groups = tray.groups,
                distance = tray.distance,
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', tray.id)
                end
            }
        })
    end
end)

-- Smazání propů při vypnutí scriptu (restartu)
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, obj in ipairs(spawnedProps) do
        DeleteObject(obj)
    end
end)