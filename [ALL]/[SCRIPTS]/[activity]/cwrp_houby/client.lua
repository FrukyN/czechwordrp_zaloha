local spawnedProps = {}
local mushroomPoints = {}
local pickCooldownUntil = 0

local function notify(message, msgType)
    lib.notify({
        title = 'Houby',
        description = message,
        type = msgType or 'inform'
    })
end

local function getRandomGroundZ(coords)
    -- Výška, ze které zkoušíme hledat zem
    local checkZ = coords.z + 150.0

    -- Požádáme hru, aby načetla fyziku/mapu na těchto souřadnicích
    RequestCollisionAtCoord(coords.x, coords.y, checkZ)

    local found = false
    local groundZ = 0.0
    -- Dáme hře max 3 sekundy na to, aby mapu načetla
    local timeout = GetGameTimer() + 3000 

    while not found and GetGameTimer() < timeout do
        found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, checkZ, false)
        if not found then
            Wait(100) -- Pokud zem ještě není, počkáme zlomky sekundy a zkusíme to znovu
        end
    end

    if found then
        return groundZ
    end

    -- Pokud se mapa nenačte ani po 3 sekundách, vrátí základní Z
    return coords.z
end

local function createTargetForProp(prop, mushroomId, label)
    exports.ox_target:addLocalEntity(prop, {
        {
            name = ('pick_mushroom_%s'):format(mushroomId),
            icon = 'fa-solid fa-basket-shopping',
            label = label,
            distance = Config.MaxPickDistance,
            onSelect = function()
                local now = GetGameTimer()
                if now < pickCooldownUntil then
                    return
                end

                local basketCount = exports.ox_inventory:Search('count', Config.RequiredItem)
                if (basketCount or 0) < 1 then
                    notify(Config.Locale.no_basket, 'error')
                    return
                end

                pickCooldownUntil = now + Config.PickCooldownMs

                local done = lib.progressCircle({
                    duration = Config.PickDurationMs,
                    label = Config.Locale.picking,
                    canCancel = true,
                    disable = {
                        move = true,
                        combat = true,
                        car = true
                    },
                    anim = {
                        scenario = 'WORLD_HUMAN_GARDENER_PLANT'
                    }
                })

                if not done then
                    notify(Config.Locale.cancel, 'error')
                    return
                end

                local ok, msg = lib.callback.await('cwrp_houby:server:tryPick', false, mushroomId)
                if ok then
                    notify(msg or Config.Locale.picked, 'success')
                else
                    notify(msg or Config.Locale.invalid, 'error')
                end
            end
        }
    })
end

-- Pomocná funkce pro bezpečné smazání entity z herního světa
local function removeMushroomEntity(mushroomId)
    local prop = spawnedProps[mushroomId]
    if not prop then return end

    exports.ox_target:removeLocalEntity(prop)

    if DoesEntityExist(prop) then
        DeleteEntity(prop)
    end

    spawnedProps[mushroomId] = nil
end

-- Funkce, která registruje neviditelný bod. Ten vytvoří houbu až ve chvíli, kdy je hráč blízko.
local function registerMushroomPoint(data)
    if mushroomPoints[data.id] then return end

    mushroomPoints[data.id] = lib.points.new({
        coords = vector3(data.coords.x, data.coords.y, data.coords.z),
        distance = 60.0, -- Houba se vytvoří, jakmile se hráč přiblíží na 60 metrů (kdy je mapa bezpečně načtená)
        onEnter = function(self)
            local model = data.model
            if type(model) == 'string' then
                model = joaat(model)
            end

            if not lib.requestModel(model, 4000) then
                return
            end

            local z = getRandomGroundZ(data.coords)
            local prop = CreateObject(model, data.coords.x, data.coords.y, z, false, false, false)

            if not DoesEntityExist(prop) then
                return
            end

            PlaceObjectOnGroundProperly(prop)
            FreezeEntityPosition(prop, true)
            SetEntityHeading(prop, math.random(0, 359) + 0.0)

            createTargetForProp(prop, data.id, data.label)
            spawnedProps[data.id] = prop

            SetModelAsNoLongerNeeded(model)
        end,
        onExit = function(self)
            -- Když hráč odejde pryč, houba se smaže z paměti (optimalizace)
            removeMushroomEntity(data.id)
        end
    })
