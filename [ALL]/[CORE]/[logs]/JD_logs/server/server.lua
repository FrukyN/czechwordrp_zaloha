local postals = {}

-- Načtení lokací POUZE JEDNOU při startu resource
Citizen.CreateThread(function()
    local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file') or 'postals.json')
    if raw then
        postals = json.decode(raw) or {}
        print('^2[JD_Logs] Nacteno ' .. #postals .. ' postals z pameti.^7')
    end
end)

function sanitize(string)
    return string:gsub('%@', '')
end

exports('sanitize', function(string)
    sanitize(string)
end)

RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs", function(message, color, channel)
    discordLog(message, color, channel)
end)

-- Pomocná funkce pro bezpečné parsování barev
local function parseColor(colorStr)
    if type(colorStr) == "string" and string.find(colorStr, "#") then
        return tonumber(colorStr:gsub("#",""), 16)
    end
    return colorStr
end

local joinColor = parseColor(Config.joinColor)
local leaveColor = parseColor(Config.leaveColor)
local chatColor = parseColor(Config.chatColor)
local shootingColor = parseColor(Config.shootingColor)
local deathColor = parseColor(Config.deathColor)
local resourceColor = parseColor(Config.resourceColor)

exports('discord', function(message, id, id2, color, channel)
    local _color = parseColor(color)
    local _message = message

    if id ~= 0 then
        _message = buildPlayerInfoString(id, message)
    end

    if id2 ~= 0 then
        local player2Info = buildPlayerInfoString(id2, "")
        _message = _message .. '\n' .. player2Info
    end

    discordLog(_message, _color, channel)
end)

function buildPlayerInfoString(id, prefixMessage)
    local ids = ExtractIdentifiers(id)
    local postal = getPlayerLocation(id)
    
    local str = prefixMessage .. '\n'
    if Config.playerID then str = str .. "**Player ID:** " .. id .. "\n" end
    if Config.postal then str = str .. "**Nearest Postal:** " .. postal .. "\n" end
    if Config.discordID then 
        str = str .. "**Discord ID:** " .. (ids.discord ~= "" and "<@" .. ids.discord:gsub("discord:", "") .. ">" or "N/A") .. "\n"
    end
    if Config.steamID then 
        str = str .. "**Steam ID:** " .. (ids.steam ~= "" and ids.steam or "N/A") .. "\n"
    end
    if Config.steamURL then  
        str = str .. "**Steam URL:** " .. (ids.steam ~= "" and "https://steamcommunity.com/profiles/" .. tonumber(ids.steam:gsub("steam:", ""), 16) or "N/A") .. "\n"
    end
    if Config.license then 
        str = str .. "**License:** " .. (ids.license ~= "" and ids.license or "N/A") .. "\n"
    end
    if Config.IP then 
        str = str .. "**IP:** " .. (ids.ip ~= "" and ids.ip or "N/A") .. "\n"
    end
    return str
end

function discordLog(message, color, channel)
    local embedData = {
        username = Config.username,
        avatar_url = Config.avatar,
        embeds = {{
            ["color"] = color,
            ["author"] = {["name"] = Config.communtiyName, ["icon_url"] = Config.communtiyLogo},
            ["description"] = message,
            ["footer"] = {
                ["text"] = "© JokeDevil.com - "..os.date("%x %X %p"),
                ["icon_url"] = "https://www.jokedevil.com/img/logo.png"
            }
        }}
    }
    
    if Config.AllLogs and Config.webhooks["all"] and Config.webhooks["all"] ~= "" then
        PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode(embedData), { ['Content-Type'] = 'application/json' })
    end

    if Config.webhooks[channel] and Config.webhooks[channel] ~= "" then
        PerformHttpRequest(Config.webhooks[channel], function(err, text, headers) end, 'POST', json.encode(embedData), { ['Content-Type'] = 'application/json' })
    end
end

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '** is connecting to the server.')
    discordLog(msg, joinColor, 'joins')
end)

