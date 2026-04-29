function OpenRestaurantMenu(job)
    local data = Config.Menu[job]
    
    if data then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            label = data.label,
            food = data.food,
            drinks = data.drinks
        })
    end
end

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Target pro otevření
CreateThread(function()
    for _, v in ipairs(Config.Locations) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = vec3(0.6, 0.6, 1.2),
            rotation = 0,
            options = {
                {
                    label = 'Otevřít jídelní lístek',
                    icon = 'fas fa-book-open',
                    onSelect = function() 
                        OpenRestaurantMenu(v.job) 
                    end
                }
            }
        })
    end
end)