ESX = nil
Citizen.CreateThread(function()
	-- while ESX == nil do
	-- 	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	-- 	Citizen.Wait(0)
	-- end
	ESX = exports["es_extended"]:getSharedObject()
	-- esx 1.7.5 above not mandatory
	-- 

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)


_menuPool = NativeUI.CreatePool()
local currentArrestSeconds = 0
local currentPrison	

local isAtPed = false
local currentGuard
local spawnedNPCs = {}
local guardMenu

local isAtManagementPed = false
local isNearManagementPed = false
local isManagementPedLoaded = false
local managementPed 

local isAtJob = false
local currentJob
local blipRange
local blipLoaded

local IsEscaping = false
local prefixColor = '~o~'

local secondsSinceEscape = 0
local InPrisonBlipsSet = false

local currentExersice
local isNearExersices = false
local isAtExersice = false
local gymStartTime = 0


--[[

myPrison - Advanced Jail management script

]]

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

	ESX.TriggerServerCallback('Jail:getPrisonTime', function(remainingTime, jailname)
		if remainingTime ~= nil then
			
			currentArrestSeconds = remainingTime

			for k, v in pairs(Config.Prisons) do
				if v.name == jailname then
					currentPrison = v
					break
				end
			end
		end
	end)

	ESX.PlayerData = xPlayer
    print('registered Job: ' .. xPlayer.job.name)

end)


-- after death
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function(spawn)
	print('detected player spawned')
	ESX.TriggerServerCallback('Jail:getPrisonTime', function(remainingTime, jailname)
		if remainingTime ~= nil then
			
			currentArrestSeconds = remainingTime

			for k, v in pairs(Config.Prisons) do
				if v.name == jailname then
					currentPrison = v
					break
				end
			end
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()

	
	for k, v in pairs(Config.Prisons) do
		if v.blip ~= nil then
			local blip = AddBlipForCoord(v.inside.x, v.inside.y)
			
			SetBlipSprite (blip, v.blip.Sprite)
			SetBlipColour (blip, v.blip.Color)
			SetBlipDisplay(blip, v.blip.Display)
			SetBlipScale  (blip, v.blip.Scale)
		
			SetBlipAsShortRange(blip, true)
		
			BeginTextCommandSetBlipName("STRING")
			--AddTextComponentString(v.name)
			AddTextComponentString("<font face='Roboto'>"..v.name.."</font>")
			EndTextCommandSetBlipName(blip)
		end
	end

	ESX.TriggerServerCallback('Jail:getPrisonTime', function(remainingTime, jailname)
		if remainingTime ~= nil then

			currentArrestSeconds = remainingTime

			for k, v in pairs(Config.Prisons) do
				if v.name == jailname then
					currentPrison = v
					break
				end
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do

		if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        end

		if Config.enableManagementPeds then
			if isAtManagementPed then
				showInfobar(Translation[Config.Locale]['infobar_management'])
				if IsControlJustReleased(0, 38) then
					for k, v in pairs(Config.policeJobs) do
						if ESX.PlayerData ~= nil and ESX.PlayerData.job.name == v then
							openJailManagement()
							break
						end
					end
				end
			end
		end

		if isAtPed then
			showInfobar(Translation[Config.Locale]['infobar_guard'])
			if IsControlJustReleased(0, 38) then
				openGuardMenu()
			end
		end

		if isAtJob then
			showInfobar(Translation[Config.Locale]['infobar_work'])
			if IsControlJustPressed(0, 38) then
				if currentJob.animation ~= nil then
					if currentJob.animation.type == 'scenario' then
						TaskStartScenarioInPlace(PlayerPedId(), currentJob.animation.anim, 0, true)
						Citizen.Wait(currentJob.workTime * 1000)
						
						ClearPedTasksImmediately(PlayerPedId())
						TriggerServerEvent('myJail:clearObject', GetEntityCoords(PlayerPedId()))
						workSuccess()
						
					else
						RequestAnimDict(currentJob.animation.dict)
						while (not HasAnimDictLoaded(currentJob.animation.dict)) do 
							Citizen.Wait(10)
							--print('waiting for dictionary')
						end
						TaskPlayAnim(player,currentJob.animation.dict,currentJob.animation.anim,1.0,-1.0, 5000, 0, 1, true, true, true)
						Citizen.Wait(currentJob.workTime * 1000)
						workSuccess()
					end
				else
					Citizen.Wait(currentArea.workTime * 1000)
					workSuccess()
				end
			end
		end

		-- gymisAtPed
		if Config.EnableGym then
			if isNearExersices then
				for k, v in pairs(Config.Exersices) do
					DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 153, 55, 55, 0, 0, 0, 0)
				end
			end

			if isAtExersice or isTraining then
				if not isTraining then
					showInfobar(Translation[Config.Locale]['gym_start'] .. '~y~' .. currentExersice.type)
				else
					showInfobar(Translation[Config.Locale]['gym_stop'])
				end
				
				if IsControlJustReleased(0, Config.GymKey) then
					
					if isTraining then
						if currentExersice.scenario == 'world_human_muscle_free_weights' then
							TriggerServerEvent('myJail:clearObject', GetEntityCoords(PlayerPedId()))
						end
 
						isTraining = false	
						ClearPedTasksImmediately(PlayerPedId())
						-- finish
						if (gymStartTime - currentArrestSeconds) >= Config.GymDuration then
							
							local changeSeconds = math.random(Config.GymReward.min, Config.GymReward.max)

							changePrisonTimeNotify(changeSeconds, 'remove')
							currentArrestSeconds = currentArrestSeconds - changeSeconds
						else
							ShowNotification(Translation[Config.Locale]['gym_no_success'])
						end

					else
						gymStartTime = currentArrestSeconds
						if currentExersice.scenario == 'prop_human_muscle_chin_ups' then
							SetEntityCoords(PlayerPedId(), currentExersice.fixedChinPos.x, currentExersice.fixedChinPos.y, currentExersice.fixedChinPos.z - 1)
							SetEntityHeading(PlayerPedId(), currentExersice.fixedChinPos.rot)
						end
						isTraining = true
						TaskStartScenarioInPlace(PlayerPedId(), currentExersice.scenario, 0, true)
					end
					
				end
			end
		end

		Citizen.Wait(1)

	end
end)

