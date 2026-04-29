ESX = exports['es_extended']:getSharedObject()
TriggerEvent('esx_society:registerSociety', Config.JobName, Config.JobName, 'society_'.. Config.JobName, 'society_'.. Config.JobName,'society_'.. Config.JobName, { type = 'private' })
local sellbebhook = "https://discord.com/api/webhooks/1022085112923430962/1vtvvyE8_WQFcaR2bvYayk7B2fH526yGbGNB3zTb-BjG83swD02-rHlUiCxVatEFy_Uo"

RegisterNetEvent('wn_brewery:givehop')
AddEventHandler('wn_brewery:givehop', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true)
	local distance = #(coords - Config.HopSpawnCoords[1])

    if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 60 then
				if Config.LimitHop then 
					if xPlayer.getInventoryItem(Config.HopItem).count < Config.LimitHopAmount then
						xPlayer.addInventoryItem(Config.HopItem, Config.GiveHopAmount)
					else
						lib.notify(src,{
							title = TranslateCap('brewery'),
							description = TranslateCap('not_enough_space'),
							type = 'error'
						})
					end
				else 
					xPlayer.addInventoryItem(Config.HopItem, Config.GiveHopAmount)
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:givebarley')
AddEventHandler('wn_brewery:givebarley', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.BarleySpawnCoords[1])

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 80 then
				if Config.LimitBarley then 
					if xPlayer.getInventoryItem(Config.BarleyItem).count < Config.LimitBarleyAmount then
						xPlayer.addInventoryItem(Config.BarleyItem, Config.GiveBarleyAmount)
					else
						lib.notify(src,{
							title = TranslateCap('brewery'),
							description = TranslateCap('not_enough_space'),
							type = 'error'
						})
					end
				else 
					xPlayer.addInventoryItem(Config.BarleyItem, Config.GiveBarleyAmount)
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:bottlebeer')
AddEventHandler('wn_brewery:bottlebeer', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true)
	local distance = #(coords - Config.Cooking)

    if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then	
				if xPlayer.getInventoryItem(Config.HopItem).count > Config.CookingHopNeedB -1 and xPlayer.getInventoryItem(Config.BarleyItem).count > Config.CookingBarleyNeedB -1 and xPlayer.getInventoryItem(Config.WaterItem).count > Config.CookingWaterNeedB -1 and xPlayer.getInventoryItem(Config.BottleItem).count > Config.CookingBottleNeedB -1 then
					lib.callback.await('wn_brewery:startprogressb', source, id, recipeId)
					xPlayer.addInventoryItem(Config.PisswaserBottleItem, Config.BottleGive)
					xPlayer.removeInventoryItem(Config.HopItem, Config.CookingHopNeedB)
					xPlayer.removeInventoryItem(Config.BarleyItem, Config.CookingBarleyNeedB)
				elseif 	xPlayer.getInventoryItem(Config.HopItem).count < Config.CookingHopNeedB or xPlayer.getInventoryItem(Config.BarleyItem).count < Config.CookingBarleyNeedB or xPlayer.getInventoryItem(Config.WaterItem).count < Config.CookingWaterNeedB or xPlayer.getInventoryItem(Config.BottleItem).count < Config.CookingBottleNeedB then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:canbeer')
AddEventHandler('wn_brewery:canbeer', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true)
	local distance = #(coords - Config.Cooking)

    if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then	
				if xPlayer.getInventoryItem(Config.HopItem).count > Config.CookingHopNeedC -1 and xPlayer.getInventoryItem(Config.BarleyItem).count > Config.CookingBarleyNeedC -1 and xPlayer.getInventoryItem(Config.WaterItem).count > Config.CookingWaterNeedC -1 and xPlayer.getInventoryItem(Config.CanItem).count > Config.CookingCanNeedC -1 then
					lib.callback.await('wn_brewery:startprogressc', source, id, recipeId)
					xPlayer.addInventoryItem(Config.PisswaserCanItem, Config.CanGive)
					xPlayer.removeInventoryItem(Config.HopItem, Config.CookingHopNeedC)
					xPlayer.removeInventoryItem(Config.BarleyItem, Config.CookingBarleyNeedC)
				elseif 	xPlayer.getInventoryItem(Config.HopItem).count < Config.CookingHopNeedC or xPlayer.getInventoryItem(Config.BarleyItem).count < Config.CookingBarleyNeedC or xPlayer.getInventoryItem(Config.WaterItem).count < Config.CookingWaterNeedC or xPlayer.getInventoryItem(Config.CanItem).count < Config.CookingCanNeedC then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:soudekbeer')
