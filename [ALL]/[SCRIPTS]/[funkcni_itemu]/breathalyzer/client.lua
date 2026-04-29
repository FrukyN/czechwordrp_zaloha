local display = false

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })

    -- Smyčka běží pouze ve chvíli, kdy je UI aktivní
    if bool then
        Citizen.CreateThread(function()
            while display do
                Citizen.Wait(0)
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 142, true) -- MeleeAttackAlternate
                DisableControlAction(0, 18, true) -- Enter
                DisableControlAction(0, 322, true) -- ESC
                DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            end
        end)
    end
end

-- notifikace ox_lib (přesunuto nahoru pro lepší strukturu)
function Notify(text, notifType)
    lib.notify({
        title = 'Alkoholtester',
        description = text,
        type = notifType or 'inform'
    })
end

RegisterNUICallback("exit", function(data, cb)
    SetDisplay(false)
    SendNUIMessage({
        type = "data",
        bac = '0.00',
        textColor = '--color-black'
    })
    cb('ok')
end)

RegisterNUICallback("startBac", function(data, cb)
    -- Využití ox_lib pro maximální optimalizaci hledání hráče
    local playerCoords = GetEntityCoords(cache.ped)
    local closestPlayer, closestDistance = lib.getClosestPlayer(playerCoords, 2.0, false)

    if not closestPlayer then 
        Notify("Nebyl nalezen žádný hráč v dosahu.", "error") 
        cb('ok')
        return 
    end

    local targetServerId = GetPlayerServerId(closestPlayer)
    TriggerServerEvent('breathalyzer.server:doBacTest', targetServerId)
    Notify("Žádost o dechovou zkoušku byla odeslána hráči: " .. GetPlayerName(closestPlayer), "inform")
    cb('ok')
end)

-- otevření přes ox_inventory item
exports('useBreathalyzer', function(data, slot)
    SetDisplay(true)
end)

RegisterNetEvent('breathalyzer.client:requestBac', function(leo, target)
    local officerName = GetPlayerName(GetPlayerFromServerId(leo))

    -- Alert dialog
    local alert = lib.alertDialog({
        header = 'Dechová zkouška',
        content = officerName .. " si přeje provést dechovou zkoušku.",
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Přijmout',
            cancel = 'Odmítnout'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('breathalyzer.server:acceptedBac', leo, target)

        -- Input dialog
        local input = lib.inputDialog('Výsledek zkoušky', {
            { type = 'number', label = 'Zadej hodnotu alkoholu v krvi (‰)', required = true }
        })

        if input and input[1] then
            local bac = tonumber(input[1])
            TriggerServerEvent('breathalyzer.server:returnBac', bac, leo)
        end
    else
        TriggerServerEvent('breathalyzer.server:refusedBac', leo, target)
    end
end)

-- zobrazení výsledku
RegisterNetEvent('breathalyzer.client:displayBac', function(bac, color)
    SendNUIMessage({
        type = "data",
        bac = bac,
        textColor = color
    })
end)

-- odmítnutí
RegisterNetEvent('breathalyzer.client:bacRefused', function(target)
    SetDisplay(false)
    SendNUIMessage({
        type = "data",
        bac = '0.00',
        textColor = '--color-black'
    })
    Notify(GetPlayerName(GetPlayerFromServerId(target)) .. " odmítl dechovou zkoušku!", "error")
end)

-- potvrzení
RegisterNetEvent('breathalyzer.client:acceptedBac', function(target)
    Notify("Probíhá měření hladiny alkoholu hráče " .. GetPlayerName(GetPlayerFromServerId(target)) .. "...", "inform")
end)