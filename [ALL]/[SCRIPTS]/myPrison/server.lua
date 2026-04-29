ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterServerCallback('Jail:getJob', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.job.name)

end)

ESX.RegisterServerCallback('Jail:getGroup', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.group)

end)

ESX.RegisterServerCallback('Jail:getName', function(source, cb, id)

    local xPlayer = ESX.GetPlayerFromId(id)
    cb(xPlayer.name)

end)

RegisterServerEvent('myJail:saveClothes')
AddEventHandler('myJail:saveClothes', function(skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- print('try set ' .. tostring(skin) .. ' for  ' .. xPlayer.name)
    MySQL.Async.execute('UPDATE prison_inmates SET clothes = @clothes WHERE identifier = @identifier', {
        ['@clothes'] = json.encode(skin),
        ['@identifier'] = xPlayer.identifier,
    })
end)

RegisterNetEvent('myJail:saveAllItemsAndWeapons')
AddEventHandler('myJail:saveAllItemsAndWeapons', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inv = xPlayer.inventory
    local weapons = xPlayer.loadout

    if Config.useQSInventory ~= nil and Config.useQSInventory then
        exports['qs-inventory']:ClearInventory(xPlayer.source)
        local weapons = exports['qs-inventory']:GetWeaponList()
        for k,v in pairs(weapons) do
            xPlayer.removeInventoryItem(v.name, 1)
        end
    else
        local invOptimized = {}
        for k, v in pairs(inv) do
            if v.count ~= 0 then
                xPlayer.removeInventoryItem(v.name, v.count)
                table.insert(invOptimized, v)
            end
        end
    
        for k, v in pairs(weapons) do
            xPlayer.removeWeapon(v.name)
        end
    
        MySQL.Async.execute('UPDATE prison_inmates SET items = @items, weapons = @weapons WHERE identifier = @identifier', {
            ['@items'] = json.encode(invOptimized),
            ['@weapons'] = json.encode(weapons),
            ['@identifier'] = xPlayer.identifier,
        })
    end



end)

ESX.RegisterServerCallback('myJail:checkCopAmount', function (source, cb)
    local xPlayers = ESX.GetPlayers()

	local cops = 0
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer ~= nil then
            for k, jobname in pairs(Config.policeJobs) do
                if xPlayer.job.name == jobname then
                    cops = cops + 1
                end

            end
        end

        cb(cops)
 		
	end
    
end)

RegisterNetEvent('myJail:restoreItemsAndWeapons')
AddEventHandler('myJail:restoreItemsAndWeapons', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT items, weapons, clothes FROM prison_inmates WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    },
    function(result)
        if #result > 0 then
            local playerData = result[1]

            local pItems = json.decode(playerData.items)
            if #pItems > 0 then
                for k, v in pairs(pItems) do
                    xPlayer.addInventoryItem(v.name, v.count)
                end
            end

           
            local pWeapons = json.decode(playerData.weapons)
            if #pWeapons > 0 then
                for k, v in pairs(pWeapons) do
                    xPlayer.addWeapon(v.name, v.ammo)
                end
            end

            if playerData.clothes ~= nil then
                TriggerClientEvent('myJail:restoreSkin', xPlayer.source, json.decode(playerData.clothes))
            end

            MySQL.Async.execute('DELETE FROM prison_inmates WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier,
            })
        end
    end)

end)

RegisterServerEvent('myJail:clearObject')
AddEventHandler('myJail:clearObject', function(position)
	TriggerClientEvent('myJail:syncDelete', -1, position)
end)

RegisterNetEvent('myJail:InmateEscape')
AddEventHandler('myJail:InmateEscape', function(position, prisonName)
    local xPlayerInmate = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        for k, policeJob in pairs(Config.policeJobs) do
            if xPlayer.job.name == policeJob then
                TriggerClientEvent('myJail:callPolice', xPlayer.source, position, xPlayerInmate.name, prisonName)
            end

        end
		
    end

end)

