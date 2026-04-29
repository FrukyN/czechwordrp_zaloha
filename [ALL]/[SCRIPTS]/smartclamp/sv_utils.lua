
-- These setup the foundations for ESX / vRP / QBCore permissions
QBCore = nil
vRP = nil
ESX = nil

local itemEnabled = Inventory.quasarInventory or Inventory.qbCore or Inventory.vRP or Inventory.ESX or Inventory.coreInventory or Inventory.oxInventory

if Permissions.ESX.Enabled or Inventory.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if Permissions.vRP.Enabled or Inventory.vRP then
    Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")
end

if Permissions.QBCore.Enabled or Inventory.qbCore then
    QBCore = exports["qb-core"]:GetCoreObject()
end

function HandleInventoryItems(source, itemName, give)
    if Inventory.vRP then
        local userID = vRP.getUserId({source})
        if give then
            vRP.giveInventoryItem({userId, itemName, 1, false})
        else
            if vRP.tryGetInventoryItem({userID, itemName, 1, false}) then
                return true
            else
                return false
            end
        end
    elseif Inventory.qbCore then
        if give then
            exports['qb-inventory']:AddItem(source, itemName, 1, false, false, GetCurrentResourceName())
        else
            local successful = exports['qb-inventory']:RemoveItem(source, itemName, 1, false, GetCurrentResourceName())

            return successful
        end
    elseif Inventory.ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if give then
            xPlayer.addInventoryItem(itemName, 1)
        else
            local returnedItem = xPlayer.getInventoryItem(itemName)

            if returnedItem.canRemove then
                xPlayer.removeInventoryItem(itemName, 1)
                return true
            else
                return false
            end
        end
    elseif Inventory.oxInventory then
        if give then
            exports.ox_inventory:AddItem(source, itemName, 1)
        else
            local successful = exports.ox_inventory:RemoveItem(source, itemName, 1)

            return successful
        end
    elseif Inventory.quasarInventory then
        if give then
            exports['qs-inventory']:AddItem(source, itemName, 1)
        else
            local quantity = exports['qs-inventory']:GetItemTotalAmount(source, itemName)
            if quantity > 0 then
                exports['qs-inventory']:RemoveItem(source, itemName, 1)

                return true
            else
                return false
            end
        end
    elseif Inventory.coreInventory then
        if give then
            exports.core_Inventory:addItem(source, itemName, 1)
        else
            local successful = exports.core_Inventory:removeItem(source, itemName, 1)

            return successful
        end
    end
end

function UserHasPermission(source, location)

    if not location.EnablePermissions then
        return true
    end

    if location.AcePermissions.Enabled then
        return true
    end

    -- ESX Permissions
    if location.ESX.Enabled then
        local xPlayer = ESX.GetPlayerFromId(source)
        if location.ESX.CheckJob.Enabled then
            for k, v in pairs(location.ESX.CheckJob.Jobs) do
                if xPlayer.job.name == v then
                    return true
                end
            end
        end
    end

    -- vRP Permission
    if location.vRP.Enabled then
        if location.vRP.CheckPermission.Enabled then
            for k, v in pairs(location.vRP.CheckPermission.Permissions) do
                if vRP.hasPermission({vRP.getUserId({source}),v}) then
                    return true
                end
            end
        end

        if location.vRP.CheckGroup.Enabled then
            for k, v in pairs(location.vRP.CheckGroup.Groups) do
                if vRP.hasGroup({vRP.getUserId({source}),v}) then
                    return true
                end
            end
        end
    end

    -- QBCore Permission
    if location.QBCore.Enabled then
        local player = QBCore.Functions.GetPlayer(source)
        if location.QBCore.CheckJob.Enabled then
            for k, v in pairs(location.QBCore.CheckJob.Jobs) do
                if player.PlayerData.job.name == v then
                    return true
                end
            end
        end
        if location.QBCore.CheckPermission.Enabled then
            for k, v in pairs(location.QBCore.CheckPermission.Permissions) do
                if QBCore.Functions.HasPermission(source, v) then
                    return true
                end
            end
        end
    end

    if location.QBX.Enabled then
        local player = exports.qbx_core:GetPlayer(source)
        if location.QBX.CheckJob.Enabled then
            for k, v in pairs(location.QBX.CheckJob.Jobs) do
                if player.PlayerData.job.name == v then
                    return true
                end
            end
        end
    end

    return false
end

clampUsed = {}
lockpickUsed = {}

