local isGasActive = false
local activeParticles = {}
local hasMaskOn = false 
local lootedVitrines = {} -- TATO ŘÁDKA TI CHYBĚLA

-- 1. Funkce pro kontrolu interiéru
local function isPlayerInsideVangelico()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    return (coords.x > -633.0 and coords.x < -614.0) and 
           (coords.y > -235.0 and coords.y < -224.0) and 
           (coords.z > 36.0 and coords.z < 40.0)
end

-- 2. Export pro masku
exports('gas_mask', function(data, slot)
    local playerPed = PlayerPedId()
    lib.requestAnimDict("mp_masks@on_foot")
    TaskPlayAnim(playerPed, "mp_masks@on_foot", "put_on_mask", 8.0, -8.0, 1000, 49, 0, false, false, false)
    Wait(1000)

    if not hasMaskOn then
        SetPedComponentVariation(playerPed, 1, 46, 0, 2)
        hasMaskOn = true
        lib.notify({description = 'Nasadil jsi si plynovou masku', type = 'inform'})
    else
        SetPedComponentVariation(playerPed, 1, 0, 0, 2)
        hasMaskOn = false
        lib.notify({description = 'Sundal jsi si plynovou masku', type = 'inform'})
    end
end)

-- 3. Funkce pro kouř
local function startSmokeEffect()
    local asset = "core"
    lib.requestNamedPtfxAsset(asset)
    local smokePoints = {
        vec3(-621.85, -230.71, 36.5),
        vec3(-622.5, -231.5, 36.5),
        vec3(-620.5, -229.5, 36.5),
    }
    activeParticles = {}
    for _, coords in ipairs(smokePoints) do
        UseParticleFxAssetNextCall(asset)
        local smoke = StartParticleFxLoopedAtCoord('exp_grd_grenade_smoke', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 3.5, false, false, false, false)
        table.insert(activeParticles, smoke)
    end
    isGasActive = true
end

-- 4. Smyčka poškození
CreateThread(function()
    local animDict = "missfam5_blackout" 
    local animName = "p_blackout_loop_f"
    local gasExposure = 0 

    while true do
        local sleep = 1000
        if isGasActive then
            local playerPed = PlayerPedId()
            local pCoords = GetEntityCoords(playerPed)

            if #(pCoords - vec3(-621.85, -230.71, 38.0)) < 20.0 and isPlayerInsideVangelico() then
                sleep = 2000 
                if not hasMaskOn then
                    gasExposure = gasExposure + 1
                    local health = GetEntityHealth(playerPed)
                    local damage = 5 * gasExposure 
                    if health > 0 then
                        SetEntityHealth(playerPed, health - damage)
                        ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.1 * gasExposure)
                    end
                    if not IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
                        lib.requestAnimDict(animDict)
                        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
                    end
                else
                    gasExposure = 0
                    if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then StopAnimTask(playerPed, animDict, animName, 1.0) end
                end
            else
                gasExposure = 0
                if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then StopAnimTask(playerPed, animDict, animName, 1.0) end
            end
        end
        Wait(sleep)
    end
end)

-- 5. Targety
CreateThread(function()
    while Config == nil or not Config.Vitrines do Wait(100) end

    -- Klimatizace
    exports.ox_target:addBoxZone({
        coords = vec3(-600.7173, -274.8217, 51.8733),
        size = vec3(2.5, 2.5, 2.5),
        rotation = 0,
        options = {
            {
                label = 'Vhodit dýmovnici do klimatizace',
                icon = 'fa-solid fa-smog',
                onSelect = function()
                    local count = exports.ox_inventory:Search('count', 'gas_canister')
                    if count > 0 then
                        local hasPolice = lib.callback.await('vangelico:checkPolice', false)
                        if hasPolice then
                            if lib.progressBar({
                                duration = 5000,
                                label = 'Instalace dýmovnice...',
                                useWhileDead = false,
                                canCancel = true,
                                anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechlianico' }
                            }) then
                                TriggerServerEvent('vangelico:startHeist')
                            end
                        else
                            lib.notify({description = 'Není dostatek policistů!', type = 'error'})
                        end
                    else
                        lib.notify({description = 'Potřebuješ dýmovnici!', type = 'error'})
                    end
                end
            }
        }
    })

    -- Vitríny
    for i, v in ipairs(Config.Vitrines) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = v.heading,
            options = {
                {
                    label = 'Vykrást vitrínu',
                    icon = 'fa-solid fa-gem',
                    onSelect = function()
                        local vitId = "v_vit_"..i
                        if lootedVitrines[vitId] then
                            lib.notify({description = 'Tato vitrína je už rozbitá!', type = 'error'})
                            return
                        end
                        if not isGasActive then
                            lib.notify({description = 'Alarm je aktivní!', type = 'error'})
                            return
                        end
                        if lib.skillCheck({'easy', 'medium'}, {'w', 'a', 's', 'd'}) then
                            if lib.progressBar({
                                duration = 6000,
                                label = 'Sbírání šperků...',
                                useWhileDead = false,
                                canCancel = true,
                                anim = { dict = 'missheist_jewel', clip = 'smash_case' }
                            }) then
                                lootedVitrines[vitId] = true
                                TriggerServerEvent('vangelico:lootVitrine', vitId)
                            end
                        end
                    end
                }
            }
        })
    end
end)

-- 6. Eventy ze serveru
RegisterNetEvent('vangelico:clientSmoke', function()
    lootedVitrines = {} -- Reset vybraných vitrín při startu
    startSmokeEffect()
    SetTimeout(Config.GasDuration, function()
        for _, particle in ipairs(activeParticles) do StopParticleFxLooped(particle, 500) end
        isGasActive = false
        activeParticles = {}
    end)
end)

-- Úprava stávajícího eventu (aby uměl pracovat se zbývajícím časem)
RegisterNetEvent('vangelico:clientSmoke', function(duration)
    if isGasActive then return end -- Pokud už kouř vidí, nebudeme ho spouštět znovu
    
    startSmokeEffect()
    
    SetTimeout(duration, function()
        for _, particle in ipairs(activeParticles) do StopParticleFxLooped(particle, 500) end
        isGasActive = false
        activeParticles = {}
    end)
end)

-- Nová smyčka pro kontrolu "příjezdu" k místu činu
CreateThread(function()
    while true do
        local sleep = 5000 -- Stačí kontrolovat jednou za 5 sekund
        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)
        local dist = #(pCoords - vec3(-621.85, -230.71, 38.0))

        -- Pokud jsme blízko a kouř nám neběží (např. jsme právě přijeli)
        if dist < 60.0 and not isGasActive then
            -- Zeptáme se serveru, jestli má plyn běžet
            local active, remaining = lib.callback.await('vangelico:getGasStatus', false)
            if active and remaining > 5000 then -- Pokud zbývá víc než 5 sekund
                TriggerEvent('vangelico:clientSmoke', remaining)
            end
            sleep = 10000 -- Pokud jsme blízko, stačí kontrola jednou za 10s
        end
        Wait(sleep)
    end
end)