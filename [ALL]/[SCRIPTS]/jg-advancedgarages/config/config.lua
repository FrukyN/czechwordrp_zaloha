-----------------------------------------------------------------------------------
-- WAIT! Before editing this file manually, try our new easy configuration tool! --
--            https://configurator.jgscripts.com/advanced-garages                --
-----------------------------------------------------------------------------------
Config = {}

-- Localisation
Config.Locale = "cs"
Config.NumberAndDateFormat = "en-US"
Config.Currency = "CZK"

-- Framework & Integrations
Config.Framework = "ESX" -- or "QBCore", "Qbox", "ESX"
Config.FuelSystem = "ox_fuel" -- or "LegacyFuel", "ps-fuel", "lj-fuel", "ox_fuel", "cdn-fuel", "hyon_gas_station", "okokGasStation", "nd_fuel", "myFuel", "ti_fuel", "Renewed-Fuel", "rcore_fuel", "none"
Config.VehicleKeys = "cigan" -- or "qb-vehiclekeys", "MrNewbVehicleKeys", "jaksam-vehicles-keys", "qs-vehiclekeys", "mk_vehiclekeys", "wasabi_carlock", "cd_garage", "okokGarage", "t1ger_keys", "Renewed", "tgiann-hotwire" "none"
Config.Notifications = "ox_lib" -- or "default", "okokNotify", "ox_lib", "ps-ui"
Config.Banking = "esx_addonaccount" -- or "qb-banking", "qb-management", "esx_addonaccount", "Renewed-Banking", "okokBanking", "fd_banking"
Config.Gangs = "auto" -- "qb-gangs", "rcore_gangs"

