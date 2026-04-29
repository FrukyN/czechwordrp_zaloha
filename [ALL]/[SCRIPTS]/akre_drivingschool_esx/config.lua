Config = {}

Config.Target = 'ox' -- 'ox'
Config.Units = "kmh," -- "kmh" or "mph"

Config.TestPrice = 300

Config.License = {
    ["A"] = "motorcycle",
    ["B"] = "drive",
    ["C"] = "truck",
    ["D"] = "bus"
}

Config.Blip = {
    enabled = true,
    sprite = 498,
    display = 4,
    scale = 0.8,
    color = 47,
    shortRange = true,
    name = 'Autoškola'
}

Config.DrivingSchoolPed = {
    model = 'a_m_y_business_03',
    coords = vec4(241.0731, -1378.8107, 33.7417, 137.7335), 
    scenario = 'WORLD_HUMAN_CLIPBOARD',
    target = {
        icon = 'fas fa-book',
        label = 'Začít teoretický test',
        distance = 2.5
    }
}

Config.DrivingInstructorPed = {
    model = 's_m_m_security_01',
    coords = vec4(242.7894, -1381.8431, 33.7417, 44.8907),
    scenario = 'WORLD_HUMAN_CLIPBOARD',
    target = {
        icon = 'fas fa-car',
        distance = 2.5
    }
}

Config.Notify = {
    system = "ox", -- "esx" or "ox"
    messages = {
        -- Payment messages
	payment_success = "Zaplatil jsi {price} Kč",
	insufficient_funds = "Nemáš dostatek hotovosti! Potřebuješ {price} Kč",

	-- Zprávy k teorii
	theory_pass = "Úspěšně jsi dokončil teoretický test! Nyní musíš splnit jízdní lekce.",
	theory_fail = "Neuspěl jsi u teoretického testu.",
	theory_required = "Nejprve musíš dokončit teoretický test!",

	-- Zprávy k řidičákům
	license_A = "Získal jsi řidičský průkaz skupiny A (motocykly)",
	license_B = "Získal jsi řidičský průkaz skupiny B (osobní auta)",
	license_C = "Získal jsi řidičský průkaz skupiny C (nákladní auta)",
	license_D = "Získal jsi řidičský průkaz skupiny D (autobusy)",

	-- Zprávy k jízdnímu testu
	test_started = "Jízdní test začal! Sleduj žluté značky a dodržuj rychlostní limity.",
	penalty_limit = "Můžeš dostat maximálně 3 trestné body, jinak test nesplníš!",
	speed_limit = "Rychlostní limit v této zóně: {limit} {unit}",
	checkpoint_complete = "Checkpoint {current} dokončen! Pokračuj k dalšímu.",
	test_passed = "Úspěšně jsi dokončil jízdní test! Trestné body: {points}/3",
	test_passed_final = "Úspěšně jsi dokončil jízdní test!",
	test_failed = "Neuspěl jsi u jízdního testu! Příliš mnoho trestných bodů: {points}/3",
	test_failed_reason = "Test nesplněn! Důvod: {reason}",

	-- Zprávy k vozidlu
	vehicle_destroyed = "Testovací vozidlo bylo zničeno nebo zmizelo! Test ukončen.",
	vehicle_abandoned = "Opustil jsi testovací vozidlo! Test nesplněn.",
	return_vehicle = "Vrať se do autoškoly a odevzdej vozidlo!",

	-- Důvody neúspěchu
	penalty_limit_reached = "Příliš mnoho trestných bodů",
	vehicle_destroyed_reason = "Vozidlo bylo zničeno",
	vehicle_abandoned_reason = "Vozidlo bylo opuštěno",

	-- Oznámení o překročení rychlosti
	speeding_penalty = "Překročil jsi rychlostní limit ({limit} {unit})! Trestný bod! ({points}/3)",
	speeding_fail = "Překročil jsi rychlostní limit ({limit} {unit})! Dosáhl jsi 3 trestných bodů. Test nesplněn."

    }
}

