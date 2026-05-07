local playerNeeds, consumeCooldown, invalidAttempts, pendingUse = {}, {}, {}, {}

local function banPlayer(src, reason, details)
    if GetResourceState('ElectronAC') == 'started' then exports['ElectronAC']:banPlayer(src, reason, details or '{}', true) else DropPlayer(src, reason) end
end

local function clamp(value) return math.max(0, math.min(Config.MaxNeed, math.floor(value))) end
local function nowTs() return os.time() end
local function defaultNeeds() return { hunger = Config.Defaults.hunger, thirst = Config.Defaults.thirst, stress = Config.Defaults.stress, alcohol = Config.Defaults.alcohol, drug = Config.Defaults.drug, lastDamageAt = 0 } end

local function punishInvalid(src, reason, details)
    invalidAttempts[src] = (invalidAttempts[src] or 0) + 1
    if invalidAttempts[src] >= Config.MaxInvalidAttempts then banPlayer(src, reason, details) end
end

local function savePlayerNeeds(src)
    local xPlayer, needs = ESX.Player(src), playerNeeds[src]
    if not xPlayer or not needs then return end
    MySQL.insert.await('INSERT INTO cwrp_needs (identifier, needs) VALUES (?, ?) ON DUPLICATE KEY UPDATE needs = VALUES(needs), updated_at = CURRENT_TIMESTAMP', { xPlayer.getIdentifier(), json.encode(needs) })
end

local function sendState(src)
    if playerNeeds[src] then TriggerClientEvent('cwrp_needs:client:setState', src, playerNeeds[src]) end
end

local function adjust(src, key, amount)
    local needs = playerNeeds[src]
    if needs then needs[key] = clamp((needs[key] or 0) + amount) end
end

local function getSpoilageMeta(itemDef, metadata)
    local spoil = itemDef.spoilage
    metadata = metadata or {}

    if not spoil or not spoil.enabled then return metadata, nil, nil end

    local hours = tonumber(spoil.hours) or 48
    local createdAt = tonumber(metadata.createdAt) or nowTs()
    local spoilsAt = tonumber(metadata.spoilsAt) or (createdAt + hours * 3600)
    local left = spoilsAt - nowTs()
    local pct = math.max(0, math.floor((left / (hours * 3600)) * 100))

    metadata.createdAt = createdAt
    metadata.spoilsAt = spoilsAt
    metadata.freshness = pct
    metadata.state = left <= 0 and 'spoiled' or 'fresh'

    return metadata, left <= 0, pct
end

local function initOrUpdateSlotMeta(src, slotData, itemDef, maxUses)
    local metadata = slotData.metadata or {}
    local usesLeft = tonumber(metadata.usesLeft) or maxUses

    metadata.usesLeft = usesLeft
    metadata.maxUses = maxUses
    metadata.durability = math.floor((usesLeft / maxUses) * 100)
    metadata, _, _ = getSpoilageMeta(itemDef, metadata)

    exports.ox_inventory:SetMetadata(src, slotData.slot, metadata)
    exports.ox_inventory:SetDurability(src, slotData.slot, metadata.durability)
    return metadata, usesLeft
end

local function handleSpoiledItem(src, slot, itemName, itemDef, metadata)
    local spoil = itemDef.spoilage
    if not spoil or not spoil.enabled then return false end

    local _, isSpoiled = getSpoilageMeta(itemDef, metadata)
    if not isSpoiled then return false end

    exports.ox_inventory:RemoveItem(src, itemName, 1, nil, slot)

    if spoil.onSpoil and spoil.onSpoil.action == 'replace' and spoil.onSpoil.item then
        exports.ox_inventory:AddItem(src, spoil.onSpoil.item, spoil.onSpoil.count or 1)
    end

    TriggerClientEvent('cwrp_needs:client:warn', src, 'Item se zkazil.')
    return true
end

local function applyGiveItems(src, itemDef)
    if not itemDef.giveItems then return true end
    for i = 1, #itemDef.giveItems do
        local gift = itemDef.giveItems[i]
        if not exports.ox_inventory:AddItem(src, gift.name, gift.count or 1, gift.metadata) then return false end
    end
    return true
end

local function applyItemEffects(src, itemName, itemDef, usesLeft, freshness)
    adjust(src, 'hunger', itemDef.hunger or 0)
    adjust(src, 'thirst', itemDef.thirst or 0)
    adjust(src, 'stress', itemDef.stress or 0)
    adjust(src, 'alcohol', itemDef.alcohol or 0)
    adjust(src, 'drug', itemDef.drug or 0)
    TriggerClientEvent('cwrp_needs:client:consumed', src, itemName, usesLeft, freshness)
    sendState(src)