AddEventHandler('wn_brewery:soudekbeer', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true)
	local distance = #(coords - Config.Cooking)

    if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then	
				if xPlayer.getInventoryItem(Config.HopItem).count > Config.CookingHopNeedC -1 and xPlayer.getInventoryItem(Config.BarleyItem).count > Config.CookingBarleyNeedC -1 and xPlayer.getInventoryItem(Config.WaterItem).count > Config.CookingWaterNeedC -1 and xPlayer.getInventoryItem(Config.CanItem).count > Config.CookingCanNeedC -1 then
					lib.callback.await('wn_brewery:startprogressc', source, id, recipeId)
					xPlayer.addInventoryItem(Config.PisswaserCanItem, Config.CanGive)
					xPlayer.removeInventoryItem(Config.HopItem, Config.CookingHopNeedC)
					xPlayer.removeInventoryItem(Config.BarleyItem, Config.CookingBarleyNeedC)
				elseif 	xPlayer.getInventoryItem(Config.HopItem).count < Config.CookingHopNeedC or xPlayer.getInventoryItem(Config.BarleyItem).count < Config.CookingBarleyNeedC or xPlayer.getInventoryItem(Config.WaterItem).count < Config.CookingWaterNeedC or xPlayer.getInventoryItem(Config.CanItem).count < Config.CookingCanNeedC then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:packbeerb')
