local ESX = exports["es_extended"]:getSharedObject()
local basketItems = {}
local hasBasket = false
local basketObj = nil

-- 1. Vzetí košíku
exports.ox_target:addBoxZone({
    coords = Config.Locations.BasketPickup,
    size = vec3(1.2, 1.2, 1.2),
    options = {
        {
            label = "Vzít nákupní košík",
            icon = "fa-solid fa-basket-shopping",
            onSelect = function()
                if hasBasket then return end
                lib.requestModel(Config.BasketProp)
                basketObj = CreateObject(Config.BasketProp, 0, 0, 0, true, true, true)
                
                -- Bone 57005 je pravá ruka
                AttachEntityToEntity(basketObj, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.1, 0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
                
                hasBasket = true
                SendNUIMessage({ action = "showUI" })
                lib.notify({title = 'Tesco', description = 'Vzal jsi si košík', type = 'inform'})
            end
        }
    }
})

-- 2. Interakce s regály
for _, dept in ipairs(Config.Departments) do
    exports.ox_target:addBoxZone({
        coords = dept.coords,
        options = {
            {
                label = "Prohlédnout " .. dept.label,
                icon = dept.icon,
                groups = dept.groups,
                onSelect = function()
                    if not hasBasket then 
                        return lib.notify({description = 'Potřebuješ košík!', type = 'error'}) 
                    end
                    
                    if dept.isFrozen then
                        -- Efekt mrazu (pára)
                        lib.requestNamedPtfxAsset("core")
                        UseParticleFxAssetNextCall("core")
                        StartNetworkedParticleFxNonLoopedAtCoord("ent_ae_smoke_out", dept.coords, 0.0, 0.0, 0.0, 0.8, false, false, false)
                    end

                    local options = {}
                    for _, v in ipairs(dept.items) do
                        table.insert(options, {
                            title = v.label,
                            description = "Cena: " .. v.price .. " " .. Config.Currency,
                            onSelect = function()
                                table.insert(basketItems, v)
                                SendNUIMessage({ action = "addItem", item = v })
                            end
                        })
                    end
                    lib.registerContext({ id = 'tesco_menu', title = dept.label, options = options })
                    lib.showContext('tesco_menu')
                end
            }
        }
    })
end

-- 3. Interakce u pokladny (Zákazník i Prodavač)
exports.ox_target:addBoxZone({
    coords = Config.Locations.Counter,
    size = vec3(1.5, 1.5, 1.2),
    options = {
        {
            -- ZÁKAZNÍK
            label = "Položit nákup na pás",
            icon = "fa-solid fa-hand-holding-box",
            canInteract = function() 
                return hasBasket and #basketItems > 0 
            end,
            onSelect = function()
                lib.requestAnimDict("anim@heists@money_grab@duffel")
                TaskPlayAnim(cache.ped, "anim@heists@money_grab@duffel", "place_cabinet", 8.0, -8.0, 1000, 1, 0, false, false, false)
                
                Wait(1000)
                
                TriggerServerEvent('tesco:placeItemsOnCounter', basketItems)
                TriggerEvent('tesco:reset') 
                lib.notify({title = 'Tesco', description = 'Nákup je na pásu, počkej na prodavače.', type = 'inform'})
            end
        },
        {
            -- PRODAVAČ
            label = "Otevřít pokladnu (Obsluha)",
            icon = "fa-solid fa-cash-register",
            groups = Config.CashierJob,
            onSelect = function()
                local input = lib.inputDialog('Tesco Pokladna', {
                    { type = 'number', label = 'ID Zákazníka', icon = 'user', required = true, min = 1 },
                })

                if not input or not input[1] then return end
                TriggerServerEvent('tesco:openRegister', input[1])
            end
        }
    }
})

-- 4. Eventy
RegisterNetEvent('tesco:reset')
AddEventHandler('tesco:reset', function()
    basketItems = {}
    hasBasket = false
    if DoesEntityExist(basketObj) then DeleteEntity(basketObj) end
    SendNUIMessage({ action = "hideUI" })
end)

-- PRO ZÁKAZNÍKA: Přijetí účtu (Opraveno - sjednoceno)
RegisterNetEvent('tesco:client:receiveBill')
AddEventHandler('tesco:client:receiveBill', function(total, items, cashierId)
    local alert = lib.alertDialog({
        header = 'Tesco Pokladna',
        content = 'Prodavač (ID: '..cashierId..') naskenoval váš nákup. \n\n Celková cena: **' .. total .. ' Kč**',
        centered = true,
        cancel = true,
        labels = {confirm = 'Zaplatit', cancel = 'Odmítnout'}
    })

    if alert == 'confirm' then
        TriggerServerEvent('tesco:server:finalPayment', total, items)
    else
        lib.notify({description = 'Odmítl jsi zaplatit. Nákup zůstal na pásu.', type = 'error'})
    end
end)

-- PRO PRODAVAČE: Menu se seznamem věcí
RegisterNetEvent('tesco:client:openCashierMenu')
AddEventHandler('tesco:client:openCashierMenu', function(options, targetId, total, items)
    table.insert(options, {
        title = "VYSTAVIT ÚČET",
        description = "Celkem k úhradě: " .. total .. " Kč",
        icon = "money-bill-wave",
        onSelect = function()
            TriggerServerEvent('tesco:server:requestFinalPayment', targetId, total, items)
            lib.notify({description = 'Účet odeslán zákazníkovi ID: '..targetId, type = 'success'})
        end
    })

    lib.registerContext({
        id = 'tesco_cashier_menu',
        title = 'Pokladna - Zákazník '..targetId,
        options = options
    })
    lib.showContext('tesco_cashier_menu')
end)