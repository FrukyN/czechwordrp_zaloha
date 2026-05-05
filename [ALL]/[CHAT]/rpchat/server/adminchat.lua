local function havePermission(xPlayer)
	if wx.AdminGroups[xPlayer.getGroup()] then
		return true
	end
	return false
end

RegisterCommand("a", function(source, args, rawCommand)	-- /a command for adminchat
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local playerName = GetPlayerName(source)
		if wx.AdminGroups[xPlayer.getGroup()] then
			if args[1] then
				local message = string.sub(rawCommand, 3)
				local xAll = ESX.GetPlayers()
				for i=1, #xAll, 1 do
					local xTarget = ESX.GetPlayerFromId(xAll[i])
					if wx.AdminGroups[xTarget.getGroup()] then
						TriggerClientEvent('chat:addMessage', xTarget.source, {
							template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #4b4b4bff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
									<font style="font-weight: 400;">ID: {0}</font>
								</font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #962819ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
									<font style="font-weight: 400;">ADMIN CHAT</font>
								</font>
								<font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400">{1}:</font>
								<font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {2}</font>
							</div>
							  ]],							args = { source, playerName, message }
						})
					end
				end
			else
			TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Správa nesmí být prázdná',
              type = 'error',
			  duration = 5000
        })
			end
		else
			TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Nejsi admin',
              type = 'error',
			  			  duration = 5000

        })
		end
	end
end, false)