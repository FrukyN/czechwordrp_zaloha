Config = {}

Config.RequiredPolice = 2          -- Minimální počet policistů
Config.GlobalCooldown = 15         -- Cooldown v minutách
Config.RobberyTime = 30000         -- Čas vybírání (ms)

Config.Reward = {
    min = 5000,
    max = 12000,
    account = 'black_money'
}

Config.GPSTrackerDuration = 120    -- Sekundy
Config.GPSRefreshTime = 10000      -- ms

-- Seznam tvých admin ranků pro schvalování
Config.AdminRanks = {
    ['trial'] = true, ['admin'] = true, ['junior'] = true, ['staff'] = true,
    ['senior'] = true, ['hos'] = true, ['cardev'] = true, ['dev'] = true,
    ['managment'] = true, ['cowner'] = true, ['owner'] = true
}

Config.Stores = {
    ["LTD_Grove"] = {
        name = "LTD Benzínka Grove St.",
        coords = vector3(-48.4, -1757.2, 29.4),
        heading = 320.0,
        pedModel = `mp_m_shopkeep_01`,
        reward = {min = 5000, max = 12000}
    },
    ["247_Vinewood"] = {
        name = "24/7 Vinewood",
        coords = vector3(373.60, 328.59, 103.68),
        heading = 255.0,
        pedModel = `s_m_m_ups_01`,
        reward = {min = 6000, max = 15000}
    }
}