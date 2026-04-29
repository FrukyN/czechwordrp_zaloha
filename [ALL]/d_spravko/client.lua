local function openSpravkoForm(targetServerId)
    local input = lib.inputDialog('👮 Protokol Správního Řízení', {
        {type = 'input', label = 'Jméno podezřelého (RP Jméno)', required = true},
        {type = 'select', label = 'Kategorie přestupku', options = {
            {value = 'dopravni', label = 'Dopravní přestupek'},
            {value = 'nasilny', label = 'Násilný trestný čin'},
        }, required = true},
        {type = 'textarea', label = 'Popis situace', required = true},
        {type = 'input', label = 'Důkazy (URL)'},
    })

    if not input then return end

    -- TADY JE ZMĚNA: Posíláme ID cíle jako samostatný parametr
    TriggerServerEvent('d_spravko:createRecord', targetServerId, {
        targetName = input[1],
        category = input[2],
        description = input[3],
        evidence = input[4]
    })
end

RegisterCommand('spravko', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local targetId = -1

    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        targetId = GetPlayerServerId(closestPlayer)
    else
        -- Pokud nikoho nenajde, použije tebe pro testování
        targetId = GetPlayerServerId(PlayerId())
        lib.notify({description = 'Testovací režim: Cílem jsi ty sám.', type = 'inform'})
    end

    openSpravkoForm(targetId)
end)