AddEventHandler('playerDropped', function(reason)
    local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '** has left the server. (Reason: ' .. reason .. ')')
    discordLog(msg, leaveColor, 'leaving')
end)

AddEventHandler('chatMessage', function(source, name, msgText)
    local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '**: ``' .. msgText .. '``')
    discordLog(msg, chatColor, 'chat')
end)

RegisterServerEvent('playerDied')
AddEventHandler('playerDied', function(typeId, player, killer, DeathReason, Weapon)
    local _DeathReason = DeathReason and "`"..DeathReason.."`" or "`died`"
    local _Weapon = Weapon and "`("..Weapon..")`" or ""

    if typeId == 1 then  -- Suicide / died
        local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '** '.._DeathReason..' '.._Weapon)
        discordLog(msg, deathColor, 'deaths')
    elseif typeId == 2 then -- Killed by another player
        local killerName = GetPlayerName(killer) or "Unknown"
        local sourceName = GetPlayerName(source) or "Unknown"
        
        local msgSource = buildPlayerInfoString(source, '**[Player INFO]**')
        local msgKiller = buildPlayerInfoString(killer, '**[Killer INFO]**')

        local finalMsg = '**' .. sanitize(killerName) .. '** ' .. _DeathReason .. ' ' .. sanitize(sourceName) .. ' ' .. _Weapon .. '\n\n' .. msgSource .. '\n\n' .. msgKiller
        discordLog(finalMsg, deathColor, 'deaths')
    else 
        local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '** `died`')
        discordLog(msg, deathColor, 'deaths')
    end
end)

RegisterServerEvent('playerShotWeapon')
AddEventHandler('playerShotWeapon', function(weapon)
    if not Config.weaponLog then return end
    local weaponName = weapon or "Unknown Weapon"
    local msg = buildPlayerInfoString(source, '**' .. sanitize(GetPlayerName(source)) .. '** fired a `' .. weaponName .. '`')
    discordLog(msg, shootingColor, 'shooting')
end)

RegisterServerEvent('ClientDiscord')
AddEventHandler('ClientDiscord', function(message, id, id2, color, channel)
    local _color = parseColor(color)
    local _message = message

    if id ~= 0 then _message = buildPlayerInfoString(id, message) end
    if id2 ~= 0 then _message = _message .. '\n' .. buildPlayerInfoString(id2, "") end

    discordLog(_message, _color, channel)
end)

AddEventHandler('onResourceStop', function(resourceName)
    discordLog('**' .. resourceName .. '** has been stopped.', resourceColor, 'resources')
end)

AddEventHandler('onResourceStart', function(resourceName)
    Wait(100)
    discordLog('**' .. resourceName .. '** has been started.', resourceColor, 'resources')
end)

RegisterServerEvent('JDlogs:GetIdentifiers')
AddEventHandler('JDlogs:GetIdentifiers', function(src)
    return ExtractIdentifiers(src)
end)

function ExtractIdentifiers(src)
    local identifiers = { steam = "", ip = "", discord = "", license = "", xbl = "", live = "" }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then identifiers.steam = id
        elseif string.find(id, "ip") then identifiers.ip = id
        elseif string.find(id, "discord") then identifiers.discord = id
        elseif string.find(id, "license") then identifiers.license = id
        elseif string.find(id, "xbl") then identifiers.xbl = id
        elseif string.find(id, "live") then identifiers.live = id
        end
    end
    return identifiers
end

function getPlayerLocation(src)
    if not Config.postal or #postals == 0 then return "N/A" end

    local ped = GetPlayerPed(src)
    if not DoesEntityExist(ped) then return "N/A" end

    local playerCoords = GetEntityCoords(ped)
    local x, y = table.unpack(playerCoords)

    local ndm = -1
    local ni = -1
    for i, p in ipairs(postals) do
        local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
        if ndm == -1 or dm < ndm then
            ni = i
            ndm = dm
        end
    end

    if ni ~= -1 then
        return postals[ni].code
    end
    return "N/A"
end