local ESX = exports["es_extended"]:getSharedObject()
local playerAttempts = {}

-- Callback na kontrolu předmětu a cooldownu
lib.callback.register('parking_robbery:canRob', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return "error" end

    local item = xPlayer.getInventoryItem('lockpick')
    if not item or item.count <= 0 then
        return "no_item"
    end

    local identifier = xPlayer.getIdentifier()
    local currentTime = os.time()

    if not playerAttempts[identifier] then
        playerAttempts[identifier] = { count = 0, nextRob = 0 }
    end

    if currentTime < playerAttempts[identifier].nextRob then
        return "cooldown"
    end

    return "success"
end)

-- Event pro odměnu
RegisterNetEvent('parking_robbery:reward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()
    local currentTime = os.time()

    if not playerAttempts[identifier] then
        playerAttempts[identifier] = { count = 0, nextRob = 0 }
    end

    playerAttempts[identifier].count = playerAttempts[identifier].count + 1

    if playerAttempts[identifier].count >= 5 then
        playerAttempts[identifier].nextRob = currentTime + 3600
        playerAttempts[identifier].count = 0
    end

    local reward = math.random(150, 350)
    xPlayer.addMoney(reward)

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Úspěch',
        description = ('Vypáčil jsi %s Kč.'):format(reward),
        type = 'success'
    })
end)

-- EVENT PRO ODEBRÁNÍ LOCKPICKU (Při neúspěchu)
RegisterNetEvent('parking_robbery:breakLockpick', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Odebere 1 kus lockpicku
    xPlayer.removeInventoryItem('lockpick', 1)
end)