ESX = exports["es_extended"]:getSharedObject()

local loocwebhook = Webhooks['looc']
local mewebhook = Webhooks['me']
local dowebhook = Webhooks['do']
local trywebhook = Webhooks['try']
local adwebhook = Webhooks['ad']
local staffwebhook = Webhooks['staff']
local blackmarketwebhook = Webhooks['blackmarket']

function GetRealPlayerName(playerId)
  local xPlayer = ESX.GetPlayerFromId(playerId)

  if xPlayer then
      if wx.OnlyInicials then
          local name = xPlayer.get('firstName')
          name = string.sub(name, 1, 1)
          local surname = xPlayer.get('lastName')
          surname = string.sub(surname, 1, 1)
          local shortName = name..". "..surname..". "
          return shortName
      else
          return xPlayer.getName()
      end
  else
      return GetPlayerName(playerId)
  end
end

function ExtractIdentifiers(src)
  local identifiers = {
      steam = "Not Found",
      ip = "Not Found",
      discord = "Not Found",
      license = "Not Found",
      xbl = "Not Found",
      live = "Not Found"
  }

  --Loop over all identifiers
  for i = 0, GetNumPlayerIdentifiers(src) - 1 do
      local id = GetPlayerIdentifier(src, i)

      --Convert it to a nice table.
      if string.find(id, "steam") then
          identifiers.steam = id
      elseif string.find(id, "ip") then
          identifiers.ip = id
      elseif string.find(id, "discord") then
          identifiers.discord = id
      elseif string.find(id, "license") then
          identifiers.license = id
      elseif string.find(id, "xbl") then
          identifiers.xbl = id
      elseif string.find(id, "live") then
          identifiers.live = id
      elseif string.find(id, "fivem") then
          identifiers.fivem = id
      end
  end

  return identifiers
end



AddEventHandler('chatMessage', function(source, name, message)
  if string.sub(message, 1, string.len('/')) ~= '/' then CancelEvent()
    local discord = "Not Found"
    local ip = "Not Found"
    local steam = "Not Found"
    for k, v in pairs(GetPlayerIdentifiers(source)) do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steam = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ip = v
      end
    end
    log("L-OOC", source, name, message,steam,discord,ip,loocwebhook)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = GetPlayerName(source)
    local admin = false
    if wx.LOOCAdminPrefixes then
      if wx.AdminGroups[xPlayer.getGroup()] then admin = true end
    end
    TriggerClientEvent('wx_rpchat:sendLocalOOC', -1, source, name, message, admin);
  end

end)


RegisterCommand(wx.Commands['Staff Announcement'], function(source,args,raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  local toSay = ''
    for i=1,#args do
     toSay = toSay .. args[i] .. ' ' 
   end

   if wx.AdminGroups[xPlayer.getGroup()] == true then
    TriggerClientEvent('chat:addMessage', -1, {
      template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #962819ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
            <font style="font-weight: 400;">OZNÁMENÍ</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
        <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {0}</font>
    </div>
      ]],
      args = { toSay }
  })
  end
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/staff** Announcement", source, GetPlayerName(source), toSay,steam,discord,ip,staffwebhook)
end,false)


RegisterCommand('id', function(source,args,raw)
    TriggerClientEvent('chat:addMessage', source, {
      template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #244617ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
            <font style="font-weight: 400;">SERVER</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400">Tvoje ID:</font>
        <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {0}</font>
    </div>
      ]],
    args = { source }
  })
end)


RegisterCommand(wx.Commands['Job'], function(source,args,raw)
    local fal = GetRealPlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('chat:addMessage', source, {
      template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #244617ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
            <font style="font-weight: 400;">SERVER</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
        <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {0}</font>
    </div>
      ]],      args = { fal.."zaměstnán jako "..xPlayer.job.label.." - "..xPlayer.job.grade_label }
  })
end)