function workSuccess()
	-- change the remaining time
	local randomTime = math.random(currentJob.rewardSeconds.min, currentJob.rewardSeconds.max)
	changePrisonTimeNotify(randomTime, 'remove')
	currentArrestSeconds = currentArrestSeconds - randomTime
	
end

function changePrisonTimeNotify(seconds, type)

	if type == 'add' then
		-- now longer
		local i = 0
		prefixColor = '~r~'
		while i<400 do
			i = i + 1
			changeText(Translation[Config.Locale]['longer_1'] .. seconds .. Translation[Config.Locale]['longer_2'])
			Citizen.Wait(1)
		end
		prefixColor = '~o~'
	else
		-- now shorter
		local i = 0
		prefixColor = '~g~'
		while i<400 do
			i = i + 1
			changeText(Translation[Config.Locale]['shorter_1'] .. seconds .. Translation[Config.Locale]['shorter_2'])
			Citizen.Wait(1)
		end
		prefixColor = '~o~'
	end

end



Citizen.CreateThread(function()
	while true do

		-- while ESX.PlayerData == nil do
		-- 	Wait(50)
		-- end

		isAtPed = false
		isAtJob = false

		if Config.enableManagementPeds then
			local playerCoords = GetEntityCoords(PlayerPedId())

			isAtManagementPed = false
			isNearManagementPed = false

			for k, v in pairs(Config.ManagementPeds) do
				local distance = Vdist(playerCoords, v.x, v.y, v.z)
				-- print(distance)
				if distance <= 2.0 then
					isAtManagementPed = true
				end

				if distance <= 20.0 then
                    
					isNearManagementPed = true

					if not isManagementPedLoaded then
						isManagementPedLoaded = true
						RequestModel(GetHashKey(v.pedmodel))
						while not HasModelLoaded(GetHashKey(v.pedmodel)) do
							Wait(1)
						end
						local npc = CreatePed(4, GetHashKey(v.pedmodel), v.x, v.y, v.z - 1.0, v.rot, false, true)
						FreezeEntityPosition(npc, true)	
						SetEntityHeading(npc, v.rot)
						SetEntityInvincible(npc, true)
						SetBlockingOfNonTemporaryEvents(npc, true)                    

						managementPed = npc
						SetModelAsNoLongerNeeded(GetHashKey(v.pedmodel))
					end
				end
			end

			if not isNearManagementPed and isManagementPedLoaded then
				DeleteEntity(managementPed)
				isManagementPedLoaded = false
			end


		end

		if currentArrestSeconds ~= nil and currentArrestSeconds > 0 and currentPrison ~= nil then
			local playerCoords = GetEntityCoords(PlayerPedId())

			local distanceToPrison = Vdist(playerCoords, currentPrison.inside.x, currentPrison.inside.y, currentPrison.inside.z)
			if distanceToPrison > currentPrison.escapeRange then
				-- the inmate escaped
				ESX.TriggerServerCallback('myJail:checkCopAmount', function (copamount)
					if copamount >= Config.CopsRequiredToEscape then
						IsEscaping = true
						currentArrestSeconds = 0
						secondsSinceEscape = 0
						TriggerServerEvent('myJail:InmateEscape', playerCoords, currentPrison.name)
						TriggerServerEvent('myJail:releaseFromJail', nil, 1)
					elseif Config.teleportBackWhenTryingToEscape then
						SetEntityCoords(PlayerPedId(), currentPrison.inside.x, currentPrison.inside.y, currentPrison.inside.z)
					end
				end)
				

			end

			

			for k, v in pairs(currentPrison.prisonJobs) do
				local distance = Vdist(playerCoords, v.x, v.y, v.z)
				if distance < v.range then
					currentJob = v
					isAtJob = true
					if not blipLoaded then
						blipLoaded = true
	
						blipRange = AddBlipForRadius(v.x, v.y, v.z, v.range) 
						SetBlipSprite (blipRange, 9)
						SetBlipColour (blipRange, v.blipColor)
						SetBlipAsShortRange(blipRange, true)
						SetBlipAlpha(blipRange, 50)
					end
				end
			end

			if blipLoaded and not isAtJob then
				if blipRange ~= nil then
					RemoveBlip(blipRange)
				end
				blipLoaded = false
			end

			for k, ped in pairs(currentPrison.securityPeds) do

				local distance = Vdist(playerCoords, ped.x, ped.y, ped.z)
				if distance <= 2.0 then
					currentGuard = ped
					isAtPed = true
				elseif k == #currentPrison.securityPeds then
					if guardMenu ~= nil and guardMenu:Visible() then
						guardMenu:Visible(false)
					end
				end

				if not ped.disabled then
                    
					RequestModel(GetHashKey(ped.pedmodel))
					while not HasModelLoaded(GetHashKey(ped.pedmodel)) do
						Wait(1)
					end
					local npc = CreatePed(4, GetHashKey(ped.pedmodel), ped.x, ped.y, ped.z - 1.0, ped.rot, false, true)
					FreezeEntityPosition(npc, true)	
					SetEntityHeading(npc, ped.rot)
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)                    
					ped.disabled = true

					table.insert(spawnedNPCs, npc)
					SetModelAsNoLongerNeeded(GetHashKey(ped.pedmodel))
					
				end
			end
			
		end

		if ((currentArrestSeconds == 0 or currentPrison == nil) and spawnedNPCs ~= nil and #spawnedNPCs > 0) then
			for k, v in pairs(spawnedNPCs) do
				DeleteEntity(v)
				table.remove(spawnedNPCs, k)
				resetLoadedPeds()
			end
            
		end


		-- gym
		if Config.EnableGym then
			local playerCoords = GetEntityCoords(PlayerPedId())
			isNearExersices = false
			isAtExersice = false

			for k, v in pairs(Config.Exersices) do
				local distance = Vdist(playerCoords, v.x, v.y, v.z)
				if distance < 20.0 then
					isNearExersices = true
				end
				if distance < 0.6 then
					isAtExersice = true
					currentExersice = v
				end
			end
		end
		--

		Citizen.Wait(350)
	end
end)



