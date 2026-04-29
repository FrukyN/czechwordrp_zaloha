local ESX = exports["es_extended"]:getSharedObject()

-- 1. Odeslání účtu
RegisterNetEvent('pos:server:sendToCustomer', function(targetId, items, total)
    local _source = source
    if not GetPlayerName(targetId) then 
        return TriggerClientEvent('ox_lib:notify', _source, {type = 'error', description = 'Zákazník nenalezen'}) 
    end
    TriggerClientEvent('pos:client:receiveBill', targetId, items, total, _source)
end)

-- 2. Platba a připsání do Boss Menu
RegisterNetEvent('pos:server:completePayment', function(method, amount, sellerId)
    local _source = source -- Zákazník
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xSeller = ESX.GetPlayerFromId(sellerId)
    
    if not xPlayer or not xSeller then return end

    local amount = tonumber(amount)
    local jobName = xSeller.job.name -- Mělo by být 'kongrest'
    local success = false

    -- Kontrola peněz (OX Inventory / Banka)
    if method == 'money' then
        local moneyCount = exports.ox_inventory:GetItemCount(_source, 'money')
        if moneyCount >= amount then
            exports.ox_inventory:RemoveItem(_source, 'money', amount)
            success = true
        end
    elseif method == 'bank' then
        if xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
            success = true
        end
    end

    if success then
        local societyName = 'society_' .. jobName

        -- POKUS O PŘIPSÁNÍ DO ESX SOCIETY (LB-Phone toto vyžaduje)
        TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
            if account then
                account.addMoney(amount)
                print(("^2[KASA]^7 Peníze (%s CZK) připsány do %s"):format(amount, societyName))
                
                TriggerClientEvent('ox_lib:notify', _source, {type = 'success', description = 'Zaplaceno '..amount..' CZK'})
                TriggerClientEvent('ox_lib:notify', sellerId, {type = 'success', description = 'Firma obdržela platbu.'})
            else
                -- Pokud Job Creator nevytvořil society v addon_account, peníze se nemají kam uložit
                print("^1[CHYBA]^7 LB-Phone neuvidí peníze, protože v databázi chybí " .. societyName .. " v tabulce addon_account!")
                xSeller.addAccountMoney('bank', amount) -- Nouzovka: dá peníze prodavači
                TriggerClientEvent('ox_lib:notify', sellerId, {type = 'warning', description = 'Chyba Boss Menu! Peníze dány tobě osobně.'})
            end
        end)
    else
        TriggerClientEvent('ox_lib:notify', _source, {type = 'error', description = 'Nedostatek peněz!'})
    end
end)