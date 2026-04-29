local alarmActive = true 
local doorId = 552 -- Sjednoceno na tvoje ID
local alarmCoords = vec3(1273.9009, -1720.9484, 57.5528)
local doorCoords = vec3(1274.4042, -1720.5970, 55.5562)

local function startScavenging(itemName, label)
    local completed = exports.ox_lib:progressBar({
        duration = 5000,
        label = 'Prohledáváš místo: ' .. label,
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, mouse = false },
        anim = {
            dict = 'amb@medic@standing@tendtodead@base',
            clip = 'base'
        }
    })

    if completed then
        local success = exports.ox_lib:skillCheck({'easy'}, {'w', 'a', 's', 'd'})
        if success then
            -- Pouze zavoláme server. Ten zkontroluje cooldown a buď dá itemy, nebo vynadá.
            TriggerServerEvent('my_crafting:giveItem', itemName)
        else
            -- Notifikaci při selhání minihry necháme v klientovi
            exports.ox_lib:notify({ title = 'Chyba', description = 'Při demontáži jsi to rozbil.', type = 'error' })
        end
    else
        exports.ox_lib:notify({ title = 'Zrušeno', description = 'Přestal jsi hledat.', type = 'inform' })
    end
end

-- Vytvoření zón (Targety)
CreateThread(function()
    Wait(1000)

    -- 1. PROCESOR
    exports.ox_target:addBoxZone({
        coords = vec3(2633.8210, 2931.4497, 44.7679),
        size = vec3(2.0, 2.0, 2.0),
        rotation = 0,
        debug = false,
        options = {
            {
                label = 'Hledat procesor',
                icon = 'fa-solid fa-microchip',
                onSelect = function() startScavenging('processor', 'Počítač') end
            }
        }
    })

    -- 2. TELEFON
    exports.ox_target:addBoxZone({
        coords = vec3(1276.2788, -1710.2450, 54.5682),
        size = vec3(1.0, 1.0, 1.0),
        rotation = 0,
        debug = false,
        options = {
            {
                label = 'Prohledat stůl',
                icon = 'fa-solid fa-mobile',
                onSelect = function() startScavenging('broken_phone', 'Stůl') end
            }
        }
    })

    -- 3. ANTÉNKA
    exports.ox_target:addBoxZone({
        coords = vec3(2399.9844, 3082.2832, 48.6749),
        size = vec3(2.0, 2.0, 2.0),
        rotation = 0,
        debug = false,
        options = {
            {
                label = 'Prohrabat nepořádek',
                icon = 'fa-solid fa-tower-broadcast',
                onSelect = function() startScavenging('antenna', 'skládka') end
            }
        }
    })

-- 4. CRAFTING STŮL
    exports.ox_target:addBoxZone({
        coords = vec3(1272.2263, -1711.1509, 54.5517),
        size = vec3(1.5, 1.5, 1.5),
        rotation = 0,
        debug = false,
        options = {
            {
                label = 'Sestavit Hacking Device',
                icon = 'fa-solid fa-screwdriver-wrench',
                onSelect = function()
                    local craftProgress = exports.ox_lib:progressBar({
                        duration = 8000,
                        label = 'Pájení a programování...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true }
                    })

                    if craftProgress then
                        local skill = exports.ox_lib:skillCheck({'medium', 'hard'}, {'w', 'a', 's', 'd'})
                        if skill then
                            TriggerServerEvent('my_crafting:assembleDevice')
                        else
                            -- PŘIDÁNO: Serverový event pro odebrání surovin při selhání
                            TriggerServerEvent('my_crafting:failedCrafting')
                            exports.ox_lib:notify({ title = 'Chyba', description = 'Zkratoval jsi to a zničil součástky!', type = 'error' })
                        end
                    end
                end
            }
        }
    })

-- 5. TARGET NA DVEŘE
    exports.ox_target:addBoxZone({
        coords = doorCoords,
        size = vec3(1.5, 1.5, 2.5),
        rotation = 0,
        debug = false,
        options = {
            {
                label = 'Zkusit otevřít',
                icon = 'fa-solid fa-door-closed',
                onSelect = function()
                    -- Pokud je ALARM AKTIVNÍ (true), napíšeme že je přístup odepřen
                    if alarmActive then 
                        exports.ox_lib:notify({
                            title = 'Systém zabezpečení',
                            description = 'PŘÍSTUP ODEPŘEN: Alarm je aktivní!',
                            type = 'error',
                            position = 'top',
                            icon = 'shield-halved'
                        })
                        PlaySoundFrontend(-1, "Place_Prop_Fail", "DLC_DZH_Stats_Sounds", 1)
                    else
                        -- Pokud NENÍ AKTIVNÍ (false), napíšeme že je vyřazen
                        exports.ox_lib:notify({
                            title = 'Systém offline',
                            description = 'Alarm je vyřazen, můžeš vstoupit.',
                            type = 'success'
                        })
                    end
                end
            }
        }
    })
end)

