ESX = exports["es_extended"]:getSharedObject()

local warnings = { hunger = false, thirst = false }

local function sendWarning(title, description, icon, iconColor)
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    lib.notify({
        title = title,
        description = description,
        type = 'inform',
        duration = 15000,
        icon = icon,
        iconColor = iconColor
    })
end

CreateThread(function()
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(hungerStatus)
            if hungerStatus.val < 300000 and not warnings.hunger then
                sendWarning('Máš hlad', 'Měl by ses najíst, nebo upadneš do bezvědomí!', 'burger', '#f09e67')
                warnings.hunger = true
            elseif hungerStatus.val >= 300000 then
                warnings.hunger = false
            end
        end)

        TriggerEvent('esx_status:getStatus', 'thirst', function(thirstStatus)
            if thirstStatus.val < 300000 and not warnings.thirst then
                sendWarning('Máš žízeň', 'Měl by ses napít, nebo upadneš do bezvědomí!', 'glass-water', '#6795f0')
                warnings.thirst = true
            elseif thirstStatus.val >= 300000 then
                warnings.thirst = false
            end
        end)
        Wait(4000) 
    end
end)