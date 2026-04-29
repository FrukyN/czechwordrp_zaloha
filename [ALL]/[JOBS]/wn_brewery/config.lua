Config = {}
Config.Locale = 'en'

Config.SkillCheck = false
Config.JobName = "brewery"
Config.EnableDebug = false
Config.MoneyToPlayer = true

Config.ShopName = "Pivovar Material"
Config.BreweryShop = vector3(1407.6837, 3619.1382, 34.8943)
Config.ShopItems = {
    { name = 'bottle', price = 20 },
    { name = 'can', price = 15 },
    { name = 'water', price = 10 }
}

Config.CloakroomCoords = vector3(-66.2297, 6440.8525, 31.5013)
Config.SkinMenu = "illenium" --  illeium for illenium-appearance and fivem-appearance for fivem-appearance

Config.JobBlips = {
    EmployeeShop = {
        BlipCoords = vec3(1407.6837, 3619.1382, 34.8943),
        Sprite = 59,
        Display = 4,
        Scale = 0.8,
        Color = 5,
        Name = "Pivovar Material"
    },
    BarleyField = {
        BlipCoords = vec3(651.5635, 6474.3071, 37.0306),
        Sprite = 237,
        Display = 4,
        Scale = 0.8,
        Color = 5,
        Name = "Jecné pole"
    },
    HopField = {
        BlipCoords = vec3(263.7039, 6611.0400, 29.9669),
        Sprite = 71,
        Display = 4,
        Scale = 0.8,
        Color = 2,
        Name = "Chmelnice"
    },
    SellMarket = {
        BlipCoords = vec3(316.9546, 2622.7971, 44.4550),
        Sprite = 59,
        Display = 4,
        Scale = 0.8,
        Color = 67,
        Name = "Prodej piva"
    },
}

--- HOP COLLECTING CONFIG ---

Config.HopItem = "hop"
Config.HopModel = "prop_plant_fern_02c"
Config.LimitHop = true
Config.LimitHopAmount = 50
Config.GiveHopAmount = 5
Config.BarleyHopDuration = 2000

Config.HopSpawnCoords = {
    [1] = vector3(284.75, 6602.59, 30.21),
    --[2] = vector3(284.81, 6607.59, 30.23),
    [3] = vector3(284.86, 6612.59, 30.09),
    [4] = vector3(284.91, 6617.59, 29.92),
    --[5] = vector3(284.96, 6622.59, 29.8),
    [6] = vector3(277.25, 6602.67, 29.99),
    [7] = vector3(277.31, 6607.67, 29.92),
    --[8] = vector3(277.41, 6617.67, 29.69),
    [9] = vector3(277.46, 6622.67, 29.67),
    [10] = vector3(269.75, 6602.75, 30.19),
    --[11] = vector3(269.81, 6607.75, 30.13),
    [12] = vector3(269.86, 6612.75, 29.93),
    [13] = vector3(269.91, 6617.75, 29.86),
    --[14] = vector3(269.96, 6622.75, 29.84),
    [15] = vector3(262.25, 6602.82, 30.1),
    [16] = vector3(262.31, 6607.82, 29.92),
    [17] = vector3(262.36, 6612.82, 29.79),
    --[18] = vector3(262.41, 6617.82, 29.66),
    [19] = vector3(262.46, 6622.82, 29.67),
    [20] = vector3(254.76, 6602.9, 30.1),
    --[21] = vector3(254.81, 6607.9, 30.13),
    [22] = vector3(254.86, 6612.9, 29.85),
    [23] = vector3(254.91, 6617.9, 29.7),
    --[24] = vector3(254.96, 6622.9, 29.76),
    [25] = vector3(247.26, 6602.98, 29.98),
    [26] = vector3(247.31, 6607.98, 29.94),
    --[27] = vector3(247.36, 6612.98, 29.8),
    [28] = vector3(247.41, 6617.98, 29.71),
    [29] = vector3(247.47, 6622.98, 29.81),
    --[30] = vector3(276.33, 6612.58, 29.80)
}

--- BARLEY COLLECTING CONFIG ---

Config.BarleyItem = "haybale"
Config.BarleyModel = "prop_haybale_01"
Config.LimitBarley = true
Config.LimitBarleyAmount = 50
Config.GiveBarleyAmount = 5
Config.BarleyHarvestDuration = 2000

