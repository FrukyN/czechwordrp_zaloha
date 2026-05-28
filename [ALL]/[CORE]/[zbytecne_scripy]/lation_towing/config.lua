Config = {}

--[[ General Configs ]]
Config.Framework = 'esx' -- 'esx', 'qbcore' or 'standalone'
Config.RequireJob = false  -- Do you want this to be only for players with a specific job? (True if yes, false if no. You must set framework to 'esx' or 'qbcore' for this feature)
Config.JobName = 'tow' -- The job name required if Config.JobLock is true
Config.StartJobPedModel = 'a_m_m_business_01' -- The model of the ped that starts the job
Config.StartJobLocation = vec3(411.2884, -1620.2120, 28.2920) -- The location at which you start the job (and the map blip location)
Config.DeliverLocation = vec3(403.0332, -1632.3462, 29.2839) -- The location at which you deliver vehicles
Config.DeliverRadius = 24 -- The radius at which the player must be within (in relation to DeliverLocation) to get paid for delivering
Config.StartJobRadius = 50 -- The distance at which once a player is within the ped will spawn/be visable
Config.StartJobPedHeading = 213.637786 -- The direction at which the start job ped is facing
Config.SpawnTruckLocation = vector3(407.1526, -1644.8938, 29.4033) -- The location at which the tow truck spawns to start the job
Config.SpawnTruckHeading = 228.9518 -- The direction the tow truck being spawned is facing
Config.EnableCarKeys = false -- This is for ESX/Standalone only, QBCore key system already works even when set to false
Config.MinWaitTime = 1 -- The minimum wait time in minutes for a new job assignment
Config.MaxWaitTime = 3 -- The maximum wait time in minutes for a new job assignment

--[[ Pay Conigs ]]
Config.PayPerDelivery = 1000 -- How much the player is paid per delivery completed
Config.PayPerDeliveryAccount = 'money' -- Pay in cash with 'money' or to the bank with 'bank'
Config.RandomPayPerDelivery = true -- Set true if you want randomized pay, set false for same amount (PayPerDelivery).
Config.MinPayPerDelivery = 1500 -- If Config.RandomPayPerDelivery = true then what is the minimum pay? (If RandomPay false, ignore this)
Config.MaxPayPerDelivery = 4400 -- If Config.RandomPayPerDelivery = true then what is the maxmimum pay? (If RandomPay false, ignore this)

Config.Blips = {
    startJob = {
        blipSprite = 477, -- https://docs.fivem.net/docs/game-references/blips/
        blipColor = 21, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        blipScale = 0.8,
        blipName = ("<font face='Roboto'>[BRIGÁDA]: Odtahová služba</font>")
    },
    pickupVehicle = {
        blipSprite = 380,
        blipColor = 1,
        blipScale = 1.0,
        blipName = 'Vozidlo na odtazeni'
    },
    dropOff = {
        blipSprite = 68,
        blipColor = 2,
        blipScale = 1.0,
        blipName = 'Odstaveni vozidla'
    }
}

--[[ Car Spawns - Must Follow Format ]]
Config.Locations = {
    { x = 1015.3276, y = -2462.3572, z = 27.7853, h = 82.8159 },
    { x = -247.7807, y = -1687.8434, z = 33.4754, h = 178.8647 },
    { x = 372.9686, y = -767.0320, z = 29.2700, h = 0.0682 },
    { x = -1276.2042, y = -556.5905, z = 30.2092, h = 219.8612 },
    { x = 1205.2948, y = -708.5202, z = 59.4169, h = 9.6660 },
    { x = 213.8225, y = 389.6160, z = 106.5621, h = 171.4204 },
    { x = -449.8099, y = 98.6727, z = 62.8731, h = 355.5552 },
    { x = -928.4528, y = -124.9771, z = 37.2992, h = 117.7664 },
    { x = -1772.7124, y = -519.8768, z = 38.5269, h = 299.9457 },
    { x = -2165.7588, y = -420.4905, z = 13.0514, h = 20.4053 },
    { x = -1483.1953, y = -895.6342, z = 9.7399, h = 64.1165 },
    { x = 285.0289, y = -1240.8114, z = 28.7927, h = 3.6427 },
    { x = 174.4495, y = -1011.8644, z = 28.8535, h = 205.9382 }


}

--[[ Car Models ]]
Config.CarModels = {
    'felon',
    'prairie',
    'baller',
    'sentinel',
    'zion',
    'ruiner',
    'asea',
    'ingot',
    'intruder',
    'primo',
    'stratum',
    'tailgater'
}

--[[ String Configs ]]
Notifications = {
    position = 'top', -- The position of all notifications
    icon = 'truck-ramp-box', -- The icon displayed for all notifications
    title = 'Odtahovka', -- The title for all notifications
    notAuthorized = 'K provádění této práce nejsI oprávněni – musíte být' ..Config.JobName,
    successfulVehicleLoad = 'Úspěšně jsI naložili vozidlo na odtahovku',
    cancelledVehicleLoad = 'Nepodařilo se ti naložit vozidlo',
    notCloseEnough = 'Nejsi dostatečně blízko vozidla, který se pokoušíš odtáhnout',
    sucessfulVehicleUnload = 'Úspěšně jsi vyložil vozidlo',
    cancelledVehicleUnload = 'Zrušil jsi vykládání vozidla',
    error = 'Něco se pokazilo zkus to prosím později',
    noVehicleToUnload = 'Nemáš přece žádné vozidlo na vyložení',
    towTruckSpawnOccupied = 'Místo pro spown je momentálně obsazené',
    clockedIn = 'Za nedlouho ti přijde GPS a prácí, počkej si',
    tooFarToDeliver = 'Jsi moc daleko od cíle na zisk výplaty',
    confirmNextJob = 'Jsi frajer, za chvili přijdě další zakázka',
    searchingForJob = 'Čekání na další zakázku',
    jobAssigned = 'A je to tu nová zakázka na GPS, honem jeď'
}

Target = {
    distance = 2, -- The radius at which target options are visable from the target for all target options
    loadVehicle = 'Naložit vozidlo',
    loadVehicleIcon = 'fas fa-truck-ramp-box',
    unloadVehicle = 'Vyložit vozidlo',
    unloadVehicleIcon = 'fas fa-truck-ramp-box',
    startJob = 'Mluvit',
    startJobIcon = 'fas fa-truck'
}

ContextMenu = {
    menuTitle = 'Odtah',
    towTruckTitle = 'Odtahovka',
    towTruckDescription = 'Převezměte odtahovku a začněte pracovat',
    towTruckIcon = 'truck',
    clockInTitle = 'Zahájit službu',
    clockInDescription = 'Zahaj službu a počkej až přijde první zakázka', -- This description displays whilst not clocked in
    clockInDescription2 = 'Již máš zahájenou službu, čekej na zakázku', -- This description displays whilst clocked in
    clockInIcon = 'clock',
    clockOutTitle = 'Ukončit službu',
    clockOutDescription = 'vrať odtahovku a ukonči službu', -- This description displays whilst clocked in
    clockOutDescription2 = 'Nemáš zahájenou službu', -- This description displays whilst not clocked in
    clockOutIcon = 'clock'
}

ProgressCircle = {
    position = 'middle', -- The position for all Progress Circles
    loadVehicleLabel = 'nakládání...',
    loadVehicleDuration = 5000,
    unloadVehicleLabel = 'Vykládání...',
    unloadVehicleDuration = 5000
}

AlertDialog = {
    header = 'Dispetch',
    content = 'Moc děkujeme za odtažení vozidla, přejete si pokračovat?',
}