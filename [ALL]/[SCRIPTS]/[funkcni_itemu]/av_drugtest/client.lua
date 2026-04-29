-- Fáze 1: Policista zadává ID
RegisterNetEvent('av_drugtest:startTest', function()
    local input = lib.inputDialog('Drogový test', {
        {type = 'number', label = 'ID osoby', description = 'Zadej ID hráče, kterému děláš stěr', icon = 'user', required = true},
    })

    if not input then return end
    TriggerServerEvent('av_drugtest:requestResult', input[1])
end)

-- Fáze 2: Podezřelý vybírá výsledek
RegisterNetEvent('av_drugtest:showTargetMenu', function(policistaId)
    local alert = lib.alertDialog({
        header = '👮 Drogová kontrola',
        content = 'Policista ti provádí stěr z úst. Jaký je výsledek testu? (RP volba)',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Pozitivní (+)',
            cancel = 'Negativní (-)'
        }
    })

    local isPositive = false
    if alert == 'confirm' then isPositive = true end
    
    TriggerServerEvent('av_drugtest:sendBackToPolice', policistaId, isPositive)
end)

-- Fáze 3: Policista vidí vizuální výsledek
RegisterNetEvent('av_drugtest:finalDisplay', function(isPositive)
    local resultText = ""
    
    if isPositive then
        resultText = "VÝSLEDEK: **POZITIVNÍ** \n\n  ---  \n  **[ | ]** \n  **[ | ]** \n  ---  \n\n (Nalezeny omamné látky)"
    else
        resultText = "VÝSLEDEK: **NEGATIVNÍ** \n\n  ---  \n  **[ | ]** \n  ---  \n\n (Hráč je čistý)"
    end

    lib.alertDialog({
        header = 'Výsledek papírového testeru',
        content = resultText,
        centered = true
    })
end)

-- TENTO EXPORT MUSÍ BÝT V CLIENT.LUA
exports('drugtest', function(data, slot)
    -- Kontrola jobu na straně klienta (rychlejší)
    local xPlayer = ESX.GetPlayerData()
    local job = xPlayer.job.name

    if Config.AllowedJobs[job] then
        TriggerEvent('av_drugtest:startTest')
    else
        lib.notify({type = 'error', description = 'Nejsi u správné frakce!'})
    end
end)

-- ... zbytek tvého client.lua (RegisterNetEventy atd.)