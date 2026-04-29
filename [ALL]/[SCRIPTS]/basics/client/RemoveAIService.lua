-- gangy uklidnit

local relationshipTypes = {
	`GANG_1`, `GANG_2`, `GANG_9`, `GANG_10`,
	`AMBIENT_GANG_LOST`, `AMBIENT_GANG_MEXICAN`, `AMBIENT_GANG_FAMILY`,
	`AMBIENT_GANG_BALLAS`, `AMBIENT_GANG_MARABUNTE`, `AMBIENT_GANG_CULT`,
	`AMBIENT_GANG_SALVA`, `AMBIENT_GANG_WEICHENG`, `AMBIENT_GANG_HILLBILLY`,
	`DEALER`, `COP`, `PRIVATE_SECURITY`, `SECURITY_GUARD`, `ARMY`,
	`MEDIC`, `FIREMAN`, `HATES_PLAYER`, `NO_RELATIONSHIP`,
	`SPECIAL`, `MISSION2`, `MISSION3`, `MISSION4`,
	`MISSION5`, `MISSION6`, `MISSION7`, `MISSION8`
}

CreateThread(function()
	for _, relationship in ipairs(relationshipTypes) do
		SetRelationshipBetweenGroups(1, relationship, `PLAYER`)
		SetRelationshipBetweenGroups(1, `PLAYER`, relationship)
	end
end)




-- Konfigurace pro ClearArea (přesunuto z cleararea.lua)
local clearAreasConfig = {
    -- {coords = vec3(125.51, -1286.41, 29.28), radius = 25.0}, 
}

-- Základní nastavení světa (spustí se jednou)
CreateThread(function()
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("PoliceScannerDisabled", true)
    SetGarbageTrucks(false)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)
    DistantCopCarSirens(false)
    
    for i = 0, 15 do
        EnableDispatchService(i, false)
    end
end)

-- Loop pro promazávání oblastí a AI (každých 500ms)
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Promazávání generátorů aut v okolí PD
        RemoveVehiclesFromGeneratorsInArea(335.26 - 300.0, -1432.45 - 300.0, 46.51 - 300.0, 335.26 + 300.0, -1432.45 + 300.0, 46.51 + 300.0)
        
        -- ClearArea z původního cleararea.lua
        for _, v in pairs(clearAreasConfig) do
            if #(playerCoords - v.coords) < (v.radius + 50.0) then 
                ClearAreaOfVehicles(v.coords, v.radius, false, false, false, false, false)
                ClearAreaOfPeds(v.coords, v.radius, 1)
            end
        end

        -- Základní čištění pedů
        ClearAreaOfCops(playerCoords.x, playerCoords.y, playerCoords.z, 200.0, 0)
        SetPedConfigFlag(playerPed, 35, false)
        DisablePlayerVehicleRewards(PlayerId())
        
        Wait(500)
    end
end)

-- Loop pro zakázání MLÁCENÍ PAŽBOU (Pazba.lua optimalizace)
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        -- Běží pouze pokud má hráč zbraň a míří/útočí (ušetří MS)
        if IsPedArmed(playerPed, 4) then 
            -- Zakáže údery pažbou (R v GTA)
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Loop pro potlačení modelů a zbraní (každou 1s)
CreateThread(function()
    local SUPPRESSED_MODELS = { "JET", "LAZER", "TITAN", "BARRACKS", "BARRACKS2", "CRUSADER", "RHINO", "BLIMP" }
    while true do
        for i=1, #SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(GetHashKey(SUPPRESSED_MODELS[i]), true)
        end

        local handle, ped = FindFirstPed()
        local finished = false
        repeat
            if not IsEntityDead(ped) then SetPedDropsWeaponsWhenDead(ped, false) end
            finished, ped = FindNextPed(handle)
        until not finished
        EndFindPed(handle)

        RemoveAllPickupsOfType(`PICKUP_WEAPON_GolfClub`)
        RemoveAllPickupsOfType(`PICKUP_WEAPON_CARBINERIFLE`)
        RemoveAllPickupsOfType(`PICKUP_WEAPON_PISTOL`)
        
        SetForcePedFootstepsTracks(false)
        SetForceVehicleTrails(false)
        Wait(1000)
    end
end)