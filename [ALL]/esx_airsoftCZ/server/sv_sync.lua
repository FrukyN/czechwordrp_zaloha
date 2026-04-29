local Matches = {}

-- Zajištění, že zápas pro danou arénu existuje
RegisterServerEvent('airsoft:sync:ensureMatch')
AddEventHandler('airsoft:sync:ensureMatch', function(arenaId)
    if not Matches[arenaId] then
        Matches[arenaId] = {
            blue = 0,
            red = 0,
            startTime = os.time()
        }
        print("[AIRSOFT] Inicializován nový zápas v aréně: " .. arenaId)
    end
end)

-- Zpracování úmrtí a aktualizace skóre
RegisterServerEvent('airsoft:server:onDeath')
AddEventHandler('airsoft:server:onDeath', function(victimTeam)
    local src = source
    local arenaId = nil
    local attackerSrc = nil

    -- Najdeme, ve které aréně se to stalo (jednoduchá verze přes ActivePlayers)
    -- Pro rcore standard bychom zde dělali cross-check útočníka
    arenaId = "tovarna_v1" -- Default pro teď, v cl_logic se posílá arenaId

    if Matches[arenaId] then
        local scoringTeam = (victimTeam == "blue") and "red" or "blue"
        Matches[arenaId][scoringTeam] = Matches[arenaId][scoringTeam] + 1

        -- Poslat aktualizované skóre všem (globálně nebo podle arény)
        TriggerClientEvent('airsoft:client:syncScore', -1, {
            blue = Matches[arenaId].blue,
            red = Matches[arenaId].red
        })

        -- Trigger pro uložení do databáze (pokud máme útočníka)
        -- Zde by se dal přidat logic pro zjištění source útočníka
        TriggerEvent('airsoft:db:updateStats', nil, src)
    end
end)

-- Periodic check (např. konec zápasu)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000) -- Kontrola každých 10s
        for arenaId, data in pairs(Matches) do
            local elapsed = os.time() - data.startTime
            if elapsed >= Config.Arenas[arenaId].time then
                -- Zápas skončil
                print("[AIRSOFT] Zápas v aréně " .. arenaId .. " vypršel.")
                Matches[arenaId] = nil -- Reset zápasu
                TriggerClientEvent('esx:showNotification', -1, "~y~Airsoft zápas v " .. arenaId .. " skončil!")
            end
        end
    end
end)