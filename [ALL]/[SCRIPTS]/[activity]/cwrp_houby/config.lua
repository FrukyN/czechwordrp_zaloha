Config = {}

Config.MaxMushrooms = 20
Config.RespawnTimeMs = 7 * 60 * 1000
Config.PickDurationMs = 2800
Config.PickCooldownMs = 1200
Config.MaxPickDistance = 5.0
Config.RequiredItem = 'kosik_na_houby'

Config.Security = {
    EnableRateLimit = false,
    MaxRequestsPerWindow = 8,
    WindowMs = 10 * 1000
}

Config.Weather = {
    Enabled = false,
    RainWeathers = {
        RAIN = true,
        THUNDER = true,
        CLEARING = true
    },
    RainBoostMultiplier = 1.7
}

Config.Discord = {
    Enabled = false,
    Webhook = '',
    BotName = 'CWRP Houby',
    IconURL = '',
    LogCollectSuccess = true,
    LogPoisonUse = true,
    LogExploitAttempt = true
}

Config.Blips = {
    Enable = true,
    RadiusColor = 2,
    RadiusAlpha = 100,
    IconSprite = 141,
    IconColor = 2,
    IconScale = 0.8,
    Label = 'Houbařská oblast'
}

Config.Zones = {
    { coords = vector3(-2078.0745, 1462.4502, 275.8478), radius = 200.0 },
    { coords = vector3(-1051.7664, 1601.3048, 265.8578), radius = 150.0 }
}

Config.Mushrooms = {
    { model = `prop_stoneshroom1`, item = 'hrib_smrkovy', label = 'Sebrat hrib smrkovy', poisonous = false, chance = 30 },
    { model = `prop_stoneshroom1`, item = 'liska_obecna', label = 'Sebrat lisku obecnou', poisonous = false, chance = 28 },
    { model = `prop_stoneshroom2`, item = 'bedla_vysoka', label = 'Sebrat bedlu vysokou', poisonous = false, chance = 24 },
    { model = `prop_stoneshroom1`, item = 'klouzek_slicny', label = 'Sebrat klouzek slicny', poisonous = false, chance = 12 },
    { model = `prop_stoneshroom2`, item = 'muchomurka_cervena', label = 'Sebrat muchomurku cervenou', poisonous = true, chance = 6 }
}

Config.PoisonEffects = {
    DurationMs = 30 * 1000,
    Shake = 'DRUNK_SHAKE',
    Timecycle = 'spectator5',
    RagdollChance = 0.15
}

Config.Locale = {
    no_basket = 'Potrebujes kosik na houby.',
    picking = 'Sbirani houby...',
    cancel = 'Sbirani zruseno.',
    picked = 'Sebral jsi houbu.',
    poisoned = 'Spatna houba! Je ti zle...',
    healthy = 'Ta houba byla jedla.',
    invalid = 'Neplatny pokus o sbirani.'
}
