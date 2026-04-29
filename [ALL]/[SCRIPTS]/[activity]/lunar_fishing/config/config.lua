Config = {}

Config.progressPerCatch = 0.05 -- The progress per one fish caught

---@class Fish
---@field price integer | { min: integer, max: integer }
---@field chance integer Percentage chance
---@field skillcheck SkillCheckDifficulity }

---@type table<string, Fish>
Config.fish = {
    ['ouklej'] = { price = { min = 25, max = 50 }, chance = 35, skillcheck = { 'easy', 'medium' } },
    ['plotice'] = { price = { min = 50, max = 100 }, chance = 35, skillcheck = { 'easy', 'medium' } },
    ['cejn'] = { price = { min = 150, max = 200 }, chance = 25, skillcheck = { 'easy', 'medium' } },
    ['lin'] = { price = { min = 200, max = 250 }, chance = 20, skillcheck = { 'easy', 'medium', 'medium' } },
    ['kapr'] = { price = { min = 300, max = 350 }, chance = 25, skillcheck = { 'easy', 'medium', 'medium' } },
    ['pstruh'] = { price = { min = 350, max = 450 }, chance = 20, skillcheck = { 'easy', 'medium', 'medium', 'hard' } },
    ['candat'] = { price = { min = 400, max = 450 }, chance = 15, skillcheck = { 'easy', 'medium', 'hard' } },
    ['stika'] = { price = { min = 450, max = 500 }, chance = 15, skillcheck = { 'easy', 'medium', 'hard', 'hard' } },
    ['uhor'] = { price = { min = 1250, max = 1500 }, chance = 5, skillcheck = { 'easy', 'medium', 'hard', 'hard' } },
    ['sumec'] = { price = { min = 2250, max = 2750 }, chance = 1, skillcheck = { 'medium', 'hard', 'hard', 'hard' } },
}

---@class FishingRod
---@field name string
---@field price integer
---@field minLevel integer The minimal level
---@field breakChance integer Percentage chance

---@type FishingRod[]
Config.fishingRods = {
    { name = 'basic_rod', price = 2000, minLevel = 1, breakChance = 20 },
    { name = 'graphite_rod', price = 5500, minLevel = 2, breakChance = 10 },
    { name = 'titanium_rod', price = 15000, minLevel = 3, breakChance = 0 },
}

---@class FishingBait
---@field name string
---@field price integer
---@field minLevel integer The minimal level
---@field waitDivisor number The total wait time gets divided by this value

---@type FishingBait[]
Config.baits = {
    { name = 'zizaly', price = 5, minLevel = 1, waitDivisor = 1.0 },                       
    { name = 'kukurice', price = 25, minLevel = 2, waitDivisor = 1.5 },      
    { name = 'cervi', price = 45, minLevel = 3, waitDivisor = 1.8 },          
    { name = 'boilies', price = 80, minLevel = 4, waitDivisor = 2.2 },          -- Profi kuličky na velké ryby
    { name = 'trpytka', price = 150, minLevel = 5, waitDivisor = 3.0 },         -- Umělá návnada
   
    -- NELEGÁLNÍ 
    --{ name = 'zakazane_feromony', price = 600, minLevel = 1, waitDivisor = 6.0 }, 
}
---@class FishingZone
---@field locations vector3[] One of these gets picked at random
---@field radius number
---@field minLevel integer
---@field waitTime { min: integer, max: integer }
---@field includeOutside boolean Whether you can also catch fish from Config.outside
---@field blip BlipData?
---@field message { enter: string, exit: string }?
---@field fishList string[]

---@type FishingZone[]
Config.fishingZones = {
    {
        blip = {
            name = 'RYBAŘENÍ: Horská řeka',
            sprite = 317,
            color = 3, -- Světle modrá
            scale = 0.6
        },
        locations = {
            vector3(-258.5912, 4337.2388, 41.1172),
            vector3(-1279.8567, 4369.1934, 10.4398)
        },
        radius = 50.0,
        minLevel = 1,
        waitTime = { min = 5, max = 15 },
        includeOutside = true,
        message = { enter = 'Přišel jsi k horské řece.', exit = 'Opustil jsi horskou řeku.' },
        fishList = { 'pstruh', 'candat' }
    },
    {
        blip = {
            name = 'RYBAŘENÍ: Hluboká přehrada',
            sprite = 317,
            color = 29, -- Tmavě modrá
            scale = 0.6
        },
        locations = {
            vector3(1966.9247, 248.0691, 169.7696),
        },
        radius = 100.0,
        minLevel = 0, --3
        waitTime = { min = 20, max = 40 },
        includeOutside = false,
        message = { enter = 'Vplul jsi do hlubokých vod přehrady.', exit = 'Opustil jsi hluboké vody.' },
        fishList = { 'stika', 'sumec' }
    },
    {
        blip = {
            name = 'RYBAŘENÍ: Zarostlá tůň',
            sprite = 317,
            color = 52, -- Zelená
            scale = 0.6
        },
        locations = {
            vector3(-2188.1182, 2596.9348, 0.0),
        },
        radius = 200.0,
        minLevel = 0, --2
        waitTime = { min = 10, max = 20 },
        includeOutside = true,
        message = { enter = 'Dorazil jsi k zarostlé tůni.', exit = 'Odešel jsi od zarostlé tůně.' },
        fishList = { 'lin', 'uhor' }
    }
}

-- Mimo všechny specifikované zóny (chytání kdekoliv jinde)
Config.outside = {
    waitTime = { min = 10, max = 25 },

    ---@type string[]
    fishList = {
        'ouklej', 'plotice', 'cejn', 'kapr'
    }
}

Config.ped = {
    model = `s_m_m_cntrybar_01`,
    buyAccount = 'money',
    sellAccount = 'money',
    blip = {
        name = 'RYBAŘENÍ: Rybářské potřeby',
        sprite = 356,
        color = 74,
        scale = 0.8
    },

    ---@type vector4[]
    locations = {
        vector4(-2081.3831, 2614.3223, 3.0840, 112.7910),
        vector4(-1492.3639, -939.2579, 10.2140, 144.0305)
    }
}

Config.renting = {
    model = `s_m_m_dockwork_01`, -- The ped model
    account = 'money',
    boats = {
        { model = `speeder`, price = 500, image = 'https://i.postimg.cc/mDSqWj4P/164px-Speeder.webp' },
        { model = `dinghy`, price = 750, image = 'https://i.postimg.cc/ZKzjZgj0/164px-Dinghy2.webp'  },
       -- { model = `tug`, price = 1250, image = 'https://i.postimg.cc/jq7vpKHG/164px-Tug.webp' }
    },
    blip = {
        name = 'RYBAŘENÍ: Pronájem lodí',
        sprite = 410,
        color = 74,
        scale = 0.8
    },
    returnDivider = 10, -- Players can return it and get some cash back
    returnRadius = 40.0, -- The save radius

    ---@type { coords: vector4, spawn: vector4 }[]
    locations = {
        { coords = vector4(-1434.4818, -1512.2745, 2.1486, 25.8666), spawn = vector4(-1494.4496, -1537.6943, 2.3942, 115.6015) }
    }
}