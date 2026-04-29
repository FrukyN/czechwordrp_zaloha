local ESX = exports["es_extended"]:getSharedObject()
local activeAdminTags = {}

local Config = {
    Roles = {
        ['tester']    = {label = "HELPER",        icon = "💡", color = {r = 255, g = 165, b = 0}, msg = "DODRŽUJTE RP PRAVIDLA - NEVYRUŠUJTE PRI REŠENÍ"},
        ['trial']     = {label = "TRIAL STAFF",   icon = "🛡️", color = {r = 255, g = 165, b = 0}, msg = "KOMUNIKUJ SLUŠNĚ - NEVYRUŠUJTE PRI REŠENÍ"},
        ['admin']     = {label = "ADMIN",         icon = "🛡️", color = {r = 255, g = 165, b = 0}, msg = "RP POZASTAVENO - NEVYRUŠUJTE PRI REŠENÍ"},
        ['junior']    = {label = "JUNIOR STAFF",  icon = "🌱", color = {r = 0, g = 255, b = 0},   msg = "RP POZASTAVENO - NEVYRUŠUJTE PRI REŠENÍ"},
        ['staff']     = {label = "STAFF",         icon = "🛡️", color = {r = 0, g = 191, b = 255}, msg = "RESPEKTUJ ROZHODNUTÍ STAFFA - NEVYRUŠUJTE PRI REŠENÍ"},
        ['senior']    = {label = "SENIOR STAFF",  icon = "🎖️", color = {r = 147, g = 112, b = 219}, msg = "RP POZASTAVENO - NEVYRUŠUJTE PRI REŠENÍ"},
        ['hos']       = {label = "HEAD OF STAFF", icon = "⚔️", color = {r = 128, g = 0, b = 128},   msg = "NEVYVOLÁVEJ KONFLIKTY - NEVYRUŠUJTE PRI REŠENÍ"},
        ['cardev']    = {label = "CAR DEVELOPER", icon = "🔧", color = {r = 255, g = 50, b = 50},   msg = "DEVUJU - NEPSAT / NEVYRUŠOVAT / JÁ TU NEJSEM"},
        ['dev']       = {label = "DEVELOPER",     icon = "💻", color = {r = 147, g = 112, b = 219}, msg = "DEVUJU - NEPSAT / NEVYRUŠOVAT / JÁ TU NEJSEM"},
        ['managment'] = {label = "MANAGEMENT",    icon = "💼", color = {r = 255, g = 215, b = 0},   msg = "VEDENÍ SERVERU - NEVYRUŠUJTE PRI REŠENÍ"},
        ['cowner']    = {label = "SPOLUMAJITEL",  icon = "👑", color = {r = 255, g = 215, b = 0},   msg = "SPOLUMAJITEL - NEVYRUŠUJTE PRI REŠENÍ"},
        ['owner']     = {label = "MAJITEL",       icon = "👑", color = {r = 255, g = 215, b = 0},   msg = "MAJITEL - NEVYRUŠUJTE PRI REŠENÍ"},
    }
}

function RefreshAdminData()
    local data = {}
    for source, active in pairs(activeAdminTags) do
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local roleData = Config.Roles[xPlayer.getGroup()]
            if roleData then
                table.insert(data, {
                    source = source,
                    label = roleData.label,
                    icon = roleData.icon,
                    color = roleData.color,
                    status = roleData.msg
                })
            end
        end
    end
    TriggerClientEvent('esx_adminTags:sync', -1, data)
end

RegisterCommand('tagy', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and Config.Roles[xPlayer.getGroup()] then
        if activeAdminTags[source] then
            activeAdminTags[source] = nil
            TriggerClientEvent('esx:showNotification', source, "Tag: ~r~SKRYT")
        else
            activeAdminTags[source] = true
            TriggerClientEvent('esx:showNotification', source, "Tag: ~g~ZOBRAZEN")
        end
        RefreshAdminData()
    end
end)

AddEventHandler('playerDropped', function()
    if activeAdminTags[source] then
        activeAdminTags[source] = nil
        RefreshAdminData()
    end
end)