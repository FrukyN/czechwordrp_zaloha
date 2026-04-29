local isHacking = false
local npcPracovnik = nil
local rozvadecHacknut = false -- NOVÁ PROMĚNNÁ

-- Funkce pro bezpečné získání počtu itemů (oprava chyby s tabulkou)
local function getInventoryCount(itemName)
    local count = exports.ox_inventory:Search('count', itemName)
    if type(count) == 'table' then
        local total = 0
        for _, v in pairs(count) do total = total + v end
        return total
    end
    return count or 0
end

-- Vytvoření NPC Pracovníka
CreateThread(function()
    local model = `s_m_y_construct_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    if npcPracovnik then DeleteEntity(npcPracovnik) end
    npcPracovnik = CreatePed(4, model, 660.9419, 1283.8616, 359.2958, 90.1933, false, true)
    
    SetEntityInvincible(npcPracovnik, true)
    FreezeEntityPosition(npcPracovnik, true)
    SetBlockingOfNonTemporaryEvents(npcPracovnik, true)

    exports.ox_target:addLocalEntity(npcPracovnik, {
        {
            name = 'okrast_pracovnika',
            label = 'Okrást pracovníka',
            icon = 'fa-solid fa-hand-holding-dollar',
            canInteract = function()
                -- Tato možnost se ukáže JEN když není NPC mrtvé
                return not GlobalState.BlackoutNpcDead
            end,
            onSelect = function()
                -- 1. OKAMŽITÝ DOTAZ NA SERVER
                lib.callback('blackout:server:getPoliceCount', false, function(enoughPolice)
                    -- Pokud server řekne NE, okamžitě skončíme dřív, než cokoli začne
                    if not enoughPolice then
                        lib.notify({ 
                            title = 'Chyba', 
                            description = 'V oblasti není dostatek policejních hlídek!', 
                            type = 'error' 
                        })
                        return -- ZASTAVUJE VŠE
                    end

                    -- 2. KONTROLA BASEBALLKY (jen když policie prošla)
                    if getInventoryCount('WEAPON_BAT') > 0 then
                        -- AŽ TADY SPOUŠTÍME ROBBERY (ANIMACI)
                        startRobbery(npcPracovnik)
                    else
                        lib.notify({title = 'Chyba', description = 'Potřebuješ baseballku!', type = 'error'})
                    end
                end)
            end
        }
    })
end)

-- Funkce pro okradení NPC (UPRAVENO: Posílá info na server pro synchro)
function startRobbery(entity)
    lib.progressBar({
        duration = 5000,
        label = 'Omračuješ pracovníka...',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true },
        anim = { dict = 'melee@hatchet@streamed_core', clip = 'settle_low' }
    })

    -- Pošleme trigger na server, který nastaví GlobalState a zabije peda všem
    TriggerServerEvent('blackout:server:npcKilled')
end

-- NOVÝ EVENT: Synchro smrti pro všechny v okolí
RegisterNetEvent('blackout:client:syncNpcDeath')
AddEventHandler('blackout:client:syncNpcDeath', function()
    if npcPracovnik and DoesEntityExist(npcPracovnik) then
        SetEntityInvincible(npcPracovnik, false)
        FreezeEntityPosition(npcPracovnik, false)
        SetBlockingOfNonTemporaryEvents(npcPracovnik, false)
        SetEntityHealth(npcPracovnik, 0) -- NPC lehne u všech
    end
end)

-- Vstupní zámek do objektu (Dveře ID 553)
exports.ox_target:addBoxZone({
    coords = vec3(735.6889, 131.6678, 80.7170),
    size = vec3(1, 1, 2),
    rotation = 57.0,
    options = {
        {
            label = 'Vloupat se do objektu',
            icon = 'fa-solid fa-unlock',
            onSelect = function()
                -- KONTROLA POLICIE PŘES CALLBACK
                lib.callback('blackout:server:getPoliceCount', false, function(enoughPolice)
                    if enoughPolice then
                        -- SPUŠTĚNÍ PINCODE MINIHRY
                        exports['boii_minigames']:pincode({
                            style = 'default',
                            difficulty = 1, -- Počet čísel v PINu
                            guesses = 8     -- Počet pokusů
                        }, function(success)
                            if success then
                                -- ZMĚNA: Volání serverového eventu pro odemčení (0 = odemčeno)
                                TriggerServerEvent('blackout:server:doorSyncSilent', 553, 0)
                                
                                lib.notify({
                                    title = 'Úspěch', 
                                    description = 'Zámek cvakl, dveře jsou otevřené! Máš minutu, než se spustí tichý alarm!', 
                                    type = 'success'
                                })

                                -- NOVÉ: Opožděný Dispatch (60 sekund)
                                SetTimeout(60000, function()
                                    local dispatchData = exports['cd_dispatch']:GetPlayerInfo()
                                    TriggerServerEvent('cd_dispatch:AddNotification', {
                                        job_table = {'police'},
                                        coords = vec3(735.6889, 131.6678, 80.7170),
                                        title = 'NARUŠENÍ OBJEKTU',
                                        message = 'Byl zaznamenán neoprávněný vstup do zabezpečeného objektu! (Tichý alarm se zpožděním)', 
                                        flash = 0,
                                        unique_id = dispatchData.unique_id,
                                        sound = 1,
                                        blip = {
                                            sprite = 161, 
                                            scale = 1.2, 
                                            colour = 1,
                                            flashes = true, 
                                            text = 'VLAMÁNÍ DO OBJEKTU', 
                                            time = 5,
                                            radius = 0,
                                        }
                                    })
                                end)
                                
                                -- Spuštění alarmu na serveru (pokud máš zvukový alarm)
                                TriggerServerEvent('blackout:server:startAlarmTimer')
                            else
                                -- SELHÁNÍ
                                lib.notify({
                                    title = 'Chyba', 
                                    description = 'Nepodařilo se ti dešifrovat PIN kód!', 
                                    type = 'error'
                                })
                            end
                        end)
                    else
                        -- Pokud není dost policie
                        lib.notify({ 
                            title = 'Chyba', 
                            description = 'V oblasti není dostatek policejních hlídek!', 
                            type = 'error' 
                        })
                    end
                end)
            end
        }
    }
})

-- Hackování elektrické krabice (S RIZIKEM SMRTI A DISPATCHEM)
exports.ox_target:addBoxZone({
    coords = vec3(664.3893, 130.2636, 80.9502),
    size = vec3(1, 1, 1),
    rotation = 336.0,
    options = {
        {
            label = 'Hackovat rozvaděč',
            icon = 'fa-solid fa-microchip',
            onSelect = function()
                if getInventoryCount('access_card') > 0 then
                    -- SPUŠTĚNÍ BOII CHIP HACK MINIHRY
                    exports['boii_minigames']:chip_hack({
                        style = 'default',
                        loading_time = 8000,
                        chips = 2, -- Počet čipů, které musí hráč najít
                        timer = 30000 -- Čas na hru
                    }, function(success)
                        if success then
                            rozvadecHacknut = true -- Tímto odemkneme hlavní vypínač
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'spark', 0.5)
                            lib.notify({title = 'Hacknuto', description = 'Nyní běž k hlavnímu vypínači!', type = 'success'})
                        else
                            -- SELHÁNÍ: Masivní požár, Smrt a Dispatch
                            local ped = PlayerPedId()
                            local boxCoords = vec3(663.9275, 132.2677, 84.2285) 
                            
                            -- Zvuk a vizuální efekty jisker pro bezprostřední okolí
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 15.0, 'spark', 1.0)
                            TriggerServerEvent('blackout:server:failEffects', boxCoords) 
                            
                            -- SPUŠTĚNÍ MASIVNÍHO Z_FIRE (Zvýšený počet plamenů vytvoří hustý kouř)
                            TriggerServerEvent('z_fire:Server:StartFire', boxCoords, 15, 10)

                            -- Hráč dostane ránu a zemře tam, kde stojí
                            SetEntityHealth(ped, 0) 

                            -- CD_DISPATCH
                            local data = exports['cd_dispatch']:GetPlayerInfo()
                            TriggerServerEvent('cd_dispatch:AddNotification', {
                                job_table = {'police', 'ambulance', 'fireman'},
                                coords = boxCoords,
                                title = 'VÝBUCH',
                                message = 'Hlášen výbuch a rozsáhlý požár rozvodné skříně! Hustý černý kouř na místě!', 
                                flash = 0,
                                unique_id = data.unique_id,
                                sound = 1,
                                blip = {
                                    sprite = 436, 
                                    scale = 1.4, 
                                    colour = 1,
                                    flashes = false, 
                                    text = 'POŽÁR ROZVADĚČE', 
                                    time = 5,
                                    radius = 0,
                                }
                            })
                            
                            lib.notify({title = 'Kritické selhání', description = 'Rozvaděč vybuchl a začal silně hořet!', type = 'error'})
                        end
                    end)
                else
                    lib.notify({title = 'Chyba', description = 'Nemáš přístupovou kartu!', type = 'error'})
                end
            end
        }
    }
})

-- Finální vypnutí elektřiny (S KONTROLOU HACKU)
exports.ox_target:addBoxZone({
    coords = vec3(651.8914, 101.2216, 80.7377),
    size = vec3(1, 1, 1),
    rotation = 181.0,
    options = {
        {
            label = 'Vypnout elektřinu',
            icon = 'fa-solid fa-power-off',
            onSelect = function()
                -- KONTROLA: Pokud ještě nehacknul skříňku, nepustíme ho dál
                if not rozvadecHacknut then
                    lib.notify({
                        title = 'Systém uzamčen', 
                        description = 'Musíš nejdříve hacknout hlavní rozvaděč!', 
                        type = 'error'
                    })
                    return
                end

                if getInventoryCount('access_card') > 0 then
                    local hour = GetClockHours()
                    TriggerServerEvent('blackout:server:attemptBlackout', hour)
                    -- Po vypnutí můžeme resetovat stav pro příště
                    rozvadecHacknut = false 
                else
                    lib.notify({title = 'Chyba', description = 'Nemáš přístupovou kartu!', type = 'error'})
                end
            end
        }
    }
})

-- Registrace stavu světel + OPRAVENÉ ZVUKY PŘES SERVER
RegisterNetEvent('blackout:client:setLightState')
AddEventHandler('blackout:client:setLightState', function(state)
    SetArtificialLightsState(state)
    SetArtificialLightsStateAffectsVehicles(false)
    
    if state then
        -- Blackout začíná
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 99999.0, 'blackout_off', 0.8)
        lib.notify({title = 'VÝPADEK', description = 'Městská síť byla odpojena!', type = 'error'})
    else
        -- Blackout končí
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 99999.0, 'blackout_on', 0.8)
        lib.notify({title = 'OBNOVENO', description = 'Elektřina byla nahozena.', type = 'success'})
        
        -- ZAMKNUTÍ DVEŘÍ PŘI NAHOZENÍ PROUDU (Tické přes serverový event, 1 = zamčeno)
        TriggerServerEvent('blackout:server:doorSyncSilent', 553, 1)
        rozvadecHacknut = false
    end
end)

-- Event pro vizuální efekty ohně a jisker
RegisterNetEvent('blackout:client:createFire')
AddEventHandler('blackout:client:createFire', function(coords)
    StartScriptFire(coords.x, coords.y, coords.z - 1.0, 25, false)
    
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do Wait(10) end
    UseParticleFxAssetNextCall("core")
    StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_electrical", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
end)

-- Pojistka při startu scriptu (ZAMKNUTÍ DVEŘÍ)
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    -- Tiché zamknutí
    TriggerServerEvent('blackout:server:doorSyncSilent', 553, 1)
end)

-- Pojistka při vypnutí nebo restartu scriptu
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- 1. Okamžitě rozsvítit světla v celém městě
    SetArtificialLightsState(false)
    SetArtificialLightsStateAffectsVehicles(false)

    -- 2. Smazat NPC
    if npcPracovnik and DoesEntityExist(npcPracovnik) then
        DeleteEntity(npcPracovnik)
    end

    -- 3. Zamknout dveře
    TriggerServerEvent('blackout:server:doorSyncSilent', 553, 1)

    print("^2[Blackout]^7 Script zastaven, svetla byla obnovena, NPC smazano a dvere zamknuty.")
end)