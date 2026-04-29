local ESX = exports["es_extended"]:getSharedObject() -- PŘIDEJ TENTO ŘÁDEK
-- 1. ADRENALIN (Probrání z bezvědomí / Restart srdce)
ESX.RegisterUsableItem('adrenaline', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Zkontrolujeme, zda je hráč u ZZS (volitelné, pokud chceš, aby to mohli používat jen oni)
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('ems_script:useMedicalItem', source, 'adrenaline')
    else
        xPlayer.showNotification("Tohle neumíš bezpečně použít, mohl bys pacienta zabít!")
    end
end)

-- 2. MORFIUM (Utišení bolesti a stabilizace obrazovky)
ESX.RegisterUsableItem('morphine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('ems_script:useMedicalItem', source, 'morphine')
    else
        xPlayer.showNotification("Předávkoval bys ho!")
    end
end)

-- 3. TURNIKET / ŠKRTIDLO (Zastavení masivního krvácení)
ESX.RegisterUsableItem('tourniquet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Turniket může použít kdokoliv (First Aid), ale záchranář je efektivnější
    TriggerClientEvent('ems_script:useMedicalItem', source, 'tourniquet')
end)

-- 4. CHIRURGICKÉ ŠITÍ (Definitivní ošetření ran)
ESX.RegisterUsableItem('suture_kit', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('ems_script:useMedicalItem', source, 'suture_kit')
    else
        xPlayer.showNotification("Nejsi chirurg!")
    end
end)

-- LOGIKA ODEBÍRÁNÍ PŘEDMĚTŮ (Server Event)
-- Tohle zavoláme z klienta, až když úspěšně dokončí minihru
RegisterServerEvent('ems_script:removeItem')
AddEventHandler('ems_script:removeItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemName, 1)
end)

-- EVENT PRO ZÁCHRANU (Aplikace efektů na target)
RegisterServerEvent('ems_script:applyTreatment')
AddEventHandler('ems_script:applyTreatment', function(targetId, type)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if type == 'adrenaline' then
        -- Pokud je hráč "down", oživíme ho
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
    elseif type == 'morphine' then
        -- Pošleme efekt na klienta pacienta
        TriggerClientEvent('ems_script:onDrugEffect', targetId, 'morphine')
    elseif type == 'tourniquet' then
        -- Zastavíme krvácení v damage_engine
        TriggerClientEvent('ems_script:stopBleeding', targetId)
    end
end)