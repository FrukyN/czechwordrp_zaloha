local place = 0
local started = false
local grade = 0.5
local disabledControl = 0
local currentTableIndex = nil

Citizen.CreateThread(function()
    -- Blipy pro stoly z configu (volitelné)
    if globalConfig.showBlipOnMap then
        for _, info in pairs(globalConfig.props) do
            if info.blip then
                local blip = AddBlipForCoord(info.x, info.y, info.z)
                SetBlipSprite(blip, globalConfig.blip.id)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, globalConfig.blip.colour)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(globalConfig.blip.title)
                EndTextCommandSetBlipName(blip)
            end
        end
    end

    -- Získání modelů pro ox_target
    local modelsToTarget = {}
    for _, config in pairs(globalConfig.props) do
        modelsToTarget[config.model] = true
    end

    local targetModels = {}
    for model, _ in pairs(modelsToTarget) do
        table.insert(targetModels, model)
    end

    -- Přidání ox_target na modely stolů (funguje i na dynamicky položené)
    exports.ox_target:addModel(targetModels, {
        {
            name = 'arm_wrestling_interaction',
            icon = 'fas fa-hand-back-fist',
            label = 'Arm Wrestle',
            onSelect = function(data)
                local entity = data.entity
                local coords = GetEntityCoords(entity)
                local model = GetEntityModel(entity)
                
                -- Vytvoříme unikátní ID z pozice (na 1 desetinné místo pro shodu mezi hráči)
                local tIndex = "table_" .. string.format("%.1f_%.1f_%.1f", coords.x, coords.y, coords.z)
                
                TriggerServerEvent('evy_arm:check_sv', tIndex, coords, model)
            end
        }
    })
end)

-- Tento thread spawnuje stoly z configu.
-- Dynamické stoly z itemů tento thread ignoruje (což je správně, ty ti spawnuje inventář)
Citizen.CreateThread(function()
    while true do
        Wait(2000)
        local pedCoords = GetEntityCoords(PlayerPedId())

        for i, modelConfig in pairs(globalConfig.props) do
            local dist = #(pedCoords - vec3(modelConfig.x, modelConfig.y, modelConfig.z))
            local tableHash = GetHashKey(modelConfig.model)

            if dist < 50.0 then
                local thisTable = GetClosestObjectOfType(modelConfig.x, modelConfig.y, modelConfig.z, 1.5, tableHash, false, false, false)
                if not DoesEntityExist(thisTable) then
                    thisTable = CreateObject(tableHash, modelConfig.x, modelConfig.y, modelConfig.z, false, false, false)
                    SetEntityHeading(thisTable, modelConfig.heading or 0.0)
                    PlaceObjectOnGroundProperly(thisTable)
                    FreezeEntityPosition(thisTable, true)
                end
            else
                local thisTable = GetClosestObjectOfType(modelConfig.x, modelConfig.y, modelConfig.z, 1.5, tableHash, false, false, false)
                if DoesEntityExist(thisTable) then
                    DeleteEntity(thisTable)
                end
            end
        end		
    end
end)

