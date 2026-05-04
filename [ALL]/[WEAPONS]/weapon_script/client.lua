local shakeConfig = {
    ["WEAPON_STUNGUN"] = 0.0, ["WEAPON_FLAREGUN"] = 0.1, ["WEAPON_SNSPISTOL"] = 0.05,
    ["WEAPON_SNSPISTOL_MK2"] = 0.1, ["WEAPON_PISTOL"] = 0.05, ["WEAPON_PISTOL_MK2"] = 0.1,
    ["WEAPON_APPISTOL"] = 0.1, ["WEAPON_COMBATPISTOL"] = 0.04, ["WEAPON_PISTOL50"] = 0.1,
    ["WEAPON_HEAVYPISTOL"] = 0.1, ["WEAPON_VINTAGEPISTOL"] = 0.15, ["WEAPON_MARKSMANPISTOL"] = 0.1,
    ["WEAPON_REVOLVER"] = 0.3, ["WEAPON_REVOLVER_MK2"] = 0.25, ["WEAPON_DOUBLEACTION"] = 0.15,
    ["WEAPON_MICROSMG"] = 0.019, ["WEAPON_COMBATPDW"] = 0.019, ["WEAPON_SMG"] = 0.019,
    ["WEAPON_SMG_MK2"] = 0.019, ["WEAPON_ASSAULTSMG"] = 0.019, ["WEAPON_MACHINEPISTOL"] = 0.019,
    ["WEAPON_MINISMG"] = 0.019, ["WEAPON_MG"] = 0.019, ["WEAPON_COMBATMG"] = 0.019,
    ["WEAPON_COMBATMG_MK2"] = 0.019, ["WEAPON_ASSAULTRIFLE"] = 0.018, ["WEAPON_ASSAULTRIFLE_MK2"] = 0.018,
    ["WEAPON_CARBINERIFLE"] = 0.018, ["WEAPON_CARBINERIFLE_MK2"] = 0.018, ["WEAPON_ADVANCEDRIFLE"] = 0.018,
    ["WEAPON_GUSENBERG"] = 0.018, ["WEAPON_SPECIALCARBINE"] = 0.018, ["WEAPON_SPECIALCARBINE_MK2"] = 0.018,
    ["WEAPON_BULLPUPRIFLE"] = 0.018, ["WEAPON_BULLPUPRIFLE_MK2"] = 0.018, ["WEAPON_COMPACTRIFLE"] = 0.018,
    ["WEAPON_PUMPSHOTGUN"] = 0.3, ["WEAPON_PUMPSHOTGUN_MK2"] = 0.3, ["WEAPON_SAWNOFFSHOTGUN"] = 0.3,
    ["WEAPON_ASSAULTSHOTGUN"] = 0.3, ["WEAPON_BULLPUPSHOTGUN"] = 0.3, ["WEAPON_DBSHOTGUN"] = 0.3,
    ["WEAPON_AUTOSHOTGUN"] = 0.3, ["WEAPON_MUSKET"] = 0.3, ["WEAPON_HEAVYSHOTGUN"] = 0.3,
    ["WEAPON_SNIPERRIFLE"] = 0.2, ["WEAPON_HEAVYSNIPER"] = 0.3, ["WEAPON_HEAVYSNIPER_MK2"] = 0.35,
    ["WEAPON_MARKSMANRIFLE"] = 0.1, ["WEAPON_MARKSMANRIFLE_MK2"] = 0.1, ["WEAPON_GRENADELAUNCHER"] = 0.8,
    ["WEAPON_RPG"] = 0.9, ["WEAPON_HOMINGLAUNCHER"] = 0.9, ["WEAPON_MINIGUN"] = 0.20,
    ["WEAPON_RAILGUN"] = 1.0, ["WEAPON_COMPACTLAUNCHER"] = 0.8, ["WEAPON_FIREWORK"] = 0.5
}

