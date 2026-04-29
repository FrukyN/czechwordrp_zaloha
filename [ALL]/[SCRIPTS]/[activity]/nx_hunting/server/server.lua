local ox_inventory = exports.ox_inventory
local rewardCooldown = {}
local itemCache = nil

local function itemExists(itemName)
    if type(itemName) ~= 'string' then
        return false
    end

    if not itemCache then
        itemCache = ox_inventory:Items()
    end

    return itemCache and itemCache[itemName] ~= nil
end

local function isValidZone(zoneName)
    return Config.Zones and Config.Zones[zoneName] ~= nil
end

local function getAnimalByName(zoneName, animalName)
    local zone = Config.Zones[zoneName]
    if not zone or not zone.Animals then
        return nil
    end

    return zone.Animals[animalName]
end

local function normalizeLootEntry(entry)
    if type(entry) == 'string' then
        return entry, 1, 1
    end

    if type(entry) ~= 'table' or type(entry.item) ~= 'string' then
        return nil
    end

    local min = math.floor(tonumber(entry.min) or 1)
    local max = math.floor(tonumber(entry.max) or min)

    if min < 1 then
        min = 1
    end

    if max < min then
        max = min
    end

    return entry.item, min, max
end

local function getAllLoots(animalData)
    if not animalData or type(animalData.loots) ~= 'table' or #animalData.loots == 0 then
        return nil
    end

    local result = {}

    for _, entry in ipairs(animalData.loots) do
        local itemName, minCount, maxCount = normalizeLootEntry(entry)
        if itemName then
            result[#result + 1] = {
                item = itemName,
                min = minCount,
                max = maxCount
            }
        end
    end

    if #result == 0 then
        return nil
    end

    return result
end

RegisterNetEvent('nx_hunting:server:reward', function(animalZone, animalName)
    local src = source

    if type(animalZone) ~= 'string' or type(animalName) ~= 'string' then
        exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Lovení", true)
        print(('[nx_hunting] %s sent invalid reward payload'):format(GetPlayerName(src) or src))
        return
    end

    local now = GetGameTimer()
    local nextAllowed = rewardCooldown[src] or 0

    if now < nextAllowed then
        return
    end

    rewardCooldown[src] = now + 1500

    if not isValidZone(animalZone) then
        exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Lovení", true)
        print(('[nx_hunting] %s tried invalid zone: %s'):format(GetPlayerName(src) or src, animalZone))
        return
    end

    local animalData = getAnimalByName(animalZone, animalName)
    if not animalData then
        exports["ElectronAC"]:banPlayer(src, "Podezření na číty", "Lovení", true)
        print(('[nx_hunting] %s tried invalid animal: %s'):format(GetPlayerName(src) or src, animalName))
        return
    end

    local loots = getAllLoots(animalData)
    if not loots then
        return
    end

    local addedAnyItem = false

    for _, lootData in ipairs(loots) do
        local loot = lootData.item
        local count = math.random(lootData.min, lootData.max)

        if itemExists(loot) and count > 0 then
            local success = ox_inventory:AddItem(src, loot, count)
            if success then
                addedAnyItem = true
            end
        else
            print(('[nx_hunting] Invalid loot item in config: %s (zone=%s animal=%s)'):format(tostring(loot), animalZone, animalName))
        end
    end

    if not addedAnyItem then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Nedostatek mista v inventari.'
        })
    end
end)

AddEventHandler('playerDropped', function()
    rewardCooldown[source] = nil
end)