Config.LicenseTypes = {
    B = {
        label = "Skupina B (Vozidlo do 3500KG)",
        price = 16000,
        vehicle = "autoskola",
        vehicleLabel = "Vehicle",
        target = {
            icon = 'fas fa-car-side'
        }
    },

    A = {
        label = "Skupina A (Motocykl)",
        price = 15000,
        vehicle = "pcj",
        vehicleLabel = "Motorcycles",
        target = {
            icon = 'fas fa-motorcycle'
        }
    },


    C = {
        label = "Skupina C (Nákladní vozidla)",
        price = 22000,
        vehicle = "mule",
        vehicleLabel = "Trucks",
        target = {
            icon = 'fas fa-truck',
        }
    },
    D = {
        label = "Skupina D (Autobus)",
        price = 24000,
        vehicle = "bus",
        vehicleLabel = "Bus",
        target = {
            icon = 'fas fa-bus'
        }
    }

}

Config.StartLocations = {
    vec4(238.1487, -1411.7401, 30.2483, 328.5504),
    vec4(240.7646, -1413.3508, 30.2494, 327.6136),
    vec4(243.5157, -1416.1011, 30.2487, 325.2063),
    vec4(239.7772, -1402.0809, 30.2465, 273.9137)
}

Config.TestRoutes = {
    {
        {coords = vec3(258.2470, -1396.2482, 30.2068), radius = 5.0, speedLimit = 55},
        {coords = vec3(268.4279, -1385.1602, 31.6543), radius = 5.0, speedLimit = 55},
        {coords = vec3(257.0144, -1346.0087, 31.9243), radius = 5.0, speedLimit = 55},
        {coords = vec3(220.4473, -1407.3937, 29.3415), radius = 5.0, speedLimit = 55},
    },
}
Config.TestQuestions = {
    {
        question = "Jaká je maximální povolená rychlost v obci?",
        options = {
            "30 km/h",
            "50 km/h",
            "70 km/h",
            "90 km/h"
        },
        correct = "50 km/h"
    },
    {
        question = "Co musíte udělat na značce STOP?",
        options = {
            "Zastavit a pokračovat až když je to bezpečné",
            "Pokračovat pomalu bez zastavení",
            "Zastavit jen když jede jiné auto",
            "Projíždět vždy bez zastavení"
        },
        correct = "Zastavit a pokračovat až když je to bezpečné"
    },
    {
        question = "Kdo má přednost na přechodu pro chodce?",
        options = {
            "Řidič auta",
            "Chodec",
            "Ten kdo jede rychleji",
            "Nikdo"
        },
        correct = "Chodec"
    },
    {
        question = "Jaká je maximální rychlost na dálnici v ČR?",
        options = {
            "110 km/h",
            "120 km/h",
            "130 km/h",
            "150 km/h"
        },
        correct = "130 km/h"
    },
    {
        question = "Co značí červená na semaforu?",
        options = {
            "Tutnost zastavit vozidlo",
            "Pokračovat opatrně",
            "Jet rychleji",
            "Zastavit jen když je provoz"
        },
        correct = "Zastavit vozidlo"
    },
    {
        question = "Kdy musíte mít zapnuté bezpečnostní pásy?",
        options = {
            "Jen na dálnici",
            "Jen v obci",
            "Vždy, pokud jimi je vozidlo vybaveno",
            "Nikdy"
        },
        correct = "Vždy, pokud jimi je vozidlo vybaveno"
    },
    {
        question = "Jaká je povolená hladina alkoholu v krvi pro řidiče v ČR?",
        options = {
            "0.0 ‰",
            "0.2 ‰",
            "0.5 ‰",
            "1.0 ‰"
        },
        correct = "0.0 ‰"
    },
    {
        question = "Co znamená dopravní značka kruhový objezd?",
        options = {
            "Zastavit a pokračovat",
            "Přednost mají vozidla v objezdu",
            "Můžete vjet bez ohledu na provoz",
            "Musíte jet rovně"
        },
        correct = "Přednost mají vozidla v objezdu"
    },
    {
        question = "Jaká je maximální rychlost mimo obec?",
        options = {
            "70 km/h",
            "80 km/h",
            "90 km/h",
            "110 km/h"
        },
        correct = "90 km/h"
    },
}