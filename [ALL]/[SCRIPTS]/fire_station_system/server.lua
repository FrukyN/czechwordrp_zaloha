local ESX = exports["es_extended"]:getSharedObject()

-- Funkce pro rozeslání alarmu na klienty
function TriggerStationAlarm(title, street, message)
    TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, {
        title = title,
        location = street,
        msg = message
    })
    print(("^1[FireDispatch] Alarm aktivován: %s - %s^7"):format(title, street))
end

-- CESTA 1: Sledování chatu (manuální 150/112/požár)
AddEventHandler('chatMessage', function(source, name, message)
    local msg = message:lower()
    if string.find(msg, "150") or string.find(msg, "112") or string.find(msg, "požár") or string.find(msg, "pozar") then
        TriggerStationAlarm("TÍSŇOVÉ VOLÁNÍ", "Hlášení z chatu", message)
    end
end)

-- CESTA 2: CD Dispatch (Automatické zachycení slova POŽÁR)
RegisterNetEvent('cd_dispatch:ExternalDispatch') 
AddEventHandler('cd_dispatch:ExternalDispatch', function(data)
    local msg = (data.message or ""):lower()
    local title = (data.job_description or data.title or ""):lower()

    if string.find(msg, "požár") or string.find(msg, "pozar") or string.find(title, "požár") or string.find(title, "pozar") then
        TriggerStationAlarm(data.job_description or "VÝJEZD", data.street or "Neznámá lokalita", data.message or "Požár nahlášen")
    end
end)

-- Testovací příkaz pro adminy
RegisterCommand("testtv", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerStationAlarm("ZKUŠEBNÍ POPLACH", "STANICE 1", "Zkouška systému GINA a TV obrazovky.")
    end
end, false)

local ESX = exports["es_extended"]:getSharedObject()

-- Hlavní event, který přijímá data od kohokoliv (příkazy, automatika, dispatch)
RegisterNetEvent('esx_fireDispatch:passToServer')
AddEventHandler('esx_fireDispatch:passToServer', function(dispatchData)
    -- Rozpošle alarm všem na televize
    TriggerClientEvent('esx_fireDispatch:syncAlarmForAll', -1, {
        title = dispatchData.title or dispatchData.display_code or "POPLACH",
        location = dispatchData.location or dispatchData.street or "Stanice",
        msg = dispatchData.msg or dispatchData.message or ""
    })
    print("^1[FireDispatch] Data přijata a rozeslána na stanice.^7")
end)

-- Ponecháme i sledování chatu pro jistotu
AddEventHandler('chatMessage', function(source, name, message)
    local msg = message:lower()
    if string.find(msg, "150") or string.find(msg, "112") or string.find(msg, "požár") then
        TriggerEvent('esx_fireDispatch:passToServer', {
            title = "HLÁŠENÍ CHAT",
            location = "Zjišťování...",
            msg = message
        })
    end
end)