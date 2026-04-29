-- 1. Nejdříve definujeme hlavní tabulku
Airsoft = {
    Active = false,
    CurrentArena = nil,
    Team = nil,
    IsEliminated = false,
    Scores = { blue = 0, red = 0 }, -- Přidáno pro sledování skóre lokálně
    Data = { hits = 0, kills = 0, deaths = 0 }
}

-- 2. Funkce pro připojení do arény
function Airsoft:Join(arenaId, teamId)
    ESX.TriggerServerCallback('airsoft:checkMoney', function(canJoin)
        if canJoin then
            self.Active = true
            self.CurrentArena = arenaId
            self.Team = teamId
            self.IsEliminated = false
            self.Scores = { blue = 0, red = 0 } -- Reset skóre při vstupu
            
            Airsoft:ScreenTransition()
            
            local arena = Config.Arenas[arenaId]
            local spawn = arena.teams[teamId].spawn
            local ped = PlayerPedId()
            
            SetPedConfigFlag(ped, 184, true) -- CPED_CONFIG_FLAG_PreventPrecipitatedDie
            SetEntityCoords(ped, spawn.x, spawn.y, spawn.z)
            SetEntityHeading(ped, spawn.w)
            
            self:ApplyUniform(arena.teams[teamId].clothing)
            
            SendNUIMessage({ action = "showHUD" })
            -- Resetujeme body v HUDu na nulu
            self:UpdateUI()
            
            TriggerServerEvent('airsoft:playerJoined', arenaId, teamId)
            TriggerEvent('airsoft:startTimer', 600)
        else
            ESX.ShowNotification(Config.Locales['no_money']:format(Config.Arenas[arenaId].price))
        end
    end, Config.Arenas[arenaId].price)
end

-- Event pro aktualizaci skóre ze serveru (Musí přijít od serveru, aby to viděli všichni)
RegisterNetEvent('airsoft:updateScore')
AddEventHandler('airsoft:updateScore', function(blue, red)
    if Airsoft.Active then
        Airsoft.Scores.blue = blue
        Airsoft.Scores.red = red
        Airsoft:UpdateUI()
    end
end)

-- Tento event přijme čas od serveru a pošle ho do tvého HUDu
RegisterNetEvent('airsoft:updateTime')
AddEventHandler('airsoft:updateTime', function(timeStr)
    if Airsoft.Active then
        SendNUIMessage({
            action = "updateTime",
            time = timeStr
        })
    end
end)

RegisterNetEvent('airsoft:registerHit')
AddEventHandler('airsoft:registerHit', function()
    if not Airsoft.Active or Airsoft.IsEliminated then return end
    
    Airsoft.Data.hits = Airsoft.Data.hits + 1
    
    PlaySoundFrontend(-1, "HACK_FAILED", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    StartScreenEffect("DeathFailMPIn", 200, false)

    local maxHitsNeeded = 2 

    if Airsoft.Data.hits >= maxHitsNeeded then
        Airsoft:OnEliminated()
    else
        ESX.ShowNotification("~o~Byl jsi trefen! ["..Airsoft.Data.hits.."/"..maxHitsNeeded.."]")
    end
end)

function Airsoft:OnEliminated()
    if self.IsEliminated then return end
    self.IsEliminated = true
    
    local ped = PlayerPedId()
    
    -- Informujeme server, že jsme byli eliminováni, aby přičetl bod druhému týmu
    TriggerServerEvent('airsoft:server:onDeath', self.Team)

    ClearPedTasksImmediately(ped)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    
    local animDict = "random@mugging3"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(1) end
    TaskPlayAnim(ped, animDict, "handsup_standing_base", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    SendNUIMessage({ action = "status", text = "OUT", color = "red" })
    ESX.ShowNotification("~r~JSI OUT! Čekej na respawn.")
    
    Wait(5000)
    
    self:Respawn()
end

-- 6. Funkce pro odchod z arény
function Airsoft:Exit()
    local ped = PlayerPedId()
    local arena = Config.Arenas[self.CurrentArena]
    
    DoScreenFadeOut(800)
    Wait(1000)
    
    self.Active = false
    self.IsEliminated = false
    self.Data.hits = 0
    
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    
    SetEntityInvincible(ped, false)
    RemoveAllPedWeapons(ped, true)
    
    if arena and arena.lobby then
        SetEntityCoords(ped, arena.lobby.x, arena.lobby.y, arena.lobby.z)
    end

    SendNUIMessage({ action = "hideHUD" })
    
    Wait(500)
    DoScreenFadeIn(800)
    ESX.ShowNotification("~g~Opustil jsi airsoft.")
end

function Airsoft:Respawn()
    local ped = PlayerPedId()
    
    self.IsEliminated = false
    self.Data.hits = 0
    ClearPedTasksImmediately(ped)
    
    DoScreenFadeOut(500)
    Wait(500)

    local arena = Config.Arenas[self.CurrentArena]
    local spawn = arena.teams[self.Team].spawn
    
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, false)
    SetEntityHeading(ped, spawn.w)
    
    SetEntityHealth(ped, 200)
    ClearEntityLastDamageEntity(ped) 
    
    SendNUIMessage({ action = "status", text = "V BOJI", color = "green" })
    ESX.ShowNotification("~g~Jsi zpět! Můžeš znovu bojovat.")

    Wait(500)
    DoScreenFadeIn(500)
end

-- UPRAVENO: Názvy proměnných nyní odpovídají tvému JavaScriptu (item.blue, item.red)
function Airsoft:UpdateUI()
    SendNUIMessage({
        action = "updateScore",
        blue = self.Scores.blue,
        red = self.Scores.red
    })
end

-- 7. Příkazy a nápovědy
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/exitairsoft', 'Opustit airsoftový zápas a vrátit se do lobby.')
end)