-- Draw text UI prompts (key binding control IDs here: https://docs.fivem.net/docs/game-references/controls/)
Config.DrawText = "ox_lib" -- or "jg-textui", "qb-DrawText", "okokTextUI", "ox_lib", "ps-ui"
Config.OpenGarageKeyBind = 38
Config.OpenGaragePrompt = "Otevřít garáž"
Config.OpenImpoundKeyBind = 38
Config.OpenImpoundPrompt = "Otevřít odtahovku"
Config.InsertVehicleKeyBind = 38
Config.InsertVehiclePrompt = "Uložit vozidlo"
Config.ExitInteriorKeyBind = 38
Config.ExitInteriorPrompt = "Opustit garáž"

-- Target
Config.UseTarget = true
Config.Target = "ox_target" -- or "qb-target"
Config.TargetPed = "s_m_y_valet_01"

-- Radial
Config.UseRadialMenu = false
Config.RadialMenu = "ox_lib"


-- Little vehicle preview images in the garage UI - learn more/add custom images: https://docs.jgscripts.com/advanced-garages/vehicle-images
Config.ShowVehicleImages = true

-- Vehicle Spawning & Storing
Config.DoNotSpawnInsideVehicle = false
Config.SaveVehicleDamage = true -- Save and apply body and engine damage when taking the vehicle out a garage
Config.AdvancedVehicleDamage = true -- use Kiminaze's VehicleDeformation
Config.SaveVehiclePropsOnInsert = true
Config.CheckVehicleModel = true -- Extra security

-- If you don't know what this means, don't touch this
-- If you know what this means, I do recommend enabling it but be aware you may experience reliability issues on more populated servers
-- Having significant issues? I beg you to just set it back to false before opening a ticket with us
-- HIGHLY recommended that you set Config.DoNotSpawnInsideVehicle = false if you decide to enable this
-- Want to read my rant about server spawned vehicles? https://docs.jgscripts.com/advanced-garages/misc/why-are-you-not-using-createvehicleserversetter-by-default
Config.SpawnVehiclesWithServerSetter = false

-- Vehicle Transfers
Config.GarageVehicleTransferCost = 200 -- Cost to transfer between garages
Config.TransferHidePlayerNames = false
Config.EnableTransfers = {
  betweenGarages = true,
  betweenPlayers = true
}
Config.DisableTransfersToUnregisteredGarages = false -- Potential hacking protection for vigilant servers - unregistered garages are ones created via events in third-party script integrations, such as housing scripts, and therefore could be prone to script kiddie attacks.

-- Prevent vehicle duplication
-- Learn more: https://docs.jgscripts.com/advanced-garages/vehicle-duplication-prevention
Config.AllowInfiniteVehicleSpawns = false -- Public & private garages
Config.JobGaragesAllowInfiniteVehicleSpawns = true -- Job garages
Config.GangGaragesAllowInfiniteVehicleSpawns = false -- Gang garages
Config.GarageVehicleReturnCost = 220 -- "towing" tax if not placed back in garage after server restart; or if destroyed or underwater while left out
Config.GarageVehicleReturnCostSocietyFund = false -- Job name of society fund to pay return fees into (optional)

-- Public Garages
Config.GarageShowBlips = true
Config.GarageUniqueBlips = false
Config.GarageUniqueLocations = false
Config.GarageEnableInteriors = false
Config.GarageLocations = { -- IMPORTANT - Every garage name must be unique
  ["Legion Square"] = { -- If you change the name of this garage from Legion Square, you must change the default value of `garage_id` to the same name in the SQL table `players_vehicles`
    coords = vector3(214.2566, -806.9131, 30.8102),
    spawn = {vector4(214.0728, -793.6228, 30.8500, 157.2023), vector4(218.5291, -796.8945, 30.7630, 50.7903), vector4(219.8881, -794.5185, 30.7428, 53.7892), vector4(220.5685, -791.7475, 30.7504, 64.6155), vector4(222.4632, -786.8069, 30.7646, 53.7803), vector4(223.3941, -784.1202, 30.7596, 68.5224)}, --  you can add multiple spawn locations into a table
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Islington South"] = {
    coords = vector3(276.1812, -343.4639, 44.9199),
    spawn = vector4(278.3732, -336.4412, 44.9199, 69.7364),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Grove Street"] = {
    coords = vector3(14.3474, -1728.7272, 29.3030),
    spawn = vector4(11.6726, -1714.6586, 29.2986, 27.5100),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Mirror Park"] = {
    coords = vector3(1035.0031, -765.2793, 57.9956),
    spawn = vector4(1028.2224, -771.1685, 58.0378, 144.3655),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Beach"] = {
    coords = vector3(-1249.2672, -1426.1654, 4.3229),
    spawn = vector4(-1240.5297, -1416.5881, 4.3236, 307.0488),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Great Ocean Highway"] = {
    coords = vector3(-2961.5576, 376.5538, 15.0132),
    spawn = vector4(-2965.0701, 364.1922, 14.7699, 69.6669),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Sandy South"] = {
    coords = vector3(218.1168, 2601.8022, 45.7663),
    spawn = vector4(218.1168, 2601.8022, 45.7663, 13.6852),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Sandy North"] = {
    coords = vector3(1874.6719, 3761.4756, 32.9772),
    spawn = vector4(1877.3695, 3756.9026, 32.9522, 214.2562),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["North Vinewood Blvd"] = {
    coords = vector3(363.2175, 296.9417, 103.5062),
    spawn = vector4(359.3810, 290.3000, 103.5123, 256.8995),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Grapeseed"] = {
    coords = vector3(1714.4080, 4743.5381, 42.0078),
    spawn = vector4(1707.3865, 4747.9351, 41.9835, 87.7475),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Paleto Bay"] = {
    coords = vector3(104.6885, 6606.9458, 31.8976),
    spawn = vector4(117.8191, 6599.1152, 32.0152, 277.9039),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["pcr"] = {
    coords = vector3(407.1454, -1011.1510, 29.4078),
    spawn = vector4(408.5540, -998.0944, 29.2664, 47.1925),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["BENZO VIP"] = {
    coords = vector3(-3350.8472, 1753.3993, 34.1583),
    spawn = vector4(-3350.8472, 1753.3993, 34.1583, 288.9163),
    distance = 10,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["autokelly"] = {
    coords = vector3(-390.0522, -101.6316, 38.7532),
    spawn = vector4(-393.2798, -119.1963, 38.5693, 292.0212),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["AAA"] = {
    coords = vector3(-14.1523, -1077.7396, 26.6721),
    spawn = vector4(-8.4446, -1082.5999, 26.6732, 144.0927),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["vinice"] = {
    coords = vector3(-1892.6326, 2037.9607, 140.8515),
    spawn = vector4(-1895.6722, 2035.1892, 140.7415, 166.2290),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["vanilla"] = {
    coords = vector3(154.3876, -1314.6770, 29.2022),
    spawn = vector4(152.1048, -1309.4845, 29.2022, 71.6817),
    distance = 4,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["pivovar"] = {
    coords = vector3(-47.9574, 6451.1768, 31.4785),
    spawn = vector4(-55.9444, 6453.6157, 31.5144, 48.8779),
    distance = 4,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["hzs"] = {
    coords = vector3(1165.3042, -1460.4604, 34.6930),
    spawn = vector4(1160.8727, -1468.1044, 34.6930, 94.3433),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["zzs"] = {
    coords = vector3(-1874.6797, -332.7626, 49.3941),
    spawn = vector4(-1877.0588, -335.8110, 49.2575, 138.3459),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["usti"] = {
    coords = vector3(1369.6570, 3606.3374, 34.8938),
    spawn = vector4(1375.6475, 3600.2810, 34.8946, 217.5409),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["split"] = {
    coords = vector3(-420.7925, 286.6104, 83.2292),
    spawn = vector4(-416.4284, 288.7166, 83.2292, 0.4007),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["cernakovci"] = {
    coords = vector3(-1556.1621, 17.4063, 58.8357),
    spawn = vector4(-1553.9043, 24.8778, 58.5515, 338.4141),
    distance = 5,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["vezeni"] = {
    coords = vector3(1852.6970, 2596.2334, 45.6720),
    spawn = vector4(1869.2878, 2595.3687, 45.6720, 265.8953),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = false,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["kajikgarage"] = {
    coords = vector3(-821.2604, 183.9009, 72.0257),
    spawn = vector4(-821.2604, 183.9009, 72.0257, 129.6829),
    distance = 5,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["kamionak"] = {
    coords = vector3(1211.3895, -3102.4658, 6.0280),
    spawn = vector4(1205.0625, -3105.7729, 5.6541, 2.5155),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["elektrikar"] = {
    coords = vector3(880.4636, -2342.8950, 30.3678),
    spawn = vector4(883.5651, -2349.8765, 30.3312, 235.4217),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["rozvoznovin"] = {
    coords = vector3(-613.5671, -917.3625, 23.7194),
    spawn = vector4(-617.1418, -923.4785, 23.1024, 108.9763),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["rozvozpizzy"] = {
    coords = vector3(590.8096, 33.8478, 91.5662),
    spawn = vector4(597.6703, 34.9170, 90.8599, 252.8943),
    distance = 5,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["uodtahovky"] = {
    coords = vector3(453.5105, -1685.3503, 29.2819),
    spawn = vector4(452.6139, -1693.8572, 29.2925, 329.6909),
    distance = 5,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["ironwolves"] = {
    coords = vector3(979.0162, -140.2245, 74.2141),
    spawn = vector4(972.1062, -138.4267, 74.2950, 87.1454),
    distance = 6,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["udalsidilny"] = {
    coords = vector3(-602.6706, -2334.6250, 13.8284),
    spawn = vector4(-602.1602, -2329.7878, 13.8284, 320.3265),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["taxi"] = {
    coords = vector3(915.7560, -160.9828, 74.7645),
    spawn = vector4(915.7560, -160.9828, 74.7645, 153.2190),
    distance = 10,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["utelevize"] = {
    coords = vector3(-462.8382, 22.2401, 45.5336),
    spawn = vector4(-464.2550, 17.9486, 45.5087, 86.0869),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["usti2"] = {
    coords = vector3(-3205.5493, 827.2545, 8.9358),
    spawn = vector4(-3204.9700, 818.5694, 8.9271, 212.8337),
    distance = 5,
    type = "car",
    hideBlip = true,
    blip = {
      id = 357,
      color = 0,
      scale = 0.4
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["ukasina"] = {
    coords = vector3(889.5876, -56.8820, 78.7640),
    spawn = vector4(893.0790, -54.7153, 78.7640, 240.0587),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.4
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
    
  ["stkacko"] = {
    coords = vector4(959.6081, -1038.9532, 41.0309, 277.5648),
    spawn = vector4(975.3347, -1041.5713, 40.8303, 5.1385),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["pizzerie"] = {
    coords = vector4(-1317.3303, -1128.3096, 4.9885, 131.5081),
    spawn = vector4(-1318.7084, -1134.2828, 4.5865, 117.8035),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["ustihel"] = {
    coords = vector4(-3253.5938, 835.6710, 2.9165, 58.7946),
    spawn = vector4(-3259.1440, 839.7797, 2.9165, 114.6673),
    distance = 15,
    type = "air",
    hideBlip = true,
    blip = {
      id = 0,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["udiliny"] = {
    coords = vector4(440.7567, -1523.9679, 29.2705, 127.1522),
    spawn = vector4(440.7567, -1523.9679, 29.2705, 127.1522),
    distance = 15,
    type = "car",
    hideBlip = false,
    blip = {
      id = 357,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  --[[
  
  ["Boats"] = {
    coords = vector3(-795.15, -1510.79, 1.6),
    spawn = vector4(-798.66, -1507.73, -0.47, 102.23),
    distance = 20,
    type = "sea",
    hideBlip = false,
    blip = {
      id = 356,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },

  ["Hangar"] = {
    coords = vector3(-1243.49, -3391.88, 13.94),
    spawn = vector4(-1258.4, -3394.56, 13.94, 328.23),
    distance = 20,
    type = "air",
    hideBlip = false,
    blip = {
      id = 359,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  }
  
    ]]
}

-- Private Garages
Config.PrivGarageCreateCommand = "privategarages"
Config.PrivGarageCreateJobRestriction = {"realestate"}
Config.PrivGarageEnableInteriors = true
Config.PrivGarageHideBlips = false
Config.PrivGarageBlip = {
  id = 357,
  color = 0,
  scale = 0.7
}

-- Job Garages
Config.JobGarageShowBlips = false
Config.JobGarageSetVehicleCommand = "setjobvehicle" -- admin only
Config.JobGarageRemoveVehicleCommand = "removejobvehicle" -- admin only
Config.JobGarageUniqueBlips = false
Config.JobGarageUniqueLocations = false
Config.JobGarageEnableInteriors = false
Config.JobGarageLocations = { -- IMPORTANT - Every garage name must be unique
  ["Police_1_MOP"] = {
    coords = vector4(450.3727, -995.1016, 22.3969, 4.8821), -- mission rtow
    spawn = vector4(454.8608, -975.4548, 22.3969, 92.7932),
    distance = 5,
    job = {"police"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "kodiaqpcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3com", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      --{ model = "supun", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Liftback FL PČR", livery = 0, extras = {}, maxMods = true },            
     -- { model = "21540iunmk", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR", livery = 0, extras = {}, maxMods = true },
      { model = "t6zj", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6 PČR ZJ", livery = 0, extras = {}, maxMods = true },
      { model = "dppassatpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Sedan PČR", livery = 0, extras = {}, maxMods = true },
      { model = "passatdp2", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Alltrack PČR", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflramvel", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM VP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflram2", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM 2", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqpmjfl", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflohs", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM OHS", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaq2rampcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq II. PČR RAM", livery = 0, extras = {}, maxMods = true }, 
      { model = "kodiaq2pcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq II. PČR", livery = 0, extras = {}, maxMods = true }, 
      { model = "touaregpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Touareg III. FL PČR VP", livery = 0, extras = {}, maxMods = true },
      { model = "t61skpv", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR ZJ/SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "toyotaprado", plate = false, minJobGrade = 0, nickname = "Toyota Land Cruiser J150 PČR ZJ/SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "hilux", plate = false, minJobGrade = 0, nickname = "Toyota Hilux 8 FL", livery = 0, extras = {}, maxMods = true },
      { model = "crafter", plate = false, minJobGrade = 0, nickname = "Volkswagen Crafter L3H3", livery = 0, extras = {}, maxMods = true },
      { model = "o2pcr2nonfl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia II. Combi PČR", livery = 0, extras = {}, maxMods = true },
      --{ model = "21540i", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o2fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia II. Liftback FL PČR", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqdp2", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o2flcom", plate = false, minJobGrade = 0, nickname = "Škoda Octavia II. Combi FL PČR", livery = 0, extras = {}, maxMods = true },
      --{ model = "o3new", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Liftback PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3un", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Liftback PČR", livery = 0, extras = {}, maxMods = true },
      { model = "r1250rtp", plate = false, minJobGrade = 0, nickname = "BMW R 1250 RT PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "scala", plate = false, minJobGrade = 0, nickname = "Škoda Scala PČR", livery = 0, extras = {}, maxMods = true },
      { model = "t6long", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6 PČR", livery = 0, extras = {}, maxMods = true },
      { model = "t61pcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "amarok2", plate = false, minJobGrade = 0, nickname = "Volkswagen Amarok I. PČR SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "amarok", plate = false, minJobGrade = 0, nickname = "Volkswagen Amarok I. PČR", livery = 0, extras = {}, maxMods = true },
      { model = "prado2", plate = false, minJobGrade = 0, nickname = "Toyota Land Cruiser J150 PČR", livery = 0, extras = {}, maxMods = true },
      { model = "octaviabac", plate = false, minJobGrade = 0, nickname = "Škoda Octavia IV. Liftback PČR OVK", livery = 0, extras = {}, maxMods = true },


    }
  },

  ["celnisprava_1"] = {
    coords = vector4(536.0939, -42.2614, 70.8194, 192.0335), -- vinewood
    spawn = vector4(543.0161, -48.1046, 70.6551, 210.6550),
    distance = 5,
    job = {"celnisprava"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "supun", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Liftback FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "21540iunmk", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR OSDP 2", livery = 0, extras = {}, maxMods = true },
      { model = "dppassatpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Sedan PČR", livery = 0, extras = {}, maxMods = true },
      { model = "passatdp2", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Alltrack PČR", livery = 0, extras = {}, maxMods = true },
      { model = "t61skpv", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR ZJ/SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "o3un", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Liftback PČR OSDP", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Police_3_ODP"] = { -- dopravka v pici na dalnici
    coords = vector3(1545.6240, 809.7437, 77.0125),
    spawn = vector4(1553.9115, 809.8195, 77.0387, 189.2660),
    distance = 10,
    job = {"police"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {

      { model = "t61pcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqdp2", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. Facelift PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi Facelift RAM PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3un", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Liftback PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "superb21", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Combi Facelift PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "supun2", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Liftback Facelift PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "r1250rtp", plate = false, minJobGrade = 0, nickname = "BMW R 1250 RT PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "21540i", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "21540iunmk", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR OSDP", livery = 0, extras = {}, maxMods = true },  
      { model = "hwp2021", plate = false, minJobGrade = 0, nickname = "BMW 5 G30 Sedan PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqpmjfl", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. Facelift RAM PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaq2rampcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq II. RAM PČR OSDP", livery = 0, extras = {}, maxMods = true }, 
      { model = "o3new", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Liftback PČR OSDP", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Police_4"] = { -- sandy
    coords = vector3(1861.3717, 3683.3328, 33.8352),
    spawn = vector4(1866.4062, 3681.2983, 33.6288, 221.9603),
    distance = 10,
    job = {"police"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "r1200rtp", plate = false, minJobGrade = 0, nickname = "BMW R 1200 RT PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "21540iunmk", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR OSDP 2", livery = 0, extras = {}, maxMods = true },   
      { model = "kodiaqpcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. PČR", livery = 0, extras = {}, maxMods = true },
      { model = "pcrkodiaqDP", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3com", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi PČR", livery = 0, extras = {}, maxMods = true },
      { model = "superb21", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Combi FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      { model = "pcrsuperbDP", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Liftback FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "scalapcr", plate = false, minJobGrade = 0, nickname = "Škoda Scala PČR", livery = 0, extras = {}, maxMods = true },
      { model = "vwt61new", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "t6zj", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6 PČR ZJ", livery = 0, extras = {}, maxMods = true },
      { model = "dppassatpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Sedan PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "passatdp2", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Alltrack PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflramvel", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM VP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflram2", plate = false, minJobGrade = 0, nickname = "kodiaqflram2", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflram", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflohs", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM OHS", livery = 0, extras = {}, maxMods = true },
      { model = "24kodiaqpc", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq II. FL PČR", livery = 0, extras = {}, maxMods = true }, 
      { model = "touaregpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Touareg III. FL PČR VP", livery = 0, extras = {}, maxMods = true },
      { model = "t61skpv", plate = false, minJobGrade = 0, nickname = "Volkswagen T6 SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "toyotaprado", plate = false, minJobGrade = 0, nickname = "Toyota Prado", livery = 0, extras = {}, maxMods = true },
      { model = "hilux", plate = false, minJobGrade = 0, nickname = "Toyota Hilux", livery = 0, extras = {}, maxMods = true },
      { model = "crafter", plate = false, minJobGrade = 0, nickname = "Volkswagen Crafter", livery = 0, extras = {}, maxMods = true },
      { model = "o2pcr2nonfl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia II. Combi PČR", livery = 0, extras = {}, maxMods = true },
      { model = "superb4neoz", plate = false, minJobGrade = 0, nickname = "Škoda Superb neoznačený OVK", livery = 0, extras = {}, maxMods = true },
    }
  },


  ["Police_5"] = { -- paleto
    coords = vector3(-458.9700, 6015.4297, 31.4901),
    spawn = vector4(-463.5227, 6021.9116, 31.3405, 335.6257),
    distance = 10,
    job = {"police"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "r1200rtp", plate = false, minJobGrade = 0, nickname = "BMW R 1200 RT PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "21540iunmk", plate = false, minJobGrade = 0, nickname = "BMW 5 G31 Touring PČR OSDP 2", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqpcr", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. PČR", livery = 0, extras = {}, maxMods = true },
      { model = "pcrkodiaqDP", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3com", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi PČR", livery = 0, extras = {}, maxMods = true },
      { model = "superb21", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Combi FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR", livery = 0, extras = {}, maxMods = true },
      { model = "o3fl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia III. Combi FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      { model = "supun", plate = false, minJobGrade = 0, nickname = "Škoda Superb III. Liftback FL PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "scalapcr", plate = false, minJobGrade = 0, nickname = "Škoda Scala PČR", livery = 0, extras = {}, maxMods = true },
      { model = "vwt61new", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6.1 PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "t6zj", plate = false, minJobGrade = 0, nickname = "Volkswagen Transporter T6 PČR ZJ", livery = 0, extras = {}, maxMods = true },
      { model = "dppassatpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Sedan PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "passatdp2", plate = false, minJobGrade = 0, nickname = "Volkswagen Passat B7 Alltrack PČR OSDP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflramvel", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM VP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflram2", plate = false, minJobGrade = 0, nickname = "kodiaqflram2", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflram", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflohs", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq I. FL PČR RAM OHS", livery = 0, extras = {}, maxMods = true },
      { model = "24kodiaqpc", plate = false, minJobGrade = 0, nickname = "Škoda Kodiaq II. FL PČR", livery = 0, extras = {}, maxMods = true }, 
      { model = "touaregpcr", plate = false, minJobGrade = 0, nickname = "Volkswagen Touareg III. FL PČR VP", livery = 0, extras = {}, maxMods = true },
      { model = "t61skpv", plate = false, minJobGrade = 0, nickname = "Volkswagen T6 SKPV", livery = 0, extras = {}, maxMods = true },
      { model = "toyotaprado", plate = false, minJobGrade = 0, nickname = "Toyota Prado", livery = 0, extras = {}, maxMods = true },
      { model = "hilux", plate = false, minJobGrade = 0, nickname = "Toyota Hilux", livery = 0, extras = {}, maxMods = true },
      { model = "crafter", plate = false, minJobGrade = 0, nickname = "Volkswagen Crafter", livery = 0, extras = {}, maxMods = true },
      { model = "o2pcr2nonfl", plate = false, minJobGrade = 0, nickname = "Škoda Octavia II. Combi PČR", livery = 0, extras = {}, maxMods = true },
      { model = "superb4neoz", plate = false, minJobGrade = 0, nickname = "Škoda Superb neoznačený OVK", livery = 0, extras = {}, maxMods = true },
            
    }
  },


  ["Police_5_Heli"] = {
    coords = vector4(442.7814, -980.3173, 40.7639, 138.5663),
    spawn = vector4(438.8815, -985.0016, 40.7639, 89.4739),
    distance = 5,
    job = {"police"},
    type = "air",
    hideBlip = true,
    blip = { id = 43, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "supervolito", plate = false, minJobGrade = 3, nickname = "Vrtulník", livery = 0, extras = {}, maxMods = true },
    }
  },

  -- ==========================================
  -- HZS
  -- ==========================================
  ["HZS_1"] = {
    coords = vector3(1215.4961, -1484.3960, 34.6923),
    spawn = vector4(1214.1055, -1460.9030, 34.7479, 6.0550),
    distance = 10,
    job = {"hzs"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "o4vea", plate = false, minJobGrade = 0, nickname = "o4vea", livery = 0, extras = {}, maxMods = true },
      { model = "favojsdh", plate = false, minJobGrade = 0, nickname = "favojsdh", livery = 0, extras = {}, maxMods = true },
      { model = "gatorhzs", plate = false, minJobGrade = 0, nickname = "gatorhzs", livery = 0, extras = {}, maxMods = true },
      { model = "vwt61hzs", plate = false, minJobGrade = 0, nickname = "vwt61hzs", livery = 0, extras = {}, maxMods = true },
      { model = "terrno2", plate = false, minJobGrade = 0, nickname = "terrno2", livery = 0, extras = {}, maxMods = true },
      { model = "scanka", plate = false, minJobGrade = 0, nickname = "scanka", livery = 0, extras = {}, maxMods = true },
      { model = "vwtouana", plate = false, minJobGrade = 0, nickname = "vwtouana", livery = 0, extras = {}, maxMods = true },
      { model = "t153", plate = false, minJobGrade = 0, nickname = "t153", livery = 0, extras = {}, maxMods = true },
      { model = "t815", plate = false, minJobGrade = 0, nickname = "t815", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqHZS", plate = false, minJobGrade = 0, nickname = "kodiaqHZS", livery = 0, extras = {}, maxMods = true },
      { model = "hazmat2", plate = false, minJobGrade = 0, nickname = "hazmat2", livery = 0, extras = {}, maxMods = true },
      { model = "techres", plate = false, minJobGrade = 0, nickname = "techres", livery = 0, extras = {}, maxMods = true },
      { model = "t6rza", plate = false, minJobGrade = 0, nickname = "t6rza", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflhzs", plate = false, minJobGrade = 0, nickname = "kodiaqflhzs", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflhzs2", plate = false, minJobGrade = 0, nickname = "kodiaqflhzs2", livery = 0, extras = {}, maxMods = true },
      { model = "respond", plate = false, minJobGrade = 0, nickname = "respond", livery = 0, extras = {}, maxMods = true },
      { model = "scanxt", plate = false, minJobGrade = 0, nickname = "scanxt", livery = 0, extras = {}, maxMods = true },
      { model = "scanxtaz", plate = false, minJobGrade = 0, nickname = "scanxtaz", livery = 0, extras = {}, maxMods = true },
    }
  },

  -- ==========================================
  -- AMBULANCE
  -- ==========================================
  ["Ambulance_1_Podzemi"] = {
    coords = vector3(-1841.7842, -374.0900, 40.7615),
    spawn = vector4(-1837.9775, -378.8398, 40.7287, 326.8292),
    distance = 15,
    job = {"ambulance"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "t6zzs", plate = false, minJobGrade = 0, nickname = "t6zzs", livery = 0, extras = {}, maxMods = true },
      { model = "ovceZZS", plate = false, minJobGrade = 0, nickname = "ovceZZS", livery = 0, extras = {}, maxMods = true },
      { model = "iak_wheelchair", plate = false, minJobGrade = 0, nickname = "iak_wheelchair", livery = 0, extras = {}, maxMods = true },
      { model = "touaregok", plate = false, minJobGrade = 0, nickname = "touaregok", livery = 0, extras = {}, maxMods = true },
      { model = "sprinterzzs2", plate = false, minJobGrade = 0, nickname = "sprinterzzs2", livery = 0, extras = {}, maxMods = true },
      { model = "zzscoro", plate = false, minJobGrade = 0, nickname = "zzscoro", livery = 0, extras = {}, maxMods = true },
      { model = "fenixzzs", plate = false, minJobGrade = 0, nickname = "fenixzzs", livery = 0, extras = {}, maxMods = true },
      { model = "GleZZSIP", plate = false, minJobGrade = 0, nickname = "GleZZSIP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflzzs", plate = false, minJobGrade = 0, nickname = "kodiaqflzzs", livery = 0, extras = {}, maxMods = true },
      { model = "ZZSSprinter", plate = false, minJobGrade = 0, nickname = "ZZSSprinter", livery = 0, extras = {}, maxMods = true },
      { model = "o4zzs", plate = false, minJobGrade = 0, nickname = "o4zzs", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Ambulance_2_Nadzemi"] = {
    coords = vector3(-1880.3229, -320.2722, 49.3883),
    spawn = vector4(-1885.9442, -316.6064, 49.2218, 88.0479),
    distance = 4,
    job = {"ambulance"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "t6zzs", plate = false, minJobGrade = 0, nickname = "t6zzs", livery = 0, extras = {}, maxMods = true },
      { model = "ovceZZS", plate = false, minJobGrade = 0, nickname = "ovceZZS", livery = 0, extras = {}, maxMods = true },
      { model = "iak_wheelchair", plate = false, minJobGrade = 0, nickname = "iak_wheelchair", livery = 0, extras = {}, maxMods = true },
      { model = "touaregok", plate = false, minJobGrade = 0, nickname = "touaregok", livery = 0, extras = {}, maxMods = true },
      { model = "sprinterzzs2", plate = false, minJobGrade = 0, nickname = "sprinterzzs2", livery = 0, extras = {}, maxMods = true },
      { model = "zzscoro", plate = false, minJobGrade = 0, nickname = "zzscoro", livery = 0, extras = {}, maxMods = true },
   --   { model = "fenixzzs", plate = false, minJobGrade = 0, nickname = "fenixzzs", livery = 0, extras = {}, maxMods = true },
      { model = "GleZZSIP", plate = false, minJobGrade = 0, nickname = "GleZZSIP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflzzs", plate = false, minJobGrade = 0, nickname = "kodiaqflzzs", livery = 0, extras = {}, maxMods = true },
      { model = "ZZSSprinter", plate = false, minJobGrade = 0, nickname = "ZZSSprinter", livery = 0, extras = {}, maxMods = true },
      { model = "o4zzs", plate = false, minJobGrade = 0, nickname = "o4zzs", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Ambulance_3_VPici"] = {
    coords = vector3(-1289.5219, -1376.2083, 4.3068),
    spawn = vector4(-1271.2583, -1366.5636, 4.3017, 276.5765),
    distance = 10,
    job = {"ambulance"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "t6zzs", plate = false, minJobGrade = 0, nickname = "t6zzs", livery = 0, extras = {}, maxMods = true },
      { model = "ovceZZS", plate = false, minJobGrade = 0, nickname = "ovceZZS", livery = 0, extras = {}, maxMods = true },
      { model = "iak_wheelchair", plate = false, minJobGrade = 0, nickname = "iak_wheelchair", livery = 0, extras = {}, maxMods = true },
      { model = "touaregok", plate = false, minJobGrade = 0, nickname = "touaregok", livery = 0, extras = {}, maxMods = true },
      { model = "sprinterzzs2", plate = false, minJobGrade = 0, nickname = "sprinterzzs2", livery = 0, extras = {}, maxMods = true },
      { model = "zzscoro", plate = false, minJobGrade = 0, nickname = "zzscoro", livery = 0, extras = {}, maxMods = true },
      { model = "fenixzzs", plate = false, minJobGrade = 0, nickname = "fenixzzs", livery = 0, extras = {}, maxMods = true },
      { model = "GleZZSIP", plate = false, minJobGrade = 0, nickname = "GleZZSIP", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqflzzs", plate = false, minJobGrade = 0, nickname = "kodiaqflzzs", livery = 0, extras = {}, maxMods = true },
      { model = "ZZSSprinter", plate = false, minJobGrade = 0, nickname = "ZZSSprinter", livery = 0, extras = {}, maxMods = true },
      { model = "o4zzs", plate = false, minJobGrade = 0, nickname = "o4zzs", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Ambulance_4_Heli"] = {
    coords = vector4(-1869.1329, -358.4810, 58.0227, 357.5235),
    spawn = vector4(-1866.8882, -352.0341, 58.0352, 142.7250),
    distance = 10,
    job = {"ambulance"},
    type = "air",
    hideBlip = true,
    blip = { id = 43, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "dsa", plate = "EMS", minJobGrade = 0, nickname = "EMS Heli", livery = 0, extras = {}, maxMods = true },
    }
  },

  ["Ambulance_5_Heli"] = {
    coords = vector3(-1286.7345, -1359.4688, 11.4202),
    spawn = vector4(-1285.4198, -1368.4703, 13.5201, 204.0331),
    distance = 10,
    job = {"ambulance"},
    type = "air",
    hideBlip = true,
    blip = { id = 43, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "dsa", plate = "EMS", minJobGrade = 0, nickname = "EMS Heli", livery = 0, extras = {}, maxMods = true },
    }
  },

  -- ==========================================
  -- MECHANIC
  -- ==========================================
  ["Mechanic_1"] = {
    coords = vector3(-349.5494, -148.8585, 39.0105),
    spawn = vector4(-345.4453, -144.0306, 39.0122, 338.4879),
    distance = 7,
    job = {"mechanic"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "odtahovkaczrp", plate = "autokelly", minJobGrade = 0, nickname = "Odtahovka", livery = 0, extras = {}, maxMods = false },
      { model = "flatbedczrp", plate = "autokelly", minJobGrade = 0, nickname = "Vetší Odtahovka", livery = 1, extras = {}, maxMods = false },
      { model = "towtruck2", plate = "autokelly2", minJobGrade = 0, nickname = "Stará Odtahovka", livery = 0, extras = {}, maxMods = false },
    }
  },

  -- ==========================================
  -- BREWERY
  -- ==========================================
  ["Brewery_1"] = {
    coords = vector3(-36.6176, 6421.9346, 31.4736),
    spawn = vector4(-32.9635, 6416.1626, 31.4443, 221.7132),
    distance = 4,
    job = {"brewery"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "sprinter", plate = false, minJobGrade = 0, nickname = "Sprinter", livery = 0, extras = {}, maxMods = false },
    }
  },

  -- ==========================================
  -- TELEVIZE
  -- ==========================================
  ["televize_1"] = {
    coords = vector3(-491.2613, 23.8559, 44.9855),
    spawn = vector4(-487.3960, 20.4792, 44.6151, 91.0730),
    distance = 4,
    job = {"televize"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "newsvan", plate = false, minJobGrade = 0, nickname = "Sprinter", livery = 0, extras = {}, maxMods = false },
    }
  },


  -- ==========================================
  -- HOSPUDKA
  -- ==========================================
  ["Hospudka_1"] = {
    coords = vector3(822.5330, -114.6633, 80.4329),
    spawn = vector4(829.8540, -127.0687, 79.9650, 241.8150),
    distance = 4,
    job = {"hospudka"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "taco", plate = false, minJobGrade = 0, nickname = "Taco", livery = 0, extras = {}, maxMods = false },
      { model = "hospoddod", plate = false, minJobGrade = 0, nickname = "Hospoda Dodávka", livery = 0, extras = {}, maxMods = false },

    }
  },

  -- ==========================================
  -- GIBS
  -- ==========================================
  ["Gibs_1"] = {
    coords = vector3(-487.6363, -249.5993, 35.8554),
    spawn = vector4(-489.7721, -253.3417, 35.6659, 114.8742),
    distance = 7,
    job = {"gibs"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "superb", plate = false, minJobGrade = 0, nickname = "superb", livery = 0, extras = {}, maxMods = false },
      { model = "octaviabac", plate = false, minJobGrade = 0, nickname = "octaviabac", livery = 0, extras = {}, maxMods = false },
      { model = "ACTRPavantum", plate = false, minJobGrade = 0, nickname = "ACTRPavantum", livery = 0, extras = {}, maxMods = false },
    }
  },

  -- ==========================================
  -- POLICIE MP
  -- ==========================================
  ["PolicieMP_1"] = {
    coords = vector3(-361.1941, -243.3688, 32.9370),
    spawn = vector4(-343.7549, -246.9100, 31.9385, 336.4770),
    distance = 7,
    job = {"policie_mp"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "actgdrpaddy", plate = false, minJobGrade = 0, nickname = "actgdrpaddy", livery = 0, extras = {}, maxMods = true },
      { model = "AFPskoda", plate = false, minJobGrade = 0, nickname = "AFPskoda", livery = 0, extras = {}, maxMods = true },
      { model = "enyaqmp", plate = false, minJobGrade = 0, nickname = "enyaqmp", livery = 0, extras = {}, maxMods = true },
      { model = "fabiamp", plate = false, minJobGrade = 0, nickname = "fabiamp", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqmp", plate = false, minJobGrade = 0, nickname = "kodiaqmp", livery = 0, extras = {}, maxMods = true },
      { model = "kodiaqvelitel", plate = false, minJobGrade = 0, nickname = "kodiaqvelitel", livery = 0, extras = {}, maxMods = true },
--      { model = "o2mp", plate = false, minJobGrade = 0, nickname = "o2mp", livery = 0, extras = {}, maxMods = true },
      { model = "octaviaivmp", plate = false, minJobGrade = 0, nickname = "octaviaivmp", livery = 0, extras = {}, maxMods = true },
      { model = "o3combimpo", plate = false, minJobGrade = 0, nickname = "o3combimpo", livery = 0, extras = {}, maxMods = true },
      { model = "sonata", plate = false, minJobGrade = 0, nickname = "sonata", livery = 0, extras = {}, maxMods = true },
--      { model = "t6mpo", plate = false, minJobGrade = 0, nickname = "t6mpo", livery = 0, extras = {}, maxMods = true },
      { model = "t6policen", plate = false, minJobGrade = 0, nickname = "t6policen", livery = 0, extras = {}, maxMods = true },
      { model = "wvtran", plate = false, minJobGrade = 0, nickname = "wvtran", livery = 0, extras = {}, maxMods = true },
    }
  },

  -- ==========================================
  -- IRON WOLVES
  -- ==========================================
  ["IronWolves_1"] = {
    coords = vector3(961.3563, -120.6531, 74.3532),
    spawn = vector4(963.7720, -126.4847, 74.3532, 186.3518),
    distance = 7,
    job = {"ironwolves"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "nightblade", plate = false, minJobGrade = 5, nickname = "nightblade", livery = 0, extras = {}, maxMods = true },
      { model = "sanctus", plate = false, minJobGrade = 5, nickname = "sanctus", livery = 0, extras = {}, maxMods = true },
      { model = "daemon", plate = false, minJobGrade = 0, nickname = "daemon", livery = 0, extras = {}, maxMods = true },
      { model = "daemon2", plate = false, minJobGrade = 0, nickname = "daemon2", livery = 0, extras = {}, maxMods = true },
      { model = "gburrito", plate = false, minJobGrade = 4, nickname = "gburrito", livery = 0, extras = {}, maxMods = true },
    }
  },
    -- ==========================================
  -- PIZZA
  -- ==========================================
  ["pizza"] = {
    coords = vector4(-1339.0747, -1095.5326, 6.9113, 304.0558),
    spawn = vector4(-1328.8813, -1091.6227, 6.9818, 269.1811),
    distance = 7,
    job = {"pizza"},
    type = "car",
    hideBlip = true,
    blip = { id = 357, color = 0, scale = 0.7 },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
    vehiclesType = "spawner",
    showLiveriesExtrasMenu = true,
    vehicles = {
      { model = "vwcaddy", plate = false, minJobGrade = 0, nickname = "nightblade", livery = 0, extras = {}, maxMods = true },
    }
  },
}


-- Gang Garages (QBCore/Qbox only by default)
Config.GangEnableCustomESXIntegration = false -- Set to true if you've added a custom system to cl/sv-functions.lua
Config.GangGarageShowBlips = false
Config.GangGarageSetVehicleCommand = "setgangvehicle" -- admin only
Config.GangGarageRemoveVehicleCommand = "removegangvehicle" -- admin only
Config.GangGarageUniqueBlips = false
Config.GangGarageUniqueLocations = true
Config.GangGarageEnableInteriors = true
Config.GangGarageLocations = { -- IMPORTANT - Every garage name must be unique

}

-- Impound
Config.ImpoundCommand = "odtah"
Config.ImpoundFeesSocietyFund = "police" -- Job name of society fund to pay impound fees into (optional)
Config.ImpoundShowBlips = true
Config.ImpoundUniqueBlips = false
Config.ImpoundTimeOptions = {0, 1, 4, 12, 24, 72, 168} -- in hours
Config.ImpoundLocations = { -- IMPORTANT - Every impound name must be unique
  ["Impound A"] = {
    coords = vector3(408.9516, -1622.7435, 29.2919),
    spawn = vector4(417.2832, -1628.4368, 29.2919, 172.0791),
    distance = 15,
    type = "car",
    job = {"police"},
    hideBlip = false,
    blip = {
      id = 68,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  },
  ["Impound B"] = {
    coords = vector3(1893.5356, 3714.2620, 32.7834),
    spawn = vector4(1888.4395, 3717.1470, 32.8374, 120.3954),
    distance = 15,
    type = "car",
    job = {"police"},
    hideBlip = false,
    blip = {
      id = 68,
      color = 0,
      scale = 0.7
    },
    hideMarkers = true,
    markers = { id = 21, size = { x = 0.3, y = 0.3, z = 0.3 }, color = { r = 255, g = 255, b = 255, a = 120 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 },
  }
}

-- Garage Interior
Config.GarageInteriorEntrance = vector4(227.96, -1003.06, -99.0, 0.0)
Config.GarageInteriorCameraCutscene = {
  vector4(227.96, -977.81, -98.99, 0.0), -- from
  vector4(227.96, -1006.96, -98.99, 0.0), -- to (this should be the entrance, or slightly further back from the entrance coords for a better final player transition)
}
Config.GarageInteriorVehiclePositions = {
  vector4(233.000000, -984.000000, -99.410004, 118.000000),
  vector4(233.000000, -988.500000, -99.410004, 118.000000),
  vector4(233.000000, -993.000000, -99.410004, 118.000000),
  vector4(233.000000, -997.500000, -99.410004, 118.000000),
  vector4(233.000000, -1002.000000, -99.410004, 118.000000),
  vector4(223.600006, -979.000000, -99.410004, 235.199997),
  vector4(223.600006, -983.599976, -99.410004, 235.199997),
  vector4(223.600006, -988.200012, -99.410004, 235.199997),
  vector4(223.600006, -992.799988, -99.410004, 235.199997),
  vector4(223.600006, -997.400024, -99.410004, 235.199997),
  vector4(223.600006, -1002.000000, -99.410004, 235.199997),
}

-- Staff Commands
Config.ChangeVehiclePlate = "vplate" -- admin only
Config.DeleteVehicleFromDB = "dvdb" -- admin only
Config.ReturnVehicleToGarage = "vreturn" -- admin only

-- Add your import vehicle's spawn name and desired label here for pretty vehicle names in the garage
-- This is mainly designed for ESX - if you are using QB, do this in shared!
Config.VehicleLabels = {
  ["spawnName"] = "Pretty Vehicle Label"
}

-- Block certain vehicles from being transferred to other players
Config.PlayerTransferBlacklist = {
  "spawnName"
}

Config.AutoRunSQL = true
Config.ReturnToPreviousRoutingBucket = false
Config.HideWatermark = false
Config.__v3Config = true
Config.Debug = false
