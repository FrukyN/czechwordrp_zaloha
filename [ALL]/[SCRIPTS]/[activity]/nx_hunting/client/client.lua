local loaded = false
local isInArea = false
local AnimalsNPC = {}
local activeZone = nil
local charmedAnimals = {}
local spawnThreadToken = 0

local HUNT_TARGET_NAME = 'nx_hunting_hunt'

local function getRandomCoord(radius, center, debug)
    local tryCount = 15

    for _ = 1, tryCount do
        local angle = math.random() * (math.pi * 2)
        local distance = math.sqrt(math.random()) * (radius * 0.9)

        local x = center.x + math.cos(angle) * distance
        local y = center.y + math.sin(angle) * distance

        local found, groundZ = GetGroundZFor_3dCoord(x, y, center.z + 80.0, true)
        if found then
            local safePosition = vector3(x, y, groundZ)

            if Config.Debug and debug then
                print(Lang['spawning']:format(safePosition, radius))
            end

            return safePosition
        end
    end

    return vector3(center.x, center.y, center.z)
end

local function removeAnimalByEntity(entity)
    for i = #AnimalsNPC, 1, -1 do
        local data = AnimalsNPC[i]
        if data.npcEntity == entity then
            table.remove(AnimalsNPC, i)
            return data
        end
    end
    return nil
end

local function clearAnimalEntry(data, deletePed)
    if not data then
        return
    end

    if data.blip and DoesBlipExist(data.blip) then
        RemoveBlip(data.blip)
    end

    if data.npcEntity and DoesEntityExist(data.npcEntity) then
        exports.ox_target:removeLocalEntity(data.npcEntity, HUNT_TARGET_NAME)

        if deletePed then
            SetEntityAsMissionEntity(data.npcEntity, true, true)
            DeleteEntity(data.npcEntity)
        end
    end
end

local function clearAllAnimals(deletePed)
    for i = #AnimalsNPC, 1, -1 do
        clearAnimalEntry(AnimalsNPC[i], deletePed)
        AnimalsNPC[i] = nil
    end
end

local function createBlipForEntity(entity, scale)
    local blip = AddBlipForEntity(entity)
    SetBlipScale(blip, scale)
    return blip
end

local function shouldSpawnFromRarity(rarity)
    rarity = math.max(1, math.min(100, tonumber(rarity) or 50))
    return math.random(100) <= rarity
end

local function resetPlayerAfterHunt()
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    ResetPedMovementClipset(PlayerPedId(), 0)
end

local function OnStart(entity)
    if not IsEntityDead(entity) then
        return false
    end

    FreezeEntityPosition(PlayerPedId(), true)

    local dict = 'mini@repair'
    local flag = 'fixing_a_ped'

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    RequestAnimSet('move_ped_crouched')
    while not HasAnimSetLoaded('move_ped_crouched') do
        Wait(0)
    end

    SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 1)
    TaskPlayAnim(PlayerPedId(), dict, flag, 8.0, 8.0, 8000, 16, 1, false, false, false)

    return true
end

local function Complete(entity, animalData)
    if DoesEntityExist(entity) then
        SetEntityHealth(entity, 0)
    end

    resetPlayerAfterHunt()

    if Config.Debug then
        print(Lang['hunted']:format(entity))
    end

    if animalData and animalData.zone and animalData.name then
        TriggerServerEvent('nx_hunting:server:reward', animalData.zone, animalData.name)
    end

    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

local function LibProgressConfiguration(entity, animalData)
    if OnStart(entity) then
        if lib.progressCircle({
            duration = 4000,
            label = 'Hunting..',
            canCancel = true,
            useWhileDead = false,
            allowCuffed = false,
            disable = {
                move = true,
                car = true,
                combat = true,
            }
        }) then
            Complete(entity, animalData)
        else
            resetPlayerAfterHunt()
        end
    end
end

local function RProgressConfiguration(entity, animalData)
    exports.rprogress:Custom({
        canCancel = true,
        cancelKey = 178,
        Duration = 4000,
        y = 0.7,
        Label = 'Hunting..',
        Color = 'rgba(255, 255, 255, 1.0)',
        onStart = function()
            OnStart(entity)
        end,
        onComplete = function()
            Complete(entity, animalData)
        end,
        onCancel = function()
            resetPlayerAfterHunt()
        end
    })
end

local function Hunt(data)
    local animalData = removeAnimalByEntity(data.entity)
    if not animalData then
        return
    end

    clearAnimalEntry(animalData, false)

    if Config.Progress == 'ox_lib' then
        LibProgressConfiguration(data.entity, animalData)
    elseif Config.Progress == 'rprogress' then
        RProgressConfiguration(data.entity, animalData)
    end
end