AddEventHandler('wn_brewery:packbeerb', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PackingCoords)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserBottleItem).count > 5 then
					lib.callback.await('wn_brewery:startprogresspack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserBottleItem, 6)
					xPlayer.addInventoryItem(Config.PisswaserBottlePackItem , 1)
				elseif xPlayer.getInventoryItem(Config.PisswaserBottleItem).count < 6 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:packbeerc')
AddEventHandler('wn_brewery:packbeerc', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PackingCoords)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserCanItem).count > 5 then
					lib.callback.await('wn_brewery:startprogresspack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserCanItem, 6)
					xPlayer.addInventoryItem(Config.PisswaserCanPackItem , 1)
				elseif xPlayer.getInventoryItem(Config.PisswaserCanItem).count < 6 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:sellbeer')
AddEventHandler('wn_brewery:sellbeer', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PedSellingPosition.xyz)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. Config.JobName, function(account)
		societyAccount = account
	end)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserBottleItem).count > 19 then
					lib.callback.await('wn_brewery:startsellingpack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserBottleItem, 20)
					if Config.MoneyToPlayer then
						xPlayer.addAccountMoney(Config.MoneyType, Config.PriceForBeer)
						-- logy
        					exports.JD_logs:discord('Hráč obdržel výplatu ve výši ' .. Config.PriceForBeer.. ' CZK', source, 0, '65280', 'pivovar')
					else 
						societyAccount.addMoney(Config.PriceForBeerPack)
       						exports.JD_logs:discord('Hráč obdržel výplatu ve výši ' .. Config.PriceForBeer.. ' CZK', source, 0, '65280', 'pivovar')
					end
					DiscordLog(sellbebhook, GetPlayerName(source) .. " | " .. xPlayer.name .. " Have sold 20 beer. ", GetPlayerName(source) .. " Have earned " .. Config.PriceForBeerPack)
				elseif xPlayer.getInventoryItem(Config.PisswaserBottleItem).count < 20 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:sellcan')
AddEventHandler('wn_brewery:sellcan', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PedSellingPosition.xyz)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. Config.JobName, function(account)
		societyAccount = account
	end)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserCanItem).count > 19 then
					lib.callback.await('wn_brewery:startsellingpack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserCanItem, 20)
					if Config.MoneyToPlayer then
						xPlayer.addAccountMoney(Config.MoneyType, Config.PriceForCan)
					else 
						societyAccount.addMoney(Config.PriceForBeerPack)
					end 
					DiscordLog(sellbebhook, GetPlayerName(source) .. " | " .. xPlayer.name .. " Have sold 20 can beer. ", GetPlayerName(source) .. " Have earned " .. Config.PriceForBeerPack)
				elseif xPlayer.getInventoryItem(Config.PisswaserCanItem).count < 20 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:sellbeerpack')
AddEventHandler('wn_brewery:sellbeerpack', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PedSellingPosition.xyz)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. Config.JobName, function(account)
		societyAccount = account
	end)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserBottlePackItem).count > 9 then
					lib.callback.await('wn_brewery:startsellingpack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserBottlePackItem, 10)
					if Config.MoneyToPlayer then 
						xPlayer.addAccountMoney(Config.MoneyType, Config.PriceForBeerPack)
					else 
						societyAccount.addMoney(Config.PriceForBeerPack)
					end
					DiscordLog(sellbebhook, GetPlayerName(source) .. " | " .. xPlayer.name .. " Have sold 10 beer pack. ", GetPlayerName(source) .. " Have earned " .. Config.PriceForBeerPack)
				elseif xPlayer.getInventoryItem(Config.PisswaserBottlePackItem).count < 10 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

RegisterNetEvent('wn_brewery:sellcanpack')
AddEventHandler('wn_brewery:sellcanpack', function()
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
	local coords = xPlayer.getCoords(true) 
	local distance = #(coords - Config.PedSellingPosition.xyz)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. Config.JobName, function(account)
		societyAccount = account
	end)

	if xPlayer ~= nil then
    	if xPlayer.job.name == Config.JobName then
			if distance < 10 then
				if xPlayer.getInventoryItem(Config.PisswaserCanPackItem).count > 9 then
					lib.callback.await('wn_brewery:startsellingpack', source, id, recipeId)
					xPlayer.removeInventoryItem(Config.PisswaserCanPackItem, 10)
					if Config.MoneyToPlayer then 
						xPlayer.addAccountMoney(Config.MoneyType, Config.PriceForBeerPack)
					else 
						societyAccount.addMoney(Config.PriceForBeerPack)
					end
					DiscordLog(sellbebhook, GetPlayerName(source) .. " | " .. xPlayer.name .. " Have sold 10 can pack. ", GetPlayerName(source) .. " Have earned " .. Config.PriceForBeerPack)
				elseif xPlayer.getInventoryItem(Config.PisswaserCanPackItem).count < 10 then 
					lib.notify(src,{
						title = TranslateCap('brewery'),
						description = TranslateCap('not_required_items'),
						type = 'error'
					})
				end
			else
				--KickCheater(src, "Player far away")
				exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player far away (pivovar)", true)
			end
		else 
			--KickCheater(src, "Player does not have job")
			exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Player does not have job (pivovar)", true)
		end
    end
end)

ESX.OneSync.SpawnPed(Config.PedModel,Config.PedGaragePosition, Config.PedGaragePosition.w, function(NetId)
  Wait(250)
  local Ped = NetworkGetEntityFromNetworkId(NetId)
  local Exists = DoesEntityExist(Ped) 
  FreezeEntityPosition(Ped, true)
end)

ESX.OneSync.SpawnPed(Config.PedSellingModel,Config.PedSellingPosition, Config.PedSellingPosition.w, function(NetId)
	Wait(250)
	local Ped = NetworkGetEntityFromNetworkId(NetId)
	local Exists = DoesEntityExist(Ped) 
	FreezeEntityPosition(Ped, true)
end)

function KickCheater(src, message)
	print("Cheater ".. src .. " " .. message)
end

function DiscordLog(webhook,name,message,color)
    local embeds = {
        {
            ["title"] = name,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = 56108,
            ["footer"] = {
                ["text"] = "WN_BREWERY " .. os.date('%H:%M - %d. %m. %Y', os.time()),
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("wn_brewery:registershop", function()
	exports.ox_inventory:RegisterShop('BreweryShop', {
		name = Config.ShopName,
		inventory = Config.ShopItems,
		locations = {
			Config.BreweryShop,
		},
	})
end)

for itemName, data in pairs(Config.DrunkEffects) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.removeInventoryItem(itemName, 1)
            TriggerClientEvent('wn_brewery:drunkEffect', source, itemName)
        end
    end)
end