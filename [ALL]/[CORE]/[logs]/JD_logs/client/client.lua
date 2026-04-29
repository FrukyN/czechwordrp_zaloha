-- Hashované klíče pro bleskově rychlé vyhledávání namísto stringů
local WeaponNames = {
    [GetHashKey('WEAPON_UNARMED')] = 'Unarmed',
    [GetHashKey('GADGET_PARACHUTE')] = 'Parachute',
    [GetHashKey('WEAPON_KNIFE')] = 'Knife',
    [GetHashKey('WEAPON_NIGHTSTICK')] = 'Nightstick',
    [GetHashKey('WEAPON_HAMMER')] = 'Hammer',
    [GetHashKey('WEAPON_BAT')] = 'Baseball Bat',
    [GetHashKey('WEAPON_CROWBAR')] = 'Crowbar',
    [GetHashKey('WEAPON_GOLFCLUB')] = 'Golf Club',
    [GetHashKey('WEAPON_BOTTLE')] = 'Bottle',
    [GetHashKey('WEAPON_DAGGER')] = 'Antique Cavalry Dagger',
    [GetHashKey('WEAPON_HATCHET')] = 'Hatchet',
    [GetHashKey('WEAPON_KNUCKLE')] = 'Knuckle Duster',
    [GetHashKey('WEAPON_MACHETE')] = 'Machete',
    [GetHashKey('WEAPON_FLASHLIGHT')] = 'Flashlight',
    [GetHashKey('WEAPON_SWITCHBLADE')] = 'Switchblade',
    [GetHashKey('WEAPON_BATTLEAXE')] = 'Battleaxe',
    [GetHashKey('WEAPON_POOLCUE')] = 'Poolcue',
    [GetHashKey('WEAPON_PIPEWRENCH')] = 'Wrench',
    [GetHashKey('WEAPON_STONE_HATCHET')] = 'Stone Hatchet',
    [GetHashKey('WEAPON_PISTOL')] = 'Pistol',
    [GetHashKey('WEAPON_PISTOL_MK2')] = 'Pistol Mk2',
    [GetHashKey('WEAPON_COMBATPISTOL')] = 'Combat Pistol',
    [GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
    [GetHashKey('WEAPON_SNSPISTOL')] = 'SNS Pistol',
    [GetHashKey('WEAPON_SNSPISTOL_MK2')] = 'SNS Pistol Mk2',
    [GetHashKey('WEAPON_HEAVYPISTOL')] = 'Heavy Pistol',
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage Pistol',
    [GetHashKey('WEAPON_MARKSMANPISTOL')] = 'Marksman Pistol',
    [GetHashKey('WEAPON_REVOLVER')] = 'Heavy Revolver',
    [GetHashKey('WEAPON_REVOLVER_MK2')] = 'Heavy Revolver Mk2',
    [GetHashKey('WEAPON_DOUBLEACTION')] = 'Double-Action Revolver',
    [GetHashKey('WEAPON_APPISTOL')] = 'AP Pistol',
    [GetHashKey('WEAPON_STUNGUN')] = 'Stun Gun',
    [GetHashKey('WEAPON_FLAREGUN')] = 'Flare Gun',
    [GetHashKey('WEAPON_RAYPISTOL')] = 'Up-n-Atomizer',
    [GetHashKey('WEAPON_MICROSMG')] = 'Micro SMG',
    [GetHashKey('WEAPON_MACHINEPISTOL')] = 'Machine Pistol',
    [GetHashKey('WEAPON_MINISMG')] = 'Mini SMG',
    [GetHashKey('WEAPON_SMG')] = 'SMG',
    [GetHashKey('WEAPON_SMG_MK2')] = 'SMG Mk2',
    [GetHashKey('WEAPON_ASSAULTSMG')] = 'Assault SMG',
    [GetHashKey('WEAPON_COMBATPDW')] = 'Combat PDW',
    [GetHashKey('WEAPON_MG')] = 'MG',
    [GetHashKey('WEAPON_COMBATMG')] = 'Combat MG',
    [GetHashKey('WEAPON_COMBATMG_MK2')] = 'Combat MG Mk2',
    [GetHashKey('WEAPON_GUSENBERG')] = 'Gusenberg Sweeper',
    [GetHashKey('WEAPON_RAYCARBINE')] = 'Unholy Deathbringer',
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = 'Assault Rifle',
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 'Assault Rifle Mk2',
    [GetHashKey('WEAPON_CARBINERIFLE')] = 'Carbine Rifle',
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 'Carbine Rifle Mk2',
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = 'Advanced Rifle',
    [GetHashKey('WEAPON_SPECIALCARBINE')] = 'Special Carbine',
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 'Special Carbine Mk2',
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = 'Bullpup Rifle',
    [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 'Bullpup Rifle Mk2',
    [GetHashKey('WEAPON_COMPACTRIFLE')] = 'Compact Rifle',
    [GetHashKey('WEAPON_SNIPERRIFLE')] = 'Sniper Rifle',
    [GetHashKey('WEAPON_HEAVYSNIPER')] = 'Heavy Sniper',
    [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 'Heavy Sniper Mk2',
    [GetHashKey('WEAPON_MARKSMANRIFLE')] = 'Marksman Rifle',
    [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 'Marksman Rifle Mk2',
    [GetHashKey('WEAPON_GRENADE')] = 'Grenade',
    [GetHashKey('WEAPON_STICKYBOMB')] = 'Sticky Bomb',
    [GetHashKey('WEAPON_PROXMINE')] = 'Proximity Mine',
    [GetHashKey('WAPAON_PIPEBOMB')] = 'Pipe Bomb',
    [GetHashKey('WEAPON_SMOKEGRENADE')] = 'Tear Gas',
    [GetHashKey('WEAPON_BZGAS')] = 'BZ Gas',
    [GetHashKey('WEAPON_MOLOTOV')] = 'Molotov',
    [GetHashKey('WEAPON_FIREEXTINGUISHER')] = 'Fire Extinguisher',
    [GetHashKey('WEAPON_PETROLCAN')] = 'Jerry Can',
    [GetHashKey('WEAPON_BALL')] = 'Ball',
    [GetHashKey('WEAPON_SNOWBALL')] = 'Snowball',
    [GetHashKey('WEAPON_FLARE')] = 'Flare',
    [GetHashKey('WEAPON_GRENADELAUNCHER')] = 'Grenade Launcher',
    [GetHashKey('WEAPON_RPG')] = 'RPG',
    [GetHashKey('WEAPON_MINIGUN')] = 'Minigun',
    [GetHashKey('WEAPON_FIREWORK')] = 'Firework Launcher',
    [GetHashKey('WEAPON_RAILGUN')] = 'Railgun',
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = 'Homing Launcher',
    [GetHashKey('WEAPON_COMPACTLAUNCHER')] = 'Compact Grenade Launcher',
    [GetHashKey('WEAPON_RAYMINIGUN')] = 'Widowmaker',
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pump Shotgun',
    [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 'Pump Shotgun Mk2',
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 'Sawed-off Shotgun',
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 'Bullpup Shotgun',
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 'Assault Shotgun',
    [GetHashKey('WEAPON_MUSKET')] = 'Musket',
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = 'Heavy Shotgun',
    [GetHashKey('WEAPON_DBSHOTGUN')] = 'Double Barrel Shotgun',
    [GetHashKey('WEAPON_SWEEPERSHOTGUN')] = 'Sweeper Shotgun',
    [GetHashKey('WEAPON_REMOTESNIPER')] = 'Remote Sniper',
    [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = 'Smoke Grenade Launcher',
    [GetHashKey('WEAPON_PASSENGER_ROCKET')] = 'Passenger Rocket',
    [GetHashKey('WEAPON_AIRSTRIKE_ROCKET')] = 'Airstrike Rocket',
    [GetHashKey('WEAPON_STINGER')] = 'Stinger [Vehicle]',
    [GetHashKey('OBJECT')] = 'Object',
    [GetHashKey('VEHICLE_WEAPON_TANK')] = 'Tank Cannon',
    [GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET')] = 'Rockets',
    [GetHashKey('VEHICLE_WEAPON_PLAYER_LASER')] = 'Laser',
    [GetHashKey('AMMO_RPG')] = 'Rocket',
    [GetHashKey('AMMO_TANK')] = 'Tank',
    [GetHashKey('AMMO_SPACE_ROCKET')] = 'Rocket',
    [GetHashKey('AMMO_PLAYER_LASER')] = 'Laser',
    [GetHashKey('AMMO_ENEMY_LASER')] = 'Laser',
    [GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Rammed by Car',
    [GetHashKey('WEAPON_FIRE')] = 'Fire',
    [GetHashKey('WEAPON_HELI_CRASH')] = 'Heli Crash',
    [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Run over by Car',
    [GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Hit by Water Cannon',
    [GetHashKey('WEAPON_EXHAUSTION')] = 'Exhaustion',
    [GetHashKey('WEAPON_EXPLOSION')] = 'Explosion',
    [GetHashKey('WEAPON_ELECTRIC_FENCE')] = 'Electric Fence',
    [GetHashKey('WEAPON_BLEEDING')] = 'Bleeding',
    [GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowning in Vehicle',
    [GetHashKey('WEAPON_DROWNING')] = 'Drowning',
    [GetHashKey('WEAPON_BARBED_WIRE')] = 'Barbed Wire',
    [GetHashKey('WEAPON_VEHICLE_ROCKET')] = 'Vehicle Rocket',
    [GetHashKey('VEHICLE_WEAPON_ROTORS')] = 'Rotors',
    [GetHashKey('WEAPON_AIR_DEFENCE_GUN')] = 'Air Defence Gun',
    [GetHashKey('WEAPON_ANIMAL')] = 'Animal',
    [GetHashKey('WEAPON_COUGAR')] = 'Cougar'
}

-- O(1) hash mapa pro zjistění důvodu smrti namísto původních náročných funkcí
local WeaponReasons = {}
local function MapReasons(reason, weapons)
    for _, w in ipairs(weapons) do
        WeaponReasons[GetHashKey(w)] = reason
    end
end

MapReasons('murdered', {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'})
MapReasons('torched', {'WEAPON_MOLOTOV'})
MapReasons('knifed', {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'})
MapReasons('pistoled', {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'})
MapReasons('riddled', {'WEAPON_MICROSMG', 'WEAPON_SMG'})
MapReasons('rifled', {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'})
MapReasons('machine gunned', {'WEAPON_MG', 'WEAPON_COMBATMG'})
MapReasons('pulverized', {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'})
MapReasons('sniped', {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'})
MapReasons('obliterated', {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'})
MapReasons('shredded', {'WEAPON_MINIGUN'})
MapReasons('bombed', {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'})
MapReasons('mowed over', {'VEHICLE_WEAPON_ROTORS'})
MapReasons('flattened', {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'})


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50) -- Wait(50) je pro check smrti dostačující
        local ped = PlayerPedId()

        if IsEntityDead(ped) then
            local PedKiller = GetPedSourceOfDeath(ped)
            local DeathCauseHash = GetPedCauseOfDeath(ped)
            local Weapon = WeaponNames[DeathCauseHash] or 'Unknown'
            local Killer = nil

            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) then
                local driver = GetPedInVehicleSeat(PedKiller, -1)
                if IsEntityAPed(driver) and IsPedAPlayer(driver) then
                    Killer = NetworkGetPlayerIndexFromPed(driver)
                end
            end

            local DeathReason = 'died'
            if Killer == PlayerId() then
                DeathReason = 'committed suicide'
            elseif Killer ~= nil then
                DeathReason = WeaponReasons[DeathCauseHash] or 'killed'
            end

            if DeathReason == 'committed suicide' or DeathReason == 'died' then
                TriggerServerEvent('playerDied', 1, PlayerId(), nil, DeathReason, Weapon)
            else
                TriggerServerEvent('playerDied', 2, PlayerId(), GetPlayerServerId(Killer), DeathReason, Weapon)
            end

            -- Zatímco je hráč mrtvý, není nutné ověřovat smrt každých 50ms, čekáme 500ms
            while IsEntityDead(PlayerPedId()) do
                Citizen.Wait(500)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20) -- 0ms pro střelbu je zbytečné zahlcování, 20ms je responsivní
        local playerped = PlayerPedId()

        if IsPedShooting(playerped) then
            local weaponHash = GetSelectedPedWeapon(playerped)
            TriggerServerEvent('playerShotWeapon', WeaponNames[weaponHash] or "Unknown")
            Citizen.Wait(1000) -- cooldown proti spamu logů střelby
        end
    end
end)

exports('discord', function(message, id, id2, color, channel)
    TriggerServerEvent('ClientDiscord', message, id, id2, color, channel)
end)

function ShowDebug(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName("~b~JD_logs Debug:~s~\n"..text)
    DrawNotification(true, true)
end