local function spawnOneAnimal(zoneName, zoneData, animalName, animalConfig)
    local hashKey = joaat(animalConfig.model)
    RequestModel(hashKey)
    local timeout = GetGameTimer() + 3000

    while not HasModelLoaded(hashKey) do
        if GetGameTimer() > timeout then
            return
        end
        Wait(0)
    end

    local spawnCoord = getRandomCoord(zoneData.radius, zoneData.position, true)
    local animalNPC = CreatePed(28, hashKey, spawnCoord.x, spawnCoord.y, spawnCoord.z, math.random() * 360.0, false, true)
    SetModelAsNoLongerNeeded(hashKey)

    if not DoesEntityExist(animalNPC) then
        return
    end

    SetEntityAsMissionEntity(animalNPC, true, true)
    SetBlockingOfNonTemporaryEvents(animalNPC, true)

    local wanderCoords = getRandomCoord(zoneData.radius, zoneData.position, false)
    TaskWanderInArea(animalNPC, wanderCoords.x, wanderCoords.y, wanderCoords.z, zoneData.radius * 0.9, 10, 10)

    local blip = createBlipForEntity(animalNPC, 0.65)

    table.insert(AnimalsNPC, {
        npcEntity = animalNPC,
        blip = blip,
        name = animalName,
        zone = zoneName
    })

    exports.ox_target:addLocalEntity(animalNPC, {
        {
            label = 'Hunt',
            name = HUNT_TARGET_NAME,
            icon = 'fa-solid fa-eye',
            distance = 1.7,
            onSelect = Hunt,
            canInteract = function(entity)
                return IsEntityDead(entity) and IsPedArmed(PlayerPedId(), 1)
            end,
        }
    })
end

local function spawnAnimals(huntZones, zoneName)
    spawnThreadToken = spawnThreadToken + 1
    local threadToken = spawnThreadToken

    CreateThread(function()
        while isInArea and activeZone == zoneName and threadToken == spawnThreadToken do
            local zoneData = huntZones[zoneName]
            if not zoneData or not zoneData.Animals then
                return
            end

            if #AnimalsNPC < Config.MaxEntities then
                for animalName, animalConfig in pairs(zoneData.Animals) do
                    if not (isInArea and activeZone == zoneName and threadToken == spawnThreadToken) then
                        return
                    end

                    if #AnimalsNPC >= Config.MaxEntities then
                        break
                    end

                    if shouldSpawnFromRarity(animalConfig.rarity) then
                        spawnOneAnimal(zoneName, zoneData, animalName, animalConfig)
                        Wait(500)
                    elseif Config.Debug then
                        print(Lang['not-spawning']:format(animalConfig.model))
                    end
                end
            end

            Wait(4000)
        end
    end)
end

function ConfigureZones(huntZones)
    for zoneName, zoneData in pairs(huntZones) do
        lib.zones.sphere({
            coords = zoneData.position,
            radius = zoneData.radius,
            onEnter = function()
                isInArea = true
                activeZone = zoneName
                spawnAnimals(huntZones, zoneName)

                if Config.Debug then
                    print(Lang['we-are']:format(zoneName))
                end
            end,
            onExit = function()
                if Config.Debug then
                    print(Lang['we-are-not'])
                end

                isInArea = false
                activeZone = nil
                spawnThreadToken = spawnThreadToken + 1
                clearAllAnimals(true)
            end,
            debug = false
        })
    end
end

function ConfigureBlips(_, huntZones)
    for _, zone in pairs(huntZones) do
        local radiusBlip = AddBlipForRadius(zone.position, zone.radius)
        SetBlipColour(radiusBlip, zone.Blip.color)
        SetBlipAlpha(radiusBlip, 128)

        local iconBlip = AddBlipForCoord(zone.position)
        SetBlipSprite(iconBlip, zone.Blip.sprite)
        SetBlipDisplay(iconBlip, 4)
        SetBlipScale(iconBlip, 0.9)
        SetBlipColour(iconBlip, zone.Blip.color)
        SetBlipAsShortRange(iconBlip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Lovecky revir')
        EndTextCommandSetBlipName(iconBlip)
    end
end

local function pickRandomElements(tbl, count)
    local picked = {}

    if Config.Debug then
        print(Lang['charming']:format(count))
    end

    for _ = 1, count do
        local randomAnimal = tbl[math.random(#tbl)]
        if randomAnimal and DoesEntityExist(randomAnimal.npcEntity) then
            table.insert(picked, randomAnimal.npcEntity)
        end
        Wait(Config.SECONDS)
    end

    return picked
end

local function PlayerLoaded()
    if loaded then
        return
    end

    ConfigureZones(Config.Zones)
    ConfigureBlips(Config.Debug, Config.Zones)
    loaded = true
end

AddEventHandler('onClientResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end

    if Config.Framework == 'esx' and ESX and ESX.IsPlayerLoaded and not ESX.IsPlayerLoaded() then
        return
    end

    PlayerLoaded()
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end

    clearAllAnimals(true)
    resetPlayerAfterHunt()
end)

if Config.Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', PlayerLoaded)
elseif Config.Framework == 'qb' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', PlayerLoaded)
else
    print('Unsupported Framework')
    return
end

RegisterCommand('charm', function()
    if isInArea and #AnimalsNPC > 0 then
        charmedAnimals = pickRandomElements(AnimalsNPC, math.random(1, #AnimalsNPC))
        for _, entity in pairs(charmedAnimals) do
            if DoesEntityExist(entity) then
                ClearPedTasksImmediately(entity)
                TaskGoToEntity(entity, PlayerPedId(), -1, 1.0, 1.49, 0, 0)

                if Config.Debug then
                    print(Lang['charmed']:format(entity))
                end
            end
        end
        charmedAnimals = {}
    end
end, false)
RegisterKeyMapping('charm', 'Charm animals', 'keyboard', 'b')

CreateThread(function()
    while true do
        Wait(2500)

        for i = #AnimalsNPC, 1, -1 do
            local data = AnimalsNPC[i]
            if not data or not DoesEntityExist(data.npcEntity) then
                clearAnimalEntry(data, false)
                table.remove(AnimalsNPC, i)
            end
        end
    end
end)