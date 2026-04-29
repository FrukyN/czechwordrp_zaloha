-- client/damage_engine.lua

-- Inicializace ESX
local ESX = exports["es_extended"]:getSharedObject()

local patientStatus = {
    injuries = {},
    pulse = 80,
    bleedingLevel = 0,
    isUnconscious = false
}

local function IsWeaponFirearm(hash)
    local group = GetWeapontypeGroup(hash)
    -- Všechny skupiny palných zbraní
    return (group == 416676503 or group == 970310034 or group == 860347289 or 
            group == -957766203 or group == -1212478832 or group == 1159398588)
end

-- Tabulka hashů zbraní pro přesnější detekci, pokud selže WeaponGroup
local WeaponHashes = {
    ["Střelná rána"] = {
        -- Pistole
        `WEAPON_PISTOL`, `WEAPON_COMBATPISTOL`, `WEAPON_APPISTOL`, `WEAPON_PISTOL50`, 
        `WEAPON_SNSPISTOL`, `WEAPON_HEAVYPISTOL`, `WEAPON_VINTAGEPISTOL`, `WEAPON_MARKSMANPISTOL`, 
        `WEAPON_REVOLVER`, `WEAPON_DOUBLEACTION`, `WEAPON_NAVYREVOLVER`, `WEAPON_GADGETPISTOL`,
        -- SMG a PDW
        `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_ASSAULTSMG`, `WEAPON_COMBATPDW`, 
        `WEAPON_MACHINEPISTOL`, `WEAPON_MINISMG`,
        -- Pušky (Rifles)
        `WEAPON_ASSAULTRIFLE`, `WEAPON_CARBINERIFLE`, `WEAPON_ADVANCEDRIFLE`, 
        `WEAPON_SPECIALCARBINE`, `WEAPON_BULLPUPRIFLE`, `WEAPON_COMPACTRIFLE`, `WEAPON_MILITARYRIFLE`,
        -- Brokovnice
        `WEAPON_PUMPSHOTGUN`, `WEAPON_SAWNOFFSHOTGUN`, `WEAPON_ASSAULTSHOTGUN`, `WEAPON_BULLPUPSHOTGUN`, 
        `WEAPON_MUSKET`, `WEAPON_HEAVYSHOTGUN`, `WEAPON_DBSHOTGUN`, `WEAPON_AUTOSHOTGUN`,
        -- Odstřelovačky a těžké
        `WEAPON_SNIPERRIFLE`, `WEAPON_HEAVYSNIPER`, `WEAPON_MARKSMANRIFLE`, `WEAPON_COMBATMG`, `WEAPON_MG`
    },
    ["Řezná rána"] = {
        `WEAPON_KNIFE`, `WEAPON_DAGGER`, `WEAPON_MACHETE`, `WEAPON_SWITCHBLADE`, 
        `WEAPON_BATTLEAXE`, `WEAPON_HATCHET`, `WEAPON_STONE_HATCHET`
    }
}

-- Funkce, která zkontroluje, jestli hash patří do našeho seznamu
local function GetInjuryTypeFromHash(hash)
    for category, hashes in pairs(WeaponHashes) do
        for _, weaponHash in ipairs(hashes) do
            if hash == weaponHash then
                return category
            end
        end
    end
    return "Tupé trauma" -- Pokud není v seznamu, je to tupé trauma (pěsti, pád, auto)
end

-- Tabulka koordinátů pro tečky v UI (podle bodyPart)
local BodyCoords = {
    ["Hlava"] = {x = 50, y = 10},
    ["Trup"]  = {x = 50, y = 40},
    ["Ruka"]  = {x = 25, y = 35}, -- Levá/pravá se zde zjednodušuje na stranu
    ["Noha"]  = {x = 45, y = 75}
}

