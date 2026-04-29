QBCore = nil
vRP = nil
ESX = nil

itemEnabled = Inventory.quasarInventory or Inventory.qbCore or Inventory.vRP or Inventory.ESX or Inventory.coreInventory or Inventory.oxInventory

if FanCommand.Permissions.ESX.Enabled or HalliganCommand.Permissions.ESX.Enabled or StabilisersCommand.Permissions.ESX.Enabled or SpreadersCommand.Permissions.ESX.Enabled or SawCommand.Permissions.ESX.Enabled or Inventory.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if FanCommand.Permissions.vRP.Enabled or HalliganCommand.Permissions.vRP.Enabled or StabilisersCommand.Permissions.vRP.Enabled or SpreadersCommand.Permissions.vRP.Enabled or SawCommand.Permissions.vRP.Enabled or Inventory.vRP then
    Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")
end

if FanCommand.Permissions.vRP.Enabled or HalliganCommand.Permissions.QBCore.Enabled or StabilisersCommand.Permissions.QBCore.Enabled or SpreadersCommand.Permissions.QBCore.Enabled or SawCommand.Permissions.QBCore.Enabled or Inventory.qbCore then
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

usedFan = {}
usedStabilisers = {}

if Inventory.qbCore then
    CreateThread(function()
        QBCore.Functions.CreateUseableItem(Inventory.fanItemName, function(src, item)
            TriggerEvent("Server:FanWithItem", src)
        end)
        QBCore.Functions.CreateUseableItem(Inventory.stabilisersItemName, function(src, item)
            TriggerEvent("Server:StabilisersWithItem", src)
        end)

    end)

end

if Inventory.ESX then
    CreateThread(function()
        ESX.RegisterUsableItem(Inventory.fanItemName, function(playerId)
            TriggerEvent("Server:FanWithItem", playerId)
        end)
        ESX.RegisterUsableItem(Inventory.stabilisersItemName, function(playerId)
            TriggerEvent("Server:StabilisersWithItem", playerId)
        end)

    end)
end

if Inventory.oxInventory then
    exports('OxUseFan', function(event, _, Inventory)
        if event == 'usingItem' then
            usedFan[Inventory.player.source] = true
            TriggerClientEvent("Client:toggleFan", Inventory.player.source, true)

            Citizen.SetTimeout(2000, function()
                usedFan[Inventory.player.source] = false
            end)
        end
    end)
    exports('OxUseStabilisers', function(event, _, Inventory)
        if event == 'usingItem' then
            usedStabilisers[Inventory.player.source] = true
            TriggerClientEvent("Client:toggleStabilisers", Inventory.player.source, true)

            Citizen.SetTimeout(2000, function()
                usedStabilisers[Inventory.player.source] = false
            end)
        end
    end)
end

if itemEnabled then
    RegisterNetEvent("Server:FanWithItem", function(src)
        if HandleInventoryItems(src, Inventory.fanItemName, false) then
            usedFan[src] = true
            TriggerClientEvent("Client:toggleFan", src, true)

            Citizen.SetTimeout(2000, function()
                usedFan[src] = false
            end)
        else
            TriggerClientEvent("Client:fireToolsNotification", src, translations.noItem)
        end
    end)

    RegisterNetEvent("Server:StabilisersWithItem", function(src)
        if HandleInventoryItems(src, Inventory.stabilisersItemName, false) then
            usedStabilisers[src] = true
            TriggerClientEvent("Client:toggleStabilisers", src, true)

            Citizen.SetTimeout(2000, function()
                usedStabilisers[src] = false
            end)
        else
            TriggerClientEvent("Client:fireToolsNotification", src, translations.noItem)
        end
    end)

    RegisterNetEvent("Server:ReturnFanFireTools", function()
        local source = source
        if usedFan[source] then
            HandleInventoryItems(source, Inventory.fanItemName, true)
            usedFan[source] = false
        end
    end)

    RegisterNetEvent("Server:ReturnStabilisersFireTools", function()
        local source = source
        if usedStabilisers[source] then
            HandleInventoryItems(source, Inventory.stabilisersItemName, true)
            usedStabilisers[source] = false
        end
    end)
end

