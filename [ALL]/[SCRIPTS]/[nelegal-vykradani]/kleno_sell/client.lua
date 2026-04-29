local buyerPed = nil
local buyerBlip = nil
local isCalling = false

-- Standardní funkce pro titulky
local function showSubtitle(text, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(duration, true)
end

-- Funkce pro načtení modelu a animace (bezpečnější než ox_lib exporty)
local function ensureAssets(model, dict)
    if model then
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
    end
    if dict then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(10) end
    end
end

-- Funkce pro vytvoření kupce na souřadnicích
function spawnBuyer(coords)
    if buyerBlip then RemoveBlip(buyerBlip) end
    if buyerPed then DeleteEntity(buyerPed) end

    -- Vytvoření GPS
    buyerBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(buyerBlip, 500)
    SetBlipColour(buyerBlip, 5)
    SetBlipScale(buyerBlip, 1.0)
    SetBlipRoute(buyerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Prekupnik")
    EndTextCommandSetBlipName(buyerBlip)

    ensureAssets(Config.BuyerModel)

    buyerPed = CreatePed(4, Config.BuyerModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    FreezeEntityPosition(buyerPed, true)
    SetEntityInvincible(buyerPed, true)
    SetBlockingOfNonTemporaryEvents(buyerPed, true)

    -- Target na samotného kupce
    exports.ox_target:addLocalEntity(buyerPed, {
        {
            label = 'Prodat klenoty',
            icon = 'fa-solid fa-sack-dollar',
            onSelect = function()
                TriggerServerEvent('kleno_sell:sellItems')
                Wait(500)
                if buyerBlip then RemoveBlip(buyerBlip) end
                TaskWanderStandard(buyerPed, 10.0, 10)
                SetEntityAsNoLongerNeeded(buyerPed)
                buyerPed = nil
            end
        }
    })

    exports.ox_lib:notify({title = 'Prekupnik', description = 'GPS dorazila, pohni si!', type = 'success'})
end

-- Seznam modelů převedený na hashe pro stabilitu
local phoneHashes = {}
for _, modelName in ipairs(Config.PhoneBoxes) do
    phoneHashes[GetHashKey(modelName)] = true
end

CreateThread(function()
    -- Použijeme addGlobalObject, ale s maximálním zabezpečením
    exports.ox_target:addGlobalObject({
        {
            label = 'Zavolat prekupnikovi',
            icon = 'fa-solid fa-phone',
            canInteract = function(entity, distance, coords, name, bone)
                -- 1. Kontrola existence entity
                if not entity or not DoesEntityExist(entity) then return false end
                
                -- 2. Kontrola, zda je to objekt (typ 3)
                if GetEntityType(entity) ~= 3 then return false end

                -- 3. Získání modelu PŘESNĚ a BEZPEČNĚ
                local model = GetEntityModel(entity)
                if not phoneHashes[model] then return false end

                -- 4. Vzdálenost
                if distance > 2.0 then return false end

                return not isCalling
            end,
            onSelect = function()
                TriggerServerEvent('kleno_sell:requestCall')
            end
        }
    })
end)
-- Event pro hovor a dialog
RegisterNetEvent('kleno_sell:startPhoneDialog', function(coords)
    isCalling = true
    local dict = "anim@heists@prison_heiststation@cop_reactions"
    ensureAssets(nil, dict)
    
    TaskPlayAnim(PlayerPedId(), dict, "cop_b_idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    showSubtitle("~b~Hrac:~s~ (Vytacis cislo...)", 3000)
    Wait(3000)
    showSubtitle("~r~Prekupnik:~s~ Kdo ses a proc me otravujes? ... No dobre, poslu ti GPS.", 4000)
    Wait(4000)
    
    StopAnimTask(PlayerPedId(), dict, "cop_b_idle", 1.0)
    isCalling = false
    spawnBuyer(coords)
end)