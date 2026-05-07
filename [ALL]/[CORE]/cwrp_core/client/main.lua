ESX = exports["es_extended"]:getSharedObject()


-- vypnutí picoviny
Citizen.CreateThread(function()
    SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_01_STAGE', false)
    SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM', false)
    SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM', false)

end)

---------------------------------------------------------------------------------------------------------

CreateThread(function()
    exports.ox_inventory:displayMetadata('name', "Jméno")
    exports.ox_inventory:displayMetadata('dateofbirth', "Datum narození")
end)


lib.addRadialItem({
    id = 'obcan',
    label = 'Občanské údaje',
    icon = 'id-card',
    menu = 'obcan_main' 
})

lib.registerRadial({
    id = 'obcan_main',
    items = {
        {
            label = 'Jméno',
            icon = 'user',
            onSelect = function()
                TriggerServerEvent("radial:getPlayerInfo", "name")
            end
        },
        {
            label = 'Rok narození',
            icon = 'calendar',
            onSelect = function()
                TriggerServerEvent("radial:getPlayerInfo", "dob")
            end
        },
        {
            label = 'Zaměstnání',
            icon = 'briefcase',
            onSelect = function()
                TriggerServerEvent("radial:getPlayerInfo", "job")
            end
        }
    }
})

RegisterNetEvent("radial:returnPlayerInfo", function(infoType, value)
    if infoType == "name" then
        lib.notify({title = "Občan", description = "Jméno: " .. value, type = "info"})
    elseif infoType == "dob" then
        lib.notify({title = "Občan", description = "Rok narození: " .. value, type = "info"})
    elseif infoType == "job" then
        lib.notify({title = "Občan", description = "Zaměstnání: " .. value, type = "info"})
    end
end)

----------------------------------------------------------------------------------------------------------------

lib.addRadialItem({
    id = 'nastaveni',
    label = 'Nastavení',
    icon = 'gear',
    menu = 'nastaveni_main' 
})

lib.registerRadial({
    id = 'nastaveni_main',
    items = {
        {
            label = 'Ukázat/skrýt hud',
            icon = 'user',
            onSelect = function()
                ExecuteCommand('togglehud')
            end

        },
        {
            label = 'Nastavení pozice notifikací',
            icon = 'gear',
            onSelect = function()
                ExecuteCommand('ox_lib')
            end

        },
        {
            label = 'Změnit práci',
            icon = 'gear',
            onSelect = function()
                ExecuteCommand('changejob')
            end

        },
    }
})