if FanCommand.enabled then
    RegisterCommand(FanCommand.commandName, function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, FanCommand.Permissions)
        if itemEnabled then
            permission = true
        end

        local argument = nil

        if args[1] == nil or (args[1] ~= translations.setup and args[1] ~= translations.remove) then
            argument = translations.setup
        else
            argument = args[1]
        end

        if permission then
            if argument == translations.setup then
                -- Install Stabiliser
                if itemEnabled then 
                    TriggerEvent("Server:FanWithItem", source)
                else
                    TriggerClientEvent("Client:toggleFan", source, true)
                end
            else
                -- Removing the fan
                TriggerClientEvent("Client:toggleFan", source, false)
            end
        else
            TriggerClientEvent("Client:fireToolsNotification", source, translations.noPermission)
        end
    end, FanCommand.Permissions.AcePermissions.Enabled and FanCommand.Permissions.EnablePermissions)
end

if StabilisersCommand.enabled then
    RegisterCommand(StabilisersCommand.commandName, function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, StabilisersCommand.Permissions)
        if itemEnabled then
            permission = true
        end

        local argument = nil

        if args[1] == nil or (args[1] ~= translations.setup and args[1] ~= translations.remove) then
            argument = translations.setup
        else
            argument = args[1]
        end

        if permission then
            if argument == translations.setup then
                -- Install Stabilisers
                if itemEnabled then 
                    TriggerEvent("Server:StabilisersWithItem", source)
                else
                    TriggerClientEvent("Client:toggleStabilisers", source, true)
                end
            else
                -- Removing the stabiliser
                TriggerClientEvent("Client:toggleStabilisers", source, false)
            end
        else
            TriggerClientEvent("Client:fireToolsNotification", source, translations.noPermission)
        end


    end, StabilisersCommand.Permissions.AcePermissions.Enabled and StabilisersCommand.Permissions.EnablePermissions)
end

usedSpreaders = {}

if SpreadersCommand.enabled then
    -- Command registered server side below:
    RegisterCommand(SpreadersCommand.commandName, function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, SpreadersCommand.Permissions)

        if permission then
            local ped = GetPlayerPed(source)
            if usedSpreaders[source] then
                RemoveWeaponFromPed(ped, models.spreadersWeapon)
                usedSpreaders[source] = false
            else
                GiveWeaponToPed(ped, models.spreadersWeapon, 0, false, true)
                usedSpreaders[source] = true
            end
        else
            TriggerClientEvent("Client:fireToolsNotification", source, translations.noPermission)
        end
    end, SpreadersCommand.Permissions.AcePermissions.Enabled and SpreadersCommand.Permissions.EnablePermissions)
end

usedHalligan = {}

if HalliganCommand.enabled then
    -- Command registered server side below:
    RegisterCommand(HalliganCommand.commandName, function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, HalliganCommand.Permissions)

        if permission then
            local ped = GetPlayerPed(source)
            if usedHalligan[source] then
                RemoveWeaponFromPed(ped, models.halliganWeapon)
                usedHalligan[source] = false
            else
                GiveWeaponToPed(ped, models.halliganWeapon, 0, false, true)
                usedHalligan[source] = true
            end
        else
            TriggerClientEvent("Client:fireToolsNotification", source, translations.noPermission)
        end
    end, HalliganCommand.Permissions.AcePermissions.Enabled and HalliganCommand.Permissions.EnablePermissions)
end

usedSaw = {}

if SawCommand.enabled then
    -- Command registered server side below:
    RegisterCommand(SawCommand.commandName, function(source, args, rawCommand)
        local source = source
        local permission = UserHasPermission(source, SawCommand.Permissions)

        if permission then
            local ped = GetPlayerPed(source)
            if usedSaw[source] then
                RemoveWeaponFromPed(ped, models.sawWeapon)
                usedSaw[source] = false
            else
                GiveWeaponToPed(ped, models.sawWeapon, 0, false, true)
                usedSaw[source] = true
            end
        else
            TriggerClientEvent("Client:fireToolsNotification", source, translations.noPermission)
        end
    end, SawCommand.Permissions.AcePermissions.Enabled and SawCommand.Permissions.EnablePermissions)
end