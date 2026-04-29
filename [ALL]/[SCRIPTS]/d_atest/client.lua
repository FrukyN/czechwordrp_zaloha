local ESX = exports["es_extended"]:getSharedObject()
local printerProp = `prop_printer_01`
local printerCoords = vec4(-338.9740, -156.2284, 44.4864, 167.4832) 
local spawnedPrinter = nil

-- ZOBRAZENÍ ATESTU (OPRAVENÁ FUNKCE)
function showAtest(data)
    -- Vytáhneme metadata z jakékoliv struktury, kterou ox_inventory pošle
    local info = data.metadata or (data.item and data.item.metadata) or data

    -- Pokud by metadata náhodou chyběla, zkusíme vzít description (popisek)
    local fallbackDesc = data.description or (data.item and data.item.description)

    -- Pokud nemáme ani jméno majitele, ani popisek, je to špatně
    if not info.owner and not fallbackDesc then 
        lib.notify({title = 'Chyba', description = 'Doklad nemá platná data!', type = 'error'})
        return 
    end

    -- Sestavíme menu
    lib.registerContext({
        id = 'atest_kelly_menu',
        title = '📜 ATEST AUTO KELLY',
        options = {
            {
                title = 'Majitel: ' .. (info.owner or "Zobrazeno v popisku"),
                description = info.owner and ('SPZ: ' .. info.plate .. ' | Tint: ' .. info.tint .. '%') or fallbackDesc,
                icon = 'file-contract',
                readOnly = true
            },
            {
                title = 'Vozidlo (SPZ)',
                description = tostring(info.plate or "Viz popisek v inv"),
                icon = 'car',
                readOnly = true
            },
            {
                title = 'Propustnost / Datum',
                description = (info.tint or '??') .. '% | ' .. (info.date or '??'),
                icon = 'calendar-check',
                readOnly = true
            }
        }
    })
    lib.showContext('atest_kelly_menu')
end

-- Registrace exportu pro ox_inventory
exports('showAtest', showAtest)

-- PŘÍKAZ PRO MECHANIKA (Ponecháno původní)
RegisterCommand('vystavitatest', function()
    local job = ESX.GetPlayerData().job.name
    if job == 'mechanic' then
        local input = lib.inputDialog('Protokol Auto Kelly', {
            {type = 'input', label = 'Jméno majitele', required = true},
            {type = 'input', label = 'SPZ Vozidla', required = true},
            {type = 'number', label = 'Propustnost (%)', default = 25},
            {type = 'input', label = 'Datum', default = "01.01.2024"}
        })

        if input then
            TriggerServerEvent('d_atest:sendToPrinter', {
                owner = input[1],
                plate = input[2],
                tint = input[3],
                date = input[4]
            })
        end
    end
end)

-- SPAWN TISKÁRNY A TARGET (Ponecháno původní)
CreateThread(function()
    RequestModel(printerProp)
    while not HasModelLoaded(printerProp) do Wait(10) end

    spawnedPrinter = CreateObject(printerProp, printerCoords.x, printerCoords.y, printerCoords.z, false, false, false)
    SetEntityHeading(spawnedPrinter, printerCoords.w)
    FreezeEntityPosition(spawnedPrinter, true)
    SetEntityAsMissionEntity(spawnedPrinter, true, true)

    exports.ox_target:addLocalEntity(spawnedPrinter, {
        {
            name = 'pickup_atest',
            icon = 'fa-solid fa-print',
            label = 'Vyzvednout dokumenty',
            onSelect = function()
                TriggerServerEvent('d_atest:pickup')
            end
        }
    })
end)