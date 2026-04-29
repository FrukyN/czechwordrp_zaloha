local carryBagProp = nil
local placedBagObject = nil

-- Sebrání batohu v nemocnici / z auta
function TakeMedicBag()
    local playerPed = PlayerPedId()
    local model = `prop_ld_health_pack` -- Můžeš změnit na jiný MedicBag prop
    
    ESX.Streaming.RequestModel(model, function()
        carryBagProp = CreateObject(model, 0, 0, 0, true, true, true)
        AttachEntityToEntity(carryBagProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, 0.0, 0.0, 266.0, 0.0, true, true, false, true, 1, true)
        ESX.ShowNotification("Neseš zdravotnický batoh. Použij /polozbag pro položení.")
    end)
end

RegisterCommand('getbag', function()
    TakeMedicBag() -- Zavolá funkci, která vytvoří objekt a připne ho na ruku
end)

-- Položení batohu na zem
RegisterCommand('polozbag', function()
    if carryBagProp then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local forward = GetEntityForwardVector(playerPed)
        local x, y, z = table.unpack(coords + forward * 0.5)

        DetachEntity(carryBagProp, true, true)
        SetEntityCoords(carryBagProp, x, y, z - 1.0)
        PlaceObjectOnGroundProperly(carryBagProp)
        FreezeEntityPosition(carryBagProp, true)
        
        placedBagObject = carryBagProp
        carryBagProp = nil

        -- Přidání OX-Target na položený batoh
        exports.ox_target:addLocalEntity(placedBagObject, {
            {
                name = 'open_medic_bag',
                icon = 'fas fa-briefcase_medical',
                label = 'Otevřít zdravotnický batoh',
onSelect = function()
    -- Místo OpenBagInventory() použijeme toto:
    SendNUIMessage({
        type = "openBagUI"
    })
    SetNuiFocus(true, true) -- Musíme zapnout myš, aby se dalo v batohu klikat
end
            },
            {
                name = 'pick_up_bag',
                icon = 'fas fa-hand-holding',
                label = 'Sebrat batoh',
                onSelect = function()
                    DeleteEntity(placedBagObject)
                    TakeMedicBag()
                end
            }
        })
    end
end)

RegisterCommand('schovajbag', function()
    if carryBagProp ~= nil then
        DeleteEntity(carryBagProp)
        carryBagProp = nil
        ESX.ShowNotification("~g~Batoh byl uklizen.")
    else
        ESX.ShowNotification("~r~Nemáš co schovat.")
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        -- Pokud hráč umře nebo upadne do ragdollu, batoh zmizí z ruky
        if IsEntityDead(ped) or IsPedRagdoll(ped) then
            if carryBagProp ~= nil then
                DeleteEntity(carryBagProp)
                carryBagProp = nil
            end
        end
    end
end)