if itemEnabled then
    RegisterNetEvent("Server:ClampWithItem", function(src, clampType)
        if HandleInventoryItems(src, clampType, false) then
            if clampUsed[src] == nil then
                clampUsed[src] = 1
            else
                clampUsed[src] = clampUsed[src] + 1
            end
            TriggerClientEvent("Client:toggleClamp", src, true, clampType)
        else
            TriggerClientEvent("Client:starChaseNotification", src, translations.noItem)
        end
    end)
end

RegisterNetEvent("Server:ReturnClampItems", function(clampType)
    local source = source
    if clampUsed[source] ~= nil and clampUsed[source] > 0 then
        HandleInventoryItems(source, clampType, true)
        clampUsed[source] = clampUsed[source] - 1
    end
end)

if Inventory.vRP then
    RegisterNetEvent("Server:LockPickInventory", function(source)
        local source = source
        if HandleInventoryItems(source, Inventory.lockpickItem, false) then
            TriggerClientEvent("Client:pickClampLock", source)
            lockpickUsed[source] = true
        end
    end)
end


if main.commandEnabled then
    RegisterCommand(translations["CLAMP_COMMAND"], function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, Permissions)

        if args[1] == nil or (args[1] ~= translations["CLAMP_COMMAND_SETUP"] and args[1] ~= translations["CLAMP_COMMAND_REMOVE"]) then
            TriggerClientEvent("Client:clampNotification", source, translations["CLAMP_COMMAND_ERROR"])
            return 
        end

        local permission = UserHasPermission(source, Permissions)

        if permission then
            local setup = false
            local clampType = getClampType(args[2])
            if args[1] == translations["CLAMP_COMMAND_SETUP"] then 
                setup = true
            end

            if itemEnabled and setup then
                TriggerEvent("Server:ClampWithItem", source, clampType)
            else
                TriggerClientEvent("Client:toggleClamp", source, setup, clampType)
            end
        else
            TriggerClientEvent("Client:clampNotification", source, translations["NO_PERMISSION"])
        end
    end, Permissions.AcePermissions.Enabled)
end

if Inventory.oxInventory then
    exports('useClamp', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent("Client:toggleClamp", inventory.player.source, true, item.name)

            if clampUsed[inventory.player.source] == nil then
                clampUsed[inventory.player.source] = 1
            else
                clampUsed[inventory.player.source] = clampUsed[inventory.player.source] + 1 
            end
        end
    end)

    exports('useClampLockpick', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent("Client:pickClampLock", inventory.player.source)
            lockpickUsed[inventory.player.source] = true
        end
    end)
end

if Inventory.qbCore then
    for _, itemName in pairs(Inventory.clampItemNames) do
        QBCore.Functions.CreateUseableItem(itemName, function(source, item)
            if clampUsed[source] == nil then
                clampUsed[source] = 1
            else
                clampUsed[source] = clampUsed[source] + 1 
            end
            TriggerClientEvent("Client:toggleClamp", source, true, itemName)
        end)
    end

    QBCore.Functions.CreateUseableItem(Inventory.lockpickItem, function(source, item)
        TriggerClientEvent("Client:pickClampLock", source)
        lockpickUsed[source] = true
    end)
end

if Inventory.ESX then
    for _, itemName in pairs(main.clampItemNames) do
        ESX.RegisterUsableItem(itemName, function(source)

            if clampUsed[source] == nil then
                clampUsed[source] = 1
            else
                clampUsed[source] = clampUsed[source] + 1 
            end

            TriggerClientEvent("Client:toggleClamp", source, true, itemName)
        end)
    end
    ESX.RegisterUsableItem(Inventory.lockpickItem, function(source)
        TriggerClientEvent("Client:pickClampLock", source) 
        lockpickUsed[source] = true
    end)
end



-- .CreateThread(function()
--     if inventory.itemEnabled then
--         elseif inventory.esxInventory or (inventory.coreInventory and jobCheck.ESX.enabled) or (inventory.quasarInventory and jobCheck.ESX.enabled) then
            

--         elseif inventory.vRPInventory then
--             RegisterNetEvent("Server:useClamp", function(source, itemName)
--                 local user_id = vRP.getUserId({source})
--                 if userHasPermission(source, jobCheck) and vRP.tryGetInventoryItem({user_id,itemName,1}) then
--                     itemUsed[source] = itemName
--                     TriggerClientEvent("Client:toggleClamp", source, true, itemName)
--                     Citizen.SetTimeout(1000, function()
--                         itemUsed[source] = false
--                     end)
--                 end
--             end)

--             RegisterNetEvent("Server:pickClampLock", function(source, itemName)
--                 TriggerClientEvent("Client:pickClampLock", source)
--                 lockpickUsed[source] = true
--             end)
--         end
--     end
-- end)

