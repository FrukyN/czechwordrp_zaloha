Config = {}

-- Musí tu být aspoň prázdná tabulka {}, jinak to hodí tu chybu, co ti to napsalo
Config.Budky = {
    vec3(213.750473,-852.786743,30.455204), -- Tady si vyměň souřadnice za ty tvoje
    vec3(-241.9740, -765.5530, 32.7863),
}

Config.PhoneBoxes = {
    'prop_phonebox_01a',
    'prop_phonebox_01b',
    'prop_phonebox_01c'
}

-- Itemy, které lze prodat a jejich ceny (min/max za 1 kus)
Config.SellItems = {
    ['jewel_emerald'] = { min = 500, max = 800 },
    ['jewel_diamond'] = { min = 1200, max = 2000 },
    ['gold_ring'] = { min = 3000, max = 5000 },
}

-- Možná místa pro spawn překupníka (X, Y, Z, Heading)
Config.BuyerLocations = {
    vec4(1638.9042, 4819.0547, 41.9783, 283.1117),
    vec4(2433.4993, 3130.5205, 48.2632, 102.2815),
    vec4(1191.9091, -1261.1653, 35.1748, 270.8240),
    vec4(95.3600, -1810.9669, 27.0767, 238.5953),
    vec4(1348.4385, -1837.8401, 57.0900, 97.3881)
}

Config.BuyerModel = `a_m_m_soucent_02`