end

local function getRestrictionError(itemDef, clientState, src)
    clientState = clientState or {}
    if itemDef.denyInVehicle then local ped = GetPlayerPed(src) if ped and ped > 0 and GetVehiclePedIsIn(ped, false) ~= 0 then return 'Tento item nemuzes pouzit v aute.' end end
    if itemDef.denyWhileSwimming and clientState.isSwimming then return 'Tento item nemuzes pouzit ve vode.' end
    if itemDef.denyWhileSprinting and clientState.isSprinting then return 'Tento item nemuzes pouzit pri sprintu.' end
    return nil
end

local function getFirstSlot(src, itemName)
    local found = exports.ox_inventory:Search(src, 1, itemName)
    if type(found) ~= 'table' then return nil end
    for _, v in pairs(found) do if v and v.slot and (v.count or 0) > 0 then return v end end
    return nil
end

local function beginUsePrompt(src, itemName)
    local itemDef = Config.Items[itemName]
    if not itemDef then return punishInvalid(src, 'cwrp_needs: invalid item', json.encode({ item = itemName })) end

    local now = GetGameTimer()
    if consumeCooldown[src] and consumeCooldown[src] > now then return TriggerClientEvent('cwrp_needs:client:warn', src, 'Pockej chvili pred dalsim pouzitim.') end

    local slotData = getFirstSlot(src, itemName)
    if not slotData then return punishInvalid(src, 'cwrp_needs: missing slot', json.encode({ item = itemName })) end

    local maxUses = math.max(1, tonumber(itemDef.uses) or 1)
    local metadata, usesLeft = initOrUpdateSlotMeta(src, slotData, itemDef, maxUses)

    if handleSpoiledItem(src, slotData.slot, itemName, itemDef, metadata) then return end

    local freshness = tonumber(metadata.freshness) or 100
    local token = ('%s:%s:%s'):format(src, itemName, math.random(111111, 999999))
    pendingUse[src] = { token = token, itemName = itemName, slot = slotData.slot, usesLeft = usesLeft, maxUses = maxUses, freshness = freshness, expiresAt = now + Config.UsePromptTimeoutMs }
    TriggerClientEvent('cwrp_needs:client:showUsePrompt', src, token, itemName, usesLeft, maxUses, freshness)
end

RegisterNetEvent('cwrp_needs:server:usePromptResult', function(token, action, clientState)
    local src = source
    local prompt = pendingUse[src]
    if not prompt then return end
    pendingUse[src] = nil

    if prompt.token ~= token then return punishInvalid(src, 'cwrp_needs: invalid use token', json.encode({ token = token })) end
    if GetGameTimer() > prompt.expiresAt then return TriggerClientEvent('cwrp_needs:client:warn', src, 'Pouziti itemu vyprselo.') end
    if action == 'hide' then return TriggerClientEvent('cwrp_needs:client:hidden', src) end
    if action ~= 'use' then return punishInvalid(src, 'cwrp_needs: invalid use action', json.encode({ action = action })) end

    local itemDef = Config.Items[prompt.itemName]
    if not itemDef then return end

    local restrictionError = getRestrictionError(itemDef, clientState, src)
    if restrictionError then return TriggerClientEvent('cwrp_needs:client:warn', src, restrictionError) end

    local current = exports.ox_inventory:GetSlot(src, prompt.slot)
    if not current or current.name ~= prompt.itemName then return punishInvalid(src, 'cwrp_needs: slot mismatch', json.encode({ slot = prompt.slot })) end

    local metadata, isSpoiled, freshness = getSpoilageMeta(itemDef, current.metadata)
    if isSpoiled then
        handleSpoiledItem(src, prompt.slot, prompt.itemName, itemDef, metadata)
        return
    end

    local usesLeft = prompt.usesLeft - 1
    if itemDef.remove then
        if usesLeft <= 0 then
            if not exports.ox_inventory:RemoveItem(src, prompt.itemName, 1, nil, prompt.slot) then return punishInvalid(src, 'cwrp_needs: remove failed', json.encode({ slot = prompt.slot })) end
        else
            metadata.usesLeft = usesLeft
            metadata.maxUses = prompt.maxUses
            metadata.durability = math.floor((usesLeft / prompt.maxUses) * 100)
            exports.ox_inventory:SetMetadata(src, prompt.slot, metadata)
            exports.ox_inventory:SetDurability(src, prompt.slot, metadata.durability)
        end
    end

    if not applyGiveItems(src, itemDef) then TriggerClientEvent('cwrp_needs:client:warn', src, 'Nemas misto pro nove itemy.') end
    consumeCooldown[src] = GetGameTimer() + Config.ConsumptionCooldownMs
    applyItemEffects(src, prompt.itemName, itemDef, math.max(0, usesLeft), freshness)
end)