RegisterNetEvent('myJail:UpdateEscapeGPS')
AddEventHandler('myJail:UpdateEscapeGPS', function(position, last)
    local xPlayerInmate = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer ~= nil then
            for k, policeJob in pairs(Config.policeJobs) do
                
                if xPlayer.job.name == policeJob then
                    TriggerClientEvent('myJail:EscapeUpdate', xPlayer.source, position, last)
                end

            end
		end
    end
    
end)

local lastFood = {}
ESX.RegisterServerCallback('myJail:checkHasGotFood', function(source, cb, prisonFood, prisonCooldown)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()

    if lastFood[xPlayer.identifier] ~= nil then
        
		local diff = os.difftime(currentTime, lastFood[xPlayer.identifier])
        local minutes = diff / 60

        if minutes >= prisonCooldown then
            -- can get food
            lastFood[xPlayer.identifier] = currentTime
            for k, v in pairs(prisonFood) do
                xPlayer.addInventoryItem(v.item, v.quantity)
            end
            cb(true)
        else
            -- cooldown time
            local remainingTime = math.floor(prisonCooldown - minutes)
            cb(false, remainingTime)
        end



    else
        lastFood[xPlayer.identifier] = currentTime
        for k, v in pairs(prisonFood) do
            xPlayer.addInventoryItem(v.item, v.quantity)
        end

        cb(true)

    end

end)

ESX.RegisterServerCallback('Jail:getPrisonTime', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        MySQL.Async.fetchAll('SELECT remainingTime, prison FROM prison_inmates WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
        },
        function(result)
            if #result > 0 then
                cb(result[1].remainingTime, result[1].prison)
            else
                cb(nil)
            end
        end)
    end

end)

RegisterNetEvent('myJail:manipulate')
AddEventHandler('myJail:manipulate', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        xPlayer.removeMoney(amount)
        --xPlayer.removeAccountMoney('bank', amount)
    end
end)

ESX.RegisterServerCallback('Jail:checkEnoughMoney', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= amount then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('Jail:getLog', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM prison_log ORDER BY `id` DESC LIMIT @limit', {
        ['@limit'] = Config.Limit,
    },
    function(result)
        if result ~= nil and #result > 0 then
            cb(result)
        else
            cb(nil)
        end
    end)

end)

RegisterServerEvent('myJail:updateArrestSeconds')
AddEventHandler('myJail:updateArrestSeconds', function(seconds, otherIdentifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE prison_inmates SET remainingTime = @remainingTime WHERE identifier = @identifier', {
        ['@identifier'] = otherIdentifier or xPlayer.identifier,
        ['@remainingTime'] = seconds,
    })

    if otherIdentifier ~= nil then
        local players = ESX.GetPlayers()
        for i, playerid in pairs(players) do
            local xPlayerOnline = ESX.GetPlayerFromId(playerid)
            if xPlayerOnline.identifier == otherIdentifier then
                TriggerClientEvent('myJail:syncRemainingSeconds', xPlayerOnline.source, seconds)
                break
            end
        end

    end
end)

RegisterServerEvent('myJail:releaseFromJail')
AddEventHandler('myJail:releaseFromJail', function(otherIdentifier, escaped_)
    local xPlayer = ESX.GetPlayerFromId(source)

    local dateString = os.date("%x")
	if Config.dateFormat == 'de' then
		dateString = os.date("%d.%m.%Y | %H:%M")
	else
		dateString = os.date("%x | %H:%M")
	end

    MySQL.Async.execute('UPDATE prison_log SET releaseTime = @releaseTime, `escaped` = @escaped WHERE (identifier = @identifier AND releaseTime = @releaseTimeOld)', {
        ['@releaseTime'] = dateString,
        ['@escaped'] = escaped_ or 0,
        ['@releaseTimeOld'] = '0',
        ['@identifier'] = otherIdentifier or xPlayer.identifier,
    })

    if escaped_ == 1 or not Config.removeItemsAndWeapons or Config.useQSInventory then
        MySQL.Async.execute('DELETE FROM prison_inmates WHERE identifier = @identifier', {
            ['@identifier'] = otherIdentifier or xPlayer.identifier,
        })
    end

    if otherIdentifier ~= nil then
        local players = ESX.GetPlayers()
        for i, playerid in pairs(players) do
            local xPlayerOnline = ESX.GetPlayerFromId(playerid)
            if xPlayerOnline.identifier == otherIdentifier then
                TriggerClientEvent('myJail:syncRelease', xPlayerOnline.source, xPlayer.name)
                break
            end
        end

    end
end)

