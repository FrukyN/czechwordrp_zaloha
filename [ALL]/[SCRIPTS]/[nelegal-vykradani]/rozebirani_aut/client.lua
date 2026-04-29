local currentPhase = 0
local targetVehicle = nil
local phaseBlip = nil
local isAlarmActive = false

-- Tabulka 5 náhodných míst pro spawn auta
local spawnPoints = {
    [1] = vec4(116.1332, 99.6878, 80.9238, 71.7256),
    [2] = vec4(-964.8425, -1091.4431, 2.1499, 119.4585),
    [3] = vec4(823.7108, -2138.6790, 29.1638, 2.7896),
    [4] = vec4(1175.0266, -1555.6593, 39.4009, 337.6191),
    [5] = vec4(1107.3818, 253.2767, 80.8560, 58.3986)
}

-- Pomocná funkce pro vyvolání poplachu při selhání
local function triggerVehicleAlarm(veh)
    if isAlarmActive or not DoesEntityExist(veh) then return end
    isAlarmActive = true
    
    lib.notify({title = 'Poplach!', description = 'Spustil jsi alarm! Policie dostane echo za minutu.', type = 'error'})
    
    -- Fyzické efekty auta
    SetVehicleAlarm(veh, true)
    StartVehicleAlarm(veh)
    SetVehicleLights(veh, 2)
    
    -- Opožděné volání policie (60 sekund)
    SetTimeout(60000, function()
        if DoesEntityExist(veh) and currentPhase > 0 and currentPhase < 4 then
            alertPolice('Nahlášený poplach', 'Svědek nahlásil podezřelý hluk u vozidla Sultan.')
        end
        isAlarmActive = false
    end)
end

-- Pomocná funkce pro restart GPS navigace
local function updateMissionGPS(coords, label)
    if phaseBlip then 
        RemoveBlip(phaseBlip) 
    end
    
    phaseBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(phaseBlip, 326)
    SetBlipColour(phaseBlip, 5)
    SetBlipScale(phaseBlip, 0.9)
    SetBlipRoute(phaseBlip, true)
    SetBlipRouteColour(phaseBlip, 5)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(phaseBlip)
end

-- Funkce pro oznámení policii přes CD_DISPATCH
function alertPolice(title, msg)
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'},
        coords = GetEntityCoords(PlayerPedId()),
        title = '10-37 - '..title,
        message = msg,
        flash = 0, unique_id = tostring(math.random(1, 999999)),
        blip = { sprite = 326, colour = 1, scale = 1.2, text = 'Krádež vozidla', time = 5, radius = 60 }
    })
end

-- Kontrola vzdálenosti auta od bodu
local function isVehicleAtCoords(coords)
    if not targetVehicle or not DoesEntityExist(targetVehicle) then return false end
    local vehCoords = GetEntityCoords(targetVehicle)
    local dist = #(vehCoords - vec3(coords.x, coords.y, coords.z))
    return dist < 15.0 
end

-- START: Poštovní schránka
exports.ox_target:addModel(`prop_letterbox_01`, {
    {
        label = 'Prohledat schránku',
        icon = 'fas fa-envelope',
        onSelect = function()
            local hasLockpick = exports.ox_inventory:Search('count', 'lockpick')
            if hasLockpick > 0 then
                lib.callback('chopshop:server:checkCooldown', false, function(cooldown)
                    
                    -- KONTROLA POLICIE (podle tvého vzoru)
                    if cooldown == "no_police" then
                        lib.notify({
                            title = 'Chyba',
                            description = 'V oblasti není dostatek policejních hlídek!',
                            type = 'error'
                        })
                        return -- Důležité: Tady se kód zastaví
                    end

                    -- KONTROLA COOLDOWNU
                    if type(cooldown) == "number" and cooldown > 0 then
                        lib.notify({
                            title = 'Schránka', 
                            description = 'Schránka je prázdná. Další dopis dorazí za '..cooldown..' minut.', 
                            type = 'error'
                        })
                        return 
                    end

                    -- POKUD JE VŠE OK (cooldown je 0)
                    if cooldown == 0 then
                        lib.notify({
                            title = 'Schránka', 
                            description = 'Našel jsi dopis! Další se zde objeví za hodinu.', 
                            type = 'inform'
                        })
                        
                        Wait(2000)

                        lib.alertDialog({
                            header = 'Zmačkaný vzkaz',
                            content = 'Zdar,\n\nV GPS máš souřadnice jedný pěkný káry. Majitel je mimo město, tak jí vyzvedni.\n\nRozebírej to opatrně na těch místech, co jsem ti poslal. Jestli spustíš alarm, máš minutu než tam vlítnou fízlové.\n\nKlíče od toho nemám, tak doufám, že máš lockpick.',
                            centered = true,
                            cancel = false
                        })
                        
                        TriggerServerEvent('chopshop:server:startJob')
                    end
                end)
            else
                lib.notify({title = 'Schránka', description = 'Bez lockpicku to neotevřeš.', type = 'error'})
            end
        end
    }
})