lib.callback.register('cwrp_needs:server:getState', function(src) return playerNeeds[src] end)

RegisterNetEvent('cwrp_needs:server:drinkStation', function(stationId)
    local src, station = source, Config.TargetDrinkStations[tonumber(stationId)]
    if not station then return punishInvalid(src, 'cwrp_needs: invalid station', json.encode({ stationId = stationId })) end
    adjust(src, 'thirst', station.thirstGain or 0)
    adjust(src, 'stress', -(station.stressRelief or 0))
    sendState(src)
end)

AddEventHandler('esx:playerLoaded', function(src, xPlayer)
    invalidAttempts[src] = 0
    local row = MySQL.single.await('SELECT needs FROM cwrp_needs WHERE identifier = ? LIMIT 1', { xPlayer.getIdentifier() })
    playerNeeds[src] = row and row.needs and json.decode(row.needs) or defaultNeeds()
    sendState(src)
end)

AddEventHandler('esx:playerDropped', function(src)
    savePlayerNeeds(src)
    playerNeeds[src], consumeCooldown[src], invalidAttempts[src], pendingUse[src] = nil, nil, nil, nil
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for src in pairs(playerNeeds) do savePlayerNeeds(src) end
end)

CreateThread(function()
    Wait(2000)
    for itemName in pairs(Config.Items) do
        ESX.RegisterUsableItem(itemName, function(src)
            beginUsePrompt(src, itemName)
        end)
    end
end)

CreateThread(function()
    while true do
        Wait(Config.SpoilageCheckInterval)
        for src in pairs(playerNeeds) do
            for itemName, itemDef in pairs(Config.Items) do
                if itemDef.spoilage and itemDef.spoilage.enabled then
                    local found = exports.ox_inventory:Search(src, 1, itemName)
                    if type(found) == 'table' then
                        for _, slotData in pairs(found) do
                            if slotData and slotData.slot and (slotData.count or 0) > 0 then
                                local metadata, isSpoiled = getSpoilageMeta(itemDef, slotData.metadata)
                                if isSpoiled then
                                    handleSpoiledItem(src, slotData.slot, itemName, itemDef, metadata)
                                else
                                    exports.ox_inventory:SetMetadata(src, slotData.slot, metadata)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.ServerTick)
        local now = GetGameTimer()
        for src, needs in pairs(playerNeeds) do
            needs.hunger = clamp(needs.hunger - Config.Decay.hunger)
            needs.thirst = clamp(needs.thirst - Config.Decay.thirst)
            needs.alcohol = clamp(needs.alcohol - Config.Decay.addictionDecay)
            needs.drug = clamp(needs.drug - Config.Decay.addictionDecay)
            needs.stress = clamp(needs.stress - Config.Decay.stressRelief)
            if needs.hunger <= Config.Starvation.hungerThreshold or needs.thirst <= Config.Starvation.thirstThreshold then
                needs.stress = clamp(needs.stress + Config.Starvation.stressPerTick)
                if now - (needs.lastDamageAt or 0) >= Config.Starvation.damageEveryMs then
                    needs.lastDamageAt = now
                    local ped = GetPlayerPed(src)
                    if ped and ped > 0 then SetEntityHealth(ped, math.max(1, GetEntityHealth(ped) - Config.Starvation.damage)) end
                end
            end
            if needs.alcohol <= Config.Withdrawal.threshold and needs.drug <= Config.Withdrawal.threshold then
                needs.stress = clamp(needs.stress + Config.Withdrawal.stressPerTick)
                if math.random(1, 100) <= Config.Withdrawal.stumbleChance then TriggerClientEvent('cwrp_needs:client:stumble', src) end
            end
            TriggerClientEvent('cwrp_needs:client:needsTick', src, needs)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.SaveInterval)
        for src in pairs(playerNeeds) do savePlayerNeeds(src) end
    end
end)
