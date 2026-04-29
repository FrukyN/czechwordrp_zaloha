local ESX = exports["es_extended"]:getSharedObject()

-- Funkce pro odeslání logu na Discord
function SendDiscordLog(color, title, message)
    if not Config.DiscordWebhook or Config.DiscordWebhook == "" or Config.DiscordWebhook == "ZDE_VLOZ_URL" then 
        return 
    end

    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "EET POS System | " .. os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }
    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "POS Bot", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Hlavní event pro zpracování platby
RegisterServerEvent("gemini_pos:processPayment")
AddEventHandler("gemini_pos:processPayment", function(data, regName, paymentMethod)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local regData = Config.Registers[regName]
    
    -- 0. BEZPEČNOSTNÍ KONTROLA VZDÁLENOSTI (ANTI-TELEPORT/EXPLOIT)
    if not regData then return end -- Pokud název pokladny nesedí s Configem
    
    local playerPed = GetPlayerPed(_source)
    local playerCoords = GetEntityCoords(playerPed)
    local isNearRegister = false

    -- Kontrola všech slotů (locations) nebo jedné souřadnice (coords)
    if regData.locations then
        for _, loc in ipairs(regData.locations) do
            if #(playerCoords - loc.coords) < 5.0 then
                isNearRegister = true
                break
            end
        end
    elseif regData.coords then
        if #(playerCoords - regData.coords) < 5.0 then
            isNearRegister = true
        end
    end

    if not isNearRegister then
        print(("[SECURITY] Player %s (%s) tried to pay from too far! (POS: %s)"):format(xPlayer.name, xPlayer.identifier, regName))
        TriggerClientEvent('ox_lib:notify', _source, {type = 'error', description = 'Jsi příliš daleko od pokladny!'})
        return
    end

    -- 1. Získání ID zákazníka z UI
    local targetId = tonumber(data.targetId)
    local tPlayer = ESX.GetPlayerFromId(targetId)

    -- 2. Kontrola, jestli hráč existuje
    if not tPlayer then
        TriggerClientEvent('ox_lib:notify', _source, {type = 'error', description = 'Hráč s ID '..tostring(data.targetId)..' není ve městě!'})
        return
    end

    -- 3. Bezpečnostní kontrola jobu
    if xPlayer.job.name ~= regData.job then
        print(("[SECURITY] Player %s tried to use POS for %s!"):format(xPlayer.identifier, regName))
        return
    end

    local amount = tonumber(data.totalAmount)
    local itemsString = ""
    local itemsTable = {} -- Pomocná tabulka pro systém objednávek
    
    -- Ošetření položek pro logy a účtenku
    if data.items and #data.items > 0 then
        for _, item in ipairs(data.items) do
            itemsString = itemsString .. "- " .. item.label .. "\n"
            table.insert(itemsTable, item.label) -- Přidáme název do tabulky pro kuchaře
        end
    else
        itemsString = "Žádné položky (manuální částka)"
        table.insert(itemsTable, "Manuální objednávka")
    end

    -- Tabulka pro vizuální účtenku
    local receiptData = {
        action = "showReceipt",
        shop = regData.label,
        items = data.items,
        total = amount,
        currency = Config.Currency
    }

    -- 4. LOGIKA PLATBY
    if paymentMethod == 'cash' then
        -- PLATBA HOTOVĚ
        if tPlayer.getMoney() >= amount then
            tPlayer.removeMoney(amount)
            
            -- Připsání peněz do society (firmy)
            TriggerEvent('esx_addonaccount:getSharedAccount', regData.societyAccount, function(account)
                if account then
                    account.addMoney(amount)
                else
                    print("^1Chyba: Ucet "..regData.societyAccount.." neexistuje v databazi!^7")
                end
            end)

            -- SYSTÉM OBJEDNÁVEK (PROPOJENÍ) - Pouze pro Pizzerii
            if regData.job == "pizza" then
                TriggerEvent('pizzeria_orders:server:addOrder', itemsTable, tPlayer.source)
            end

            -- Notifikace
            TriggerClientEvent('ox_lib:notify', _source, {type = 'success', description = 'ID '..targetId..' zaplatil '..amount..' '..Config.Currency})
            TriggerClientEvent('ox_lib:notify', tPlayer.source, {type = 'info', description = 'Zaplatil jsi ' .. amount .. ' ' .. Config.Currency .. ' v ' .. regData.label})

            -- ZOBRAZENÍ ÚČTENKY ZÁKAZNÍKOVI
            TriggerClientEvent('gemini_pos:client:showReceipt', tPlayer.source, receiptData)

            -- Discord Log
            SendDiscordLog(65280, "✅ Platba Hotovostí", 
                "**Pokladník:** " .. xPlayer.name .. "\n" ..
                "**Zákazník:** " .. tPlayer.name .. " (ID: "..targetId..")\n" ..
                "**Podnik:** " .. regData.label .. "\n" ..
                "**Částka:** " .. amount .. " " .. Config.Currency .. "\n\n" ..
                "**Položky:**\n" .. itemsString
            )
        else
            TriggerClientEvent('ox_lib:notify', _source, {type = 'error', description = 'Zákazník (ID '..targetId..') nemá dost peněz!'})
            TriggerClientEvent('ox_lib:notify', tPlayer.source, {type = 'error', description = 'Nemáš dost peněz u sebe!'})
        end

    elseif paymentMethod == 'invoice' then
        -- Důležité: Ujistíme se, že máme text pro fakturu
        local reason = (regData and regData.label) or "Faktura - Pokladna"
        
        -- POSÍLÁME POKYN POKLADNÍKOVI (BRIDGE)
        TriggerClientEvent('gemini_pos:client:createInvoiceBridge', _source, targetId, amount, reason)

        -- SYSTÉM OBJEDNÁVEK (PROPOJENÍ) - Pouze pro Pizzerii
        if regData.job == "pizza" then
            TriggerEvent('pizzeria_orders:server:addOrder', itemsTable, tPlayer.source)
        end

        -- Notifikace OX_LIB (vždy se ukáže, i když billing selže)
        TriggerClientEvent('ox_lib:notify', _source, {
            title = 'Pokladna',
            description = 'Faktura pro ID '..targetId..' odeslána!',
            type = 'success'
        })
        
        -- Účtenka pro zákazníka
        if tPlayer then
            TriggerClientEvent('gemini_pos:client:showReceipt', tPlayer.source, receiptData)
        end

        -- Discord Log (přesně podle tvého)
        SendDiscordLog(16776960, "📄 Faktura Vystavena", 
            "**Pokladník:** " .. xPlayer.name .. "\n" ..
            "**Zákazník:** " .. (tPlayer and tPlayer.name or "Neznámý") .. " (ID: "..targetId..")"
        )
    end
end)