Config.BarleySpawnCoords = {
    [1] = vector3(616.48, 6489.07, 29.9),
    [2] = vector3(616.66, 6484.37, 30.14),
    --[3] = vector3(616.84, 6479.68, 30.16),
    [4] = vector3(617.02, 6474.98, 30.01),
    [5] = vector3(617.2, 6470.28, 29.83),
    --[6] = vector3(617.38, 6465.59, 29.81),
    [7] = vector3(623.97, 6489.36, 30.44),
    --[8] = vector3(624.15, 6484.66, 30.62),
    [9] = vector3(624.33, 6479.97, 30.58),
    [10] = vector3(624.51, 6475.27, 30.34),
    [11] = vector3(624.69, 6470.57, 30.1),
    --[12] = vector3(624.87, 6465.88, 30.0),
    [13] = vector3(631.46, 6489.65, 30.32),
    [14] = vector3(631.64, 6484.95, 30.77),
    --[15] = vector3(631.83, 6480.25, 30.67),
    [16] = vector3(632.01, 6475.56, 30.43),
    [17] = vector3(632.19, 6470.86, 30.23),
    [18] = vector3(632.37, 6466.16, 30.21),
    [19] = vector3(638.96, 6489.93, 30.06),
    --[20] = vector3(639.14, 6485.24, 30.48),
    [21] = vector3(639.32, 6480.54, 30.65),
    [22] = vector3(639.5, 6475.84, 30.57),
    --[23] = vector3(639.68, 6471.15, 30.45),
    [24] = vector3(639.86, 6466.45, 30.4),
    [25] = vector3(646.45, 6490.22, 29.7),
    [26] = vector3(646.63, 6485.53, 30.24),
    --[28] = vector3(646.81, 6480.83, 30.73),
    [29] = vector3(646.99, 6476.13, 30.76),
    [30] = vector3(647.18, 6471.44, 30.76),
    [31] = vector3(647.36, 6466.74, 30.79),
    --[32] = vector3(653.95, 6490.51, 29.46),
    --[33] = vector3(654.13, 6485.81, 30.09),
    [34] = vector3(654.31, 6481.12, 30.57),
    --[35] = vector3(654.49, 6476.42, 30.63),
    [36] = vector3(654.67, 6471.72, 30.56),
    [37] = vector3(654.85, 6467.03, 30.72),
    --[38] = vector3(661.44, 6490.8, 29.49),
    [39] = vector3(661.62, 6486.1, 29.99),
    [40] = vector3(661.8, 6481.4, 30.33),
   --[41] = vector3(661.98, 6476.71, 30.42),
    [42] = vector3(662.34, 6467.32, 30.62),
    [43] = vector3(662.16, 6472.01, 30.35),
    [44] = vector3(668.94, 6491.09, 29.31),
    --[45] = vector3(669.12, 6486.39, 29.55),
    [46] = vector3(669.3, 6481.69, 29.89),
    [47] = vector3(669.48, 6477.0, 30.15),
    [48] = vector3(669.66, 6472.3, 30.24),
    --[49] = vector3(669.84, 6467.6, 30.47),
    [50] = vector3(676.43, 6491.37, 29.33),
    [51] = vector3(676.61, 6486.68, 29.34),
    --[52] = vector3(676.79, 6481.98, 29.76),
    [53] = vector3(676.97, 6477.28, 30.12),
    [54] = vector3(677.15, 6472.59, 30.34),
    --[55] = vector3(677.33, 6467.89, 30.46)
}

--- BEER COOKING CONFIG ---

Config.WaterItem = "water"
Config.BottleItem = "bottle"
Config.CanItem = "can"
Config.PisswaserBottleItem = "beerbottle"
Config.PisswaserCanItem = "beercan"

Config.Cooking = vector3(-57.8353, 6432.7090, 32.6901)
Config.CookingHopNeedB = 5
Config.CookingBarleyNeedB = 5
Config.CookingWaterNeedB = 5
Config.CookingBottleNeedB = 5
Config.BottleGiveB = 5
Config.BottleCookingDuration = 3000

Config.CookingHopNeedC = 5
Config.CookingBarleyNeedC = 5
Config.CookingWaterNeedC = 5
Config.CookingCanNeedC = 5
Config.CanGiveC = 5

Config.CanCookingDuration = 3000

--- BEER PACKING ---

Config.PackingCoords = vector3(-52.9754, 6425.9370, 32.5641)
Config.PackingDuration = 3000

Config.PisswaserBottlePackItem = "beerbottlepack"
Config.PisswaserCanPackItem = "beercanpack"

--- BREWERY GARAGE ---

Config.PedGaragePosition = vector4(-60.3273, 6439.8125, 32.6900, 351.7259)
Config.PedModel = "a_m_m_farmer_01"
Config.JobVehicles = {
    {
        model = "SADLER",
        spawn = vector4(-61.5825, 6443.6372, 31.4906, 50.2637),
        delete = vector3(-61.4245, 6443.9321, 31.0785)
    },
    {
        model = "BISON",
        spawn = vector4(-61.5825, 6443.6372, 31.4906, 50.2637),
        delete = vector3(-61.4245, 6443.9321, 31.0785)
    },
    {
        model = "PHANTOM",
        spawn = vector4(-61.5825, 6443.6372, 31.4906, 50.2637),
        delete = vector3(-61.4245, 6443.9321, 31.0785)
    }
}

Config.GarageLang = "[E] - Store vehicle"

--- SELLING ---

Config.PedSellingModel = "a_m_m_farmer_01"
Config.PedSellingPosition = vector4(316.9546, 2622.7971, 44.4550, 309.3194)
Config.SellPackingDuration = 3000

Config.MoneyType = "money"
Config.PriceForBeer = 3500
Config.PriceForCan = 3500

Config.PriceForBeerPack = 8000
Config.PriceForCanPack = 8000

--- Drunk Effect ---

Config.DrunkEffects = {
    ['beerbottle'] = {duration = 30, intensity = 0.7, anim = "move_m@drunk@slightlydrunk"},
    ['beercan'] = {duration = 45, intensity = 1.0, anim = "move_m@drunk@slightlydrunk"}
}