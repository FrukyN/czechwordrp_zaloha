ESX = exports["es_extended"]:getSharedObject()
local cooldown = false
RegisterNetEvent('wx_rpchat:send')
AddEventHandler('wx_rpchat:send', function(id, name, message)
	local sourceID = PlayerId()
	local playerID = GetPlayerFromServerId(id)
	ESX.TriggerServerCallback('wx_rpchat:getPlayerGroup', function(pgroup)
		if not cooldown then
			cooldown = true
			Citizen.SetTimeout(15*1000,function ()
				cooldown = false
			end)
			if playerID == sourceID then
					if message == '' or message == nil then
						Notify('Error',"Zprává nemůže být prázdná")

					else
						Notify('Info',"Zpráva úspěšně odeslána")
					end
			elseif pgroup ~= "user" and playerID ~= sourceID and message ~= '' and message ~= nil then
				TriggerEvent('chat:addMessage', {
					template = [[
					<div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

					<font style="padding: 0.15vw; margin: 0.22vw; background-color: #4b4b4bff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
						<font style="font-weight: 400;">ID: {0}</font>
						</font>
					<font style="padding: 0.15vw; margin: 0.22vw; background-color: #922a2a; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
						<font style="font-weight: 400;">NOVÝ REPORT</font>
					</font>
					<font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400">{1}:</font>
					<font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {2}</font>
					</div>
					  ]],					args = { id, name, message }
				})
			end
		elseif cooldown and playerID == sourceID then
			Notify('Error',"Zprává nemůže být odelsaná, vyčkej 15 sekund")
		end
	end)
end)