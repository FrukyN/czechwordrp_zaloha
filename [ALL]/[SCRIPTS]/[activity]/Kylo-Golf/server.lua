local ox_inventory = exports.ox_inventory
-- local QBCore = exports["qb-core"]:GetCoreObject()  -- uncomment for QB

RegisterServerEvent('RRGolf:checkMembership')
AddEventHandler('RRGolf:checkMembership', function()
    if Config.Inventory == "ox" then
	    local GMembership = ox_inventory:GetItemCount(source, Config.MemberCarditem)
	    if GMembership > 0 then
		    TriggerClientEvent('RRGolf:Member', source) 
	    else
		    TriggerClientEvent('RRGolf:NonMember', source)
	    end
    elseif Config.Inventory == "qb" then
        local Player = QBCore.Functions.GetPlayer(source)
        local hasItem = Player.Functions.GetItemByName(Config.MemberCarditem)
        if hasItem and hasItem.amount > 0 then 
            TriggerClientEvent('RRGolf:Member', source) 
	    else
		    TriggerClientEvent('RRGolf:NonMember', source)
	    end
    end
end)

RegisterServerEvent('RRGolf:MembersCheck')
AddEventHandler('RRGolf:MembersCheck', function()
    if Config.Inventory == "ox" then
        local GMembership = ox_inventory:GetItemCount(source, Config.MemberCarditem)
        if GMembership > 0 then
            TriggerClientEvent('RRGolf:membersonly', source)
        else
            TriggerClientEvent('RRGolf:noway', source)
        end
    elseif Config.Inventory == "qb" then
        local Player = QBCore.Functions.GetPlayer(source)
        local hasItem = Player.Functions.GetItemByName(Config.MemberCarditem)
        if hasItem and hasItem.amount > 0 then 
            TriggerClientEvent('RRGolf:membersonly', source)
        else
            TriggerClientEvent('RRGolf:noway', source)
        end
    end
end)

RegisterServerEvent('RRGolf:buyMembership')
AddEventHandler('RRGolf:buyMembership', function()  
    if Config.Inventory == "ox" then    
        local money = ox_inventory:GetItemCount(source, 'money')
        if money >= Config.MemberPrice then
            if ox_inventory:CanCarryItem(source, Config.MemberCarditem, 1) then
                ox_inventory:RemoveItem(source, 'money', Config.MemberPrice)
                ox_inventory:AddItem(source, Config.MemberCarditem, 1)
                lib.notify(source, { position = 'top-right', duration = 6000, title = 'Los Santos Golf Club', type = 'success', description = 'Zakoupil sis členství' })
                TriggerClientEvent('RRGolf:Member', source) 
            else
                lib.notify(source, { position = 'top-right', duration = 6000, title = 'Los Santos Golf Club', type = 'error', description = 'Nedostatek místa v inventáři' })
            end
        else
            lib.notify(source, { position = 'top-right', duration = 6000, title = 'Los Santos Golf Club', type = 'error', description = 'Nedostatek financí' })
        end
    elseif Config.Inventory == "qb" then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return end
        local money = Player.Functions.GetMoney('cash')
        if Config.MemberPrice <= money then
            Player.Functions.AddItem(Config.MemberCarditem, 1)
            Player.Functions.RemoveMoney('cash', Config.MemberPrice)
            lib.notify(source, { position = 'top-right', duration = 6000, title = 'Los Santos Golf Club', type = 'success', description = 'Členství bylo zakoupono' })
        else
            lib.notify(source, { position = 'top-right', duration = 6000, title = 'Los Santos Golf Club', type = 'error', description = 'Nedostatek financí' })
        end
    end
end)

RegisterServerEvent('RRP-Golf:Solos')
AddEventHandler('RRP-Golf:Solos',function()
    TriggerClientEvent('RRGolf:Starting', source)
end)