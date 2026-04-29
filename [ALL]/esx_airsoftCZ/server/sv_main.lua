local ESX = exports["es_extended"]:getSharedObject()
local ActivePlayers = {}
local ArenaData = { blue = 0, red = 0 } -- Tabulka pro body v aktuálním zápasu
local GlobalAirsoftTimer = 600
local TimerStarted = false

-- Callback pro kontrolu peněz
ESX.RegisterServerCallback('airsoft:checkMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)

-- Registrace hráče
RegisterServerEvent('airsoft:playerJoined')
AddEventHandler('airsoft:playerJoined', function(arenaId, teamId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    ActivePlayers[src] = {
        identifier = xPlayer.getIdentifier(),
        arena = arenaId,
        team = teamId,
        name = xPlayer.getName()
    }

    print(("[AIRSOFT] Hráč %s vstoupil do arény %s za tým %s"):format(xPlayer.getName(), arenaId, teamId))
    
    -- SPUŠTĚNÍ ČASU
    StartGlobalTimer()
    
    -- Synchronizace aktuálního skóre novému hráči
    TriggerClientEvent('airsoft:updateScore', src, ArenaData.blue, ArenaData.red)
end)

-- Odstranění hráče při odpojení
AddEventHandler('playerDropped', function()
    local src = source
    if ActivePlayers[src] then
        ActivePlayers[src] = nil
    end
end)

-- Bodování při smrti
RegisterNetEvent('airsoft:server:onDeath')
AddEventHandler('airsoft:server:onDeath', function(playerTeam)
    -- Bod dáváme nepříteli
    if playerTeam == 'red' then
        ArenaData.blue = ArenaData.blue + 1
    else
        ArenaData.red = ArenaData.red + 1
    end
    
    -- Pošleme aktualizované body všem (změněno, aby posílalo obě čísla)
    TriggerClientEvent('airsoft:updateScore', -1, ArenaData.blue, ArenaData.red)
end)

-- HLAVNÍ ČASOVAČ
function StartGlobalTimer()
    if TimerStarted then 
        -- Pokud už běží, pošleme hráči jen aktuální čas, aby mu HUD neskočil na 120
        local mins = math.floor(GlobalAirsoftTimer / 60)
        local secs = GlobalAirsoftTimer % 60
        TriggerClientEvent('airsoft:syncTimer', source, string.format("%02d:%02d", mins, secs))
        return 
    end
    
    TimerStarted = true
    GlobalAirsoftTimer = 120 -- Nastavení na startovní hodnotu při začátku

    Citizen.CreateThread(function()
        while GlobalAirsoftTimer > 0 do
            Citizen.Wait(1000)
            GlobalAirsoftTimer = GlobalAirsoftTimer - 1

            local mins = math.floor(GlobalAirsoftTimer / 60)
            local secs = GlobalAirsoftTimer % 60
            local timeStr = string.format("%02d:%02d", mins, secs)

            -- Synchronizace času
            TriggerClientEvent('airsoft:syncTimer', -1, timeStr)

            if GlobalAirsoftTimer <= 0 then
                -- KONEC ZÁPASU - Posíláme body pro vyhlášení vítěze
                TriggerClientEvent('airsoft:matchEnd', -1, ArenaData.blue, ArenaData.red)
                
                -- Reset všeho pro další zápas
                TimerStarted = false
                GlobalAirsoftTimer = 600
                ArenaData = { blue = 0, red = 0 }
                
                -- Vynulování HUDu u všech
                TriggerClientEvent('airsoft:updateScore', -1, 0, 0)
                break -- Ukončení smyčky
            end
        end
    end)
end