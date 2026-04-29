ESX = exports["es_extended"]:getSharedObject()

-- 1. SYNCHRONIZACE DISPATCHE (Z CD_DISPATCH)
-- Tento event zachytí dispatch a rozešle ho všem hráčům
RegisterNetEvent('cd_dispatch:AddNotification')
AddEventHandler('cd_dispatch:AddNotification', function(data)
    -- Kontrola jobů (používáme tvůj Config, pokud ho máš v server.lua načtený)
    if data and (data.job == 'fire' or data.job == 'ambulance' or data.job == 'lsfd') then
        local info = {
            display_code = data.display_code or "150",
            description = data.description or "Poplach",
            street = data.street or "Neznámá lokalita",
            message = data.message or "",
            coords = data.coords
        }
        -- Pošle všem signál k aktivaci alarmu (pro zvuk a obrazovku)
        TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, info)
    end
end)

-- 2. RUČNÍ SYNCHRONIZACE (Z KLIENTA)
-- Pokud cd_dispatch u někoho vyskočí lokálně, tenhle event to přepošle ostatním
RegisterNetEvent('esx_fireDispatch:passToServer')
AddEventHandler('esx_fireDispatch:passToServer', function(data)
    if data then
        TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, data)
    end
end)

-- 3. LOGIKA TISKU LÍSTKU (OPRAVENO)
-- Klient posílá data 'currentDispatch' v tomto eventu
RegisterNetEvent('esx_fireDispatch:printTicket', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not data then 
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Nejsou k dispozici žádná data k tisku!'}) 
    end

    local item = 'dispatch_paper' -- Název itemu v ox_inventory/data/items.lua
    
    -- Metadata pro lístek (tohle se zobrazí v ox_inventory po najetí na item)
    local metadata = {
        label = "Výjezdový lístek - " .. data.display_code,
        description = "Událost: " .. (data.description or "Neznámá") .. "\nMísto: " .. (data.street or data.location or "Neznámé")
    }

    if exports.ox_inventory:CanCarryItem(src, item, 1) then
        exports.ox_inventory:AddItem(src, item, 1, metadata)
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = 'Lístek byl vytisknut.'})
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Nemáš místo v inventáři.'})
    end
end)

-- 4. TESTOVACÍ PŘÍKAZ (ZŮSTÁVÁ)
RegisterCommand('poplach', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        local testData = {
            display_code = "VÝJEZD POTŘEBNÁ ASISTENCE IZS",
            description = "IZS asistence na místě",
            street = "Dle příkazu nadřízených",
            message = "Přivolána pomoc HZS na místo."
        }
        
        print("^2[FireDispatch] " .. xPlayer.getName() .. " spustil testovací poplach pro všechny.^7")
        TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, testData)
    end
end, false)

RegisterNetEvent('esx_fireDispatch:passToServer')
AddEventHandler('esx_fireDispatch:passToServer', function(data)
    -- Server to vezme a "vykřičí" na všechny klienty
    TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, data)
end)