---@param src integer
---@param msg string
---@param type "success" | "warning" | "error"
function Framework.Server.Notify(src, msg, type)
  TriggerClientEvent("jg-handling:client:notify", src, msg, type, 5000)
end

---@param src integer
function Framework.Server.GetPlayer(src)
    if Config.Framework == "ESX" then
        return ESX.GetPlayerFromId(src)
    elseif Config.Framework == "QBCore" or Config.Framework == "Qbox" then
        return QBCore.Functions.GetPlayer(src)
    end
    return nil
end

---@param src integer
---@returns boolean
---@param src integer
---@returns boolean
function Framework.Server.IsAdmin(src)
    local player = Framework.Server.GetPlayer(src)
    if not player then return false end

    -- Kontrola pro QBCore a Qbox
    if Config.Framework == "QBCore" or Config.Framework == "Qbox" then
        return QBCore.Functions.HasPermission(src, "cardev") or IsPlayerAceAllowed(tostring(src), "command")
    
    -- Kontrola pro ESX
    elseif Config.Framework == "ESX" then
        return player.getGroup() == "cardev" or player.getGroup() == "dev"
    end

    return false
end

---@param src integer
---@return {name:string,label:string,grade:number} | false
function Framework.Server.GetPlayerJob(src)
  local player = Framework.Server.GetPlayer(src)
  if not player then return false end

  if Config.Framework == "QBCore" or Config.Framework == "Qbox" then
    if not player.PlayerData then return false end

    return {
      name = player.PlayerData.job.name,
      label = player.PlayerData.job.label,
      grade = player.PlayerData.job.grade?.level or 0,
    }
  elseif Config.Framework == "ESX" then
    return {
      name = player.job.name,
      label = player.job.label,
      grade = player.job.grade
    }
  end

  return false
end

---@param src integer
function Framework.Server.GetPlayerInfo(src)
  local player = Framework.Server.GetPlayer(src)
  if not player then
    return {
      name = GetPlayerName(src) or "cardev"
    }
  end

  if Config.Framework == "QBCore" or Config.Framework == "Qbox" then
    return {
      name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    }
  elseif Config.Framework == "ESX" then
    return {
      name = player.getName()
    }
  end
end