local recoilConfig = {
    ["WEAPON_PISTOL"] = 0.3, ["WEAPON_PISTOL_MK2"] = 0.3, ["WEAPON_COMBATPISTOL"] = 0.2,
    ["WEAPON_APPISTOL"] = 0.1, ["WEAPON_PISTOL50"] = 0.6, ["WEAPON_MICROSMG"] = 0.2,
    ["WEAPON_SMG"] = 0.1, ["WEAPON_SMG_MK2"] = 0.1, ["WEAPON_ASSAULTSMG"] = 0.1,
    ["WEAPON_ASSAULTRIFLE"] = 0.2, ["WEAPON_ASSAULTRIFLE_MK2"] = 0.2, ["WEAPON_CARBINERIFLE"] = 0.1,
    ["WEAPON_CARBINERIFLE_MK2"] = 0.1, ["WEAPON_ADVANCEDRIFLE"] = 0.1, ["WEAPON_MG"] = 0.1,
    ["WEAPON_COMBATMG"] = 0.1, ["WEAPON_COMBATMG_MK2"] = 0.1, ["WEAPON_PUMPSHOTGUN"] = 0.4,
    ["WEAPON_PUMPSHOTGUN_MK2"] = 0.4, ["WEAPON_SAWNOFFSHOTGUN"] = 0.7, ["WEAPON_ASSAULTSHOTGUN"] = 0.4,
    ["WEAPON_BULLPUPSHOTGUN"] = 0.2, ["WEAPON_STUNGUN"] = 0.1, ["WEAPON_SNIPERRIFLE"] = 0.5,
    ["WEAPON_HEAVYSNIPER"] = 0.7, ["WEAPON_HEAVYSNIPER_MK2"] = 0.7, ["WEAPON_REMOTESNIPER"] = 1.2,
    ["WEAPON_GRENADELAUNCHER"] = 1.0, ["WEAPON_GRENADELAUNCHER_SMOKE"] = 1.0, ["WEAPON_RPG"] = 0.0,
    ["WEAPON_STINGER"] = 0.0, ["WEAPON_MINIGUN"] = 0.1, ["WEAPON_SNSPISTOL"] = 0.2,
    ["WEAPON_SNSPISTOL_MK2"] = 0.25, ["WEAPON_GUSENBERG"] = 0.1, ["WEAPON_SPECIALCARBINE"] = 0.2,
    ["WEAPON_SPECIALCARBINE_MK2"] = 0.25, ["WEAPON_HEAVYPISTOL"] = 0.5, ["WEAPON_BULLPUPRIFLE"] = 0.2,
    ["WEAPON_BULLPUPRIFLE_MK2"] = 0.25, ["WEAPON_VINTAGEPISTOL"] = 0.4, ["WEAPON_DOUBLEACTION"] = 0.4,
    ["WEAPON_MUSKET"] = 0.7, ["WEAPON_HEAVYSHOTGUN"] = 0.2, ["WEAPON_MARKSMANRIFLE"] = 0.3,
    ["WEAPON_MARKSMANRIFLE_MK2"] = 0.35, ["WEAPON_HOMINGLAUNCHER"] = 0, ["WEAPON_FLAREGUN"] = 0.9,
    ["WEAPON_COMBATPDW"] = 0.2, ["WEAPON_MARKSMANPISTOL"] = 0.9, ["WEAPON_RAILGUN"] = 2.4,
    ["WEAPON_MACHINEPISTOL"] = 0.3, ["WEAPON_REVOLVER"] = 0.6, ["WEAPON_REVOLVER_MK2"] = 0.65,
    ["WEAPON_DBSHOTGUN"] = 0.7, ["WEAPON_COMPACTRIFLE"] = 0.3, ["WEAPON_AUTOSHOTGUN"] = 0.2,
    ["WEAPON_COMPACTLAUNCHER"] = 0.5, ["WEAPON_MINISMG"] = 0.1
}

local activeShakes = {}
local activeRecoils = {}
local extinguisherHash = GetHashKey("WEAPON_FIREEXTINGUISHER")

local _Wait = Citizen.Wait
local _PlayerPedId = PlayerPedId
local _DisplayAmmoThisFrame = DisplayAmmoThisFrame
local _IsPedArmed = IsPedArmed
local _DisableControlAction = DisableControlAction
local _IsPedShooting = IsPedShooting
local _GetSelectedPedWeapon = GetSelectedPedWeapon
local _SetPedInfiniteAmmo = SetPedInfiniteAmmo
local _ShakeGameplayCam = ShakeGameplayCam
local _IsPedDoingDriveby = IsPedDoingDriveby
local _GetGameplayCamRelativePitch = GetGameplayCamRelativePitch
local _GetFollowPedCamViewMode = GetFollowPedCamViewMode
local _SetGameplayCamRelativePitch = SetGameplayCamRelativePitch

Citizen.CreateThread(function()
    -- Převod textových názvů na Hashe. Provede se jen JEDNOU.
    for wep, val in pairs(shakeConfig) do activeShakes[GetHashKey(wep)] = val end
    for wep, val in pairs(recoilConfig) do activeRecoils[GetHashKey(wep)] = val end

    local targetRecoil = 0.0
    local currentRecoil = 0.0

    while true do
        _Wait(0)
        local ped = _PlayerPedId()

        -- Vypnutí HUDu (musí běžet každý snímek, ale cachovaná nativka to zrychlí)
        _DisplayAmmoThisFrame(false)

        -- Kód uvnitř se spustí JEN pokud máš v ruce střelnou zbraň (kód 6 ignoruje pěsti a nože)
        if _IsPedArmed(ped, 6) then
            _DisableControlAction(1, 140, true)
            _DisableControlAction(1, 141, true)
            _DisableControlAction(1, 142, true)

            -- Tento blok se zpracuje POUZE v milisekundě, kdy vystřelíš
            if _IsPedShooting(ped) then
                local weapon = _GetSelectedPedWeapon(ped)

                if weapon == extinguisherHash then
                    _SetPedInfiniteAmmo(ped, true, extinguisherHash)
                else
                    local shakeVal = activeShakes[weapon]
                    if shakeVal then
                        _ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeVal)
                    end

                    if not _IsPedDoingDriveby(ped) then
                        local recoilVal = activeRecoils[weapon]
                        if recoilVal then
                            targetRecoil = targetRecoil + recoilVal
                        end
                    end
                end
            end
        end

        -- Aplikace plynulého zpětného rázu
        if targetRecoil > 0.0 then
            local pitch = _GetGameplayCamRelativePitch()
            
            if _GetFollowPedCamViewMode() ~= 4 then -- Pokud není hráč ve First Person pohledu
                _SetGameplayCamRelativePitch(pitch + 0.1, 0.2)
            end
            
            currentRecoil = currentRecoil + 0.1
            
            -- Pojistka pro float čísla v Lua (odečteme 0.01 pro přesnost shody)
            if currentRecoil >= targetRecoil - 0.01 then
                targetRecoil = 0.0
                currentRecoil = 0.0
            end
        end
    end
end)