local injuryRequirements = {
    -- Typ zranění            -- Potřebný Item
    ["Povrchová odřenina"]  = "dezinfekce",
    ["Tržná rána"]          = "obvaz",
    ["Hluboká řezná rána"]  = "siti",
    ["Střelná rána"]        = "siti",
    ["Masivní krvácení"]    = "skrtidlo",
    ["Zlomenina končetiny"] = "dlaha",
    ["Popálenina"]          = "gel",
    ["Vnitřní krvácení"]    = "lekarnicka",
    ["Pneumotorax"]         = "lekarnicka" -- (Hrudní drenáž)
}

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        
        -- Detekce poškození pro ŽIVÉHO hráče
        if HasEntityBeenDamagedByAnyPed(ped) then
            local _, bone = GetPedLastDamageBone(ped)
            local cause = GetPedCauseOfDeath(ped)
            local killer = GetEntityKiller(ped)
            local killerWeapon = GetSelectedPedWeapon(killer)
            
            -- Pokud je příčina 0, zkusíme killerWeapon
            local finalHash = (cause ~= 0) and cause or killerWeapon
            ProcessInjury(finalHash, bone)
            
            ClearEntityLastDamageEntity(ped)
        end

        -- SPECIÁLNÍ KONTROLA PŘI SMRTI (pokud je tabulka prázdná)
        if (IsEntityDead(ped) or patientStatus.isUnconscious) and #patientStatus.injuries == 0 then
            local cause = GetPedCauseOfDeath(ped)
            local _, bone = GetPedLastDamageBone(ped)
            
            -- Pokud nás něco zabilo, zapíšeme to hned
            if cause ~= 0 then
                ProcessInjury(cause, bone)
            end
        end

        Wait(500)
    end
end)

-- Univerzální funkce pro zápis zranění
function ProcessInjury(weaponHash, bone)
    local damageType = "Tupé trauma"
    
    if IsWeaponFirearm(weaponHash) then
        damageType = "Střelná rána"
    elseif IsWeaponACuttingWeapon(weaponHash) then
        damageType = "Řezná rána"
    end

    -- Určení kosti
    local bodyPart = "Trup"
    if bone == 31086 or bone == 39317 then bodyPart = "Hlava"
    elseif bone == 18905 or bone == 40269 then bodyPart = "Ruka"
    elseif bone == 52335 or bone == 24806 then bodyPart = "Noha" end

    -- Zápis do tabulky
    local exists = false
    for _, v in ipairs(patientStatus.injuries) do
        if v.type == damageType and v.part == bodyPart then exists = true break end
    end

    if not exists then
        table.insert(patientStatus.injuries, {
            part = bodyPart,
            type = damageType,
            x = BodyCoords[bodyPart].x or 50,
            y = BodyCoords[bodyPart].y or 45,
            neededItem = "obvaz" -- Tady si pak doplň svůj export na itemy
        })
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        
        -- Kontrola, zda hráč utrpěl jakékoliv poškození
        if HasEntityBeenDamagedByAnyPed(ped) or HasEntityBeenDamagedByAnyObject(ped) or IsEntityDead(ped) then
            local _, bone = GetPedLastDamageBone(ped)
            local cause = GetPedCauseOfDeath(ped)
            
            -- 1. ZPRACOVÁNÍ HLAVNÍ PŘÍČINY
            if cause ~= 0 then
                AnalyzeAndAddDamage(cause, bone)
            end

            -- 2. POJISTKA PRO PÁDY (pokud cause selže)
            if IsPedFalling(ped) and GetEntitySpeed(ped) > 10.0 then
                AddInjury("Noha", "Zlomenina končetiny")
                AddInjury("Trup", "Vnitřní krvácení")
            end

            -- Vyčistíme flagy poškození
            ClearEntityLastDamageEntity(ped)
            ResetEntityAlpha(ped)
        end
        Wait(1000) -- Kontrola každou sekundu
    end
end)

