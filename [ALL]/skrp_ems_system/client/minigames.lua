-- client/minigame_surgery.lua
function StartSurgeryGame(targetId)
    local nodes = {0.2, 0.4, 0.6, 0.8} -- Body, které musí záchranář "prošít"
    local currentNode = 1
    local active = true

    print("OPERACE: Prošijte ránu v označených bodech!")

    Citizen.CreateThread(function()
        while active do
            -- Zobrazení bodu na obrazovce (v NUI by to byla grafika rány)
            DrawMarker(1, 0.5, nodes[currentNode], 0.8, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, 255, 0, 0, 200)
            
            if IsControlJustPressed(0, 18) then -- Levý klik
                -- Logika pro trefení bodu myší
                currentNode = currentNode + 1
                PlaySoundFrontend(-1, "Short_Transition_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
            end

            if currentNode > #nodes then
                active = false
                TriggerServerEvent('ems_script:completeSurgery', targetId)
                print("Rána byla úspěšně zašita.")
            end
            Wait(0)
        end
    end)
end

exports('StartMedicalSkillcheck', function(difficulty, cb)
    -- Tady bude tvoje minihra (např. ox_lib, ps-ui, nebo vlastní)
    -- Difficulty můžeš použít pro rychlost kolečka
    local success = exports.ox_lib:skillCheck({difficulty, difficulty}, {'w', 'a', 's', 'd'}) 
    
    cb(success) -- Vrátí true nebo false do ems_main
end)