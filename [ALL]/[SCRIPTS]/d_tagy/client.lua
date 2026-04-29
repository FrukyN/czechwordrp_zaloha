local adminPlayers = {}

function GetPulseAlpha()
    return math.floor(math.sin(GetGameTimer() / 500) * 27 + 227) 
end

function DrawAdminTag(coords, role, statusText, color)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + 0.95) 
    local dist = #(GetGameplayCamCoords() - coords)
    
    local scale = (1 / dist) * 1.3 * (1 / GetGameplayCamFov()) * 100
    local pulse = GetPulseAlpha()

    if onScreen then
        -- 1. POZADÍ (Uděláme ho trochu širší pro jistotu)
        local roleLength = string.len(role)
        local bgWidth = 0.014 * roleLength * scale
        if bgWidth < 0.05 * scale then bgWidth = 0.05 * scale end 
        DrawRect(_x, _y + 0.015 * scale, bgWidth, 0.042 * scale, 0, 0, 0, 160)

        -- 2. HLAVNÍ TEXT ROLE
        SetTextScale(0.0, 0.45 * scale)
        SetTextFont(0) -- Standardní font
        SetTextColour(color.r, color.g, color.b, pulse)
        SetTextOutline()
        SetTextCentre(1)
        
        -- Fix pro diakritiku (použití formátovaného vstupu)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(role) -- Tato funkce lépe zvládá UTF-8 znaky
        EndTextCommandDisplayText(_x, _y)

        -- 3. UPOZORNĚNÍ (Status Text)
        SetTextScale(0.0, 0.28 * scale) 
        SetTextFont(0)
        SetTextColour(255, 50, 50, 255) 
        SetTextOutline()
        SetTextCentre(1)
        
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString("!! " .. statusText .. " !!")
        EndTextCommandDisplayText(_x, _y + 0.042 * scale)
    end
end

-- Synchronizace dat
RegisterNetEvent('esx_adminTags:sync')
AddEventHandler('esx_adminTags:sync', function(data)
    adminPlayers = data
end)

-- Vykreslovací loop
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if #adminPlayers > 0 then
            local pPed = PlayerPedId()
            local pCoords = GetEntityCoords(pPed)
            for _, admin in pairs(adminPlayers) do
                local targetId = GetPlayerFromServerId(admin.source)
                if targetId ~= -1 then
                    local targetPed = GetPlayerPed(targetId)
                    local tCoords = GetEntityCoords(targetPed)
                    if #(pCoords - tCoords) < 18.0 and HasEntityClearLosToEntity(pPed, targetPed, 17) then
                        sleep = 0
                        DrawAdminTag(tCoords, admin.label, admin.status, admin.color)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)