local currentRecipe = nil
local currentStep = 0 
local pizzaObject = nil
local cam = nil
local PIZZA_JOB = 'pizza' -- Pokud se tvůj job v DB jmenuje 'piyya', přepiš to sem
local rollingPinObject = nil
local carryingPizza = false

local Config = {
    Book = vec3(-1341.273193,-1060.172852,7.769375),      -- Kniha receptů
    DoughBox = vec3(-1339.869873,-1062.748047,7.406026),  -- Tác s těsty
    Table = vec3(-1336.804443,-1060.909546,7.411199),     -- Pracovní vál
    Oven = vec3(-1339.060669,-1061.821777,6.734329)       -- Pec
}

-- Ovládání kamery
function ManagePizzaCam(state)
    if state then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, Config.Table.x, Config.Table.y, Config.Table.z + 1.2)
        PointCamAtCoord(cam, Config.Table.x, Config.Table.y, Config.Table.z)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1200, true, true)
    else
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(cam, false)
    end
end

-- UI KNIHA RECEPTŮ
function OpenPizzaCookbook()
    lib.registerContext({
        id = 'pizza_book',
        title = '🇮🇹 La Cucina Italiana',
        options = {
            { title = 'Margherita', image = 'https://i.imgur.com/8L8n8Gj.png', onSelect = function() ShowRecipePage('margherita', 'Margherita', 'Sugo, mozzarella, čerstvá bazalka.') end },
            { title = 'Marinara', image = 'https://i.imgur.com/8L8n8Gj.png', onSelect = function() ShowRecipePage('marinara', 'Marinara', 'Sugo, česnek, oregano.') end },
            { title = 'Quattro Formaggi', image = 'https://i.imgur.com/GzLz9zG.png', onSelect = function() ShowRecipePage('quattroformaggi', 'Quattro Formaggi', 'Čtyři druhy sýra.') end },
            { title = 'Capricciosa', image = 'https://i.imgur.com/8L8n8Gj.png', onSelect = function() ShowRecipePage('capricciosa', 'Capricciosa', 'Šunka, žampiony, artyčoky a olivy.') end },
            { title = 'Quattro Stagioni', image = 'https://i.imgur.com/8L8n8Gj.png', onSelect = function() ShowRecipePage('quattrostagioni', 'Quattro Stagioni', 'Rozdělené čtvrtiny.') end },
            { title = 'Diavola', image = 'https://i.imgur.com/pZ6J9zG.png', onSelect = function() ShowRecipePage('diavola', 'Diavola', 'Pikantní salám a pálivé papričky.') end },
        }
    })
    lib.showContext('pizza_book')
end

function ShowRecipePage(id, name, text)
    local alert = lib.alertDialog({
        header = '📖 RECEPT: ' .. string.upper(name),
        content = text .. '\n\n---\n**POSTUP:** Vezmi těsto -> Rozválej -> Ingredience -> Pec.',
        centered = true, cancel = true
    })
    if alert == 'confirm' then
        currentRecipe = id
        currentStep = 1
        lib.notify({title = 'Pizzerie', description = 'Recept vybrán. Jdi pro těsto.', type = 'inform'})
    end
end

-- Pomocná funkce pro načítání modelů
function LoadModel(model)
    local hash = type(model) == "number" and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then 
        print("^1Chyba: Model " .. model .. " neexistuje v souborech hry!^7")
        return false 
    end
    RequestModel(hash)
    local timeout = 1000
    while not HasModelLoaded(hash) and timeout > 0 do
        Wait(10)
        timeout = timeout - 1
    end
    return HasModelLoaded(hash)
end

-- TARGETY
exports.ox_target:addSphereZone({
    coords = Config.Book, radius = 0.5,
    options = {{ 
        label = 'Otevřít kuchařku', 
        icon = 'fa-solid fa-book', 
        groups = PIZZA_JOB,
        onSelect = function() OpenPizzaCookbook() end 
    }}
})

exports.ox_target:addSphereZone({
    coords = Config.DoughBox, radius = 0.5,
    options = {{
        label = 'Vzít těsto', icon = 'fa-solid fa-circle',
        groups = PIZZA_JOB,
        onSelect = function()
            if currentStep == 1 then
                if lib.progressBar({ duration = 2500, label = 'Bereš těsto...', anim = {dict = 'anim@heists@box_carry@', clip = 'idle'}}) then
                    TriggerServerEvent('pizzeria:server:removeItem', 'pizza_dough')
                    currentStep = 2
                end
            else
                lib.notify({description = 'Nejdřív si vyber recept!', type = 'error'})
            end
        end
    }}
})

exports.ox_target:addSphereZone({
    coords = Config.Table, radius = 0.6,
    options = {{
        label = 'Rozválet a složit', icon = 'fa-solid fa-hand-fist',
        groups = PIZZA_JOB,
        onSelect = function()
            if currentStep == 2 then
                local count = exports.ox_inventory:Search('count', 'pizza_ingredients')
                if count > 0 then StartPizzaMaking() else lib.notify({description = 'Chybí ti ingredience!', type = 'error'}) end
            end
        end
    }}
})

