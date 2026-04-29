local isUIOpen = false
local currentRegister = nil

Citizen.CreateThread(function()
    for registerName, data in pairs(Config.Registers) do
        
        -- Pomocná funkce pro vytvoření zóny
        local function createRegisterZone(coords, radius)
            exports.ox_target:addSphereZone({
                coords = coords,
                radius = radius,
                debug = false,
                options = {
                    {
                        name = 'open_register_' .. registerName,
                        icon = "fas fa-cash-register",
                        label = data.label,
                        onSelect = function()
                            -- VOLÁME TVOJI FUNKCI OpenPOS
                            OpenPOS(registerName) 
                        end,
                        -- Kontrola jobu a ranku přímo v targetu
                        groups = { [data.job] = data.grade }
                    }
                }
            })
        end

        -- Kontrola, zda má pokladna více slotů (locations) nebo jen jeden (coords)
        if data.locations and type(data.locations) == "table" then
            for i, loc in ipairs(data.locations) do
                createRegisterZone(loc.coords, loc.radius or data.targetRadius)
            end
        elseif data.coords then
            createRegisterZone(data.coords, data.targetRadius)
        end

    end
end)

function OpenPOS(name)
    if isUIOpen then return end
    
    local regData = Config.Registers[name]
    currentRegister = name

    -- Animace tabletu (vyžaduje standardní anim list, případně uprav)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_TOURIST_MAP", 0, false)
    
    isUIOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "display",
        label = regData.label,
        items = regData.items,
        currency = Config.Currency
    })
end

-- Callbacky z NUI
RegisterNUICallback("closeUI", function(data, cb)
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    isUIOpen = false
    cb('ok') -- <--- Tohle je extrémně důležité!
end)

RegisterNUICallback("confirmPayment", function(data, cb)
    if data.targetId ~= nil then
        TriggerServerEvent("gemini_pos:processPayment", data, currentRegister, data.method)
    end
    cb('ok')
end)

RegisterNetEvent('gemini_pos:client:showReceipt')
AddEventHandler('gemini_pos:client:showReceipt', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage(data)
end)

RegisterNUICallback("closeReceipt", function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('gemini_pos:client:createInvoiceBridge')
AddEventHandler('gemini_pos:client:createInvoiceBridge', function(targetId, amount, reason)
    -- Převedeme na čísla a text přesně podle toho, co billing chce
    local tId = tonumber(targetId)
    local amt = tonumber(amount)
    local desc = tostring(reason) or "Faktura STK"

    print("^2[POS DEBUG] Posílám do CZW_BILLING: ID " .. tId .. ", Částka " .. amt .. "^7")

    -- VOLÁME PŘESNĚ TEN EVENT, KTERÝ JSI MI POSLAL
    TriggerServerEvent('czw_billing:createBill', tId, amt, desc)
end)

RegisterNUICallback('processPayment', function(data, cb)
    -- currentRegisterName musí být definováno při otevření tabletu
    TriggerServerEvent('gemini_pos:processPayment', data, currentRegisterName, data.paymentMethod)
    
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Pokud se ti sekne myš nebo tablet, napiš /posfix
RegisterCommand('posfix', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideAll" }) -- Volitelné: schová všechna UI
    ESX.ShowNotification('~g~Ovládání pokladny bylo restartováno.')
end, false)

RegisterNetEvent('d_pos:client:showReceipt')
AddEventHandler('d_pos:client:showReceipt', function(data)
    -- Počkáme zlomek sekundy, než se HTML "nadechne"
    Wait(50) 
    
    SendNUIMessage({
        action = "showReceipt",
        shop = data.shop,
        items = data.items,
        total = data.total,
        currency = data.currency
    })

    -- Vynutíme kurzor i focus
    SetNuiFocus(true, true)
end)