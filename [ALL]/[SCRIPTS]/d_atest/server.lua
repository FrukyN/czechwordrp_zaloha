local ESX = exports["es_extended"]:getSharedObject()
local printerQueue = {}

-- Příjem dat od mechanika do fronty tiskárny
RegisterNetEvent('d_atest:sendToPrinter', function(atestData)
    local _source = source
    table.insert(printerQueue, atestData)
    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'Tiskárna', 
        description = 'Dokument byl zařazen do fronty tiskárny.', 
        type = 'inform'
    })
end)

-- Vyzvednutí dokumentů z tiskárny
RegisterNetEvent('d_atest:pickup', function()
    local _source = source
    
    if #printerQueue > 0 then
        for i, doc in ipairs(printerQueue) do
            -- Příprava metadat - všechna data vkládáme přímo sem
            local metadata = {
                owner = doc.owner,
                plate = doc.plate,
                tint = doc.tint,
                date = doc.date,
                -- Description zajistí, že data uvidíš v inventáři i bez rozkliknutí
                description = string.format("Majitel: %s\nSPZ: %s\nPropustnost: %s%%", doc.owner, doc.plate, doc.tint)
            }

            -- Přidání itemu do inventáře (metadata jsou 4. parametr)
            exports.ox_inventory:AddItem(_source, 'atest_kelly', 1, metadata)
        end
        
        -- Vymazání fronty po vyzvednutí
        printerQueue = {} 
        TriggerClientEvent('ox_lib:notify', _source, {title = 'Tiskárna', description = 'Vyzvedl jsi hotové dokumenty.', type = 'success'})
    else
        TriggerClientEvent('ox_lib:notify', _source, {title = 'Tiskárna', description = 'V tiskárně momentálně nic není.', type = 'error'})
    end
end)