function StartPizzaMaking()
    local testDough = `v_res_fa_bread03` 
    local testPin = `prop_tool_hammer`   

    if not LoadModel(testDough) then print("^1Těsto selhalo^7") end
    if not LoadModel(testPin) then print("^1Váleček selhal^7") end

    ManagePizzaCam(true)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)

    pizzaObject = CreateObject(testDough, Config.Table.x, Config.Table.y, Config.Table.z, true, true, true)
    SetEntityHeading(pizzaObject, 0.0)
    PlaceObjectOnGroundProperly(pizzaObject)

    rollingPinObject = CreateObject(testPin, 0.0, 0.0, 0.0, true, true, true)
    AttachEntityToEntity(rollingPinObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.1, 0.0, 0.0, 80.0, 0.0, 0.0, true, true, false, true, 1, true)

    lib.notify({title = 'VÁLENÍ', description = 'Mačkej [E] pro válení!', type = 'inform'})
    
    local rolls = 0
    lib.requestAnimDict("amb@prop_human_bbq@male@base")
    
    while rolls < 10 do
        Wait(0)
        if IsControlJustPressed(0, 38) then
            rolls = rolls + 1
            TaskPlayAnim(playerPed, "amb@prop_human_bbq@male@base", "base", 8.0, 8.0, -1, 50, 0, false, false, false)
        end
    end

    lib.notify({title = 'PŘÍPRAVA', description = 'Skládáš ingredience...', type = 'inform'})
    
    if DoesEntityExist(rollingPinObject) then DeleteObject(rollingPinObject) end
    rollingPinObject = nil
    Wait(4000)

    TriggerServerEvent('pizzeria:server:removeItem', 'pizza_ingredients')
    if DoesEntityExist(pizzaObject) then DeleteObject(pizzaObject) end
    pizzaObject = nil
    
    ManagePizzaCam(false)
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(playerPed)
    
    currentStep = 3
    lib.notify({title = 'Hotovo', description = 'Pizza je připravená!', type = 'success'})
end

exports.ox_target:addSphereZone({
    coords = Config.Oven, radius = 0.8,
    options = {
        { 
            label = 'Dát do pece', icon = 'fa-solid fa-fire', groups = PIZZA_JOB,
            onSelect = function() 
                if currentStep == 3 then 
                    TriggerServerEvent('pizzeria:server:startBaking', currentRecipe) 
                    currentStep = 0
                else
                    lib.notify({description = 'Nemáš připravenou pizzu!', type = 'error'})
                end 
            end 
        },
        { 
            label = 'Vyndat pizzu', icon = 'fa-solid fa-utensils', groups = PIZZA_JOB, 
            onSelect = function() 
                TriggerServerEvent('pizzeria:server:collectPizza') 
            end 
        }
    }
})

-- NUI EVENTY PRO MINUTKU
RegisterNetEvent('pizzeria:client:startTimerUI', function(duration, recipeName)
    SendNUIMessage({
        action = 'start_timer',
        duration = duration,
        label = recipeName:upper()
    })
end)

RegisterNetEvent('pizzeria:client:stopTimerUI', function()
    SendNUIMessage({
        action = 'stop_timer'
    })
end)

RegisterNetEvent('pizzeria:client:carryPizzaBox', function()
    print("DEBUG: Event carryPizzaBox dorazil na klienta!") -- Tohle uvidíš v F8
    carryingPizza = true 
    
    local playerPed = PlayerPedId()
    LoadModel(`prop_pizza_box_02`)
    pizzaBoxProp = CreateObject(`prop_pizza_box_02`, 0, 0, 0, true, true, true)
    AttachEntityToEntity(pizzaBoxProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.1, 0.08, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
    
    lib.requestAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 51, 0, false, false, false)
end)

-- 2. TABULKA STOLŮ (Opravená ID)
local ServingPoints = {
    { id = 1, coords = vec3(-1344.855347,-1065.333374,7.312591), label = 'Hlavní pult' },
    { id = 2, coords = vec3(-1349.011108,-1069.643677,7.237217), label = 'Stůl u okna' },
    { id = 3, coords = vec3(-1347.723755,-1071.684692,7.233799), label = 'Stůl 1' },
    { id = 4, coords = vec3(-1344.168701,-1069.681519,7.233799), label = 'Stůl 2' },
    { id = 5, coords = vec3(-1342.242188,-1068.261230,7.238194), label = 'Stůl 3' },
    { id = 6, coords = vec3(-1344.767578,-1074.717285,6.796314), label = 'Stůl 4' },
    { id = 7, coords = vec3(-1344.821899,-1075.012817,6.796314), label = 'Stůl 5' },            
    { id = 8, coords = vec3(-1342.721069,-1073.352295,6.796314), label = 'Stůl 6' },
    { id = 9, coords = vec3(-1340.623535,-1072.076294,6.796314), label = 'Stůl 7' },
}

-- 3. REGISTRACE TARGETŮ (Zůstává stejná, ale díky přesunu eventu bude stabilnější)
for _, point in ipairs(ServingPoints) do
    exports.ox_target:addSphereZone({
        coords = point.coords,
        radius = 0.8,
        options = {
            {
                label = 'Servírovat pizzu ('..point.label..')',
                icon = 'fa-solid fa-bell',
                groups = PIZZA_JOB,
                canInteract = function() 
                    return carryingPizza -- Kontroluje, zda kuchař nese krabici
                end,
onSelect = function()
    if lib.progressBar({ duration = 2000, label = 'Servíruješ...', useWhileDead = false, canCancel = true }) then
        -- Smažeme vizuální krabici z ruky
        if DoesEntityExist(pizzaBoxProp) then 
            DeleteObject(pizzaBoxProp) 
            pizzaBoxProp = nil
        end
        
        ClearPedTasks(PlayerPedId())
        carryingPizza = false -- Přepneme stav, že už nic neneseme
        
        -- POSÍLÁME ID STOLU NA SERVER
        TriggerServerEvent('pizzeria:server:serveOnCounter', point.id)
    end
end
            },
            {
                label = 'Vzít si pizzu',
                icon = 'fa-solid fa-pizza-slice',
                onSelect = function()
                    TriggerServerEvent('pizzeria:server:customerTakePizza', point.id)
                end
            }
        }
    })
end