-- Funkce, která rozhodne, co se stalo
function AnalyzeAndAddDamage(cause, bone)
    local bodyPart = GetBodyPartFromBone(bone)
    
    -- STŘELBA (Kropka)
    if IsWeaponFirearm(cause) then
        -- Zapíšeme 2-4 rány místo jedné
        local count = math.random(2, 4)
        for i = 1, count do
            local part = (i == 1) and bodyPart or GetRandomBodyPart()
            AddInjury(part, "Střelná rána")
        end
        -- Šance na masivní krvácení při kropce
        if math.random(1, 10) > 7 then AddInjury(bodyPart, "Masivní krvácení") end

    -- VÝBUCHY (Auto, granát)
    elseif IsDamageTypeExplosion(cause) then
        AddInjury("Trup", "Vnitřní krvácení")
        AddInjury("Hlava", "Otřes mozku")
        AddInjury(GetRandomBodyPart(), "Popálenina")
        AddInjury(GetRandomBodyPart(), "Tržná rána")

    -- PÁDY A NÁRAZY AUTEM
    elseif cause == `WEAPON_FALL` or cause == `WEAPON_COUGAR` or cause == `WEAPON_RUN_OVER_BY_CAR` then
        AddInjury(bodyPart, "Zlomenina končetiny")
        AddInjury(GetRandomBodyPart(), "Povrchová odřenina")
        if bodyPart == "Hlava" then AddInjury("Hlava", "Vnitřní krvácení") end

    -- OHEŇ
    elseif cause == `WEAPON_FIRE` or cause == `WEAPON_FLAMETHROWER` or cause == `WEAPON_MOLOTOV` then
        AddInjury(bodyPart, "Popálenina")
        AddInjury(GetRandomBodyPart(), "Popálenina")
    end
end

-- Simulace tepu a krvácení
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            local health = GetEntityHealth(ped)

            if patientStatus.bleedingLevel > 0 then
                SetEntityHealth(ped, health - patientStatus.bleedingLevel)
                patientStatus.pulse = math.min(160, patientStatus.pulse + (patientStatus.bleedingLevel * 2))
                
                if health < 130 and not patientStatus.isUnconscious then
                    patientStatus.isUnconscious = true
                    ESX.ShowNotification("Ztrácíš vědomí kvůli ztrátě krve...")
                end
            else
                if patientStatus.pulse > 80 then
                    patientStatus.pulse = patientStatus.pulse - 1
                end
            end
        end
        Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(4000)
        local ped = PlayerPedId()
        if IsEntityDead(ped) or patientStatus.isUnconscious then
            for _, inj in ipairs(patientStatus.injuries) do
                -- Masivní krvácení zabíjí RYCHLE
                if inj.type == "Masivní krvácení" then
                    patientStatus.pulse = math.min(200, patientStatus.pulse + 5)
                    patientStatus.oxygen = math.max(40, patientStatus.oxygen - 3)
                -- Zlomenina spíše jen stresuje (tep nahoru)
                elseif inj.type == "Zlomenina končetiny" then
                    patientStatus.pulse = math.min(130, patientStatus.pulse + 1)
                -- Pneumotorax (střela do trupu) ničí oxidaci
                elseif inj.type == "Pneumotorax" or (inj.type == "Střelná rána" and inj.part == "Trup") then
                    patientStatus.oxygen = math.max(50, patientStatus.oxygen - 4)
                end
            end
            
            -- Kritický stav - Obrazovka začne šednout
            if patientStatus.oxygen < 75 then
                DoScreenFadeOut(500)
                Wait(500)
                DoScreenFadeIn(500)
            end
        end
    end
end)

-- client/damage_engine.lua

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        -- Simulace běží pouze pokud je hráč v bezvědomí nebo mrtvý
        if IsEntityDead(ped) or patientStatus.isUnconscious then
            local injuryCount = #patientStatus.injuries
            
            if injuryCount > 0 then
                -- Každé zranění zvyšuje stres organismu
                -- Tep náhodně kolísá (simulace nestability)
                local fluctuation = math.random(-2, 5)
                patientStatus.pulse = math.min(190, math.max(40, patientStatus.pulse + fluctuation + (injuryCount * 1)))
                
                -- Oxidace klesá podle vážnosti a vysokého tepu
                if patientStatus.pulse > 150 or injuryCount > 2 then
                    patientStatus.oxygen = math.max(40, patientStatus.oxygen - math.random(1, 2))
                end
            else
                -- Pokud ošetřil všechna traumata, stav se stabilizuje
                if patientStatus.pulse > 72 then patientStatus.pulse = patientStatus.pulse - 2 end
                if patientStatus.oxygen < 98 then patientStatus.oxygen = patientStatus.oxygen + 1 end
            end
            
            -- Pokud tep klesne příliš nízko (pod 40), nastává kritické selhání
            if patientStatus.pulse < 45 then
                patientStatus.oxygen = math.max(0, patientStatus.oxygen - 5)
            end
        end
        Wait(2000) -- Přepočet každé 2 sekundy pro plynulost
    end
