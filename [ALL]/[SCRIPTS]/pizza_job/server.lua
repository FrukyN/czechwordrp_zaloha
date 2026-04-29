local OX = exports.ox_inventory
local BakingPizzas = {}
local TablesWithPizza = {} -- Tabulka: [ID stolu] = "název_pizzy"
local PizzasInHands = {}
local TablesWithPizza = {} -- Tabulka pro uložení pizzy na stolech

-- Event pro odebírání surovin
RegisterNetEvent('pizzeria:server:removeItem', function(itemName)
    local src = source
    OX:RemoveItem(src, itemName, 1)
end)

-- Event pro spuštění pečení
RegisterNetEvent('pizzeria:server:startBaking', function(recipeType)
    local src = source
    local duration = 60 -- Čas v sekundách (3 minuty)
    
    -- Uložení dat o pečení
    BakingPizzas[src] = { 
        finish = os.time() + duration, 
        type = recipeType 
    }

    -- SPUŠTĚNÍ NUI MINUTKY NA KLIENTU
    -- Posíláme čas a název receptu pro zobrazení v UI
    TriggerClientEvent('pizzeria:client:startTimerUI', src, duration, recipeType:upper())
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'PEC', 
        description = 'Pizza vložena do pece.', 
        type = 'inform',
        icon = 'fire'
    })
end)

-- Event pro vyzdvihnutí hotové pizzy
RegisterNetEvent('pizzeria:server:collectPizza', function()
    local src = source
    local data = BakingPizzas[src]
    
    if not data then 
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'V peci nic nemáš!', 
            type = 'error'
        })
        return 
    end

    if os.time() >= data.finish then
        -- KONTROLA MÍSTA V INVENTÁŘI (volitelné, ale doporučené)
        local itemToGive = 'pizza_' .. data.type
        if OX:CanCarryItem(src, itemToGive, 1) then
            OX:AddItem(src, itemToGive, 1)
            BakingPizzas[src] = nil
            
            -- TADY PŘIDÁVÁME POTŘEBNÉ PROPOJENÍ --
            PizzasInHands[src] = itemToGive -- Uložíme, co hráč nese
            TriggerClientEvent('pizzeria:client:carryPizzaBox', src) -- Spustíme animaci krabice
            --------------------------------------

            -- ZASTAVENÍ NUI MINUTKY (schování UI)
            TriggerClientEvent('pizzeria:client:stopTimerUI', src)
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Šéfkuchař', 
                description = 'Pizza je hotová a zabalená!', 
                type = 'success',
                icon = 'utensils'
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                description = 'Máš plné kapsy!', 
                type = 'error'
            })
        end
    else
        local remaining = data.finish - os.time()
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'Ještě to není! Zbývá '..remaining..' s.', 
            type = 'warning',
            icon = 'clock'
        })
    end
end)

RegisterNetEvent('pizzeria:server:collectPizza', function()
    local src = source
    local data = BakingPizzas[src]
    
    if not data then 
        print("^1[DEBUG] Hráč " .. src .. " zkusil vyndat pizzu, ale v tabulce pečení nic nemá!^7")
        return 
    end

    if os.time() >= data.finish then
        local itemToGive = 'pizza_' .. data.type
        print("^2[DEBUG] Pokouším se dát item: " .. itemToGive .. " hráči " .. src .. "^7")

        -- Zkusíme přidat item
        local success = OX:AddItem(src, itemToGive, 1)
        
        if success then
            BakingPizzas[src] = nil
            
            -- TOTO JE TO KLÍČOVÉ DOPLNĚNÍ --
            PizzasInHands[src] = itemToGive 
            --------------------------------
            
            print("^2[DEBUG] Item předán, spouštím animaci krabice.^7")
            TriggerClientEvent('pizzeria:client:stopTimerUI', src)
            TriggerClientEvent('pizzeria:client:carryPizzaBox', src)
        else
            print("^1[DEBUG] Selhalo AddItem pro " .. itemToGive .. ". Má hráč místo? Existuje item v items.lua?^7")
            TriggerClientEvent('ox_lib:notify', src, {title = 'Chyba', description = 'Nepodařilo se vzít pizzu (plno/neznámý item)', type = 'error'})
        end
    else
        local remaining = data.finish - os.time()
        TriggerClientEvent('ox_lib:notify', src, {description = 'Ještě se peče! Zbývá '..remaining..'s', type = 'warning'})
    end
end)

RegisterNetEvent('pizzeria:server:serveOnCounter', function(pointId)
    local src = source
    local pizzaType = PizzasInHands[src] -- Tady si to server vytáhne z paměti

    if pizzaType then
        if OX:RemoveItem(src, pizzaType, 1) then
            TablesWithPizza[pointId] = pizzaType -- Tady se to zapíše pro zákazníka
            PizzasInHands[src] = nil -- Tady se to smaže kuchaři z rukou
            TriggerClientEvent('ox_lib:notify', src, {description = 'Servírováno!', type = 'success'})
        end
    else
        -- Tuhle chybu jsi viděl:
        TriggerClientEvent('ox_lib:notify', src, {description = 'Server neví, co neseš!', type = 'error'})
    end
end)

-- Event pro položení na KONKRÉTNÍ stůl
RegisterNetEvent('pizzeria:server:serveOnCounter', function(pointId)
    local src = source
    local pizzaType = PizzasInHands[src] -- Zjistíme, co hráč nese (např. 'pizza_margherita')

    if pizzaType then
        -- 1. ODEBEREME ITEM Z INVENTÁŘE
        local removed = OX:RemoveItem(src, pizzaType, 1)
        
        if removed then
            -- 2. ZAPÍŠEME PIZZU NA STŮL
            TablesWithPizza[pointId] = pizzaType
            PizzasInHands[src] = nil -- Už ji nemá v rukách
            
            TriggerClientEvent('ox_lib:notify', src, {
                description = 'Pizza položena na stůl č. '..pointId, 
                type = 'success'
            })
        end
    else
        -- Pokud se tohle vypíše, server zapomněl, co neseš
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'Chyba: Server neví, jakou pizzu neseš!', 
            type = 'error'
        })
    end
end)

-- Zákazník bere z KONKRÉTNÍHO stolu
RegisterNetEvent('pizzeria:server:customerTakePizza', function(pointId)
    local src = source
    local pizzaToTake = TablesWithPizza[pointId]

    if pizzaToTake then
        -- Zkontrolujeme, jestli zákazník unese pizzu
        if OX:CanCarryItem(src, pizzaToTake, 1) then
            OX:AddItem(src, pizzaToTake, 1)
            
            -- 3. SMAŽEME PIZZU ZE STOLU (už tam neleží)
            TablesWithPizza[pointId] = nil
            
            TriggerClientEvent('ox_lib:notify', src, {
                description = 'Vzal jsi si pizzu ze stolu.', 
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                description = 'Máš moc těžké kapsy!', 
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'Na tomto stole nic není.', 
            type = 'error'
        })
    end
end)