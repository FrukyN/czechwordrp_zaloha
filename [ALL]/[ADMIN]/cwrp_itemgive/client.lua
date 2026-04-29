-- Otevření hlavního menu
RegisterNetEvent('admin_give:openMenu', function()
    lib.registerContext({
        id = 'admin_give_menu',
        title = 'Admin Give Menu',
        options = {
            {
                title = 'Online Hráč',
                description = 'Dát item hráči, který je momentálně na serveru',
                icon = 'user',
                onSelect = function()
                    GiveOnlineFlow()
                end
            },
            {
                title = 'Offline Hráč',
                description = 'Dát item přes databázi (pomocí Rockstar License)',
                icon = 'user-slash',
                onSelect = function()
                    GiveOfflineFlow()
                end
            }
        }
    })
    lib.showContext('admin_give_menu')
end)

-- Flow pro ONLINE hráče
function GiveOnlineFlow()
    -- 1. Krok: Zjištění ID
    local idInput = lib.inputDialog('ID Hráče', {
        {type = 'number', label = 'Server ID', description = 'Zadej ID online hráče', required = true, min = 1}
    })
    if not idInput then return end
    local targetId = idInput[1]

    -- Zeptáme se serveru na jméno hráče
    local playerName = lib.callback.await('admin_give:getPlayerName', false, targetId)
    
    if not playerName then
        lib.notify({title = 'Chyba', description = 'Hráč s tímto ID není online!', type = 'error'})
        return
    end

    -- 2. Krok: Zjištění itemu a počtu (jméno hráče se ukáže v titulku)
    local itemInput = lib.inputDialog('Hráč: ' .. playerName, {
        {type = 'input', label = 'Název itemu', description = 'Např. water, bread...', required = true},
        {type = 'number', label = 'Počet', description = 'Kolik kusů mu chceš dát?', required = true, min = 1}
    })
    if not itemInput then return end

    -- Odeslání na server k vyřízení
    TriggerServerEvent('admin_give:giveOnline', targetId, itemInput[1], itemInput[2])
end

-- Flow pro OFFLINE hráče
function GiveOfflineFlow()
    local input = lib.inputDialog('Offline Give', {
        {type = 'input', label = 'Rockstar License', description = 'např. license:123456789...', required = true},
        {type = 'input', label = 'Název itemu', description = 'Např. water, bread...', required = true},
        {type = 'number', label = 'Počet', description = 'Kolik kusů?', required = true, min = 1}
    })
    if not input then return end

    TriggerServerEvent('admin_give:giveOffline', input[1], input[2], input[3])
end