RegisterCommand('exitairsoft', function()
    if Airsoft.Active then
        Airsoft:Exit()
    else
        ESX.ShowNotification("~r~Tento příkaz můžeš použít pouze v airsoftu!")
    end
end, false)

-- Přijme synchronizovaný čas ze serveru
RegisterNetEvent('airsoft:syncTimer')
AddEventHandler('airsoft:syncTimer', function(timeString, rawSeconds)
    if Airsoft.Active then
        -- Jen pošleme data do tvého HTML/JS
        SendNUIMessage({
            action = "updateTime",
            time = timeString
        })
    end
end)

RegisterNetEvent('airsoft:matchEnd')
AddEventHandler('airsoft:matchEnd', function(serverBlue, serverRed)
    if Airsoft.Active then
        -- Použijeme data, která přišla přímo v tomto eventu ze serveru
        local blue = tonumber(serverBlue) or 0
        local red = tonumber(serverRed) or 0
        
        -- Debugging: vypíše ti do konzole (F8), co skript zrovna porovnává
        print("Konec zapasu - Modri: " .. blue .. " vs Cerveni: " .. red)

        local title = "REMITÍZA"
        local subtitle = "Skóre bylo vyrovnané: " .. blue .. " - " .. red
        local winColor = "white"

        if blue > red then
            title = "VÍTĚZSTVÍ"
            subtitle = "MODRÝ TÝM VYHRÁL " .. blue .. ":" .. red
            winColor = "blue"
        elseif red > blue then
            title = "VÍTĚZSTVÍ"
            subtitle = "ČERVENÝ TÝM VYHRÁL " .. red .. ":" .. blue
            winColor = "red"
        end

        -- Pošleme oznámení do UI
        SendNUIMessage({
            action = "announce",
            title = title,
            subtitle = subtitle,
            color = winColor
        })

        -- Zvuk konce
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)

        SetTimeout(6000, function()
            Airsoft:Exit()
        end)
    end
end)

Citizen.CreateThread(function()
    Wait(1000) -- Krátká pauza, aby se stihl načíst Config
    local blipCount = 0

    for arenaId, data in pairs(Config.Arenas) do
        -- Kontrola, zda aréna má definované lobby nebo vstupní bod
        local coords = data.lobby or data.entrance
        
        if coords then
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

            SetBlipSprite(blip, 110) -- Ikona terče
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 5) -- Žlutá barva
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Airsoft: " .. (data.label or "Aréna"))
            EndTextCommandSetBlipName(blip)
            
            blipCount = blipCount + 1
        else
            print("^1[Airsoft] CHYBA: Arena s ID " .. arenaId .. " nema definovane lobby souřadnice!^7")
        end
    end
    
    print("^2[Airsoft] Úspěšně vytvořeno " .. blipCount .. " blipů na mapě.^7")
end)