local ESX = exports["es_extended"]:getSharedObject()
local heistActive = false
local lootedVitrines = {}
local gasStartTime = 0 

-- 1. Callback na kontrolu policie
lib.callback.register('vangelico:checkPolice', function(source)
    local xPlayers = ESX.GetExtendedPlayers('job', Config.PoliceJobName or 'police')
    return #xPlayers >= (Config.PoliceRequired or 0)
end)

-- 2. Callback pro synchronizaci plynu (DŮLEŽITÉ PRO TVOJI CHYBU)
lib.callback.register('vangelico:getGasStatus', function(source)
    if heistActive then
        local remaining = Config.GasDuration - (GetGameTimer() - gasStartTime)
        return true, remaining
    else
        return false, 0
    end
end)

-- 3. Hlavní event pro start loupeže
RegisterNetEvent('vangelico:startHeist', function()
    local src = source
    if heistActive then 
        TriggerClientEvent('ox_lib:notify', src, {description = 'Loupež již probíhá!', type = 'error'})
        return 
    end

    -- Sebere dýmovnici
    local removed = exports.ox_inventory:RemoveItem(src, 'gas_canister', 1)
    
    if removed then
        heistActive = true
        gasStartTime = GetGameTimer() 
        lootedVitrines = {} 
        
        -- DISPATCH (Ponechán beze změny dle tvého přání)
        TriggerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = vec3(-621.85, -230.71, 38.0),
            title = 'Přepadení: Klenotnictví', 
            message = 'Bezpečnostní systém zaznamenal kouř v objektu Vangelico.', 
            flash = 0,
            unique_id = tostring(math.random(1111, 9999)),
            priority = 2,
            blip = {
                sprite = 617, 
                scale = 1.0, 
                colour = 1, 
                flashing = false, 
                text = 'Signalizace - Vangelico',
                time = (5 * 60 * 1000), 
            }
        })

        -- Pošleme info všem hráčům o startu plynu
        TriggerClientEvent('vangelico:clientSmoke', -1, Config.GasDuration)

        -- Ukončení po uplynutí času
        SetTimeout(Config.GasDuration, function()
            heistActive = false
            gasStartTime = 0
        end)
    else
        TriggerClientEvent('ox_lib:notify', src, {description = 'Nemáš dýmovnici!', type = 'error'})
    end
end)

-- 4. Lootování vitríny
RegisterNetEvent('vangelico:lootVitrine', function(vitrineId)
    local src = source
    
    if not heistActive then return end
    if lootedVitrines[vitrineId] then 
        TriggerClientEvent('ox_lib:notify', src, {description = 'Tato vitrína je už prázdná!', type = 'error'})
        return 
    end

    lootedVitrines[vitrineId] = true
    
    for _, loot in pairs(Config.Loot) do
        if math.random(1, 100) <= loot.chance then
            local amount = math.random(loot.min, loot.max)
            exports.ox_inventory:AddItem(src, loot.item, amount)
        end
    end
end)