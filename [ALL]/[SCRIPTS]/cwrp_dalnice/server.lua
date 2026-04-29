local ESX = exports['es_extended']:getSharedObject()
local buyCooldown = {}

local function doDiscordLog(text, src, color)
    local ok = pcall(function()
        exports.JD_logs:discord(text, src, 0, color, Config.DiscordLogName)
    end)

    if not ok and Config.Debug then
        print(('[%s] JD_logs export nebyl dostupny.'):format(GetCurrentResourceName()))
    end
end

local function secureBan(src, reason, details)
    local banned = pcall(function()
        exports['ElectronAC']:banPlayer(src, reason, details, true)
    end)

    if not banned then
        DropPlayer(src, ('[SECURITY] %s | %s'):format(reason, details))
    end
end

local function flagSecurity(src, reason, details)
    doDiscordLog(('[SECURITY] %s | %s'):format(reason, details), src, Config.Colors.danger)
    secureBan(src, reason, details)
end

local function getPointById(pointId)
    for i = 1, #Config.BuyPoints do
        if Config.BuyPoints[i].id == pointId then
            return Config.BuyPoints[i]
        end
    end

    return nil
end

local function isNearBuyPoint(src, point)
    local ped = GetPlayerPed(src)
    if ped <= 0 then
        return false
    end

    local pcoords = GetEntityCoords(ped)
    local distance = #(pcoords - point.coords)
    return distance <= Config.MaxBuyDistance
end

local function getDateStrings(startTs, endTs)
    return os.date('%d.%m.%Y', startTs), os.date('%d.%m.%Y', endTs)
end

local function normalizePlate(plate)
    if type(plate) ~= 'string' then
        return ''
    end

    local clean = plate:gsub('^%s*(.-)%s*$', '%1')
    clean = clean:gsub('%s+', '')
    clean = clean:upper()
    return clean
end

local function getPlayerIdentifier(xPlayer)
    return xPlayer.identifier
end

local function getOwnedPlates(identifier)
    local query = ('SELECT `%s` FROM `%s` WHERE `%s` = ?'):format(
        Config.VehiclePlateColumn,
        Config.VehicleTable,
        Config.VehicleOwnerColumn
    )

    local rows = MySQL.query.await(query, { identifier }) or {}
    local result = {}

    for i = 1, #rows do
        local plate = rows[i][Config.VehiclePlateColumn]
        if type(plate) == 'string' and plate ~= '' then
            result[#result + 1] = plate:gsub('^%s*(.-)%s*$', '%1')
        end
    end

    return result
end

local function playerOwnsPlate(xPlayer, plate)
    local identifier = getPlayerIdentifier(xPlayer)
    if not identifier then
        return false
    end

    local wanted = normalizePlate(plate)
    if wanted == '' then
        return false
    end

    local owned = getOwnedPlates(identifier)

    for i = 1, #owned do
        if normalizePlate(owned[i]) == wanted then
            return true
        end
    end

    return false
end

lib.callback.register('cwrp_dalnice:server:getOwnedVehiclePlates', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return {}
    end

    local identifier = getPlayerIdentifier(xPlayer)
    if not identifier then
        return {}
    end

    return getOwnedPlates(identifier)
end)

RegisterNetEvent('cwrp_dalnice:server:buyVignette', function(pointId, vignetteType, plate)
    local src = source

    if type(pointId) ~= 'string' or type(vignetteType) ~= 'string' or type(plate) ~= 'string' then
        flagSecurity(src, 'Invalid payload', 'pointId/vignetteType/plate nejsou string')
        return
    end

    local point = getPointById(pointId)
    if not point then
        flagSecurity(src, 'Invalid point', ('pointId=%s'):format(pointId))
        return
    end

    if not isNearBuyPoint(src, point) then
        flagSecurity(src, 'Distance spoof', ('pointId=%s'):format(pointId))
        return
    end

    local now = os.time()
    local nextBuyAt = buyCooldown[src] or 0

    if now < nextBuyAt then
        TriggerClientEvent('cwrp_dalnice:client:notify', src, 'error', 'Pockej chvili pred dalsim nakupem.')
        return
    end

    buyCooldown[src] = now + Config.BuyCooldown

    local vignette = Config.Vignettes[vignetteType]
    if not vignette then
        flagSecurity(src, 'Invalid vignette type', ('type=%s'):format(vignetteType))
        return
    end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    if not playerOwnsPlate(xPlayer, plate) then
        flagSecurity(src, 'Plate spoof', ('plate=%s'):format(plate))
        return
    end

    local money = xPlayer.getMoney()
    if money < vignette.price then
        TriggerClientEvent('cwrp_dalnice:client:notify', src, 'error', 'Nemas dostatek penez.')
        doDiscordLog(('Hrac se pokusil koupit %s pro SPZ %s, ale nema penize. Cena: $%s'):format(vignette.label, plate, vignette.price), src, Config.Colors.warning)
        return
    end

    local purchaseTs = now
    local expireTs = now + (vignette.days * 86400)
    local purchaseDate, expireDate = getDateStrings(purchaseTs, expireTs)

    local metadata = {
        label = vignette.label,
        spz = plate:gsub('^%s*(.-)%s*$', '%1'),
        typ = vignetteType,
        zakoupeno = purchaseDate,
        vyprsi = expireDate,
        purchase_ts = purchaseTs,
        expire_ts = expireTs
    }

    local canCarry = exports.ox_inventory:CanCarryItem(src, Config.ItemName, 1)
    if not canCarry then
        TriggerClientEvent('cwrp_dalnice:client:notify', src, 'error', 'Nemas misto v inventari.')
        return
    end

    xPlayer.removeMoney(vignette.price, 'dalnicni_znamka_nakup')

    local added = exports.ox_inventory:AddItem(src, Config.ItemName, 1, metadata)
    if not added then
        xPlayer.addMoney(vignette.price, 'dalnicni_znamka_refund')
        TriggerClientEvent('cwrp_dalnice:client:notify', src, 'error', 'Nepodarilo se pridat item. Penize byly vraceny.')
        doDiscordLog(('Chyba pri AddItem, vracim penize za %s (SPZ %s)'):format(vignette.label, plate), src, Config.Colors.warning)
        return
    end

    TriggerClientEvent('cwrp_dalnice:client:notify', src, 'success', ('Zakoupeno: %s pro SPZ %s | platnost do %s'):format(vignette.label, metadata.spz, expireDate))

    doDiscordLog(
        ('Hrac obdrzel dalnicni znamku: %s | SPZ: %s | Cena: $%s | Zakoupeno: %s | Vyprsi: %s'):format(
            vignette.label,
            metadata.spz,
            vignette.price,
            purchaseDate,
            expireDate
        ),
        src,
        Config.Colors.success
    )
end)

AddEventHandler('playerDropped', function()
    local src = source
    buyCooldown[src] = nil
end)
