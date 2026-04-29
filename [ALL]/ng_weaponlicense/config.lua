-- PRECONFIGURED FOR GABZ MRPD

WeaponLicenseConfig = {}

WeaponLicenseConfig.Locale = 'cs' -- 'en' for english, 'fr' for french, 'de' for german, 'es' for spanish, etc add more to locales.lua if needed.

WeaponLicenseConfig.DiscordWebhook = {
    enabled = true, -- Set to false to disable webhook notifications
    url = "https://discord.com/api/webhooks/1459717717132312618/AuB-3VQiOylacFRNjUUU-aJGISDnWzDhp1CVlPRxd9wMfdQV7HDn5WKdvIoX-k9jA974", -- Replace with your actual webhook URL
    botName = "Weapon License System",
    color = 3447003 -- Blue color (you can change this to any decimal color code)
}

-- Police rank requirements
WeaponLicenseConfig.RankRequirements = {
    enabled = true, -- Set to false to disable rank requirements
    applications = {
        -- Jobs and their minimum required grades to review applications
        police = 0,    -- Grade 2 and above can review applications
        sheriff = 2,   -- Grade 1 and above can review applications  
        ambulance = 0        -- Grade 0 and above can review applications
    },
    records = {
        -- Jobs and their minimum required grades to access license records
        police = 0,    -- Grade 3 and above can access records
        sheriff = 2,   -- Grade 2 and above can access records
        ambulance = 0        -- Grade 1 and above can access records
    }
}

-- Target locations for applications
WeaponLicenseConfig.ApplicationLocations = {
    {
        coords = vector3(441.8159, -988.0763, 30.7095), -- Mission Row PD
        size = vector3(3.0, 2.0, 2.0),
        rotation = 0,
        debug = true,
        label = "Weapon License Application"
    }
}

-- Target locations for license records management
WeaponLicenseConfig.RecordsLocations = {
    {
        coords = vector3(453.3187, -987.2363, 30.2522), -- Mission Row PD
        size = vector3(9.0, 6.0, 3.0),
        rotation = 0,
        debug = true,
        label = "Weapon License Records"
    }
}

-- Target locations for taking the exam
WeaponLicenseConfig.ExamLocations = {
    {
        coords = vector3(443.1247, -991.0545, 30.2478), -- Mission Row PD
        size = vector3(2.0, 2.0, 1.5),
        rotation = 0,
        debug = true,
        label = "Weapon License Exam"
    },
--[[
    {
        coords = vector3(446.7635, -977.8757, 30.2510), -- Mission Row PD
        size = vector3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        label = "Weapon License Exam"
    },
    {
        coords = vector3(442.8742, -987.9954, 35.0000), -- Mission Row PD
        size = vector3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        label = "Weapon License Exam"
    },
    {
        coords = vector3(442.8940, -983.4362, 35.0000), -- Mission Row PD
        size = vector3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        label = "Weapon License Exam"
    },
    {
        coords = vector3(444.9651, -983.3702, 35.0000), -- Mission Row PD
        size = vector3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        label = "Weapon License Exam"
    },
    {
        coords = vector3(447.2507, -983.3260, 35.0000), -- Mission Row PD
        size = vector3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        label = "Weapon License Exam"
    }
]]
}

-- Police jobs that can approve applications
WeaponLicenseConfig.PoliceJobs = {
    'police',
    'sheriff',
    'fbi'
}

-- Exam settings
WeaponLicenseConfig.ExamSettings = {
    questionsToPass = 5, -- How many questions must be answered correctly
    totalQuestions = 10,  -- Total number of questions in the exam
    timeLimit = 300,      -- Time limit in seconds (5 minutes)
}

-- Inventory item settings
WeaponLicenseConfig.GiveItem = true -- Set to false to disable item giving
WeaponLicenseConfig.ItemName = 'wl'
WeaponLicenseConfig.ItemLabel = 'Weapon License'

WeaponLicenseConfig.ApplicationCost = {
    enabled = true,  -- Set to false to disable application cost
    amount = 10000     -- Cost in dollars to submit application
}

-- License settings
WeaponLicenseConfig.LicenseType = 'weapon' -- License type to add to player in the database

-- Replacement NPC location
WeaponLicenseConfig.ReplacementNPC = {
    coords = vector4(442.7125, -982.0085, 0.6896, 90.8691), -- Mission Row PD (x, y, z, heading)
    model = 's_m_y_cop_01', -- NPC model
    label = "License Replacement Officer"
}

-- Replacement cost
WeaponLicenseConfig.ReplacementCost = {
    enabled = true,
    amount = 100
}

-- Strike system
WeaponLicenseConfig.StrikeSystem = {
    enabled = true,
    maxStrikes = 3 -- License gets revoked after this many strikes
}

