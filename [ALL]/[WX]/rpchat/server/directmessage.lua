RegisterCommand('dm', function(source, args, _)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not args[1] or tonumber(args[1]) == nil then
        
      TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Neplatné ID hráče',
              type = 'error',
              duration = 5000
        })
        return
    end

    local player = tonumber(args[1])

    if not GetPlayerName(player) then
              TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Hráč není online',
              type = 'error',
              duration = 5000
        })
        return
    end

    table.remove(args, 1)
    local message = table.concat(args, " ")

    if message == "" then
              TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Zprava nesmí být prázdná',
              type = 'error',
              duration = 5000
        })
        return
    end

    if wx.AdminGroups[xPlayer.getGroup()] == true then
        -- zpráva pro cílového hráče
        TriggerClientEvent('chat:addMessage', player, {
            template = [[
              <div style="padding:0.15vw;height:1.3vw;width:100%;margin:0.2vw;background-color:#0f0f0fd2;border-radius:4px;padding-top:0.4vw;box-shadow:0px 0px 11px rgba(34,34,34,0.35)">
                <font style="padding:0.15vw;margin:0.22vw;background-color:#962819ff;padding-left:1%;border-radius:1px;font-size:13px">
                  <font style="font-weight:400;">ZPRÁVA OD ADMINA</font>
                </font>
                <font style="font-size:14px;padding-left:5px;color:#dfddddff;font-weight:400">{0}:</font>
                <font class="message" style="font-size:14px;color:#dfddddff;font-weight:400"> {1}</font>
              </div>
            ]],
            args = {GetPlayerName(source), message}
        })

        TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Zpráva odeslána hráči '..GetPlayerName(player),
              type = 'success',
              duration = 5000
        })

        -- logy
        local discord, ip, steam = "Not Found", "Not Found", "Not Found"
        for _, v in pairs(GetPlayerIdentifiers(source)) do
            if v:sub(1, 6) == "steam:" then
                steam = v
            elseif v:sub(1, 8) == "discord:" then
                discord = v
            elseif v:sub(1, 3) == "ip:" then
                ip = v
            end
        end
        log("**Direct Message to **"..GetPlayerName(player), source, GetPlayerName(source), message, steam, discord, ip, Webhooks['directmessage'])

    else
              TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Nejsi admin',
              type = 'error',
              duration = 5000
        })
    end
end, false)
