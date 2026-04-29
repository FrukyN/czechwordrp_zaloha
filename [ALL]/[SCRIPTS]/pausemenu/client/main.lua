ESX = exports["es_extended"]:getSharedObject()

local charData = { firstname = "", lastname = "", birth = "" }
local isSpawned = false
local currentHintFormatted = ""

local hints = {
    "Nastavení klávesových zkratek najdeš v NASTAVENÍ > BINDY > FIVEM",
    "Ve vozidle se doporučujeme poutat",
    "Užívej si HRU!!!",
    "Veškeré chyby nahlaste na discord",
    "Vaše nápady piště na discord",
}

local function makeFontText(text)
    return ("<FONT FACE='Roboto'>%s</FONT>"):format(text)
end

local serverTitle = makeFontText(" ~w~CZECH ~r~WORLD ~b~RP")

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData, isNew, skin)
    charData = {
        firstname = makeFontText(playerData.firstName or ESX.PlayerData.firstName or ""), 
        lastname = makeFontText(playerData.lastName or ESX.PlayerData.lastName or ""),
        birth = makeFontText(playerData.dateofbirth or ESX.PlayerData.dateofbirth or "")
    }
    isSpawned = true
end)

Citizen.CreateThread(function()
    while true do
        currentHintFormatted = makeFontText(hints[math.random(#hints)])
        Citizen.Wait(140000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsPauseMenuActive() then
            BeginScaleformMovieMethodOnFrontendHeader("SHIFT_CORONA_DESC")
            ScaleformMovieMethodAddParamBool(true)
            EndScaleformMovieMethod()
            
            BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE")
            ScaleformMovieMethodAddParamTextureNameString(serverTitle)
            ScaleformMovieMethodAddParamBool(true)
            ScaleformMovieMethodAddParamTextureNameString(currentHintFormatted)
            ScaleformMovieMethodAddParamBool(true)
            EndScaleformMovieMethod()

            if isSpawned then
                BeginScaleformMovieMethodOnFrontend("SET_HEADING_DETAILS")
                ScaleformMovieMethodAddParamTextureNameString(charData.firstname)
                ScaleformMovieMethodAddParamTextureNameString(charData.lastname)
                ScaleformMovieMethodAddParamTextureNameString(charData.birth)
                EndScaleformMovieMethod()
            end
            
            Citizen.Wait(1) 
        else
            Citizen.Wait(600) 
        end
    end
end)


local function AddFontTextEntry(entry, text)
    AddTextEntry(entry, "<FONT FACE='Roboto'> " .. text .. " </FONT>")
end

Citizen.CreateThread(function()
    -- Barvy HUDu
    ReplaceHudColourWithRgba(117, 27, 27, 33, 225)
    ReplaceHudColourWithRgba(116, 59, 91, 219, 245)
    ReplaceHudColourWithRgba(142, 59, 91, 219, 255) -- waypoint

    -- Text Entries (Main)
    AddFontTextEntry("PM_SCR_MAP", "Mapa")
    AddFontTextEntry("PM_SCR_STA", "Status")
    AddFontTextEntry("PM_SCR_GAM", "Hra")
    AddFontTextEntry("PM_SCR_INF", "Informace")
    AddFontTextEntry("PM_SCR_SET", "Nastavení")
    AddFontTextEntry("PM_SCR_GAL", "Galerie")

    -- Game
    AddFontTextEntry("PM_PANE_LEAVE", "Odpojit se ze serveru")
    AddFontTextEntry("PM_PANE_QUIT", "Vypnout hru")
--[[    
    -- Stats
    AddFontTextEntry("MP_STATS1", "Kariéra")
    AddFontTextEntry("MP_STATS2", "Skill")
    AddFontTextEntry("MP_STATS3", "O vás")
    AddFontTextEntry("MP_STATS4", "Kriminalita")
    AddFontTextEntry("MP_STATS5", "Vozidla")
    AddFontTextEntry("MP_STATS6", "Peníze")
    AddFontTextEntry("MP_STATS7", "Agresivita")
    AddFontTextEntry("PM_AWARDS", "------")
    AddFontTextEntry("PM_INF_UNLT", "------")
    AddFontTextEntry("PM_WEAPONS", "------")
    
    -- Info
    AddFontTextEntry("PM_PANE_FEE", "Notifikace")
    AddFontTextEntry("PM_PANE_HLP", "Pomoc")
    AddFontTextEntry("PM_PANE_BRI", "Dialog")
    AddFontTextEntry("PM_PANE_MIS", "Mise")

    -- Settings
    AddFontTextEntry("0x92320117", "Gamepad")
    AddFontTextEntry("PM_PANE_AUD", "Zvuk")
    AddFontTextEntry("PM_PANE_CAM", "Kamera")
    AddFontTextEntry("PM_PANE_DIS", "Displej")
    AddFontTextEntry("MO_VOUT", "Voice Chat")
    AddFontTextEntry("0xE782A771", "Rockstar Editor")
    AddFontTextEntry("0xFBB6E685", "Rozšířená grafika")
    AddFontTextEntry("0xD3A0C438", "Grafika")
    AddFontTextEntry("0x82FBED04", "Bindy")
    AddFontTextEntry("0x0A0C22D4", "Klávesnice / Myš")
    AddFontTextEntry("GFX_VIDMEM", "Video paměť")
    AddFontTextEntry("0x51B058B3", "Monitor")
    AddFontTextEntry("0xA28A6F51", "FXAA")
    AddFontTextEntry("0x38111CA3", "MSAA")
    AddFontTextEntry("0xFB0E70C2", "V-Sync")
    AddFontTextEntry("0xC4FD3301", "Pause Game On Focus Loss")
    AddFontTextEntry("GFX_SCALING", "Render Resolution")
    AddFontTextEntry("GFX_BUDGET", "Extended Texture Budget")
    AddFontTextEntry("0x74F73ED3", "Shadow Quality")
    AddFontTextEntry("0x78F76ACC", "Texture Quality")
    AddFontTextEntry("0x11739C25", "Shader Quality")
    AddFontTextEntry("0xC43D3B9F", "Water Quality")
    AddFontTextEntry("0x544B440F", "Particles Quality")
    AddFontTextEntry("0x5CD4E15C", "Grass Quality")
    AddFontTextEntry("0xCD676AF6", "Reflection Quality")
    AddFontTextEntry("0x67117E6F", "Ignore Suggested Limits")
    AddFontTextEntry("0x87D30231", "DirectX Version")
    AddFontTextEntry("0xD627A8D5", "Population Density")
    AddFontTextEntry("0x74EFCDDE", "Population Variety")
    AddFontTextEntry("0xF84B169F", "Distance Scaling")
    AddFontTextEntry("0x30860474", "Reflection MSAA")
    AddFontTextEntry("0x73C258A0", "Soft Shadows")
    AddFontTextEntry("0x367DB5EF", "Post FX")
    AddFontTextEntry("0x1752894A", "Motion Blur Strength")
    AddFontTextEntry("MO_DOF", "In-Game Depth Of Field Effects")
    AddFontTextEntry("0x19C1AD65", "Anisotropic Filtering")
    AddFontTextEntry("0xE0306CDD", "Ambient Occlusion")
    AddFontTextEntry("0x0F986BB4", "Tessellation")
    AddFontTextEntry("MO_RDF", "Restore Defaults")
    AddFontTextEntry("MO_GFX_NORM", "Normální")
    AddFontTextEntry("MO_CS_HIGH", "Vysoké")
    AddFontTextEntry("MO_GFX_VHIGH", "Velmi vysoké")
    AddFontTextEntry("MO_GFX_ULTRA", "Ultra")
    AddFontTextEntry("MO_GFX_X2", "X2")
    AddFontTextEntry("MO_GFX_X4", "X4")
    AddFontTextEntry("MO_GFX_X8", "X8")
    AddFontTextEntry("MO_OFF", "Vypnuto")
    AddFontTextEntry("MO_ON", "Zapnuto")
    AddFontTextEntry("GFX_SHARP", "Sharp")
    AddFontTextEntry("GFX_SOFT", "Soft")
    AddFontTextEntry("GFX_SOFTER", "Softer")
    AddFontTextEntry("GFX_SOFTEST", "Softest")
    AddFontTextEntry("0xF390EF41", "AMD CHS")
    AddFontTextEntry("GFX_NVIDIA", "NVIDIA PCSS")
    AddFontTextEntry("MP0_STAMINA", "Stamina")
    AddFontTextEntry("MP0_LUNG_CAPACITY", "Plavání")
    AddFontTextEntry("MP0_DRIVING_ABILITY", "Řízení")
    AddFontTextEntry("MP0_STRENGTH", "Síla")
]]
end)