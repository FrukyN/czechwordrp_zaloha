RegisterServerEvent('d_spravko:createRecord', function(targetId, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then 
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Hráč nenalezen!'})
    end

    -- DEBUG: Tady uvidíš v konzoli, jestli server ví, komu to poslat
    print(string.format("^3[DEBUG] Policista %s posílá správko hráči %s (ID: %s)^7", xPlayer.getName(), xTarget.getName(), targetId))

    -- 1. POSLAT NOTIFIKACI HNED (Abychom viděli, že spojení funguje)
    TriggerClientEvent('ox_lib:alertDialog', xTarget.source, {
        header = '⚖️ Správní řízení',
        content = 'S vámi bylo zahájeno správní řízení.\n\n**Policista:** '..xPlayer.getName()..'\n**Důvod:** '..data.description,
        centered = true
    })

    -- 2. ULOŽIT DO DB (Až potom)
    MySQL.insert('INSERT INTO spravni_rizeni (officer_name, target_name, target_identifier, crime_category, description, evidence) VALUES (?, ?, ?, ?, ?, ?)', {
        xPlayer.getName(), 
        data.targetName, 
        xTarget.identifier, 
        data.category, 
        data.description, 
        data.evidence or 'Žádné'
    }, function(id)
        if id then
            TriggerClientEvent('ox_lib:notify', src, {title = 'Uloženo', description = 'Spis #'..id..' je v DB.', type = 'success'})
        end
    end)
end)