if wx.AutoMessages then
  Citizen.CreateThread(function()
    while true do
    TriggerClientEvent('chat:addMessage', -1, {
      template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #244617ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
            <font style="font-weight: 400;">SERVER</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
        <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {0}</font>
    </div>
      ]],      args = { wx.AutoMessagesList[math.random(#wx.AutoMessagesList)] }
    })
    Citizen.Wait(wx.AutoMessageInterval*60*1000)
  end
  end)
end

RegisterCommand(wx.Commands['Advertisement'], function(source, args, raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  local toSay = ''
    for i=1,#args do
  toSay = toSay .. args[i] .. ' '
  end
  if xPlayer.getAccount('bank').money >= wx.AdCost then
    if not adcooldown[source] then
      if toSay == '' then

          TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Zpráva inzerátu nemůže být prázdná!',
              type = 'error',
      	      duration = 5000
          })

        return       
      end
      xPlayer.removeAccountMoney('bank',wx.AdCost)
      adcooldown[source] = true
      Citizen.SetTimeout(wx.AdCooldown,function()
      adcooldown[source] = false
      end)
      TriggerClientEvent('chat:addMessage', -1, {
        template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #4b4b4bff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">ID: {0}</font>
      </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgba(155, 182, 38, 1); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
              <font style="font-weight: 400;">REKLAMA</font>
          </font>
          <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
          <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
      </div>
        ]],
        args = {source, toSay}
      })
              TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Inzerát úspěšně odeslán za '..wx.AdCost..'CZK',
              type = 'success',
              duration = 5000
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Nemůžeš poslat inzerát, musíš počkat '..math.ceil((wx.AdCooldown/1000)/60)..' minut!',
              type = 'error',
              duration = 5000
        })
    end
  else
            TriggerClientEvent('ox_lib:notify', source, {
              title = 'CHAT',
              description = 'Nemáš dostatek peněz na bankovním účtu! Cena inzerátu je '..wx.AdCost..'CZK',
              type = 'error',
              duration = 5000
        })

  end
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/blackmarket**", source, GetPlayerName(source), toSay,steam,discord,ip,blackmarketwebhook)
end, false)


------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('me', function(source, args, raw)
  local args = table.concat(args, ' ')
  local name = GetRealPlayerName(source)
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/me**", source, GetPlayerName(source), args,steam,discord,ip,mewebhook)

  TriggerClientEvent('wx_rpchat:sendMe', -1, source, name, args, { 196, 33, 246 })
  TriggerClientEvent('3dme:triggerDisplay', -1, args, source)
end,false)

RegisterCommand('do', function(source, args, raw)
  local args = table.concat(args, ' ')
  local name = GetRealPlayerName(source)
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/do**", source, GetPlayerName(source), args,steam,discord,ip,dowebhook)

  TriggerClientEvent('wx_rpchat:sendDo', -1, source, name, args, { 255, 198, 0 })
  TriggerClientEvent('3ddo:triggerDisplay', -1, "* "..args.." *", source)
end,false)

RegisterCommand('try', function(source, args, raw)
  local result = "NE"
  local name = GetRealPlayerName(source)
  local random = math.random(1,2)
  if random == 1 then
    result = "ANO"
    TriggerClientEvent('wx_rpchat:sendTry', -1, source, name, result, { 255, 198, 0 })
    TriggerClientEvent('3dme:triggerDisplay', -1, "* "..result.." *", source)
  else
    TriggerClientEvent('wx_rpchat:sendTry', -1, source, name, result, { 255, 198, 0 })
    TriggerClientEvent('3dme:triggerDisplay', -1, "* "..result.." *", source)
  end
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/try**", source, GetPlayerName(source), result,steam,discord,ip,trywebhook)
end,false)