-- Blokace tlačítek při hře
Citizen.CreateThread(function()
    while true do
        if disabledControl > 0 then
            DisableControlAction(2, 71, true)
            DisableControlAction(2, 72, true)
            DisableControlAction(2, 63, true)
            DisableControlAction(2, 64, true)
            DisableControlAction(2, 75, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(2, 37, true)
            DisableControlAction(2, 23, true)
            DisableControlAction(2, 246, true)

            if disabledControl == 2 then
                DisableControlAction(2, 73, true)
                DisableControlAction(2, 38, true)
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

function notify(msg, type)
    lib.notify({
        title = 'Arm Wrestling',
        description = msg,
        type = type or 'info'
    })
end

function timer()
    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    local T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
        Wait(0)
        Draw2DText(0.5, 0.4, ("~s~3"), 3.0)
    end
    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
        Wait(0)
        Draw2DText(0.5, 0.4, ("~s~2"), 3.0)
    end
    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
        Wait(0)
        Draw2DText(0.5, 0.4, ("~s~1"), 3.0)
    end
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)
  
    T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
        Wait(0)
        Draw2DText(0.4, 0.4, ("~s~GO ~w~!"), 3.0)
    end
end

RegisterNetEvent('evy_arm:updategrade_cl')
AddEventHandler('evy_arm:updategrade_cl', function(gradeUpValue)
    grade = gradeUpValue
end)

RegisterNetEvent('evy_arm:start_cl')
AddEventHandler('evy_arm:start_cl', function()
    started = true
    local ped = PlayerPedId()

    if place == 1 then
        disabledControl = 2
        timer()

        PlayAnim(ped, "mini@arm_wrestling", "sweep_a", 1)
        SetEntityAnimSpeed(ped, "mini@arm_wrestling", "sweep_a", 0.0)
        SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_a", grade)
        PlayFacialAnim(ped, "electrocuted_1", "facials@gen_male@base")
        disabledControl = 1

        lib.showTextUI(text[globalConfig.language]['tuto'] .. " [E]")
        while grade >= 0.10 and grade <= 0.90 do
            Wait(0)
            PlayFacialAnim(ped, "electrocuted_1", "facials@gen_male@base")
            SetEntityAnimSpeed(ped, "mini@arm_wrestling", "sweep_a", 0.0)
            SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_a", grade)
            
            if IsControlPressed(0, 38) then
                TriggerServerEvent('evy_arm:updategrade_sv', 0.015) 
                SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_a", grade)
                while IsControlPressed(0, 38) do
                    Wait(0)
                    SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_a", grade)
                end
            end
        end
        lib.hideTextUI()

        if grade >= 0.90 then
            PlayAnim(ped, "mini@arm_wrestling", "win_a_ped_a", 2)
            notify(text[globalConfig.language]['win'], 'success')
        elseif grade <= 0.10 then
            PlayAnim(ped, "mini@arm_wrestling", "win_a_ped_b", 2)
            notify(text[globalConfig.language]['lose'], 'error')
        end
        Wait(4000)
        TriggerServerEvent('evy_arm:disband_sv', currentTableIndex)
        return

    elseif place == 2 then
        disabledControl = 2
        timer()

        PlayAnim(ped, "mini@arm_wrestling", "sweep_b", 1)
        SetEntityAnimSpeed(ped, "mini@arm_wrestling", "sweep_b", 0.0)
        SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_b", grade)
        PlayFacialAnim(ped, "electrocuted_1", "facials@gen_male@base")
        disabledControl = 1

        lib.showTextUI(text[globalConfig.language]['tuto'] .. " [E]")
        while grade >= 0.10 and grade <= 0.90 do
            Wait(0)
            PlayFacialAnim(ped, "electrocuted_1", "facials@gen_male@base")
            SetEntityAnimSpeed(ped, "mini@arm_wrestling", "sweep_b", 0.0)
            SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_b", grade)
            
            if IsControlPressed(0, 38) then
                TriggerServerEvent('evy_arm:updategrade_sv', -0.015) 
                SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_b", grade)
                while IsControlPressed(0, 38) do
                    Wait(0)
                    SetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "sweep_b", grade)
                end
            end
        end
        lib.hideTextUI()

        if grade <= 0.10 then
            PlayAnim(ped, "mini@arm_wrestling", "win_a_ped_a", 2)
            notify(text[globalConfig.language]['win'], 'success')
        elseif grade >= 0.90 then
            PlayAnim(ped, "mini@arm_wrestling", "win_a_ped_b", 2)
            notify(text[globalConfig.language]['lose'], 'error')
        end
        Wait(4000)
        TriggerServerEvent('evy_arm:disband_sv', currentTableIndex)
        return
    end
end)