Citizen.CreateThread(function()
	
	while true do
		if currentArrestSeconds ~= nil and currentArrestSeconds > 0 then
			if Config.useMinutes then
				text(prefixColor .. math.floor(currentArrestSeconds / 60) .. Translation[Config.Locale]['actionbar_currenttime_minutes'])
				text2(Translation[Config.Locale]['actionbar_currenttime_sub'])
			else
				text(prefixColor .. currentArrestSeconds .. Translation[Config.Locale]['actionbar_currenttime'])
				text2(Translation[Config.Locale]['actionbar_currenttime_sub'])
			end
			
		end

		
		Citizen.Wait(1)
	end

end)

Citizen.CreateThread(function()
	while true do
		if currentArrestSeconds ~= nil and currentArrestSeconds > 0 then
			TriggerServerEvent('myJail:updateArrestSeconds', currentArrestSeconds)
			--print('update to ' .. currentArrestSeconds)
		end

		Citizen.Wait(Config.UpdateInterval)
	end
end)

-- time updater
Citizen.CreateThread(function()
	
	
	while true do
		if IsEscaping then
			secondsSinceEscape = secondsSinceEscape + 1
			-- print(secondsSinceEscape)
			if secondsSinceEscape >= Config.EscapeUpdates then
				TriggerServerEvent('myJail:UpdateEscapeGPS', GetEntityCoords(PlayerPedId()), true)
				IsEscaping = false
			else
				TriggerServerEvent('myJail:UpdateEscapeGPS', GetEntityCoords(PlayerPedId()), false)
			end
		end
		if currentArrestSeconds ~= nil and currentArrestSeconds > 0 then
			if not InPrisonBlipsSet then
				-- set all blips
				setPrisonBlips()
			end

			currentArrestSeconds = currentArrestSeconds - 1
			if currentArrestSeconds < 1 then
				-- release player
				releaseFromJail()
				TriggerServerEvent('myJail:releaseFromJail')

			end
		elseif InPrisonBlipsSet then
			-- remove all blips
			removePrisonBlips()
		end

		if Config.RemovePrisonPeds then
			ClearAreaOfPeds(1774.45, 2551.86, 44.56, 200.0, 1)
		end

		Citizen.Wait(1000)
	end

end)

local prisonBlips = {}

function setPrisonBlips()

	if currentPrison ~= nil then
		
		local blipRangeInmate = AddBlipForRadius(currentPrison.inside.x, currentPrison.inside.y, currentPrison.inside.z, currentPrison.escapeRange) 
		SetBlipSprite (blipRangeInmate, 9)
		SetBlipColour (blipRangeInmate, 40)
		SetBlipAsShortRange(blipRangeInmate, true)
		SetBlipAlpha(blipRangeInmate, 50)
		table.insert(prisonBlips, blipRangeInmate)

		-- guard blips
		for k, v in pairs(currentPrison.securityPeds) do
			local blip = AddBlipForCoord(v.x, v.y)
			SetBlipSprite (blip, 137)
			SetBlipColour (blip, 40)
			SetBlipDisplay(blip, 2)
			SetBlipScale  (blip, 1.0)
		
			SetBlipAsShortRange(blip, false)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Translation[Config.Locale]['guard_blip'])
			EndTextCommandSetBlipName(blip)
	
			table.insert(prisonBlips, blip)
		end

		-- work blips
		for k, v in pairs(currentPrison.prisonJobs) do
			local blip = AddBlipForCoord(v.x, v.y)
			SetBlipSprite (blip, 420)
			SetBlipColour (blip, 40)
			SetBlipDisplay(blip, 2)
			SetBlipScale  (blip, 0.75)
		
			SetBlipAsShortRange(blip, false)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Translation[Config.Locale]['work_blip'])
			EndTextCommandSetBlipName(blip)
	
			table.insert(prisonBlips, blip)
		end

		if Config.EnableGym then
			local blip = AddBlipForCoord(Config.Exersices[1].x, Config.Exersices[1].y)
			SetBlipSprite (blip, 311)
			SetBlipColour (blip, 4)
			SetBlipDisplay(blip, 2)
			SetBlipScale  (blip, 0.85)
		
			SetBlipAsShortRange(blip, false)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Translation[Config.Locale]['gym_blip'])
			EndTextCommandSetBlipName(blip)
	
			table.insert(prisonBlips, blip)
		end



		InPrisonBlipsSet = true
	end
end

function removePrisonBlips()

	for k, v in pairs(prisonBlips) do
		RemoveBlip(v)
	end
	InPrisonBlipsSet = false

end


