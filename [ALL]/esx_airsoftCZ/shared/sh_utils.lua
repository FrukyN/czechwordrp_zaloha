-- shared/sh_utils.lua
Utils = {}

-- Formátování času z vteřin na MM:SS
function Utils.FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

-- Debug print, který se zobrazí jen když je v configu Config.Debug = true
function Utils.Debug(msg)
    if Config.Debug then
        print("[AIRSOFT DEBUG] " .. tostring(msg))
    end
end