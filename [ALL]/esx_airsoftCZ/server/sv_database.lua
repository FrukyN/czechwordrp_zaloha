-- Inicializace tabulky při startu serveru
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `airsoft_stats` (
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(100) DEFAULT 'Hráč',
            `kills` INT(11) DEFAULT 0,
            `deaths` INT(11) DEFAULT 0,
            `matches` INT(11) DEFAULT 0,
            PRIMARY KEY (`identifier`)
        )
    ]])
end)

-- Toto vlož do svého sv_database.lua
RegisterServerEvent('airsoft:db:updateStats')
AddEventHandler('airsoft:db:updateStats', function(attackerSrc, victimSrc)
    local xAttacker = ESX.GetPlayerFromId(attackerSrc)
    local xVictim = ESX.GetPlayerFromId(victimSrc)

    -- Aktualizace útočníka (přičteme kill)
    if xAttacker then
        MySQL.Async.execute([[
            INSERT INTO airsoft_stats (identifier, name, kills, matches) 
            VALUES (@id, @n, 1, 1) 
            ON DUPLICATE KEY UPDATE kills = kills + 1, matches = matches + 1, name = @n
        ]], {
            ['@id'] = xAttacker.getIdentifier(),
            ['@n'] = xAttacker.getName()
        })
    end

    -- Aktualizace oběti (přičteme smrt)
    if xVictim then
        MySQL.Async.execute([[
            INSERT INTO airsoft_stats (identifier, name, deaths, matches) 
            VALUES (@id, @n, 1, 1) 
            ON DUPLICATE KEY UPDATE deaths = deaths + 1, matches = matches + 1, name = @n
        ]], {
            ['@id'] = xVictim.getIdentifier(),
            ['@n'] = xVictim.getName()
        })
    end
end)

-- Možnost pro hráče podívat se na své statistiky (příkaz)
ESX.RegisterCommand('airsoftstats', 'user', function(xPlayer, args, showError)
    MySQL.single('SELECT kills, deaths, matches FROM airsoft_stats WHERE identifier = @id', {
        ['@id'] = xPlayer.getIdentifier()
    }, function(row)
        if row then
            xPlayer.showNotification(("~y~Tvé Airsoft Statistiky:~s~\nKilly: %s\nSmrti: %s\nZápasy: %s"):format(row.kills, row.deaths, row.matches))
        else
            xPlayer.showNotification("~r~Zatím nemáš žádné záznamy.")
        end
    end)
end, false)