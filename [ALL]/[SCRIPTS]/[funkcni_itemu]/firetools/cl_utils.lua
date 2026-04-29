vRP = nil
ESX = nil

if Notifications.Enabled and Notifications.Framework.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if Notifications.Enabled and Notifications.Framework.vRP then
    vRP = Proxy.getInterface("vRP")
end

function displayHelpText(message)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

if Inventory.quasarInventory or Inventory.coreInventory then
    function inventoryUseStabiliser()
        TriggerEvent("Client:toggleStabilisers", true)
    end
    
    exports("inventoryUseStabiliser", inventoryUseStabiliser)

    function inventoryUseFan()
        TriggerEvent("Client:toggleFan", true)
    end
    
    exports("inventoryUseFan", inventoryUseFan)
end

function Notify(text)

    if not Notifications.Enabled then
        return
    end

    if Notifications.Framework.ESX then
        if ESX ~= nil then
            ESX.ShowNotification(text)
        end
    elseif Notifications.Framework.QBCore then
        TriggerEvent('QBCore:Notify', text, 'info')
    elseif Notifications.Framework.QBX then
        exports.qbx_core:Notify(text, 'primary')
    elseif Notifications.Framework.vRP then
        vRP.notify(source, {text})
    elseif Notifications.Framework.okok then
        exports['okokNotify']:Alert("Police Tracker", text, 2000, 'info', true)
    else
        showBaseNotification(text)
    end
end

function showBaseNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

RegisterNetEvent("Client:fireToolsNotification")
AddEventHandler("Client:fireToolsNotification", function(message)
    Notify(message)
end)

function tableHas(table, key)
    for k, v in pairs(table) do
        if k == key and v ~= nil then
            return true
        end
    end
    return false
end

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

function tableLength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end