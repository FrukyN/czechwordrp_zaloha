local ESX = exports["es_extended"]:getSharedObject()
local isExploded = false
local doorCoords = vec4(-596.0953, 2088.7708, 130.4128, 195.6375)
local spawnedBarrels = {}

-- Souřadnice sudů
local barrelPositions = {
    vec4(-593.4561, 2084.4631, 131.3864, 115.5204),
    vec4(-594.4227, 2077.9473, 131.5499, 284.9032),
    vec4(-587.3623, 2058.4424, 130.5527, 113.3539),
    vec4(-582.7484, 2036.1731, 128.9031, 291.8600),
    vec4(-570.1542, 2020.9778, 127.6744, 279.9457),
    vec4(-549.5219, 1996.3116, 127.0397, 188.0210),
    vec4(-542.9568, 1982.8093, 127.0262, 38.5724),
    vec4(-570.1542, 2020.9778, 127.6744, 279.9457),
}

-- Funkce pro spawnutí sudů
function spawnMineBarrels()
    for i, entity in ipairs(spawnedBarrels) do
        if DoesEntityExist(entity) then DeleteEntity(entity) end
    end
    spawnedBarrels = {}

    local model = `prop_wooden_barrel`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    for _, coords in ipairs(barrelPositions) do
        local barrel = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
        SetEntityHeading(barrel, coords.w)
        FreezeEntityPosition(barrel, true)
        table.insert(spawnedBarrels, barrel)
    end
    SetModelAsNoLongerNeeded(model)
end

-- Upravený respawnMineDoor
function respawnMineDoor()
    local oldDoor = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, 5.0, Config.DoorModel, false, false, false)
    if oldDoor ~= 0 then DeleteEntity(oldDoor) end

    ESX.TriggerServerCallback('kleno_mine:checkDoorState', function(canStart)
        if canStart then
            isExploded = false 
            RequestModel(Config.DoorModel)
            while not HasModelLoaded(Config.DoorModel) do Wait(10) end
            local newDoor = CreateObject(Config.DoorModel, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false)
            SetEntityHeading(newDoor, doorCoords.w)
            FreezeEntityPosition(newDoor, true)
            spawnMineBarrels()
        else
            isExploded = true
            setupBarrels()
        end
    end)
end

-- Start skriptu
CreateThread(function()
    respawnMineDoor()
end)

-- Synchronizované smazání dveří a efekt výbuchu
RegisterNetEvent('kleno_mine:forceDeleteDoor', function()
    local coords = vec3(doorCoords.x, doorCoords.y, doorCoords.z)

    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
    
    local playerPos = GetEntityCoords(PlayerPedId())
    local dist = #(playerPos - coords)
    if dist < 20.0 then
        ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 1.5)
    end

    -- ZMĚNA: Spuštění alarmu dolu na 2 minuty (120000 ms)
    PlaySoundLoop(coords, 60.0, 'alarm_dul', 0.5, 120000)

    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, Config.DoorModel, false, false, false)
    if door ~= 0 then
        NetworkRequestControlOfEntity(door)
        local timeout = 0
        while not NetworkHasControlOfEntity(door) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
        SetEntityAsMissionEntity(door, true, true)
        DeleteEntity(door)
    end

    isExploded = true
    setupBarrels()
    exports.ox_lib:notify({description = "Městem se rozlehl výbuch a spustil se poplach!", type = 'error'})
end)

-- RESET EVENT
RegisterNetEvent('kleno_mine:resetMineClient', function()
    isExploded = false
    respawnMineDoor()
    exports.ox_target:removeModel(Config.BarrelModels, 'search_mine_barrel')
end)

-- Registrace Targetu pro odpálení
CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.MineEntrance,
        size = vec3(2.5, 1.5, 3.5),
        rotation = doorCoords.w,
        debug = false,
        options = {
            {
                label = Config.Strings['place_bomb'],
                icon = 'fa-solid fa-bomb',
                onSelect = function()
                    -- Kontrola, zda už je důl vybouchnutý/vybraný
                    if isExploded then
                        return exports.ox_lib:notify({
                            description = "Důl už je otevřený a vybraný!",
                            type = 'error'
                        })
                    end

                    ESX.TriggerServerCallback('kleno_mine:canStartHeist', function(canStart)
                        if canStart then
                            startMiningHeist()
                        end
                    end)
                end
            }
        }
    })
end)

-- Synchronizace se serverem
function openMineDoor()
    TriggerServerEvent('kleno_mine:removeDoorSync')
end

-- Hlavní logika loupeže
function startMiningHeist()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
    
    local success = exports.ox_lib:progressBar({
        duration = 8000,
        label = 'Připravuješ nálož...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true }
    })

    ClearPedTasks(ped)

    if success then
        TriggerServerEvent('kleno_mine:startHeistSync')
        exports.ox_lib:notify({description = Config.Strings['bomb_placed'], type = 'warning'})
        
        Wait(5000)
        openMineDoor()
        
        SetTimeout(Config.Police.alertDelay or 5000, function()
            if isExploded then
                TriggerServerEvent('kleno_mine:policeAlert', vec3(doorCoords.x, doorCoords.y, doorCoords.z))
            end
        end)
    end
end

-- Nastavení interakce se sudy
function setupBarrels()
    exports.ox_target:removeModel(Config.BarrelModels, 'search_mine_barrel')

    exports.ox_target:addModel(Config.BarrelModels, {
        {
            name = 'search_mine_barrel',
            label = 'Prohledat sud',
            icon = 'fa-solid fa-magnifying-glass',
            canInteract = function() return isExploded end,
            onSelect = function(data)
                searchBarrel(data.entity)
            end
        }
    })