function openGuardMenu()

	guardMenu = NativeUI.CreateMenu('Wärter', nil)
	_menuPool:Add(guardMenu)

	if currentGuard ~= nil and currentGuard.manipulation then
		local manipulateItem = NativeUI.CreateItem(Translation[Config.Locale]['guard_manipulate'], Translation[Config.Locale]['guard_desc'])
		manipulateItem:SetRightBadge(BadgeStyle.Alert)
		guardMenu:AddItem(manipulateItem)

		manipulateItem.Activated = function(sender, item, index)
			local insertedAmount = CreateDialog(Translation[Config.Locale]['guard_money'])
			if tonumber(insertedAmount) and insertedAmount ~= nil then
				ESX.TriggerServerCallback('Jail:checkEnoughMoney', function(hasEnoughMoney)
					if hasEnoughMoney then

						-- pay the money
						TriggerServerEvent('myJail:manipulate', tonumber(insertedAmount))
						startAnim()

						local chance = calculateSuccessForCorruption(tonumber(insertedAmount))
						--print('chance: ' .. tostring(chance))
						local randomInt = math.random(1, 100)
						if randomInt <= chance then
							-- win
							ShowNotification(Translation[Config.Locale]['manipulate_success'])
							local changeSeconds = math.floor(currentArrestSeconds * Config.SuccessMultiplier)
							changePrisonTimeNotify(changeSeconds, 'remove')
							currentArrestSeconds = currentArrestSeconds - changeSeconds
			
						else
							-- lose
							ShowNotification(Translation[Config.Locale]['manipulate_fail'])
							local changeSeconds = math.floor(currentArrestSeconds * Config.FailMultiplier)
							changePrisonTimeNotify(changeSeconds, 'add')
							currentArrestSeconds = currentArrestSeconds + (changeSeconds)
						end

					else
						ShowNotification(Translation[Config.Locale]['not_enough_money'])
					end
				end, tonumber(insertedAmount))
				
			end
		end
	end

	if currentGuard ~= nil and currentGuard.askForWork then
		local workItem = NativeUI.CreateItem(Translation[Config.Locale]['guard_work'], '~b~')
		guardMenu:AddItem(workItem)

		workItem.Activated = function(sender, index)
			if currentPrison.prisonJobs ~= nil and #currentPrison.prisonJobs > 0 then
				local randomJob = math.random(1, #currentPrison.prisonJobs)
				local jobInfo = currentPrison.prisonJobs[randomJob]
				ShowNotification(Translation[Config.Locale]['guard_work_info'])
				SetNewWaypoint(jobInfo.x, jobInfo.y, jobInfo.z)
			else
				ShowNotification(Translation[Config.Locale]['guard_no_work'])
			end
		end
	end

	if currentGuard ~= nil and currentGuard.food then
		if currentPrison.prisonFood ~= nil then
			local FoodAndDrinksItem = NativeUI.CreateItem(Translation[Config.Locale]['guard_food'], '~b~')
			guardMenu:AddItem(FoodAndDrinksItem)

			FoodAndDrinksItem.Activated = function(sender, index)
				ESX.TriggerServerCallback('myJail:checkHasGotFood', function(getFood, remainingMinutes)
					if getFood then
						ShowNotification(Translation[Config.Locale]['guard_food_give'])
					else
						ShowNotification(Translation[Config.Locale]['guard_food_not_available'] .. remainingMinutes .. Translation[Config.Locale]['guard_food_not_available2'])
					end
					_menuPool:CloseAllMenus()
				end, currentPrison.prisonFood, currentPrison.foodCooldown)
			end
		end
	end
	
	guardMenu:Visible(true)
	_menuPool:MouseEdgeEnabled(false)
end



function openJailManagement()

	if _menuPool:IsAnyMenuOpen() then
		_menuPool:CloseAllMenus()
	end

	--local jailMenu = NativeUI.CreateMenu(Translation[Config.Locale]['jail_menu'], nil)
	local menuTitle = '~b~'
	if not Config.CustomBanner then
		menuTitle = Translation[Config.Locale]['jail_menu']
	end	
	local jailMenu = NativeUI.CreateMenu(menuTitle, nil)
    _menuPool:Add(jailMenu)
	
	local background
	if Config.CustomBanner then
		background = Sprite.New(Config.Banner.dict, Config.Banner.file, 0, 0, 512, 128)
		jailMenu:SetBannerSprite(background, true)
	end

	if ESX.PlayerData ~= nil and ESX.PlayerData.job ~= nil then
		for j, allowedGrade in pairs(Config.allowedGradesForJailManagement) do
			if ESX.PlayerData.job.grade_name == allowedGrade then


				ESX.TriggerServerCallback('myJail:getAllInmates', function(inmates)
					local managePrisons = _menuPool:AddSubMenu(jailMenu, Translation[Config.Locale]['menu_prisons'], '~b~')
					if Config.CustomBanner then
						managePrisons.SubMenu:SetBannerSprite(background, true)
					end
			
					for k, v in pairs(Config.Prisons) do
						local prisonSubMenu = _menuPool:AddSubMenu(managePrisons.SubMenu, v.name, '~b~')
						if Config.CustomBanner then
							prisonSubMenu.SubMenu:SetBannerSprite(background, true)
						end
			
						local prisonInmates = getInmatesFromPrison(inmates, v.name)
						
						local labelItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_playername'], '~b~')
						labelItem:RightLabel('~b~' .. v.name)
						prisonSubMenu.SubMenu:AddItem(labelItem)
			
						local setWaypointItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_waypoint'], '~b~')
						setWaypointItem:RightLabel('~p~→→→')
						prisonSubMenu.SubMenu:AddItem(setWaypointItem)
			
						setWaypointItem.Activated = function(sender, index)
							SetNewWaypoint(v.inside.x, v.inside.y, v.inside.z)
						end
			
						local spacerItem = NativeUI.CreateItem('~b~', '~b~')
						prisonSubMenu.SubMenu:AddItem(spacerItem)
			
						local inmatesItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_inmates'], '~b~')
						prisonSubMenu.SubMenu:AddItem(inmatesItem)
			
						if prisonInmates ~= nil and #prisonInmates > 0 then
							for k2, v2 in pairs(prisonInmates) do
								local inmateSub = _menuPool:AddSubMenu(prisonSubMenu.SubMenu, '- ' .. v2.playername, Translation[Config.Locale]['inmate_desc'] .. math.round(v2.remainingTime / 60) .. Translation[Config.Locale]['inmate_desc2'])
								inmateSub.SubMenu.ParentItem:RightLabel('~b~→→→')
								if Config.CustomBanner then
									inmateSub.SubMenu:SetBannerSprite(background, true)
								end
			
								local nameItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_inmate'], '~b~')
								nameItem:RightLabel('~b~' .. v2.playername)
								inmateSub.SubMenu:AddItem(nameItem)
			
								local reasonItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_reason'], '~b~')
								reasonItem:RightLabel('~y~' .. v2.reason)
								inmateSub.SubMenu:AddItem(reasonItem)
			
								local remainingTimeItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_remaining_time'], '~b~')
								remainingTimeItem:RightLabel('~b~' .. math.round(v2.remainingTime / 60) .. Translation[Config.Locale]['menu_remaining_time2'])
								inmateSub.SubMenu:AddItem(remainingTimeItem)
			
								local spacerItem = NativeUI.CreateItem('~b~', '~b~')
								inmateSub.SubMenu:AddItem(spacerItem)
			
								local officerItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_officer_name'], '~b~')
								officerItem:RightLabel(v2.officerName)
								inmateSub.SubMenu:AddItem(officerItem)
			
								local dateItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_time'], '~b~')
								dateItem:RightLabel(tostring('~b~' .. tostring(v2.date)))
								inmateSub.SubMenu:AddItem(dateItem)
			
								local spacer2Item = NativeUI.CreateItem('~b~', '~b~')
								inmateSub.SubMenu:AddItem(spacer2Item)
			
								local editJailTimeSub = _menuPool:AddSubMenu(inmateSub.SubMenu, Translation[Config.Locale]['menu_change_time'], nil)
								editJailTimeSub.SubMenu.ParentItem:RightLabel('~o~→→→')
			
								if Config.CustomBanner then
									editJailTimeSub.SubMenu:SetBannerSprite(background, true)
								end

								local arrestSeconds = 0
								local arrestTime = NativeUI.CreateItem(Translation[Config.Locale]['menu_arrestTime'], '~b~')
								if Config.useMinutes then
									arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_minutes'])
								else
									arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_seconds'])
								end
								
								editJailTimeSub.SubMenu:AddItem(arrestTime)
			
								arrestTime.Activated = function(sender, index)
									local input = CreateDialog(Translation[Config.Locale]['time_dialog'])
									if input ~= nil and tonumber(input) then
										
										if Config.useMinutes then
											arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_minutes'])
											arrestSeconds = input * 60
										else
											arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_seconds'])
											arrestSeconds = input
										end
										
									end
								end
			
								local confirmChangeArrestTime = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], Translation[Config.Locale]['menu_confirm_desc'])
								editJailTimeSub.SubMenu:AddItem(confirmChangeArrestTime)
			
								confirmChangeArrestTime.Activated = function(sender, index)
									if arrestSeconds ~= 0 and tonumber(arrestSeconds) then
										TriggerServerEvent('myJail:updateArrestSeconds', arrestSeconds, v2.identifier)
										ShowNotification(Translation[Config.Locale]['time_changed'] .. arrestSeconds .. Translation[Config.Locale]['time_changed2'])
									end
								end
			
								local releasePlayerSub = _menuPool:AddSubMenu(inmateSub.SubMenu, Translation[Config.Locale]['menu_release'], nil)
								releasePlayerSub.SubMenu.ParentItem:RightLabel('~g~→→→')
			
								if Config.CustomBanner then
									releasePlayerSub.SubMenu:SetBannerSprite(background, true)
								end
			
								local confirmReleaseItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], Translation[Config.Locale]['menu_release_confirm'])
								confirmReleaseItem:SetRightBadge(BadgeStyle.Alert)
								releasePlayerSub.SubMenu:AddItem(confirmReleaseItem)
			
								confirmReleaseItem.Activated = function(sender, index)
									TriggerServerEvent('myJail:releaseFromJail', v2.identifier)
									ShowNotification('~w~' .. v2.playername .. Translation[Config.Locale]['released_officer'])
									_menuPool:CloseAllMenus()
								end
								
			
							end
							
			
						else
							local noInmatesItem = NativeUI.CreateItem(Translation[Config.Locale]['no_inmates'], '~b~')
							prisonSubMenu.SubMenu:AddItem(noInmatesItem)
						end
					end
			
			
					_menuPool:MouseEdgeEnabled(false)
					_menuPool:RefreshIndex()
				end)

				break
			end
		end
	end

	

	local sendToJail = _menuPool:AddSubMenu(jailMenu, Translation[Config.Locale]['arrest_player'])

	if Config.CustomBanner then
		sendToJail.SubMenu:SetBannerSprite(background, true)
	end


	local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
	--print('found players ' .. #playersInArea)
	local gotOSResult = false
	if Config.useOneSyncInfinity then
		ESX.TriggerServerCallback('myJail:getPlayersInArea', function(playersInArea_res)
			playersInArea = playersInArea_res
			gotOSResult = true

		end, GetEntityCoords(PlayerPedId()), 10.0)
	end

	for i=1, 10, 1 do
		if not gotOSResult then
			Citizen.Wait(100)
		end
	end

	if #playersInArea > 0 then
		for k, v in pairs(playersInArea) do
			local playerName = 'Unknown'
			local playerSource = 0

			if Config.useOneSyncInfinity then
				if v.name ~= nil then
					playerName = v.name
					playerSource = v.id
				end
			else
				playerName = GetPlayerName(v)
				playerSource = GetPlayerServerId(v)
			end
			
			local playerSub = _menuPool:AddSubMenu(sendToJail.SubMenu, playerName, nil)
			if Config.CustomBanner then
				playerSub.SubMenu:SetBannerSprite(background, true)
			end
			local arrestPlayer = _menuPool:AddSubMenu(playerSub.SubMenu, Translation[Config.Locale]['menu_arrest'], '~b~')
			arrestPlayer.SubMenu.ParentItem:SetRightBadge(BadgeStyle.Lock)

			if Config.CustomBanner then
				arrestPlayer.SubMenu:SetBannerSprite(background, true)
			end

			local arrestName = NativeUI.CreateItem(Translation[Config.Locale]['menu_playername'], '~b~')
			arrestName:RightLabel('~b~' .. playerName)
			arrestPlayer.SubMenu:AddItem(arrestName)


			local arrestReasonString = '-'
			local arrestReason = NativeUI.CreateItem(Translation[Config.Locale]['menu_reason'], '~b~')
			arrestReason:RightLabel('~p~' .. arrestReasonString)
			arrestPlayer.SubMenu:AddItem(arrestReason)

			arrestReason.Activated = function(sender, index)
				local input = CreateDialog(Translation[Config.Locale]['reason_dialog'])
				if input ~= nil and tostring(input) then
					arrestReasonString = input
					arrestReason:RightLabel('~p~' .. arrestReasonString)
				end
			end

			local arrestSeconds = 0
			local arrestTime = NativeUI.CreateItem(Translation[Config.Locale]['menu_arrestTime'], '~b~')
			if Config.useMinutes then
				arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_minutes'])
			else
				arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_seconds'])
			end
			
			arrestPlayer.SubMenu:AddItem(arrestTime)

			arrestTime.Activated = function(sender, index)
				local input = CreateDialog(Translation[Config.Locale]['time_dialog'])
				if input ~= nil and tonumber(input) then
					arrestSeconds = input
					if Config.useMinutes then
						arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_minutes'])
					else
						arrestTime:RightLabel('~p~' .. arrestSeconds .. Translation[Config.Locale]['menu_seconds'])
					end
					
				end
			end
			
			local arrestConfirm = _menuPool:AddSubMenu(arrestPlayer.SubMenu, Translation[Config.Locale]['arrest_confirm'], Translation[Config.Locale]['arrest_desc'])
			arrestConfirm.SubMenu.ParentItem:RightLabel('~o~→→→')
			
			if Config.CustomBanner then
				arrestConfirm.SubMenu:SetBannerSprite(background, true)
			end

			for j, jail in pairs(Config.Prisons) do
				local jailItem = NativeUI.CreateItem(jail.name, Translation[Config.Locale]['send_to_prison'] .. jail.name .. Translation[Config.Locale]['send_to_prison2'])
				arrestConfirm.SubMenu:AddItem(jailItem)

				jailItem.Activated = function(sender, index)
					if tonumber(arrestSeconds) and tonumber(arrestSeconds) > 0 then
						-- playerSource, playerName, arrestReasonString, arrestSeconds, jail.name
						if Config.useMinutes then
							arrestSeconds = arrestSeconds * 60
						end
						TriggerServerEvent('myJail:sendToJail', playerSource, playerName, arrestReasonString, arrestSeconds, jail.name)
						_menuPool:CloseAllMenus()
					else
						ShowNotification(Translation[Config.Locale]['invalid'])
					end
				end

			end

			_menuPool:MouseEdgeEnabled(false)
			_menuPool:RefreshIndex()
		end

	end


	local logSubMenu = _menuPool:AddSubMenu(jailMenu, Translation[Config.Locale]['prison_log'], '~b~')
	if Config.CustomBanner then
		logSubMenu.SubMenu:SetBannerSprite(background, true)
	end

	ESX.TriggerServerCallback('Jail:getLog', function(log)
		if log ~= nil and #log > 0 then
			for k, v in pairs(log) do

				local prefix = '~o~'
				-- not released
				if v.releaseTime ~= '0' then
					if v.escaped == 1 then 
						prefix = '~r~'
						-- escaped
					else
						prefix = '~g~'
						-- released
					end
					
				end

				local logPlayerEntry = _menuPool:AddSubMenu(logSubMenu.SubMenu, '[' .. prefix .. v.arrestTime .. '~s~] ' .. v.playername)
				if Config.CustomBanner then
					logPlayerEntry.SubMenu:SetBannerSprite(background, true)
				end
				
				local arrestStatus = NativeUI.CreateItem(Translation[Config.Locale]['prison_state'], '~b~')
				if v.releaseTime ~= '0' then
					if v.escaped == 1 then 
						arrestStatus:RightLabel(Translation[Config.Locale]['escaped'])
						logPlayerEntry.SubMenu.ParentItem:SetRightBadge(BadgeStyle.Alert)
					else
						arrestStatus:RightLabel(Translation[Config.Locale]['released'])
					end
					
				else
					arrestStatus:RightLabel(Translation[Config.Locale]['in_prison'])
					logPlayerEntry.SubMenu.ParentItem:SetRightBadge(BadgeStyle.Lock)
				end
				logPlayerEntry.SubMenu:AddItem(arrestStatus)

				local spacerItem2 = NativeUI.CreateItem('~b~', '~b~')
				logPlayerEntry.SubMenu:AddItem(spacerItem2)

				local nameItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_inmate'], '~b~')
				nameItem:RightLabel('~s~' .. v.playername)
				logPlayerEntry.SubMenu:AddItem(nameItem)

				local reasonItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_reason'], '~b~')
				reasonItem:RightLabel('~y~' .. v.reason)
				logPlayerEntry.SubMenu:AddItem(reasonItem)

				local prisonItem = NativeUI.CreateItem(Translation[Config.Locale]['prisonname'], '~b~')
				prisonItem:RightLabel('~s~' .. v.prison)
				logPlayerEntry.SubMenu:AddItem(prisonItem)

				local timeItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_arrestTime'], '~b~')
				timeItem:RightLabel('~b~' .. math.round(v.duration / 60) .. Translation[Config.Locale]['menu_remaining_time2'])
				logPlayerEntry.SubMenu:AddItem(timeItem)

				local spacerItem = NativeUI.CreateItem('~b~', '~b~')
				logPlayerEntry.SubMenu:AddItem(spacerItem)

				local officerItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_officer_name'], '~b~')
				officerItem:RightLabel(v.officerName)
				logPlayerEntry.SubMenu:AddItem(officerItem)

				local dateItem = NativeUI.CreateItem(Translation[Config.Locale]['menu_time'], '~o~')
				dateItem:RightLabel(tostring('~b~' .. tostring(v.arrestTime)))
				logPlayerEntry.SubMenu:AddItem(dateItem)

				if v.releaseTime ~= '0' then
					if v.escaped == 1 then
						local releasedItem = NativeUI.CreateItem(Translation[Config.Locale]['escaped_time'], '~b~')
						releasedItem:RightLabel(tostring('~r~' .. tostring(v.releaseTime)))
						logPlayerEntry.SubMenu:AddItem(releasedItem)
					else
						local releasedItem = NativeUI.CreateItem(Translation[Config.Locale]['released_time'], '~b~')
						releasedItem:RightLabel(tostring('~g~' .. tostring(v.releaseTime)))
						logPlayerEntry.SubMenu:AddItem(releasedItem)
					end
					
				end


			end

			_menuPool:MouseEdgeEnabled(false)
			_menuPool:RefreshIndex()
		end

	end)


	jailMenu:Visible(true)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:RefreshIndex()

end

function getInmatesFromPrison(allinmates, prison)

	local inmatesTable = {}

	if allinmates ~= nil then
		for k, v in pairs(allinmates) do
			if v.prison == prison then
				table.insert(inmatesTable, v)
			end
		end

		return inmatesTable
	else
		return {}
	end

end

if Config.useJailCommand then
	RegisterCommand(Config.jailCommand, function(source, args, rawCommand)

		--openJailManagement()

		for k, v in pairs(Config.policeJobs) do
			if ESX.PlayerData ~= nil and ESX.PlayerData.job.name == v then
				openJailManagement()
				break
			end

		end
	end, false)
end

RegisterCommand('sendtojail', function(source, args, rawCommand)
	-- print('TEST')
	--openJailManagement()
	ESX.TriggerServerCallback('Jail:getGroup', function(pgroup)
		-- print(pgroup)
		if pgroup == 'admin' or pgroup == 'superadmin' then

			local Playersource = tonumber(args[1])
			local str = args[2]
			local duration = args[3]
			local jailname = Config.Prisons[1].name

			-- print(args[1])
			-- print(args[2])
			-- print(args[3])
			if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
				ESX.TriggerServerCallback('Jail:getName', function(pname)
					TriggerServerEvent('myJail:sendToJail', Playersource, pname, str, duration, jailname)
				end, tonumber(args[1]))
			else
				ShowNotification('~y~Syntax: ~s~/sendToJail [ID] [Grund] [Zeit in Sekunden]')
			end
	
			
		end
	
	end)

end, false)



RegisterNetEvent('myPrison:open')
AddEventHandler('myPrison:open', function()
	openJailManagement()
end)

function releaseFromJail()
	local playerPed = PlayerPedId()

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)

	SetEntityCoords(playerPed, currentPrison.exit.x, currentPrison.exit.y, currentPrison.exit.z)
	SetEntityHeading(playerPed, currentPrison.exit.rot)
	-- if currentPrison.setPrisonClothes then
	-- 	-- TriggerEvent('skinchanger:getSkin', function(oldskin)
	-- 	-- 	TriggerEvent('skinchanger:loadSkin', oldskin)
	-- 	-- end)
	-- 	-- restore old skin
	-- end
	if Config.removeItemsAndWeapons and Config.useQSInventory == nil and not Config.useQSInventory then
		TriggerServerEvent('myJail:restoreItemsAndWeapons')
	end

	DoScreenFadeIn(2000)
    Citizen.Wait(2000)
