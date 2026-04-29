

vRP = nil
ESX = nil

if Notifications.Enabled and Notifications.Framework.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if Notifications.Enabled and Notifications.Framework.vRP then
    vRP = Proxy.getInterface("vRP")
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

if Inventory.quasarInventory then
    function inventoryInstallChainClamp()
        setupClamp(Inventory.clampItemNames[1])
    end
    
    exports("inventoryInstallChainClamp", inventoryInstallChainClamp)

    function inventoryInstallWheelClamp()
        setupClamp(Inventory.clampItemNames[2])
    end
    
    exports("inventoryInstallWheelClamp", inventoryInstallWheelClamp)

    function inventoryUseLockPick()
        lockpickClamp()
    end
    
    exports("inventoryUseLockPick", inventoryUseLockPick)
end

function showBaseNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

RegisterNetEvent("Client:clampNotification", function(message)
    Notify(message)
end)

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(0) 
    end
end


function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

if main.commandEnabled then
    TriggerEvent('chat:addSuggestion', '/'..translations["CLAMP_COMMAND"], translations["CLAMP_COMMAND_SUGGESTION"], {
        { name=translations["CLAMP_COMMAND_SETUP"] .. "/"..translations["CLAMP_COMMAND_REMOVE"], help=translations["CLAMP_COMMAND_HELP"] },
        { name=translations["CLAMP_COMMAND_SETUP_CHAIN"].."/"..translations["CLAMP_COMMAND_SETUP_WHEEL"], help=translations["CLAMP_COMMAND_HELP"] }
    })
end


-- "locker_chain" or "locker_wheel"
-- Install clamp on nearby vehicle, this export will determine the vehicle automatically
exports("SetupClamp", function(clampType) 
    setupClamp(clampType)
end)

-- Remove clamp from nearby vehicle, this export will determine the vehicle automatically
exports("RemoveClamp", function() 
    removeClamp()
end)