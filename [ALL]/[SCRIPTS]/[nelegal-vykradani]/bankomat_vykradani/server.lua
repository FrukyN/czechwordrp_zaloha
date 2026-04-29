local ESX = exports["es_extended"]:getSharedObject()
local atmCooldowns = {}

-- === PŘIDANÁ KONFIGURACE ===
local minPolice = 3 -- Počet policistů potřebných pro vykradení

-- === PŘIDANÁ FUNKCE PRO KONTROLU POLICIE ===
local function getOnlinePolice()
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    return #xPlayers
end

-- Kontrola itemu a cooldownu
lib.callback.register('atm_robbery:canRob', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return "error" end

    -- 1. KONTROLA POLICIE
    local policeCount = getOnlinePolice()
    if policeCount < minPolice then
        return "no_police"
    end

    -- Kontrola itemu hacking_device (opraven název v uvozovkách na tvůj hackingdevice)
    local item = xPlayer.getInventoryItem('hackingdevice')
    if not item or item.count <= 0 then
        return "no_item"
    end

    -- Cooldown kontrola (např. 15 minut mezi vykrádáním)
    local identifier = xPlayer.getIdentifier()
    if atmCooldowns[identifier] and os.time() < atmCooldowns[identifier] then
        return "cooldown"
    end

    return "success"
end)

-- Volání policie (CD_Dispatch)
RegisterNetEvent('atm_robbery:callPolice', function(coords)
    TriggerClientEvent('cd_dispatch:AddNotification', -1, {
        job_table = {'police'},
        coords = coords,
        title = 'Napadení ATM',
        message = 'Detekován neoprávněný pokus o přístup k bankomatu!',
        flash = 0, -- Změněno z 1 na 0 (vypne blikání HUDu)
        unique_id = tostring(math.random(1111, 9999)),
        blip = {
            sprite = 500, 
            scale = 1.2, 
            color = 1, -- Barva blipu na mapě (1 = červená)
            flashes = true, -- Bliká pouze blip na mapě, ne celá obrazovka
            text = 'Alarm ATM', 
            time = 5
        }
    })
end)

-- Odměna
RegisterNetEvent('atm_robbery:reward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Nastavení cooldownu na 15 minut
    atmCooldowns[xPlayer.getIdentifier()] = os.time() + (15 * 60)

    -- Náhodná odměna v černých penězích
    local amount = math.random(5000, 15000)
    xPlayer.addAccountMoney('black_money', amount)

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Úspěch',
        description = ('Bankomat vydal %s Kč v neznačených bankovkách.'):format(amount),
        type = 'success'
    })
end)

-- Šance na rozbití itemu při failu
RegisterNetEvent('atm_robbery:breakDevice', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if math.random(1, 100) <= 35 then -- 35% šance na zničení při failu
        xPlayer.removeInventoryItem('hackingdevice', 1)
        TriggerClientEvent('ox_lib:notify', src, { title = 'Hardware Error', description = 'Tvoje zařízení se spálilo!', type = 'error' })
    end
end)