RegisterNetEvent('evy_arm:check_cl')
AddEventHandler('evy_arm:check_cl', function(args, tIndex, tCoords, tModel)
    local ped = PlayerPedId()
    currentTableIndex = tIndex
    
    -- Vyhledání konkrétního stolu (z itemu nebo z configu)
    local tableEntity = GetClosestObjectOfType(tCoords.x, tCoords.y, tCoords.z, 2.0, tModel, false, false, false)

    if not DoesEntityExist(tableEntity) then
        notify("Stůl nebyl nalezen.", "error")
        return
    end

    if args == 'place1' then
        place = 1
        disabledControl = 2
        SetEntityNoCollisionEntity(ped, tableEntity, false)
        SetEntityHeading(ped, GetEntityHeading(tableEntity))
        Wait(100)
        SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(tableEntity, -0.20, 0.0, 0.0).x, GetOffsetFromEntityInWorldCoords(tableEntity, 0.0, -0.65, 0.0).y, GetEntityCoords(ped).z-1)
        FreezeEntityPosition(ped, true)
        PlayAnim(ped, "mini@arm_wrestling","aw_ig_intro_alt1_a", 2)
        
        while ( GetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "aw_ig_intro_alt1_a") < 0.95 ) do Wait(0) end
        PlayAnim(ped, "mini@arm_wrestling", "nuetral_idle_a", 1)
        disabledControl = 1

        lib.showTextUI(text[globalConfig.language]['wait'])
        while not started do
            Wait(0)
            if IsControlPressed(2, 73) or IsPedRagdoll(ped) or IsControlPressed(2, 200) or IsControlPressed(2, 214) then
                SetEntityNoCollisionEntity(ped, tableEntity, true)
                TriggerServerEvent('evy_arm:disband_sv', currentTableIndex)
                lib.hideTextUI()
                return
            end
        end
        lib.hideTextUI()

    elseif args == 'place2' then
        place = 2
        disabledControl = 2
        SetEntityNoCollisionEntity(ped, tableEntity, false)
        SetEntityHeading(ped, GetEntityHeading(tableEntity)-180)
        Wait(100)
        SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(tableEntity, 0.0, 0.0, 0.0).x, GetOffsetFromEntityInWorldCoords(tableEntity, 0.0, 0.50, 0.0).y, GetEntityCoords(ped).z-1)
        
        FreezeEntityPosition(ped, true)
        PlayAnim(ped, "mini@arm_wrestling","aw_ig_intro_alt1_b", 2)
        
        while ( GetEntityAnimCurrentTime(ped, "mini@arm_wrestling", "aw_ig_intro_alt1_b") < 0.95 ) do Wait(0) end
        PlayAnim(ped, "mini@arm_wrestling", "nuetral_idle_b", 1)
        disabledControl = 1
        
        lib.showTextUI(text[globalConfig.language]['wait'])
        while not started do
            Wait(0)
            if IsControlPressed(2, 73) or IsPedRagdoll(ped) or IsControlPressed(2, 200) or IsControlPressed(2, 214) then
                SetEntityNoCollisionEntity(ped, tableEntity, true)
                TriggerServerEvent('evy_arm:disband_sv', currentTableIndex)
                lib.hideTextUI()
                return
            end
        end
        lib.hideTextUI()

    elseif args == 'noplace' then
        notify(text[globalConfig.language]['full'], 'error')
    end
end)

RegisterNetEvent('evy_arm:reset_cl')
AddEventHandler('evy_arm:reset_cl', function(tCoords, tModel)
    local ped = PlayerPedId()
    
    if tCoords and tModel then
        local tableEntity = GetClosestObjectOfType(tCoords.x, tCoords.y, tCoords.z, 2.0, tModel, false, false, false)
        if DoesEntityExist(tableEntity) then
            SetEntityNoCollisionEntity(ped, tableEntity, true)
        end
    end
    
    ClearPedTasks(ped)
    place = 0
    started = false
    grade = 0.5
    disabledControl = 0
    currentTableIndex = nil
    FreezeEntityPosition(ped, false)
    lib.hideTextUI()
end)

--============================================================================================--
--=====================              EXTERNAL FUNCTION              ==========================--
--============================================================================================--

function PlayAnim(ped, dict, name, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(ped, dict, name, 1.5, 1.5, -1, flag, 0.0, false, false, false)
end

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(198, 25, 66, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end