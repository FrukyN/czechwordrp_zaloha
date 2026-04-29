-- 3D Text nad markery
function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Kontrola zbraní
function Airsoft:HasArenaWeapon()
    local ped = PlayerPedId()
    local _, currentWep = GetCurrentPedWeapon(ped, true)
    if currentWep == `WEAPON_UNARMED` then return true end
    return Config.Weapons[currentWep] ~= nil
end