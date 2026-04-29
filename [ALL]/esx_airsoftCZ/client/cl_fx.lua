-- Převlékání do Airsoft dresů
function Airsoft:ApplyUniform(clothing)
    local ped = PlayerPedId()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, clothing.male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, clothing.female)
        end
    end)
end

-- Efekt zásahu (Red flash)
function Airsoft:PlayHitEffect()
    StartScreenEffect("DeathFailMPIn", 200, false)
    PlaySoundFrontend(-1, "HACK_FAILED", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end

-- Plynulý přechod obrazovky
function Airsoft:ScreenTransition()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    Wait(500)
    DoScreenFadeIn(500)
end