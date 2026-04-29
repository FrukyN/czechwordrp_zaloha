local eventSpam = {}
local teleportTracker = {}

local MAX_EVENTS_PER_SECOND = 15
local MAX_MASS_TELEPORT = 5

local WEBHOOK = "https://discord.com/api/webhooks/1478051120273293475/9RCNsp6bgVucMeZi_EO7sc_Ns_XD8gK1p5J7xWjJLJbCa-DMg9yC_fSZfcmc-Rp3ti_T"

-- 🔐 DISCORD FUNCTION MUSÍ BÝT NAHOŘE
local function SendToDiscord(title, message, color)
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color,
            ["footer"] = {
                ["text"] = os.date("%d.%m.%Y %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(WEBHOOK, function(err, text, headers) end, 'POST', json.encode({
        username = "CzechWorldRP AntiNuke",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- 🔥 EVENT SPAM PROTECTION
AddEventHandler("__cfx_internal:serverEventTriggered", function(eventName, source)
    if not eventSpam[source] then
        eventSpam[source] = {count = 0, time = os.time()}
    end

    local data = eventSpam[source]

    if os.time() ~= data.time then
        data.count = 0
        data.time = os.time()
    end

    data.count = data.count + 1

    if data.count > MAX_EVENTS_PER_SECOND then
        local name = GetPlayerName(source)
        local identifiers = GetPlayerIdentifiers(source)

        SendToDiscord(
            "🚨 EVENT SPAM DETECTED",
            "**Hráč:** "..name..
            "\n**ID:** "..source..
            "\n**Identifiers:** "..json.encode(identifiers),
            16711680
        )

        DropPlayer(source, "Event spam detected.")
    end
end)

-- 🔥 MASS TELEPORT DETECTION
CreateThread(function()
    while true do
        Wait(1000)

        local teleportedPlayers = 0

        for _, playerId in ipairs(GetPlayers()) do
            local ped = GetPlayerPed(playerId)
            if ped then
                local coords = GetEntityCoords(ped)

                if not teleportTracker[playerId] then
                    teleportTracker[playerId] = coords
                else
                    local old = teleportTracker[playerId]
                    local dist = #(coords - old)

                    if dist > 300.0 then
                        teleportedPlayers = teleportedPlayers + 1
                    end

                    teleportTracker[playerId] = coords
                end
            end
        end

        if teleportedPlayers >= MAX_MASS_TELEPORT then
            SendToDiscord(
                "🚨 MASS TELEPORT DETECTED",
                "Více hráčů bylo teleportováno během 1 sekundy.\nServer ochráněn.",
                16711680
            )

            for _, id in ipairs(GetPlayers()) do
                DropPlayer(id, "Mass teleport exploit detected. Server protected.")
            end
        end
    end
end)

CreateThread(function()
    Wait(2000) -- malá pauza aby se server stihl načíst

    SendToDiscord(
        "🟢 ANTI-BACKDOOR START",
        "Shield byl úspěšně spuštěn.\nServer běží a logy fungují.",
        65280
    )
end)
print("^2[ANTI-NUKE] Shield Loaded Successfully")