end

-- Funkce pro prohledávání
function searchBarrel(entity)
    local coords = GetEntityCoords(entity)
    local roundedCoords = vec3(
        math.floor(coords.x * 10) / 10, 
        math.floor(coords.y * 10) / 10, 
        math.floor(coords.z * 10) / 10
    )

    ESX.TriggerServerCallback('kleno_mine:isPositionLooted', function(isLooted)
        if isLooted then
            exports.ox_lib:notify({description = "Tento sud už je prázdný!", type = 'error'})
            return
        end

        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
        
        if exports.ox_lib:progressBar({
            duration = 6000,
            label = Config.Strings['searching'] or 'Prohledáváš...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true }
        }) then
            TriggerServerEvent('kleno_mine:barrelSearched', roundedCoords)
        end
        ClearPedTasks(ped)
    end, roundedCoords)
end

-- Synchronizované smazání sudu
RegisterNetEvent('kleno_mine:deleteBarrelAtCoords', function(coords)
    local barrel = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.0, `prop_wooden_barrel`, false, false, false)
    if barrel ~= 0 then
        SetEntityAsMissionEntity(barrel, true, true)
        DeleteEntity(barrel)
    end
end)

-- Synchronizace výbuchu pro ostatní
RegisterNetEvent('kleno_mine:setMineExploded', function()
    isExploded = true
    setupBarrels() 
end)

-- Registrace Targetu pro budku s Thermitem
CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = vec3(2835.1628, 2806.8945, 57.4010),
        size = vec3(1.5, 1.5, 2.5),
        rotation = 88.15,
        debug = false,
        options = {
            {
                label = 'Vyloupit budku s vybavením',
                icon = 'fa-solid fa-user-secret',
                onSelect = function()
                    ESX.TriggerServerCallback('kleno_mine:canRobBooth', function(canRob)
                        if canRob then
                            exports['boii_minigames']:pincode({
                                style = 'default',
                                difficulty = 1,
                                guesses = 8
                            }, function(success)
                                if success then
                                    TriggerServerEvent('kleno_mine:giveBoothReward')
                                else
                                    -- NOTIFIKACE A DISPATCH
                                    exports.ox_lib:notify({description = "Selhal jsi a spustil jsi alarm!", type = 'error'})
                                    TriggerServerEvent('kleno_mine:boothFailDispatch', GetEntityCoords(PlayerPedId()))

                                    -- ZMĚNA: Spuštění alarmu budky na 1 minutu (60000 ms)
                                    local boothCoords = vec3(2835.1628, 2806.8945, 57.4010)
                                    PlaySoundLoop(boothCoords, 30.0, 'alarm', 0.5, 60000)
                                end
                            end)
                        else
                            exports.ox_lib:notify({description = "Tato budka je momentálně prázdná!", type = 'error'})
                        end
                    end)
                end
            }
        }
    })
end)

-- NOVÁ POMOCNÁ FUNKCE: Opakování zvuku po určenou dobu
function PlaySoundLoop(coords, maxDistance, soundName, volume, totalDuration)
    local interval = 10000 -- Pustí zvuk každých 10 sekund (přizpůsob délce tvého .ogg)
    local startTime = GetGameTimer()

    CreateThread(function()
        while GetGameTimer() - startTime < totalDuration do
            PlaySoundInRadius(coords, maxDistance, soundName, volume)
            Wait(interval)
        end
    end)
end

-- Pomocná funkce pro 3D zvuk (posílá zvuk jen IDčkům v okruhu)
function PlaySoundInRadius(coords, maxDistance, soundName, volume)
    local players = GetActivePlayers()
    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(coords - targetCoords)

        if distance <= maxDistance then
            TriggerServerEvent('InteractSound_SV:PlayOnOne', GetPlayerServerId(player), soundName, volume)
        end
    end
end

RegisterCommand('minecheck', function()
    if not isExploded then
        print("Důl je připraven k odpálení.")
        exports.ox_lib:notify({description = "Důl je zavřený a připravený.", type = 'inform'})
    else
        -- Zavoláme server, aby nám řekl, jaký je stav
        ESX.TriggerServerCallback('kleno_mine:checkDoorState', function(canStart)
            if canStart then
                exports.ox_lib:notify({description = "Důl by se měl každou chvíli resetovat!", type = 'warning'})
            else
                exports.ox_lib:notify({description = "Důl je stále v režimu 'vybráno'. Počkej na serverový reset.", type = 'error'})
            end
        end)
    end
end)

-- Logika pro neustálé mazání defaultních dveří z mapy
CreateThread(function()
    while true do
        local wait = 1000 -- Kontrola každou sekundu
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Počítáme vzdálenost od vstupu do dolu
        local distance = #(playerCoords - vec3(doorCoords.x, doorCoords.y, doorCoords.z))

        -- Pokud jsme blízko a důl má být odpálený
        if distance < 50.0 then
            if isExploded then
                -- Hledáme objekt dveří v okolí
                local mapDoor = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, 5.0, Config.DoorModel, false, false, false)
                
                if mapDoor ~= 0 then
                    -- Pokud dveře existují, smažeme je
                    SetEntityAsMissionEntity(mapDoor, true, true)
                    DeleteObject(mapDoor)
                    DeleteEntity(mapDoor)
                end
                wait = 250 -- Když jsme blízko a je vybuchnuto, kontrolujeme častěji
            end
        else
            wait = 3000 -- Pokud jsme daleko, šetříme výkon
        end
        
        Wait(wait)
    end
end)