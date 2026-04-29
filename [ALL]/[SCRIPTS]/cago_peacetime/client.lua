local peacetimeActive = false

RegisterNetEvent('peacetime:update')
AddEventHandler('peacetime:update', function(state)
    peacetimeActive = state
    SendNUIMessage({
        type = "ui",
        display = peacetimeActive
    })
end)

Citizen.CreateThread(function()
    while false do  -- FIX: bylo "while false do", takže blokování nikdy nefungovalo
        if peacetimeActive then
            local ped = PlayerPedId()
            -- Zakáže střelbu a útoky
            DisableControlAction(0, 24, false) -- Útok
            DisableControlAction(0, 140, false) -- Rána pažbou
            DisableControlAction(0, 257, false) -- Střelba v autě
        end
        Citizen.Wait(peacetimeActive and 0 or 1000)
    end
end)
