ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('give:id', function(index, licenseIndex)
    	local src = source
    	local xPlayer = ESX.GetPlayerFromId(src)
	local xPlayer = ESX.GetPlayerFromId(source)
	exports['ox_inventory']:AddItem(source, "id", 1, {
   		['name'] = xPlayer.getName(),
    		['dateofbirth'] = xPlayer.get('dateofbirth'),
    --		['sex'] = xPlayer.get('sex'),
    --		['height'] = xPlayer.get('height'),
        })
--end)
end)

RegisterNetEvent('give:dl', function(index, licenseIndex)
    	local src = source
    	local xPlayer = ESX.GetPlayerFromId(src)
	local xPlayer = ESX.GetPlayerFromId(source)
	local todayDate = os.date('%Y-%m-%d')
		exports['ox_inventory']:AddItem(source, "dl", 1, {
   			['name'] = xPlayer.getName(),
    			['dateofbirth'] = xPlayer.get('dateofbirth'),
    		--	['sex'] = xPlayer.get('sex'),
    		--	['dateoff'] = todayDate,
                --	['license'] = "a,b,c",
        	})
--end)
end)

--RegisterCommand('give', function(source, index, licenseIndex)
RegisterNetEvent('start:give', function(index, licenseIndex)
    	local src = source
    	local xPlayer = ESX.GetPlayerFromId(src)
	local xPlayer = ESX.GetPlayerFromId(source)
	exports['ox_inventory']:AddItem(source, "id", 1, {
   		['name'] = xPlayer.getName(),
    		['dateofbirth'] = xPlayer.get('dateofbirth'),
   -- 		['sex'] = xPlayer.get('sex'),
    --		['height'] = xPlayer.get('height'),
        })
	exports['ox_inventory']:AddItem(source, "phone", 1, {})
end)


-- radial menu


RegisterNetEvent("radial:getPlayerInfo", function(infoType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local value

    if infoType == "name" then
        value = xPlayer.getName()
    elseif infoType == "dob" then
        value = xPlayer.get("dateofbirth") or "Neuvedeno"
    elseif infoType == "job" then
        value = xPlayer.job.label
    end

    TriggerClientEvent("radial:returnPlayerInfo", src, infoType, value)
end)