end

-- Vlákno pro inicializaci blipů a načtení stávajících hub ze serveru
CreateThread(function()
    if Config.Blips.Enable then
        for _, zone in ipairs(Config.Zones) do
            local radiusBlip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
            SetBlipRotation(radiusBlip, 0)
            SetBlipColour(radiusBlip, Config.Blips.RadiusColor)
            SetBlipAlpha(radiusBlip, Config.Blips.RadiusAlpha)

            local centerBlip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
            SetBlipSprite(centerBlip, Config.Blips.IconSprite)
            SetBlipDisplay(centerBlip, 4)
            SetBlipScale(centerBlip, Config.Blips.IconScale)
            SetBlipColour(centerBlip, Config.Blips.IconColor)
            SetBlipAsShortRange(centerBlip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("<font face='Roboto'>"..Config.Blips.Label.."</font>")
            EndTextCommandSetBlipName(centerBlip)
        end
    end

    -- Vyžádání aktuálně aktivních hub ze serveru při připojení
    local initialMushrooms = lib.callback.await('cwrp_houby:server:getInitialMushrooms', false)
    if type(initialMushrooms) == 'table' then
        for _, mushroom in pairs(initialMushrooms) do
            registerMushroomPoint(mushroom)
        end
    end
end)

-- Event, když server vygeneruje novou houbu do světa
RegisterNetEvent('cwrp_houby:client:addMushroom', function(data)
    if type(data) ~= 'table' or not data.id or not data.coords or not data.model then
        return
    end

    registerMushroomPoint(data)
end)

-- Event, když někdo houbu sebere a server ji odstraní
RegisterNetEvent('cwrp_houby:client:removeMushroom', function(mushroomId)
    if type(mushroomId) ~= 'number' then
        return
    end

    -- Smažeme záchytný bod z ox_lib
    if mushroomPoints[mushroomId] then
        mushroomPoints[mushroomId]:remove()
        mushroomPoints[mushroomId] = nil
    end

    -- Smažeme samotnou entitu, pokud ji měl hráč zrovna spawnutou u sebe
    removeMushroomEntity(mushroomId)
end)

-- Efekt otravy
RegisterNetEvent('cwrp_houby:client:poisonEffect', function(effectCfg)
    effectCfg = effectCfg or Config.PoisonEffects
    local duration = effectCfg.DurationMs or 30000
    local shakeName = effectCfg.Shake or 'DRUNK_SHAKE'
    local timecycle = effectCfg.Timecycle or 'spectator5'
    local ragdollChance = effectCfg.RagdollChance or 0.1

    StartScreenEffect('DrugsMichaelAliensFightIn', 1000, false)
    SetTimecycleModifier(timecycle)
    SetTimecycleModifierStrength(1.0)
    ShakeGameplayCam(shakeName, 1.0)

    local start = GetGameTimer()
    while (GetGameTimer() - start) < duration do
        Wait(1200)

        if math.random() < ragdollChance then
            SetPedToRagdoll(cache.ped, 1500, 1500, 0, false, false, false)
        end
    end

    StopGameplayCamShaking(true)
    ClearTimecycleModifier()
    StopScreenEffect('DrugsMichaelAliensFightIn')
end)

-- Vyčištění při stopnutí skriptu
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    -- Odstranění všech ox_lib bodů
    for mushroomId, point in pairs(mushroomPoints) do
        point:remove()
        mushroomPoints[mushroomId] = nil
    end

    -- Odstranění všech spawnutých objektů
    for mushroomId, prop in pairs(spawnedProps) do
        exports.ox_target:removeLocalEntity(prop)
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
        spawnedProps[mushroomId] = nil
    end
end)