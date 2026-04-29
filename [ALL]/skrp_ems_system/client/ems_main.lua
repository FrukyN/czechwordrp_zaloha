-- client/ems_main.lua
local ESX = exports["es_extended"]:getSharedObject()

local isUiOpen = false
local currentTarget = nil
local currentItemInHand = nil
local initialInjuryCount = 0

-- 1. OTEVŘENÍ DIAGNOSTIKY (Opravená verze pro synchronizaci mezi hráči)
function OpenMedicalMenu(targetPed)
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
    
    ESX.TriggerServerCallback('skrp_ems_system:getPatientDataFromClient', function(data)
        if data then
            -- Pokud jsou zranění prázdná (protože je hráč naživu)
            if #data.injuries == 0 then
                ESX.ShowNotification("~b~Diagnostika: ~s~Pacient nevykazuje žádné známky traumatu.")
            end

            SendNUIMessage({
                type = "openUI",
                pulse = data.pulse,
                oxygen = (data.oxygen or 98) .. "%",
                injuries = data.injuries -- Bude prázdné pro živé hráče
            })
            
            isUiOpen = true
            SetNuiFocus(true, true)
            TriggerEvent('skrp_ems_system:ekg:startAnimation')
        end
    end, targetServerId)
end

-- 2. PŘIDAT NA KONEC SOUBORU (Aby tvůj klient mohl odpovědět, když tě někdo diagnostikuje)
RegisterNetEvent('skrp_ems_system:requestClientData')
AddEventHandler('skrp_ems_system:requestClientData', function(requestId)
    -- Tato část běží u pacienta: vytáhne jeho data a pošle je na server
    local myInjuries = exports['skrp_ems_system']:getPatientData()
    local myPulse = exports['skrp_ems_system']:getPatientPulse()
    
    TriggerServerEvent('skrp_ems_system:respondWithData', requestId, {
        injuries = myInjuries,
        pulse = myPulse
    })
end)

-- 2. EKG ANIMACE
RegisterNetEvent('skrp_ems_system:ekg:startAnimation', function()
    Citizen.CreateThread(function()
        while isUiOpen do
            Citizen.Wait(1000)
            if isUiOpen then
                SendNUIMessage({ type = "triggerEkgPulse" })
            end
        end
    end)
end)

-- 3. ZAVŘENÍ TABLETU
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    isUiOpen = false
    cb('ok')
end)

-- 4. VÝBĚR POLOŽKY Z BATOHU (JS volá takeBagItem)
RegisterNUICallback('takeBagItem', function(data, cb)
    currentItemInHand = data.item -- Uložíme si, co má doktor v ruce
    
    -- Zavřeme UI batohu a myš
    SendNUIMessage({ type = "closeBagUI" })
    SetNuiFocus(false, false)
    
    ESX.ShowNotification("Vzal jsi z batohu: ~b~" .. currentItemInHand:upper())
    cb('ok')
end)

-- 5. ZPRACOVÁNÍ OŠETŘENÍ (Kliknutí na tlačítko "OŠETŘIT" v tabletu)
RegisterNUICallback('processTreatment', function(data, cb)
    local injuryIndex = data.injuryIndex
    local injuryType = data.injuryType
    
    -- Zjistíme, co je na toto zranění potřeba
    local neededItem = exports['skrp_ems_system']:getNeededItemForType(injuryType)

    -- Kontrola, zda má doktor v ruce správnou věc
    if currentItemInHand == neededItem then
        -- Dočasně schováme tablet pro minihru
        SendNUIMessage({ type = "hideUI" }) 
        SetNuiFocus(false, false)

        -- SPUŠTĚNÍ TVÉ KRUHOVÉ MINIHRY (z minigames.lua)
        exports['skrp_ems_system']:StartMedicalMiniGame(function(success)
            if success then
                -- Animace ošetřování
                local ped = PlayerPedId()
                TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_ITERATIVE", 0, true)
                ESX.ShowNotification("~g~Provádím ošetření...")
                
                Citizen.Wait(5000)
                ClearPedTasks(ped)

                -- Smazání zranění v damage_engine
                local remaining = exports['skrp_ems_system']:removeInjuryByIndex(injuryIndex)
                currentItemInHand = nil -- Item byl spotřebován
                
                if remaining == 0 then
                    FinalizePatientTreatment()
                else
                    ESX.ShowNotification("~g~Zranění ošetřeno. Zbývá: " .. remaining)
                    OpenMedicalMenu(currentTarget) -- Znovu otevřeme tablet pro zbytek
                end
            else
                ESX.ShowNotification("~r~Zákrok se nepovedl!")
                OpenMedicalMenu(currentTarget)
            end
        end)
    else
        ESX.ShowNotification("~r~Špatné vybavení! Potřebuješ: ~b~" .. neededItem:upper())
    end
    cb('ok')
end)