end)

-- Export pro tep, který vrací "N/A" pokud hráč není napojen na monitor (volitelné)
exports('getPatientPulse', function()
    if not patientStatus.isUnconscious and not IsEntityDead(PlayerPedId()) then
        return 72 -- Normální tep pro živé lidi
    end
    return patientStatus.pulse
end)

exports('getNeededItemForType', function(type)
    return injuryRequirements[type] or "obvaz"
end)

-- LÉKAŘSKÉ ZÁKROKY (Mazání zranění)
exports('removeInjuryByIndex', function(index)
    if patientStatus.injuries[index] then
        table.remove(patientStatus.injuries, index)
    end
    
    if #patientStatus.injuries == 0 then
        patientStatus.bleedingLevel = 0
        patientStatus.pulse = 72
        patientStatus.isUnconscious = false
    end
    return #patientStatus.injuries
end)

exports('clearAllInjuries', function()
    patientStatus.injuries = {}
    patientStatus.bleedingLevel = 0
    patientStatus.pulse = 72
    patientStatus.isUnconscious = false
    ESX.ShowNotification("~g~Pacient byl kompletně stabilizován.")
end)

-- client/damage_engine.lua

function EnsureDeathInjuries()
    if #patientStatus.injuries == 0 then
        local ped = PlayerPedId()
        local cause = GetPedCauseOfDeath(ped) -- Tohle GTA vrací i dlouho po smrti
        
        local damageType = "Tupé trauma"
        if IsWeaponFirearm(cause) then
            damageType = "Střelná rána"
        elseif IsWeaponACuttingWeapon(cause) then
            damageType = "Řezná rána"
        end

        table.insert(patientStatus.injuries, {
            part = "Trup",
            type = damageType,
            x = 50, y = 45,
            neededItem = "obvaz"
        })
    end
end

exports('getPatientData', function()
    local ped = PlayerPedId()
    
    -- Pokud hráč není v bezvědomí ani mrtvý, vracíme prázdno
    -- (I kdyby měl v kódu nějaká stará zranění, tablet je "neuvidí")
    if not patientStatus.isUnconscious and not IsEntityDead(ped) then
        return {} 
    end

    -- Pokud je mrtvý a tabulka je náhodou prázdná, vygenerujeme aspoň jedno zranění
    if #patientStatus.injuries == 0 then
        EnsureDeathInjuries()
    end

    return patientStatus.injuries
end)

-- Rozšířená detekce (přidej do svého threadu s detekcí poškození)
function GetAdvancedInjury(damageType, bodyPart)
    if damageType == "Střelná rána" then
        if math.random(1, 10) > 7 then return "Masivní krvácení" end
        return "Střelná rána"
    elseif damageType == "Tupé trauma" then
        if bodyPart == "Noha" or bodyPart == "Ruka" then return "Zlomenina končetiny" end
        return "Povrchová odřenina"
    end
    return damageType
end

RegisterNetEvent('esx_ambulancejob:revive') -- Nebo tvůj revive event
AddEventHandler('esx_ambulancejob:revive', function()
    patientStatus.injuries = {}
    patientStatus.pulse = 72
    patientStatus.oxygen = 98
    patientStatus.isUnconscious = false
    patientStatus.bleedingLevel = 0
end)

RegisterNetEvent('skrp_ems_system:requestClientData')
AddEventHandler('skrp_ems_system:requestClientData', function(doctorId)
    -- Vytáhneme naše data
    local data = {
        injuries = patientStatus.injuries,
        pulse = patientStatus.pulse,
        oxygen = patientStatus.oxygen
    }
    -- Pošleme je zpět na server pro doktora
    TriggerServerEvent('skrp_ems_system:respondWithData', doctorId, data)
end)

-- client/damage_engine.lua