RegisterCommand("kostka", function(source, args, rawCommand)
    if source == 0 then return end

    local roll = math.random(1, 6)
    local srcPed = GetPlayerPed(source)
    local srcCoords = GetEntityCoords(srcPed)

    -- 🔹 Řekni klientovi, ať spustí animaci přes Scully Emote Menu
    TriggerClientEvent('kostka:animace', source)

    -- 🔹 Pošli zprávu a 3D text jen hráčům v okolí
    for _, playerId in pairs(GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        local coords = GetEntityCoords(ped)

        if #(srcCoords - coords) <= 5.0 then
            TriggerClientEvent('chat:addMessage', playerId, {
                template = [[
                    <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw; background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">
                        <font style="padding: 0.15vw; margin: 0.22vw; background-color: #461734ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
                            <font style="font-weight: 400;">KOSTKA</font>
                        </font>
                        <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400">Padlo číslo:</font>
                        <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400">{0}</font>
                    </div>
                ]],
                args = { roll }
            })

            TriggerClientEvent('3ddo:triggerDisplay', playerId, "* " .. roll .. " *", source)
        end
    end
end, false)

RegisterCommand('doc', function(source, args, raw)
  local name = GetRealPlayerName(source)
  if args[1] ~= nil then 
    local c = 0
    local count = tonumber(args[1])
    if count < wx.MaxDocCount then
      while c < count do
          c = c + 1 
          TriggerClientEvent('wx_rpchat:sendDoc', -1, source, name, c .. "/" .. count , { 255, 198, 0 })
          TriggerClientEvent('3ddoa:triggerDisplay', -1, c .. "/" .. count, source)
          Wait(1518)
      end
    end
  end
end,false)

----------------------------------------------------------------------------------------------------------------------------------

-- Police Chat
RegisterCommand("pcr", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "pcr"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'police' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #2495b1ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Policie České Republiky</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- policie mp Chat
RegisterCommand("mp", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "mp"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'policie_mp' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #2495b1ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Městská policie</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)



-- EMS Chat

RegisterCommand("zzs", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "zzs"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'ambulance' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #dad733ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Záchranná zdravotnická služba</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- fire chat

RegisterCommand("hzs", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "hzs"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'hzs' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #962b2bff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Hasičský záchranný sbor</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)


 -- podniky

RegisterCommand("autokelly", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "mechanic"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'mechanic' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #858457ff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Auto Kelly</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

RegisterCommand("splitsides", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "splitsides"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'splitsides' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #46110dff; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">SplitSides</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)


RegisterCommand("wine", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "wine"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'wine' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #7d302a; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Vinařství</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

RegisterCommand("zastavarna", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "pawshop"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'pawshop' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #7A502a; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Zastavárna</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)


RegisterCommand("stk", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "stk"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'stk' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: #4B5065; padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Stk</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- huspudku mp Chat
RegisterCommand("hospudka", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "hospudka"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'hospudka' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(122, 88, 13); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Hospůdka na rohu</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- Vanilla mp Chat
RegisterCommand("vanilla", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "vanilla"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'vanilla' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(199, 19, 199); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Vanilla klub</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- Bahama mp Chat
RegisterCommand("bahama", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "bahama"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'bahama' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(184, 18, 218); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Bahama bar</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: #dfddddff; margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: #dfddddff; margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- Zastavarna Chat
RegisterCommand("zastavarna", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "zastavarna"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'zastavarna' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(243, 239, 8); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Zastavárna</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- Zastavarna Chat
RegisterCommand("congrest", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "congrest"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'kongrest' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(18, 240, 221); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">CHAIN RESTAURANTE</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- ProfiAuto Chat
RegisterCommand("profiauto", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "congrest"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'profiauto' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgb(107, 173, 21); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Profi Auto</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- ProfiAuto Chat
RegisterCommand("stk", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "stk"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'stk' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgba(210, 241, 71, 0.7); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">STK dílna</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- cernakovci
RegisterCommand("cernakovci", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "cernakovci"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'cernakovci' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgba(110, 182, 71, 0.7); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Bar u Čermáků</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

-- taxi
RegisterCommand("taxi", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "taxi"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'taxi' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgba(255, 216, 0, 0.7); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">TAXI</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)




-- Pizza de costa Chat
RegisterCommand("pizza", function(source, args, raw)
  local playerName = GetPlayerName(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local command = "pizza"
  local toSay = ''
     for i=1,#args do
  toSay = toSay .. args[i] .. ' '
end
  if xPlayer.job.name ==  'pizza' then 
  TriggerClientEvent('chat:addMessage', -1, {
    template = [[
          <div style="padding: 0.15vw; height: 1.3vw; width: 100%; margin: 0.2vw;  background-color: rgba(6, 11, 34, 0.75); border-radius: 4px; padding-top: 0.4vw; border: none; box-shadow: 0px 0px 11px rgba(34, 34, 34, 0.35)">

  </font>
          <font style="padding: 0.15vw; margin: 0.22vw; background-color: rgba(6, 233, 25, 0.7); padding-left: 1%; border-radius: 1px; border: none; font-size: 13px">
          <font style="font-weight: 400;">Pizzerie de costa</font>
      </font>
      <font style="font-size: 14px; padding-left: 5px; color: rgb(0, 0, 0); margin: auto; font-weight:400"></font>
      <font class="message" style="font-size: 14px; color: rgb(255, 255, 255); margin: auto; font-weight:400"> {1}</font>
  </div>
    ]],    args = {source,toSay}
    })
else
    TriggerClientEvent('ox_lib:notify', source, {
      title = 'CHAT',
      description = 'Musíš být zaměstnaný, aby jsi mohl použít tento příkaz!',
      type = 'error',
      duration = 5000
   })
end
end, false)

----


RegisterCommand(wx.Commands['Blackmarket'], function(source, args, raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  local toSay = ''
    for i=1,#args do
  toSay = toSay .. args[i] .. ' '
  end
  if xPlayer.job.name ~= wx.Jobs['LSPD'] then
    TriggerClientEvent('chat:addMessage', -1, {
      template = [[
        <div style="padding: 0.3vw; height: 1.5vw; margin: 0.5vw;  background-color: #222228ec; border-radius: 10px; padding-top: 0.35vw; border: 0.11vw solid #414146; box-shadow: 0px 0px 11px rgba(158, 158, 158, 0.35)">
        <font style="padding: 0.15vw; margin: 0.22vw; background-color: #626066; padding-left: 1%; border-radius: 8px; border: #9e9e9e solid 0.11vw; font-size: 12px; box-shadow: 0px 0px 11px rgba(158, 158, 158, 0.55)">
        <font style="font-weight: 600;">ID: {0}</font>
    </font>
        <font style="padding: 0.15vw; margin: 0.22vw; background-color: #1F1C20; padding-left: 1%; border-radius: 8px; border: #363437 solid 0.11vw; font-size: 12px; box-shadow: 0px 0px 11px rgba(50, 50, 50, 0.55)">
            <font style="font-weight: 600;">BLACKMARKET</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #c7c5c5; margin: auto; font-weight:400"></font>
        <font class="message" style="font-size: 14px; color: #a8a7a7; margin: auto; font-weight:400"> {1}</font>
    </div>
      ]],
      args = {source, toSay}
    })
  else
    TriggerClientEvent('chat:addMessage', source, {
      template = [[
        <div style="padding: 0.3vw; height: 1.5vw; margin: 0.5vw;  background-color: #222228ec; border-radius: 10px; padding-top: 0.35vw; border: 0.11vw solid #414146; box-shadow: 0px 0px 11px rgba(158, 158, 158, 0.35)">
        <font style="padding: 0.15vw; margin: 0.22vw; background-color: #922a2a; padding-left: 1%; border-radius: 8px; border: #c72f2f solid 0.11vw; font-size: 12px; box-shadow: 0px 0px 11px rgba(156, 21, 21, 0.55)">
            <font style="font-weight: 600;">ERROR</font>
        </font>
        <font style="font-size: 14px; padding-left: 5px; color: #c7c5c5; margin: auto; font-weight:400"></font>
        <font class="message" style="font-size: 14px; color: #a8a7a7; margin: auto; font-weight:400">You cannot use the blackmarket as LSPD</font>
    </div>
      ]],
      args = {}
    })

  end
  local discord = "Not Found"
  local ip = "Not Found"
  local steam = "Not Found"
  for k, v in pairs(GetPlayerIdentifiers(source)) do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steam = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      ip = v
    end
  end
  log("**/blackmarket**", source, GetPlayerName(source), toSay,steam,discord,ip,blackmarketwebhook)
end, false)