-- Exam questions
WeaponLicenseConfig.ExamQuestions = {
    {
        question = "Co je to 'Nutná obrana' podle trestního zákoníku ČR?",
        answers = {
            A = "Čin jinak trestný, kterým někdo odvrací přímo hrozící nebo trvající útok na zájem chráněný trestním zákonem",
            B = "Stav, kdy mohu použít zbraň proti komukoliv, kdo vstoupí na můj pozemek",
            C = "Možnost potrestat útočníka poté, co svůj útok ukončil a snaží se utéct",
            D = "Právo zastřelit osobu, která mi slovně nadává"
        },
        correct = 'A'
    },
    {
        question = "Kdy je obrana považována za 'zjevně nepřiměřenou' (exces)?",
        answers = {
            A = "Když je obránce silnější než útočník",
            B = "Když je obrana zcela očividně přehnaná vzhledem ke způsobu útoku (např. zastřelení dítěte kvůli krádeži jablka)",
            C = "Vždy, když je použita střelná zbraň proti neozbrojenému útočníkovi",
            D = "České právo pojem nepřiměřená obrana nezná"
        },
        correct = 'B'
    },
    {
        question = "Můžete nosit zbraň, pokud jste požili alkohol nebo jinou návykovou látku?",
        answers = {
            A = "Ano, pokud hladina alkoholu v krvi nepřesáhne 0.5 promile",
            B = "Ano, ale pouze v případě, že je zbraň v pouzdře",
            C = "Ne, držitel zbrojního průkazu nesmí nosit zbraň nebo s ní manipulovat pod vlivem alkoholu či drog",
            D = "Ano, zákon alkohol u držitelů zbraní neřeší"
        },
        correct = 'C'
    },
    {
        question = "Jste svědkem ozbrojené loupeže v obchodě. Útočník vás nevidí. Jaký je nejvhodnější postup?",
        answers = {
            A = "Okamžitě zahájit palbu na útočníka",
            B = "Vyzvat útočníka, aby odložil zbraň, a pokud neposlechne, střelit ho do nohy",
            C = "Zajistit vlastní bezpečnost, zavolat policii (158) a zasáhnout pouze v případě přímého ohrožení života",
            D = "Snažit se útočníka fyzicky zpacifikovat pomocí hmatů a chvatů"
        },
        correct = 'C'
    },
    {
        question = "Co znamená pojem 'Krajní nouze'?",
        answers = {
            A = "Stav, kdy odvracíte nebezpečí přímo hrozící zájmu chráněnému zákonem (např. útok psa, požár, povodeň)",
            B = "Situace, kdy nemáte peníze na zaplacení nájmu",
            C = "Právo nosit zbraň viditelně na veřejnosti",
            D = "Povinnost uposlechnout výzvy policisty"
        },
        correct = 'A'
    },
    {
        question = "Při silniční kontrole vás zastaví policista. Máte u sebe skrytě nošenou zbraň. Co musíte udělat?",
        answers = {
            A = "Nic, pokud se policista nezeptá",
            B = "Okamžitě zbraň vytáhnout a ukázat ji policistovi, aby věděl, že jste legální držitel",
            C = "Mít ruce na volantu a při prvním kontaktu policistu upozornit, že jste držitelem ZP a máte u sebe zbraň",
            D = "Vystoupit z auta s rukama nad hlavou"
        },
        correct = 'C'
    },
    {
        question = "Kdo je v ČR oprávněn kontrolovat váš zbrojní průkaz a průkaz zbraně?",
        answers = {
            A = "Jakýkoliv občan, který má podezření, že máte zbraň",
            B = "Pouze příslušník Policie ČR",
            C = "Starosta obce nebo pracovníci městského úřadu",
            D = "Majitel obchodu, do kterého vstupujete"
        },
        correct = 'B'
    },
    {
        question = "Jak musíte nosit zbraň kategorie lokace E (ochrana života, zdraví a majetku)?",
        answers = {
            A = "Viditelně v prostorech přístupných veřejnosti",
            B = "Vždy skrytě",
            C = "Zbraň musí být vždy nenabitá v uzamčeném kufříku",
            D = "Zákon způsob nošení neurčuje"
        },
        correct = 'B'
    },
    {
        question = "Může držitel zbrojního průkazu skupiny E použít zbraň k varovnému výstřelu do vzduchu?",
        answers = {
            A = "Ano, je to povinný krok před každým výstřelem na útočníka",
            B = "Ano, ale pouze v případě, že tím neohrozí nikoho dalšího a je to v rámci nutné obrany",
            C = "Ne, varovné výstřely jsou v ČR přísně zakázány",
            D = "Ano, ale pouze na střelnici"
        },
        correct = 'B'
    },
    {
        question = "Na jakou vzdálenost je v ČR považován útok nožem za bezprostředně ohrožující život (tzv. pravidlo 7 metrů)?",
        answers = {
            A = "Zhruba 7 metrů – útočník tuto vzdálenost překoná dříve, než stihnete efektivně reagovat",
            B = "Pouze na dotek těla",
            C = "20 metrů",
            D = "Vzdálenost nehraje roli, nůž není nebezpečná zbraň"
        },
        correct = 'A'
    }
}
function _U(str, ...)
    if Locales[WeaponLicenseConfig.Locale] and Locales[WeaponLicenseConfig.Locale][str] then
        return string.format(Locales[WeaponLicenseConfig.Locale][str], ...)
    else
        return 'Translation [' .. WeaponLicenseConfig.Locale .. '][' .. str .. '] does not exist'
    end
end