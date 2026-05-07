local licenses = {}

MySQL.ready(function()
	local p = promise.new()
	MySQL.query('SELECT type, label FROM licenses', function(result)
		licenses = result
		p:resolve(true)
	end)
	Citizen.Await(p)
	ESX.Trace('[esx_license] : ' .. #licenses .. ' Loaded.')
end)

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function AddLicense(identifier, licenseType, cb)
	MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function RemoveLicense(identifier, licenseType, cb)
	MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

---@param licenseType license type
---@param cb callback function
local function GetLicense(licenseType, cb)
	MySQL.scalar('SELECT label FROM licenses WHERE type = ?', {licenseType}, function(result)
		if cb then
			cb({type = licenseType, label = result})
		end
	end)
end

---@param identifier target identifier
---@param cb callback function
local function GetLicenses(identifier, cb)
	MySQL.query('SELECT user_licenses.type, licenses.label FROM user_licenses LEFT JOIN licenses ON user_licenses.type = licenses.type WHERE owner = ?', {identifier},
	function(result)
		if cb then
			cb(result)
		end
	end)
end

---@param identifier target identifier
---@param licenseType license type
---@param cb callback function
local function CheckLicense(identifier, licenseType, cb)
	MySQL.scalar('SELECT type FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(result)
		if cb then
			if result then
				cb(true)
			else
				cb(false)
			end
		end
	end)
end

local function GetLicensesList(cb)
	cb(licenses)
end

local function isValidLicense(licenseType)
	local flag = false
	for i=1,#licenses do
		if licenses[i].type == licenseType then
			flag = true
			break
		end
	end
	return flag
end

---@param target number
---@param licenseType string
---@param action fun(identifier: string, license: string, cb?: function)
---@param cb? function
local function handleLicenseAction(target, licenseType, action, cb)
	local xPlayer = ESX.Player(target)
	if not xPlayer then
		return false, 'invalid_player'
	end

	if not isValidLicense(licenseType) then
		return false, 'invalid_license'
	end

	action(xPlayer.getIdentifier(), licenseType, cb)
	return true
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, licenseType, cb)
	local ok, reason = handleLicenseAction(target, licenseType, AddLicense, cb)
	if not ok and reason == 'invalid_license' then
		print(('[esx_license]: Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(licenseType, target))
	end
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, licenseType, cb)
	local ok, reason = handleLicenseAction(target, licenseType, RemoveLicense, cb)
	if not ok and reason == 'invalid_license' then
		print(('[esx_license]: Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(licenseType, target))
	end
end)

AddEventHandler('esx_license:getLicense', function(licenseType, cb)
	GetLicense(licenseType, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	local xPlayer = ESX.Player(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

AddEventHandler('esx_license:checkLicense', function(target, licenseType, cb)
	local xPlayer = ESX.Player(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, licenseType)
	local xPlayer = ESX.Player(source)
	if xPlayer then
		GetLicense(licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	local xPlayer = ESX.Player(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, licenseType)
	local xPlayer = ESX.Player(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)

RegisterCommand('pridat', function(source, args)
	local xPlayer = ESX.Player(source)
	if source ~= 0 and (not xPlayer or xPlayer.getGroup() ~= 'admin') then
		if xPlayer then
			xPlayer.showNotification('Nemas opravneni na tento command.')
		end
		return
	end

	local targetId = tonumber(args[1])
	local licenseType = args[2]
	if not targetId or not licenseType then
		if source == 0 then
			print('Pouziti: /pridat [id] [license]')
		else
			xPlayer.showNotification('Pouziti: /pridat [id] [license]')
		end
		return
	end

	local ok, reason = handleLicenseAction(targetId, licenseType, AddLicense)
	if not ok then
		if source == 0 then
			if reason == 'invalid_player' then
				print(('Hrac s ID %s nebyl nalezen.'):format(targetId))
			else
				print(('License "%s" neexistuje v databazi.'):format(licenseType))
			end
		else
			if reason == 'invalid_player' then
				xPlayer.showNotification(('Hrac s ID %s nebyl nalezen.'):format(targetId))
			else
				xPlayer.showNotification(('License "%s" neexistuje v databazi.'):format(licenseType))
			end
		end
		return
	end

	local targetPlayer = ESX.Player(targetId)
	if targetPlayer then
		targetPlayer.showNotification(('Byla ti pridana license: %s'):format(licenseType))
	end

	if source == 0 then
		print(('License "%s" byla pridana hraci %s.'):format(licenseType, targetId))
	else
		xPlayer.showNotification(('License "%s" byla pridana hraci %s.'):format(licenseType, targetId))
	end
end, false)

RegisterCommand('odebrat', function(source, args)
	local xPlayer = ESX.Player(source)
	if source ~= 0 and (not xPlayer or xPlayer.getGroup() ~= 'admin') then
		if xPlayer then
			xPlayer.showNotification('Nemas opravneni na tento command.')
		end
		return
	end

	local targetId = tonumber(args[1])
	local licenseType = args[2]
	if not targetId or not licenseType then
		if source == 0 then
			print('Pouziti: /odebrat [id] [license]')
		else
			xPlayer.showNotification('Pouziti: /odebrat [id] [license]')
		end
		return
	end

	local ok, reason = handleLicenseAction(targetId, licenseType, RemoveLicense)
	if not ok then
		if source == 0 then
			if reason == 'invalid_player' then
				print(('Hrac s ID %s nebyl nalezen.'):format(targetId))
			else
				print(('License "%s" neexistuje v databazi.'):format(licenseType))
			end
		else
			if reason == 'invalid_player' then
				xPlayer.showNotification(('Hrac s ID %s nebyl nalezen.'):format(targetId))
			else
				xPlayer.showNotification(('License "%s" neexistuje v databazi.'):format(licenseType))
			end
		end
		return
	end

	local targetPlayer = ESX.Player(targetId)
	if targetPlayer then
		targetPlayer.showNotification(('Byla ti odebrana license: %s'):format(licenseType))
	end

	if source == 0 then
		print(('License "%s" byla odebrana hraci %s.'):format(licenseType, targetId))
	else
		xPlayer.showNotification(('License "%s" byla odebrana hraci %s.'):format(licenseType, targetId))
	end
end, false)