end

function startAnim()
 	
	Citizen.CreateThread(function()
		
	  RequestAnimDict("mp_common")
	  
	  while not HasAnimDictLoaded("mp_common") do
	    Citizen.Wait(0)
	  end
		TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
		Wait(1600)
	end)
end

RegisterNetEvent('myJail:enterJail')
AddEventHandler('myJail:enterJail', function(jail, time, officer, reason)

	for k, v in pairs(Config.Prisons) do
		if v.name == jail then
			currentPrison = v
			break
		end
	end

	local playerPed = PlayerPedId()

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)

	SetEntityCoords(playerPed, currentPrison.inside.x, currentPrison.inside.y, currentPrison.inside.z)
	SetEntityHeading(playerPed, currentPrison.inside.rot)

	currentArrestSeconds = tonumber(time)

	-- remove weapons and items
	if Config.removeItemsAndWeapons then
		
		TriggerServerEvent('myJail:saveAllItemsAndWeapons')

		-- only for skinchanger
		if (GetResourceState("skinchanger") == "started") then
			TriggerEvent('skinchanger:getSkin', function(currentskin)
				TriggerServerEvent('myJail:saveClothes', currentskin)
			end)
		end

		
	end

	Citizen.Wait(200)

	if currentPrison.setPrisonClothes then
		setPrisonClothes()
	end

	showPictureNotification('CHAR_MP_MERRYWEATHER', Translation[Config.Locale]['start_jail'] .. reason .. Translation[Config.Locale]['start_jail2'] .. tostring(currentArrestSeconds) .. Translation[Config.Locale]['start_jail3'] .. Translation[Config.Locale]['start_jail4'] .. officer, jail, nil)

	
	DoScreenFadeIn(2000)
    Citizen.Wait(2000)
	

	-- SetEntityCoords(GetPlayerPed(-1), 1736.76, 2633.64, 58.95)
	-- SetEntityHeading(GetPlayerPed(-1), 180.0)
	
    -- local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1736.82, 2627.78,60.35, 300.00, 0.00 ,0.00, 70.00, false, 0)
	-- PointCamAtCoord(cam, 1736.76, 2633.64, 59.95)

	-- SetCamActive(cam, true)
    -- RenderScriptCams(true, false, 1, true, true)

	-- LoadAnim("mp_character_creation@customise@male_a")
    -- TaskPlayAnim(GetPlayerPed(-1), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)
    -- Citizen.Wait(5000)
	-- FreezeEntityPosition(GetPlayerPed(-1), true)

		-- mp_character_creation@customise@male_a
		-- STREAMING::SET_MODEL_AS_NO_LONGER_NEEDED(joaat("prop_police_id_board"));
		-- STREAMING::SET_MODEL_AS_NO_LONGER_NEEDED(joaat("prop_police_id_text"));
		-- STREAMING::SET_MODEL_AS_NO_LONGER_NEEDED(joaat("prop_police_id_text_02"));
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@lineup@male_a");
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@lineup@male_b");
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@lineup@female_a");
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@lineup@female_b");
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@customise@male_a");
		-- STREAMING::REMOVE_ANIM_DICT("mp_character_creation@customise@female_a");