-- RegisterServerEvent('myJail:addLogEntry')
-- AddEventHandler('myJail:addLogEntry', function()


-- end)

RegisterServerEvent('myJail:sendToJail')
AddEventHandler('myJail:sendToJail', function(playerSource, playerName, arrestReason, arrestSeconds, jail)

    local xPlayer = ESX.GetPlayerFromId(playerSource)
    local xPlayerOfficer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil and xPlayerOfficer ~= nil then
        TriggerClientEvent('myJail:msg', xPlayerOfficer.source, '~o~' .. xPlayer.name .. Translation[Config.Locale]['server_imprisoned'] .. arrestSeconds .. Translation[Config.Locale]['server_imprisoned2'] .. arrestReason)
        
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local playerId = xPlayers[i]
                TriggerClientEvent('chat:addMessage', playerId, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[TN.cz]", xPlayer.name .. " byl uvězněn do věznice Mírov. Důvod: " .. arrestReason}
                })
            end
        

        addJailEntry(xPlayer.identifier, playerName, arrestReason, arrestSeconds, xPlayerOfficer.name, jail)
        TriggerClientEvent('myJail:enterJail', xPlayer.source, jail, arrestSeconds, xPlayerOfficer.name, arrestReason)
    else
        -- player was not found 
        -- message to source?
    end

end)

function addJailEntry(identifier, playername, reason, time, officerName, jail)

    local dateString = os.date("%x")
	if Config.dateFormat == 'de' then
		dateString = os.date("%d.%m.%Y | %H:%M")
	else
		dateString = os.date("%x | %H:%M")
	end

    MySQL.Async.execute(
        'INSERT INTO prison_inmates (identifier, playername, prison, reason, remainingTime, officerName, date) VALUES (@identifier, @playername, @prison, @reason, @remainingTime, @officerName, @date)', {
            ['@identifier'] = identifier,
            ['@playername'] = playername,
            ['@prison'] = jail,
            ['@reason'] = reason,
            ['@remainingTime'] = time,
            ['@officerName'] = officerName,
            ['@date'] = dateString,
    }, function()

    end)

    addLogEntry(identifier, playername, jail, reason, time, officerName, dateString)

end

function addLogEntry(identifier, playername, jail, reason, time, officerName, dateString)
    MySQL.Async.execute(
        'INSERT INTO prison_log (identifier, playername, prison, reason, duration, officerName, arrestTime) VALUES (@identifier, @playername, @prison, @reason, @duration, @officerName, @arrestTime)', {
            ['@identifier'] = identifier,
            ['@playername'] = playername,
            ['@prison'] = jail,
            ['@reason'] = reason,
            ['@duration'] = time,
            ['@officerName'] = officerName,
            ['@arrestTime'] = dateString,
    }, function()

    end)

end

-- OneSync getPlayers

ESX.RegisterServerCallback('myJail:getPlayersInArea', function(source, cb, position, distance)
    local p = GetPlayers()
    local players = {}
    local vecposition = vector3(position.x, position.y, position.z)
    if(#p > 0) then
        for index, playerID in ipairs(p) do
            local player = ESX.GetPlayerFromId(playerID)
            if player ~= nil and playerID ~= source then
                local coords = player.getCoords(true)
                if #(vecposition - coords) < distance then
                    local playerInfo = {id = playerID, name = player.getName()}
                    table.insert(players, playerInfo)
                end
            else
              print('[Info] ESX was not able to fetch the player')
            end
        end
    end
    cb(players)
  end)
  
  

ESX.RegisterServerCallback('myJail:getAllInmates', function(source, cb)

    MySQL.Async.fetchAll('SELECT * from prison_inmates', {
	},
	function(result)
		cb(result)
	end
	)

end)