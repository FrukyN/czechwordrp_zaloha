local ESX = exports['es_extended']:getSharedObject()
local isTied = false

-- Funkce pro načtení animace
local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

-- Event na použití pásky (iniciátor)
RegisterNetEvent('pasky:useZiptie')
AddEventHandler('pasky:useZiptie', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        -- ox_lib progressbar pro akci
        if lib.progressBar({
            duration = Config.TieDuration,
            label = 'Svazování...',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true, move = true, combat = true },
            anim = { dict = 'mp_arresting', clip = 'a_uncuff' }
        }) then
            TriggerServerEvent('pasky:tieTarget', GetPlayerServerId(closestPlayer))
        else
            lib.notify({title = 'Zrušeno', description = 'Svazování bylo přerušeno.', type = 'error'})
        end
    else
        lib.notify({title = 'Chyba', description = 'Nikdo není poblíž.', type = 'error'})
    end
end)

-- Event na použití nůžek
RegisterNetEvent('pasky:useCutter')
AddEventHandler('pasky:useCutter', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        if lib.progressBar({
            duration = Config.UntieDuration,
            label = 'Rozvazování...',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true, move = true, combat = true },
            anim = { dict = 'mp_arresting', clip = 'a_uncuff' }
        }) then
            TriggerServerEvent('pasky:untieTarget', GetPlayerServerId(closestPlayer))
        end
    else
        lib.notify({title = 'Chyba', description = 'Nikdo není poblíž.', type = 'error'})
    end
end)

-- Event aplikovaný na oběť
RegisterNetEvent('pasky:toggleTied')
AddEventHandler('pasky:toggleTied', function(state)
    local playerPed = PlayerPedId()
    
    -- Pokud server poslal konkrétní state (např. rozvázání), použijeme ho, jinak to přepneme
    if state ~= nil then
        isTied = state
    else
        isTied = not isTied
    end

    if isTied then
        loadAnimDict('mp_arresting')
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        SetPedCanPlayGestureAnims(playerPed, false)
        lib.notify({title = 'Byl jsi svázán', type = 'warning'})
    else
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        lib.notify({title = 'Byl jsi rozvázán', type = 'info'})
    end
end)

-- Smyčka pro blokování tlačítek, když je hráč svázaný
CreateThread(function()
    while true do
        Wait(0)
        if isTied then
            DisableControlAction(0, 24, true) -- Útok
            DisableControlAction(0, 257, true) -- Útok 2
            DisableControlAction(0, 25, true) -- Míření
            DisableControlAction(0, 263, true) -- Melee
            DisableControlAction(0, 45, true) -- Přebíjení
            DisableControlAction(0, 22, true) -- Skok
            DisableControlAction(0, 44, true) -- Kryt
            DisableControlAction(0, 37, true) -- Výběr zbraně
            DisableControlAction(0, 23, true) -- Nastoupení do auta (F)
            DisableControlAction(0, 288, true) -- F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6

            -- Udržení animace (občas se může přerušit)
            if not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) then
                loadAnimDict('mp_arresting')
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        else
            Wait(500) -- Pokud není svázán, šetříme výkon
        end
    end
end)