end)

RegisterNetEvent('myJail:callPolice')
AddEventHandler('myJail:callPolice', function(coords, playername, prisonname)

    local streetlabel = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street = GetStreetNameFromHashKey(streetlabel)
    showPictureNotification('CHAR_MP_MERRYWEATHER', Translation[Config.Locale]['cop_notify'] .. playername .. Translation[Config.Locale]['cop_notify2'] .. street .. Translation[Config.Locale]['cop_notify3'], prisonname, Translation[Config.Locale]['cop_heading'])

    local Blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local transT = 600

    SetBlipSprite(Blip, 10)
    SetBlipColour(Blip,  6)
    SetBlipAlpha(Blip,  transT)
    SetBlipAsShortRange(Blip, 1)

    while transT ~= 0 do
        Wait(100)
        transT = transT - 1
        SetBlipAlpha(Blip, transT)
        if transT == 0 then
            SetBlipSprite(Blip, 2)
            return
        end
    end

end)

RegisterNetEvent('myJail:EscapeUpdate')
AddEventHandler('myJail:EscapeUpdate', function(coords, last)
	if last then
		ShowNotification(Translation[Config.Locale]['gps_off'])
	end

	local Blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local transT = 600

    SetBlipSprite(Blip, 10)
    SetBlipColour(Blip,  2)
    SetBlipAlpha(Blip,  transT)
    SetBlipAsShortRange(Blip, 1)

    while transT ~= 0 do
        Wait(100)
        transT = transT - 1
        SetBlipAlpha(Blip, transT)
        if transT == 0 then
            SetBlipSprite(Blip, 2)
            return
        end
    end

end)


