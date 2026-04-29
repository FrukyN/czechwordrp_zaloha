Config = {}

Config.Debug = false
Config.Locale = 'cs'

-- Maximalni vzdalenost hrace od bodu nakupu, aby server uznal request.
Config.MaxBuyDistance = 4.0

-- Jednoduchy anti-spam cooldown (sekundy).
Config.BuyCooldown = 2

-- Povolen jen tento item (jak jsi chtel).
Config.ItemName = 'dalnicni_znamka'

-- DB nastaveni pro seznam aut hrace.
Config.VehicleTable = 'owned_vehicles'
Config.VehicleOwnerColumn = 'owner'
Config.VehiclePlateColumn = 'plate'

-- Nabidka znamky.
Config.Vignettes = {
    daily = {
        label = 'Denni dalnicni znamka',
        price = 350,
        days = 1,
        description = 'Platnost 1 den'
    },
    ten_days = {
        label = '10denni dalnicni znamka',
        price = 900,
        days = 10,
        description = 'Platnost 10 dni'
    },
    thirty_days = {
        label = '30denni dalnicni znamka',
        price = 2000,
        days = 30,
        description = 'Platnost 30 dni'
    }
}

-- Mista bez NPC, kde lze nakoupit znamku pres ox_target.
Config.BuyPoints = {
    {
        id = 'dalnice_1',
        coords = vec3(-232.5642, -915.4404, 32.3108),
        radius = 1.8,
        icon = 'fa-solid fa-road',
        label = 'Promluvit'
    },

}

-- Nazev kanalu/threadu v JD_logs exportu.
Config.DiscordLogName = 'DalnicniZnamky'

-- Barvy jako string pro JD_logs.
Config.Colors = {
    success = '65280',
    warning = '16776960',
    danger = '16711680'
}