RegisterNUICallback('treatInjury', function(data, cb)
    local requiredItem = injuryRequirements[data.type]
    
    if not requiredItem then
        ESX.ShowNotification("~r~Neznámý typ zranění: " .. tostring(data.type))
        return cb('error')
    end

    -- Kontrola ox_inventory
    local count = exports.ox_inventory:Search('count', requiredItem)

    if count > 0 then
        -- Pokud máš item, spustíme proces
        TriggerEvent('skrp_ems_system:startTreatment', data.index, requiredItem, data.type)
        cb('ok')
    else
        ESX.ShowNotification("~r~Chybí ti: " .. requiredItem)
        cb('error')
    end
end)

function FinalizePatientTreatment()
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(currentTarget))
    
    -- Pokud hráč neměl ŽÁDNÁ zranění v tabulce, ale byl "mrtvý", 
    -- znamená to, že ho nikdo neošetřoval, jen na něj klikli.
    if initialInjuryCount == 0 then 
        ESX.ShowNotification("~r~Pacient nemá žádná ošetřitelná traumata!")
        CloseEverything()
        return 
    end

    if initialInjuryCount >= 3 then
        ESX.ShowNotification("~y~Stabilizováno. Nutný převoz!")
    else
        ESX.ShowNotification("~g~Vyléčeno. Pacient může vstát.")
        TriggerServerEvent('skrp_ems_system:revivePlayer', targetServerId)
    end
    
    CloseEverything()
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'ems_diagnose',
        icon = 'fas fa-stethoscope',
        label = 'Diagnostikovat pacienta',
        groups = 'ambulance',
        onSelect = function(data)
            -- data.entity je ped hráče, na kterého se díváš
            if DoesEntityExist(data.entity) and IsPedAPlayer(data.entity) then
                OpenMedicalMenu(data.entity)
            else
                ESX.ShowNotification("~r~Tento cíl nelze diagnostikovat.")
            end
        end
    }
})

-- 8. RESET PŘI STARTU
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    SendNUIMessage({ type = "closeUI" })
    SetNuiFocus(false, false)
end)

-- Callback pro zavření batohu (pokud ho hráč jen vypne)
RegisterNUICallback('closeBag', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

local function CloseEverything()
    SetNuiFocus(false, false)
    isUiOpen = false
    SendNUIMessage({ type = "closeUI" }) -- Pojistka pro JS
end

RegisterNUICallback('close', function(data, cb)
    CloseEverything()
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    CloseEverything()
    cb('ok')
end)

-- client/ems_main.lua

Citizen.CreateThread(function()
    while true do
        -- Pokud má doktor otevřený tablet a má vybraného pacienta
        if isUiOpen and currentTarget then
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(currentTarget))
            
            -- Vyžádáme si čerstvá data od pacienta přes server
            ESX.TriggerServerCallback('skrp_ems_system:getPatientDataFromClient', function(data)
                if data and isUiOpen then
                    -- Pošleme aktualizaci do JavaScriptu (NUI)
                    SendNUIMessage({
                        type = "updateVitals",
                        pulse = data.pulse,
                        oxygen = (data.oxygen or 98) .. "%"
                    })
                end
            end, targetServerId)
        end
        Wait(1500) -- Aktualizace v tabletu každou vteřinu a půl
    end
end)

-- client/ems_main.lua

Citizen.CreateThread(function()
    while true do
        -- Aktualizujeme jen pokud je UI otevřené a máme vybraného pacienta
        if isUiOpen and currentTarget then
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(currentTarget))
            
            -- Požádáme server/pacienta o čerstvé vitály
            ESX.TriggerServerCallback('skrp_ems_system:getPatientDataFromClient', function(data)
                if data and isUiOpen then
                    -- Posíláme do JavaScriptu speciální event pro refresh
                    SendNUIMessage({
                        type = "updateVitals",
                        pulse = data.pulse,
                        oxygen = data.oxygen,
                        -- Tlak můžeme lehce simulovat, aby nebyl statický
                        bloodPressure = math.random(110, 130) .. "/" .. math.random(70, 85)
                    })
                end
            end, targetServerId)
        end
        -- Interval aktualizace (1.5 sekundy pro šetření výkonu)
        Wait(1500)
    end
end)

-- client/ems_main.lua

RegisterNetEvent('skrp_ems_system:startTreatment')
AddEventHandler('skrp_ems_system:startTreatment', function(index, item, injuryName)
    local ped = PlayerPedId()
    
    -- Animace klečení u pacienta
    TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_ITERATIVE", 0, true)

    -- Progress bar (ox_lib)
    if lib.progressBar({
        duration = 5000,
        label = 'Ošetřování: ' .. injuryName,
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, mouse = false }
    }) then
        -- Úspěch: Odebereme item a synchronizujeme s pacientem
        local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(currentTarget))
        
        TriggerServerEvent('skrp_ems_system:completeTreatment', targetServerId, index, item)
        ClearPedTasks(ped)
    else
        -- Zrušeno
        ClearPedTasks(ped)
        ESX.ShowNotification("~r~Přerušeno.")
    end
end)