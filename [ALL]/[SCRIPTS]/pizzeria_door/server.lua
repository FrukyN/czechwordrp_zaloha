local ESX = exports["es_extended"]:getSharedObject()
local pizzaDoorObj = nil
local isClosed = true -- Po restartu serveru ZAVŘENO

-- KONFIGURACE
local doorModel = `v_ilev_mm_door`
local doorPos = vector4( -1348.4666,-1079.1699,7.2787,29.8299) -- Tvoje souřadniceX: -1347.5106, Y: -1078.5934, Z: 6.6182, H: 36.1704

-- Funkce pro smazání objektu ze světa
function DeletePizzaDoor()
    if pizzaDoorObj and DoesEntityExist(pizzaDoorObj) then
        DeleteEntity(pizzaDoorObj)
        pizzaDoorObj = nil
    end
end

-- Funkce pro vytvoření objektu
function CreatePizzaDoor()
    DeletePizzaDoor() -- Jistota, že tam nezůstanou staré
    
    pizzaDoorObj = CreateObjectNoOffset(doorModel, doorPos.x, doorPos.y, doorPos.z, true, true, false)
    
    -- Čekáme, až se objekt reálně vytvoří
    local timeout = 0
    while not DoesEntityExist(pizzaDoorObj) and timeout < 100 do Wait(10) timeout = timeout + 1 end
    
    if DoesEntityExist(pizzaDoorObj) then
        SetEntityHeading(pizzaDoorObj, doorPos.w)
        FreezeEntityPosition(pizzaDoorObj, true)
    end
end

-- Příkaz ZAVŘÍT
RegisterCommand("zavrit", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'pizza' then
        isClosed = true
        CreatePizzaDoor()
        TriggerClientEvent('esx:showNotification', source, "~g~Pizzerie uzavřena.")
    end
end)

-- Příkaz OTEVŘÍT
RegisterCommand("otevrit", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'pizza' then
        isClosed = false
        DeletePizzaDoor()
        TriggerClientEvent('esx:showNotification', source, "~y~Pizzerie otevřena.")
    end
end)

-- Automatický spawn po startu skriptu (ensure)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if isClosed then
        Wait(1000)
        CreatePizzaDoor()
    end
end)

-- Automatický úklid při vypnutí skriptu (aby tam nezůstávaly ty bariéry/dveře)
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    DeletePizzaDoor()
end)