RegisterNetEvent('myJail:syncDelete')
AddEventHandler('myJail:syncDelete', function(pos)
    ClearAreaOfObjects(pos, 2.0, 0)
end)

function setPrisonClothes()
	TriggerEvent('skinchanger:getSkin', function(currentskin)
		if currentskin ~= nil then
			if currentskin.sex == 0 then
				-- male
				for k, component in pairs(Config.PrisonClothes['male']) do
					TriggerEvent('skinchanger:change', component.type, component.number)
				end

			elseif currentskin.sex == 1 then
				-- female
				for k, component in pairs(Config.PrisonClothes['female']) do
					TriggerEvent('skinchanger:change', component.type, component.number)
				end

			end

			-- save the prison skin
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('esx_skin:setLastSkin', skin)

				TriggerEvent('skinchanger:getSkin', function(skinnew)
					TriggerServerEvent('esx_skin:save', skinnew)
				end)
			end)
			--
		end
	end)
end

RegisterNetEvent('myJail:restoreSkin')
AddEventHandler('myJail:restoreSkin', function(oldskin)
	TriggerEvent('skinchanger:getSkin', function(skin)

		TriggerEvent('skinchanger:loadClothes', skin, oldskin)
		TriggerEvent('esx_skin:setLastSkin', oldskin)

		TriggerEvent('skinchanger:getSkin', function(skinnew)
			TriggerServerEvent('esx_skin:save', skinnew)
		end)

	end)
end)

RegisterNetEvent('myJail:syncRemainingSeconds')
AddEventHandler('myJail:syncRemainingSeconds', function(seconds)

	currentArrestSeconds = tonumber(seconds)

end)

RegisterNetEvent('myJail:syncRelease')
AddEventHandler('myJail:syncRelease', function(officerName)

	ShowNotification(Translation[Config.Locale]['released_early'] .. officerName .. Translation[Config.Locale]['released_early2'])
	currentArrestSeconds = 0
	releaseFromJail()
	

end)

RegisterNetEvent('myJail:msg')
AddEventHandler('myJail:msg', function(message)
	ShowNotification(message)
end)

function text(content) 
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.60,0.60)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.425,0.8)
end

function text2(content) 
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.60,0.60)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.415,0.825)
end

function changeText(content) 
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.40,0.40)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.4312,0.775)
end

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)
	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
	AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end