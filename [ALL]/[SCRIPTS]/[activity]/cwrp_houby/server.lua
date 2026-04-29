local ESX = exports.es_extended:getSharedObject()

local activeMushrooms = {}
local playerRateLimits = {}
local mushroomByItem = {}
local mushroomIdCounter = 0

local function dist(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    -- Úmyslně ignorujeme osu Z (dz), protože klient houbu posouvá na reálný terén, 
    -- o jehož přesné výšce server neví. Počítáme jen 2D vzdálenost.
    return math.sqrt(dx * dx + dy * dy)
end
local function randomPointInZone(zone)
    local r = zone.radius * math.sqrt(math.random())
    local theta = math.random() * (math.pi * 2.0)

    return {
        x = zone.coords.x + (r * math.cos(theta)),
        y = zone.coords.y + (r * math.sin(theta)),
        z = zone.coords.z
    }
end

local function getCurrentWeatherName()
    local weatherState = GlobalState.weather

    if type(weatherState) == 'string' then
        return string.upper(weatherState)
    end

    return nil
end

local function getWeightedRandomMushroom()
    local weather = getCurrentWeatherName()
    local rainBoost = 1.0

    if Config.Weather.Enabled and weather and Config.Weather.RainWeathers[weather] then
        rainBoost = Config.Weather.RainBoostMultiplier
    end

    local totalChance = 0.0
    for _, mushroom in ipairs(Config.Mushrooms) do
        local c = mushroom.chance or 1
        if mushroom.poisonous then
            c = c / rainBoost
        else
            c = c * rainBoost
        end

        totalChance = totalChance + c
    end

    local roll = math.random() * totalChance
    local running = 0.0

    for _, mushroom in ipairs(Config.Mushrooms) do
        local c = mushroom.chance or 1
        if mushroom.poisonous then
            c = c / rainBoost
        else
            c = c * rainBoost
        end

        running = running + c
        if roll <= running then
            return mushroom
        end
    end

    return Config.Mushrooms[#Config.Mushrooms]
end

local function discordLog(title, description, color)
    if not Config.Discord.Enabled then
        return
    end

    if not Config.Discord.Webhook or Config.Discord.Webhook == '' then
        return
    end

    local payload = {
        username = Config.Discord.BotName or 'CWRP Houby',
        avatar_url = Config.Discord.IconURL or '',
        embeds = {
            {
                title = title,
                description = description,
                color = color or 65280,
                footer = {
                    text = os.date('%Y-%m-%d %H:%M:%S')
                }
            }
        }
    }

    PerformHttpRequest(Config.Discord.Webhook, function() end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end

local function addMushroom()
    local zone = Config.Zones[math.random(1, #Config.Zones)]
    local mushroom = getWeightedRandomMushroom()

    mushroomIdCounter = mushroomIdCounter + 1

    local data = {
        id = mushroomIdCounter,
        coords = randomPointInZone(zone),
        model = mushroom.model,
        item = mushroom.item,
        label = mushroom.label,
        poisonous = mushroom.poisonous == true
    }

    activeMushrooms[data.id] = data

    TriggerClientEvent('cwrp_houby:client:addMushroom', -1, data)
end

local function countActiveMushrooms()
    local count = 0
    for _ in pairs(activeMushrooms) do
        count = count + 1
    end

    return count
end

local function removeMushroom(mushroomId)
    activeMushrooms[mushroomId] = nil
    TriggerClientEvent('cwrp_houby:client:removeMushroom', -1, mushroomId)

    SetTimeout(Config.RespawnTimeMs, function()
        addMushroom()
    end)
end

local function isRateLimited(src)
    if not Config.Security.EnableRateLimit then
        return false
    end

    local now = GetGameTimer()
    local entry = playerRateLimits[src]

    if not entry or now > entry.resetAt then
        playerRateLimits[src] = {
            count = 1,
            resetAt = now + Config.Security.WindowMs
        }
        return false
    end

    entry.count = entry.count + 1

    return entry.count > Config.Security.MaxRequestsPerWindow
end

local function getPlayerIdentifier(src)
    local ids = GetPlayerIdentifiers(src)
    return ids[1] or 'unknown'
end

local function notify(src, message, msgType)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Houby',
        description = message,
        type = msgType or 'inform'
    })
end

local function hasRequiredBasket(src)
    local count = exports.ox_inventory:Search(src, 'count', Config.RequiredItem)
    return (count or 0) > 0
end

lib.callback.register('cwrp_houby:server:getInitialMushrooms', function()
    return activeMushrooms
end)

lib.callback.register('cwrp_houby:server:tryPick', function(src, mushroomId)
    if type(mushroomId) ~= 'number' then
        if Config.Discord.LogExploitAttempt then
            discordLog(
                'Exploit attempt',
                ('Player `%s` (%s) sent invalid mushroomId `%s`.'):format(GetPlayerName(src) or 'unknown', getPlayerIdentifier(src), tostring(mushroomId)),
                16711680
            )
        end
        return false, Config.Locale.invalid
    end

    if isRateLimited(src) then
        if Config.Discord.LogExploitAttempt then
            discordLog(
                'Rate limit hit',
                ('Player `%s` (%s) exceeded pick request rate limit.'):format(GetPlayerName(src) or 'unknown', getPlayerIdentifier(src)),
                16753920
            )
        end
        return false, 'Zpomal, zkousis to moc rychle.'
    end

    local mushroom = activeMushrooms[mushroomId]
    if not mushroom then
        if Config.Discord.LogExploitAttempt then
            discordLog(
                'Exploit attempt',
                ('Player `%s` (%s) tried to pick missing mushroom id `%s`.'):format(GetPlayerName(src) or 'unknown', getPlayerIdentifier(src), tostring(mushroomId)),
                16711680
            )
        end
        return false, Config.Locale.invalid
    end

    if not hasRequiredBasket(src) then
        return false, Config.Locale.no_basket
    end

    local ped = GetPlayerPed(src)
    if ped == 0 then
        return false, 'Ped nebyl nalezen.'
    end

    local pcoords = GetEntityCoords(ped)
    local distance = dist({ x = pcoords.x, y = pcoords.y, z = pcoords.z }, mushroom.coords)

    if distance > Config.MaxPickDistance then
        if Config.Discord.LogExploitAttempt then
            discordLog(
                'Exploit attempt',
                ('Player `%s` (%s) failed distance check (%.2f m) on mushroom `%s`.'):format(GetPlayerName(src) or 'unknown', getPlayerIdentifier(src), distance, tostring(mushroomId)),
                16711680
            )
        end
        return false, Config.Locale.invalid
    end

    local added = exports.ox_inventory:AddItem(src, mushroom.item, 1)
    if not added then
        return false, 'Inventar je plny.'
    end

    removeMushroom(mushroomId)

    if Config.Discord.LogCollectSuccess then
        discordLog(
            'Mushroom collected',
            ('`%s` (%s) collected `%s` at `%.2f, %.2f, %.2f`.'):format(
                GetPlayerName(src) or 'unknown',
                getPlayerIdentifier(src),
                mushroom.item,
                mushroom.coords.x,
                mushroom.coords.y,
                mushroom.coords.z
            ),
            5763719
        )
    end

    return true, Config.Locale.picked
end)

AddEventHandler('playerDropped', function()
    playerRateLimits[source] = nil
end)

CreateThread(function()
    for _, mushroom in ipairs(Config.Mushrooms) do
        mushroomByItem[mushroom.item] = mushroom

        ESX.RegisterUsableItem(mushroom.item, function(src)
            local removed = exports.ox_inventory:RemoveItem(src, mushroom.item, 1)
            if not removed then
                return
            end

            if mushroom.poisonous then
                TriggerClientEvent('cwrp_houby:client:poisonEffect', src, Config.PoisonEffects)
                notify(src, Config.Locale.poisoned, 'error')

                if Config.Discord.LogPoisonUse then
                    discordLog(
                        'Poisoned mushroom eaten',
                        ('`%s` (%s) ate `%s`.'):format(GetPlayerName(src) or 'unknown', getPlayerIdentifier(src), mushroom.item),
                        15548997
                    )
                end
            else
                notify(src, Config.Locale.healthy, 'success')
            end
        end)
    end

    while countActiveMushrooms() < Config.MaxMushrooms do
        addMushroom()
    end
end)
