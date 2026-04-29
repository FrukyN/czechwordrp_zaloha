local ESX = exports["es_extended"]:getSharedObject()
local playerCooldowns = {} 

-- KONFIGURACE
local MIN_POLICE = 0       -- Minimální počet poldů online
local COOLDOWN_TIME = 3600 -- 1 hodina v sekundách

-- Callback pro klienta (Kontrola před zobrazením dopisu)
lib.callback.register('chopshop:server:checkCooldown', function(source)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    
    -- Úprava podle tvého funkčního vzoru
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    if #xPlayers < MIN_POLICE then
        return "no_police" 
    end

    -- Kontrola cooldownu
    if playerCooldowns[identifier] and playerCooldowns[identifier] > os.time() then
        local remainingSeconds = playerCooldowns[identifier] - os.time()
        return math.ceil(remainingSeconds / 60)
    end
    
    return 0 -- Vše OK
end)

-- Spuštění práce
RegisterNetEvent('chopshop:server:startJob', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    
    -- Kontrola policie při startu
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    if #xPlayers < MIN_POLICE then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Chop Shop', 
            description = ('Ve městě není dostatek hlídek (%s/%s)'):format(#xPlayers, MIN_POLICE), 
            type = 'error'
        })
        return
    end

    -- Kontrola cooldownu
    if playerCooldowns[identifier] and playerCooldowns[identifier] > os.time() then
        return 
    end

    playerCooldowns[identifier] = os.time() + COOLDOWN_TIME
    TriggerClientEvent('chopshop:client:spawnVehicle', src)
end)

-- Rozdávání itemů po každé minihře
RegisterNetEvent('chopshop:server:givePhaseItems', function(phase)
    local src = source
    if phase == 1 then
        exports.ox_inventory:AddItem(src, 'car_door', 2)
        exports.ox_inventory:AddItem(src, 'car_hood', 1)
        exports.ox_inventory:AddItem(src, 'car_trunk', 1)
    elseif phase == 2 then
        exports.ox_inventory:AddItem(src, 'fluid_canister', 3)
    elseif phase == 3 then
        exports.ox_inventory:AddItem(src, 'car_electronics', 1)
        exports.ox_inventory:AddItem(src, 'car_seat', 2)
    end
end)

-- Výkup u NPC
RegisterNetEvent('chopshop:server:sellAll', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local itemsToSell = {
        ['car_door'] = 1000,
        ['car_hood'] = 1500,
        ['car_trunk'] = 800,
        ['car_seat'] = 1800,
        ['fluid_canister'] = 800,
        ['car_electronics'] = 2000
    }
    
    local totalPayout = 0

    for itemName, price in pairs(itemsToSell) do
        local count = exports.ox_inventory:GetItem(src, itemName, nil, true)
        if count > 0 then
            totalPayout = totalPayout + (count * price)
            exports.ox_inventory:RemoveItem(src, itemName, count)
        end
    end

    if totalPayout > 0 then
        xPlayer.addAccountMoney('black_money', totalPayout)
        TriggerClientEvent('ox_lib:notify', src, {title = 'Dealer', description = ('Dobrá práce, tady máš $%s.'):format(totalPayout), type = 'success'})
    else
        TriggerClientEvent('ox_lib:notify', src, {title = 'Dealer', description = 'Nemáš u sebe nic, co bych chtěl.', type = 'error'})
    end
end)