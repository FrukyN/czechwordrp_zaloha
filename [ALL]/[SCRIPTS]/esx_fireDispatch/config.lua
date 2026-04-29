Config = {}
Config.Job = 'fire'
Config.AlarmRange = 60.0

-- STŘED STANICE (Pro výpočet, zda má hrát zvuk)
Config.FireStation = { 
    coords = vector3(1194.5, -1470.2, 34.8) -- Musí to být vector3!
}

Config.Locations = {
    Monitor = {
        model = "prop_monitor_01b", -- Uvozovky místo zpětných apostrofů
        coords = vector4(1198.3929, -1482.4904, 37.4279, 180.1762),
    },
    Printer = {
        model = "prop_printer_01", 
        coords = vector4(1178.7032, -1469.3989, 35.6677, 205.0755),
    }
}