-- TARGET NA ALARM
exports.ox_target:addBoxZone({
    coords = alarmCoords,
    size = vec3(0.5, 0.5, 0.5),
    rotation = 0,
    debug = false,
    options = {
        {
            label = 'Zkratovat alarm',
            icon = 'fa-solid fa-bolt',
            onSelect = function()
                -- Tady začíná minihra, která nahradila původní skillCheck
                exports['boii_minigames']:wire_cut({
                    style = 'default',
                    timer = 60000 
                }, function(success)
                    if success then
                        -- Pokud se minihra povede, pokračuje tvůj původní progress bar
                        local progress = exports.ox_lib:progressBar({
                            duration = 10000,
                            label = 'Zkratování alarmu...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true },
                            anim = { dict = 'anim@amb@board_room@whiteboard@', clip = 'examine_01' }
                        })
                        
                        if progress then
                            TriggerServerEvent('my_crafting:hackAlarm', doorId)
                        end
                    else
                        -- Pokud minihru pokazí, spustí se tvá původní sekce pro selhání
                        -- 1. NOTIFIKACE
                        exports.ox_lib:notify({ 
                            title = 'POPLACH!', 
                            description = 'Dostal jsi ránu a spustil jsi domovní alarm!', 
                            type = 'error',
                            position = 'top'
                        })
                        
                        -- 2. ZVUK PŘES INTERACT_SOUND
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'alarm_domovni', 0.6)

                        -- 3. TEASER EFEKT
                        local ped = cache.ped
                        PlaySoundFrontend(-1, "HACK_FAILED", "DLC_HEIST_BIOLAB_2_SOUNDS", 1)
                        
                        ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.5)
                        SetTimecycleModifier("REDMIST")
                        
                        -- Ragdoll (Pád na zem na 4 sekundy)
                        SetPedToRagdoll(ped, 4000, 4000, 0, true, true, false)
                        
                        -- Sebere to 15% HP
                        ApplyDamageToPed(ped, 15, false)

                        -- Po 4 sekundách vrátíme obraz do normálu
                        SetTimeout(4000, function()
                            ClearTimecycleModifier()
                            StopGameplayCamShaking(true)
                        end)
                    end
                end) -- Konec minihry
            end
        }
    }
})

-- Synchronizace a Thready
RegisterNetEvent('my_crafting:updateAlarmState', function(state)
    alarmActive = state
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if alarmActive then
            local playerCoords = GetEntityCoords(cache.ped)
            local dist = #(playerCoords - doorCoords)
            if dist < 2.0 then
                sleep = 0
                exports.ox_lib:showTextUI('[Alarm Aktivní] - Přístup odepřen', {
                    position = "right-center",
                    icon = 'shield-halved',
                    style = { backgroundColor = '#990000', color = 'white' }
                })
                while #(GetEntityCoords(cache.ped) - doorCoords) < 2.0 and alarmActive do
                    Wait(500)
                end
                exports.ox_lib:hideTextUI()
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('my_crafting:alarmClient', function(coords)
    local playerCoords = GetEntityCoords(cache.ped)
    if #(playerCoords - coords) < 50.0 then
        local soundId = GetSoundId()
        PlaySoundFromCoord(soundId, "VEHICLES_HORNS_SIREN_1", coords.x, coords.y, coords.z, "DLC_WILLEAD_TRACKS_SOUNDS", 0, 0, 0)
        SetTimeout(15000, function()
            StopSound(soundId)
            ReleaseSoundId(soundId)
        end)
    end
end)