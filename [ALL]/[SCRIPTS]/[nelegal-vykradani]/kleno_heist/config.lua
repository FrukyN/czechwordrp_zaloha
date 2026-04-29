Config = {}

Config.PoliceRequired = 0 -- Minimální počet policistů online
Config.PoliceJobName = 'police' -- Název jobu policie

Config.GasDuration = 300000 -- Jak dlouho trvá plyn (5 minut v ms)
Config.HeistCooldown = 3600 -- Cooldown mezi loupežemi (v sekundách - 1 hodina)

-- Tady jsou ty souřadnice, které skript potřebuje pro ox_target
Config.Vitrines = {
    { coords = vec3(-627.6404, -234.2812, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
    { coords = vec3(-626.3705, -233.4286, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
    { coords = vec3(-626.0455, -234.2558, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
    { coords = vec3(-627.0977, -234.8392, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
    { coords = vec3(-624.1077, -230.6730, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
    { coords = vec3(-622.4583, -232.6468, 38.0825), size = vec3(1.1, 1.1, 1.2), heading = 34 },
}

Config.Loot = {
    { item = 'jewel_emerald', min = 1, max = 3, chance = 40 },
    { item = 'jewel_diamond', min = 1, max = 2, chance = 20 },
    { item = 'gold_ring', min = 2, max = 5, chance = 80 },
}

-- Tohle už skript aktivně nepoužívá, ale můžeš to tu nechat
Config.VitrineModels = {
    'prop_jewely_01', 'prop_jewely_02', 'prop_jewely_03', 
    'prop_jewely_04', 'prop_jewely_05', 'prop_jewely_06'
}