-- FÁZE 0: Spawn a interakce
RegisterNetEvent('chopshop:client:spawnVehicle', function()
    currentPhase = 0
    local spawnCoords = spawnPoints[math.random(1, #spawnPoints)]
    
    lib.requestModel(`sultan`)
    targetVehicle = CreateVehicle(`sultan`, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    SetEntityAsMissionEntity(targetVehicle, true, true)
    SetVehicleDoorsLocked(targetVehicle, 2) 

    updateMissionGPS(vec3(spawnCoords.x, spawnCoords.y, spawnCoords.z), "Vozidlo k odcizení")
    lib.notify({title = 'Anonym', description = 'Vyzvedni auto na GPS a začni rozebírat!', type = 'inform'})

    exports.ox_target:addLocalEntity(targetVehicle, {
        {
            name = 'phase0_lockpick',
            label = 'Vypáčit zámek',
            icon = 'fas fa-unlock',
            items = 'lockpick',
            canInteract = function() return currentPhase == 0 end,
            onSelect = function()
                local success = lib.skillCheck({'easy', 'easy'}, {'w', 'a', 's', 'd'})
                if success then
                    currentPhase = 1
                    SetVehicleDoorsLocked(targetVehicle, 1)
                    updateMissionGPS(vec3(-511.0, -1634.0, 18.0), "Rozebírání: Lokace 1")
                    lib.notify({title = 'Úspěch', description = 'Zámek povolil. Jeď na Lokaci 1.', type = 'success'})
                else
                    lib.notify({title = 'Sakra!', description = 'Lockpick se zlomil a zámek se zasekl!', type = 'error'})
                    alertPolice('Pokus o vloupání', 'Svědek nahlásil podezřelou osobu u vozidla Sultan.')
                end
            end
        },
        {
            name = 'phase1',
            label = 'Rozebrat exteriér (1. Lokace)',
            icon = 'fas fa-wrench',
            canInteract = function() return currentPhase == 1 and isVehicleAtCoords(vec3(-511.0, -1634.0, 18.0)) end,
            onSelect = function()
                exports['boii_minigames']:button_mash({
                    style = 'default',
                    difficulty = 5 
                }, function(success)
                    if success then
                        currentPhase = 2
                        
                        -- Vizuální poškození Fáze 1
                        SetVehicleDoorBroken(targetVehicle, 0, false) -- Dveře řidiče
                        SetVehicleDoorBroken(targetVehicle, 1, false) -- Dveře spolujezdce
                        SetVehicleDoorBroken(targetVehicle, 4, false) -- Kapota
                        SmashVehicleWindow(targetVehicle, 0)
                        
                        TriggerServerEvent('chopshop:server:givePhaseItems', 1)
                        updateMissionGPS(vec3(1264.1279, -2563.6819, 42.7346), "Rozebírání: Lokace 2")
                        lib.notify({title = 'Hotovo', description = 'Karoserie je dole. Jeď na bod 2.', type = 'success'})
                    else
                        triggerVehicleAlarm(targetVehicle)
                    end
                end)
            end
        },
        {
            name = 'phase2',
            label = 'Vypustit kapaliny (2. Lokace)',
            icon = 'fas fa-oil-can',
            canInteract = function() return currentPhase == 2 and isVehicleAtCoords(vec3(1264.1279, -2563.6819, 42.7346)) end,
            onSelect = function()
                exports['boii_minigames']:key_drop({
                    style = 'default',
                    score_limit = 5,
                    miss_limit = 5,
                    fall_delay = 1300,
                    new_letter_delay = 1500
                }, function(success)
                    if success then
                        currentPhase = 3
                        
                        -- Vizuální poškození Fáze 2
                        SetVehicleDoorBroken(targetVehicle, 5, false) -- Kufr
                        SetVehicleEngineHealth(targetVehicle, 400.0) -- Motor kouří, ale jede
                        SmashVehicleWindow(targetVehicle, 1)
                        SmashVehicleWindow(targetVehicle, 2)

                        TriggerServerEvent('chopshop:server:givePhaseItems', 2)
                        updateMissionGPS(vec3(-1171.5990, -2060.9329, 14.3007), "Rozebírání: Lokace 3")
                        lib.notify({title = 'Hotovo', description = 'Kapaliny vypuštěny. Jeď na bod 3.', type = 'success'})
                    else
                        triggerVehicleAlarm(targetVehicle)
                    end
                end)
            end
        },
        {
            name = 'phase3',
            label = 'Odpojit elektroniku (3. Lokace)',
            icon = 'fas fa-bolt',
            canInteract = function() return currentPhase == 3 and isVehicleAtCoords(vec3(-1171.5990, -2060.9329, 14.3007)) end,
            onSelect = function()
                exports['boii_minigames']:chip_hack({
                    style = 'default',
                    loading_time = 5000,
                    chips = 2,
                    timer = 40000 
                }, function(success)
                    if success then
                        currentPhase = 4
                        TriggerServerEvent('chopshop:server:givePhaseItems', 3)
                        
                        -- OPRAVA A POSÍLENÍ MAZÁNÍ
                        if DoesEntityExist(targetVehicle) then
                            NetworkRequestControlOfEntity(targetVehicle)
                            local timeout = 2000
                            while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do
                                Wait(10)
                                timeout = timeout - 10
                            end
                            
                            SetEntityAsMissionEntity(targetVehicle, true, true)
                            DeleteVehicle(targetVehicle)
                            DeleteEntity(targetVehicle)
                        end
                        
                        targetVehicle = nil 
                        RemoveBlip(phaseBlip)
                        spawnDealer()
                        lib.notify({title = 'Hotovo', description = 'Auto je na kousky. Jeď prodat díly!', type = 'success'})
                    else
                        triggerVehicleAlarm(targetVehicle)
                    end
                end)
            end
        }
    })
end)

-- DEALER NPC
function spawnDealer()
    local dCoords = vec4(114.1713, -1961.0883, 21.3342, 32.6756) 
    updateMissionGPS(vec3(dCoords.x, dCoords.y, dCoords.z), "Dealer: Prodej dílů")
    
    lib.requestModel(`a_m_m_soucent_02`)
    local dealerPed = CreatePed(4, `a_m_m_soucent_02`, dCoords.x, dCoords.y, dCoords.z - 1.0, dCoords.w, false, true)
    FreezeEntityPosition(dealerPed, true)
    SetEntityInvincible(dealerPed, true)
    SetBlockingOfNonTemporaryEvents(dealerPed, true)

    exports.ox_target:addLocalEntity(dealerPed, {
        {
            label = 'Prodat díly',
            icon = 'fas fa-hand-holding-dollar',
            onSelect = function()
                TriggerServerEvent('chopshop:server:sellAll')
                currentPhase = 0
                if phaseBlip then RemoveBlip(phaseBlip) end
                DeletePed(dealerPed)
            end
        }
    })
end