-- Pomocná funkce pro náhodné vedlejší zranění
local function AddCollateralDamage()
    local chance = math.random(1, 100)
    local collateralPart = ({"Hlava", "Trup", "Ruka", "Noha"})[math.random(1, 4)]
    
    if chance > 70 then -- 30% šance na odřeninu při pádu/zásahu
        return {
            part = collateralPart,
            type = "Povrchová odřenina",
            neededItem = "dezinfekce"
        }
    elseif chance > 90 then -- 10% šance na zlomeninu, když s ním kulka sekne
        return {
            part = collateralPart,
            type = "Zlomenina končetiny",
            neededItem = "dlaha"
        }
    end
    return nil
end

-- Hlavní funkce pro zpracování zranění
function ProcessInjury(weaponHash, bone)
    local damageType = "Tupé trauma"
    local isBullet = IsWeaponFirearm(weaponHash) -- Používá tvou detekci skupin
    
    if isBullet then
        damageType = "Střelná rána"
    elseif IsWeaponACuttingWeapon(weaponHash) then
        damageType = "Řezná rána"
    end

    -- Určení hlavní kosti
    local bodyPart = "Trup"
    if bone == 31086 or bone == 39317 then bodyPart = "Hlava"
    elseif bone == 18905 or bone == 40269 then bodyPart = "Ruka"
    elseif bone == 52335 or bone == 24806 then bodyPart = "Noha" end

    -- Šance na kritické stavy u střelby
    if damageType == "Střelná rána" then
        local rng = math.random(1, 10)
        if bodyPart == "Trup" and rng > 7 then damageType = "Pneumotorax"
        elseif rng > 8 then damageType = "Masivní krvácení" end
    end

    -- 1. ZÁPIS HLAVNÍHO ZRANĚNÍ
    table.insert(patientStatus.injuries, {
        part = bodyPart,
        type = damageType,
        x = BodyCoords[bodyPart].x or 50,
        y = BodyCoords[bodyPart].y or 45,
        neededItem = injuryRequirements[damageType] or "obvaz"
    })

    -- 2. GENEROVÁNÍ VÍCE RAN (pokud je to kropka)
    if isBullet then
        -- Přidáme 1-2 další náhodné rány (simulace dávky ze samopalu)
        for i = 1, math.random(1, 2) do
            local extraPart = ({"Hlava", "Trup", "Ruka", "Noha"})[math.random(1, 4)]
            local extraType = "Střelná rána"
            
            -- Pojistka, aby nebylo všechno jen "střelná rána"
            local collateral = AddCollateralDamage()
            if collateral then
                table.insert(patientStatus.injuries, {
                    part = collateral.part,
                    type = collateral.type,
                    x = BodyCoords[collateral.part].x,
                    y = BodyCoords[collateral.part].y,
                    neededItem = collateral.neededItem
                })
            else
                table.insert(patientStatus.injuries, {
                    part = extraPart,
                    type = extraType,
                    x = BodyCoords[extraPart].x,
                    y = BodyCoords[extraPart].y,
                    neededItem = "siti"
                })
            end
        end
    end
end

-- Přidá zranění do tabulky (s kontrolou duplicit a limitu)
function AddInjury(part, type)
    -- Limit 10 zranění na pacienta
    if #patientStatus.injuries >= 10 then return end

    table.insert(patientStatus.injuries, {
        part = part,
        type = type,
        x = BodyCoords[part].x,
        y = BodyCoords[part].y,
        neededItem = injuryRequirements[type] or "obvaz"
    })
end

-- Pomocník pro detekci výbuchu
function IsDamageTypeExplosion(cause)
    local explosions = {`WEAPON_EXPLOSION`, `WEAPON_GRENADE`, `WEAPON_STICKYBOMB`, `WEAPON_VEHICLE_ROCKET`}
    for _, hash in ipairs(explosions) do
        if cause == hash then return true end
    end
    return false
end

-- Náhodná část těla pro "vedlejší" rány
function GetRandomBodyPart()
    local parts = {"Hlava", "Trup", "Ruka", "Noha"}
    return parts[math.random(1, #parts)]
end

-- Převod kostí na naše názvy
function GetBodyPartFromBone(bone)
    if bone == 31086 or bone == 39317 then return "Hlava"
    elseif bone == 18905 or bone == 40269 or bone == 57005 then return "Ruka"
    elseif bone == 52335 or bone == 24806 or bone == 23643 then return "Noha"
    else return "Trup" end
end