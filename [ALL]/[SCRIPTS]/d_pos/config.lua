Config = {}

-- Webhook pro Discord logy (Vlož své URL)
Config.DiscordWebhook = "https://discord.com/api/webhooks/1487412183049699469/c45dOx0D5ePeU6Oh9mjknz4qXfM8RoqnGePZ3gGCqxsYFwgXTKvwAdzI1Sw1UFNReUys"

Config.Currency = "Kč" -- Symbol měny

Config.Registers = {
    ["stk"] = {
        label = "Pokladna - STK",
        -- TADY MŮŽEŠ PŘIDÁVAT DALŠÍ SLOTY (KASY)
        color = "#ffae00", -- Růžová pro bar
        locations = {
            { coords = vec3(946.79, -1042.13, 40.68), radius = 1.5 }, -- Kasa 1
            { coords = vec3(949.67, -1035.11, 40.68), radius = 1.5 }, -- Kasa 2 (příklad)
            -- Sem můžeš dopisovat další...
        },
        job = "stk",
        grade = 1,
        societyAccount = "society_stk",
        items = {
            { label = "Pravidelná STK kontrola", price = 6000, icon = "🔧", category = "STK" },
            { label = "Opravná STK kontrola", price = 2500, icon = "🛠️", category = "STK" },
            { label = "Manipulační přirážka po opkakované kontrole", price = 500, icon = "💲", category = "STK" },
        }
    },
    ["Bahama & Night Bar"] = {
        label = "Pokladna - Bahama",
        -- TADY MŮŽEŠ PŘIDÁVAT DALŠÍ SLOTY (KASY)
        color = "#ff00ff", -- Růžová pro bar
        locations = {
            { coords = vec3(-1379.39, -629.81, 31.04), radius = 1.5 }, -- Kasa 1
            { coords = vec3(-1376.40, -627.84, 31.04), radius = 1.5 }, -- Kasa 2 (příklad)
            { coords = vec3(-1372.88, -625.56, 31.04), radius = 1.5 }, -- Kasa 3 (příklad)

            -- Sem můžeš dopisovat další...
        },
        job = "bahama",
        grade = 1,
        societyAccount = "society_bahama",
        items = {
            -- COCKTAILY
            { label = "Sex on the Beach", price = 250, icon = "🍹", category = "Cocktaily" },
            { label = "Piña Colada", price = 280, icon = "🥥", category = "Cocktaily" },
            { label = "Mojito Fresh", price = 220, icon = "🍃", category = "Cocktaily" },
            { label = "Tequila Sunrise", price = 260, icon = "🌅", category = "Cocktaily" },
            { label = "Cuba Libre Classic", price = 210, icon = "🥃", category = "Cocktaily" },
            { label = "Blue Lagoon", price = 240, icon = "🌊", category = "Cocktaily" },
            { label = "Mai Tai Exotic", price = 310, icon = "🌺", category = "Cocktaily" },
            { label = "Long Island XXL", price = 450, icon = "🍹", category = "Cocktaily" },
            { label = "Cosmopolitan", price = 230, icon = "🍸", category = "Cocktaily" },
            { label = "Aperol Spritz", price = 190, icon = "🍊", category = "Cocktaily" },
            
            -- SHOTY
            { label = "Tequila", price = 90, icon = "🌵", category = "Shoty" },
            { label = "Jägermeister", price = 95, icon = "🦌", category = "Shoty" },
            { label = "Vodka", price = 80, icon = "🧊", category = "Shoty" },
            { label = "B52", price = 120, icon = "🔥", category = "Shoty" },
            { label = "Kamikaze", price = 110, icon = "✈️", category = "Shoty" },
            { label = "Fireball", price = 100, icon = "☄️", category = "Shoty" },
        }
    },
    ["pizza"] = {
        label = "Pokladna - Pizzerie",
        -- TADY MŮŽEŠ PŘIDÁVAT DALŠÍ SLOTY (KASY)
        color = "#3770eb", -- Růžová pro bar
        locations = {
            { coords = vec3(-1346.19, -1065.90, 7.31), radius = 1.5 }, -- Kasa 1
            -- Sem můžeš dopisovat další...
        },
        job = "pizza",
        grade = 1,
        societyAccount = "society_pizza",
        items = {
            { label = "Margherita", price = 2600, icon = "🍕", category = "Pizzy" }, -- Královna pizz: sugo, mozzarella, bazalka
            { label = "Marinara", price = 2400, icon = "🧄", category = "Pizzy" },    -- Bez sýra: sugo, česnek, oregano
            { label = "Quattro Formaggi", price = 3000, icon = "🧀", category = "Pizzy" }, -- Čtyři druhy sýra
            { label = "Capricciosa", price = 2800, icon = "🍄", category = "Pizzy" }, -- Šunka, žampiony, artyčoky, olivy
            { label = "Quattro Stagioni", price = 2900, icon = "📅", category = "Pizzy" }, -- Čtyři roční období (rozdělené čtvrtiny)
            { label = "Diavola", price = 2200, icon = "🔥", category = "Pizzy" },     -- Pálivý salám a papričky
            { label = "Margherita Kousek", price = 1200, icon = "🍕", category = "Pizzy Kousky" }, -- Královna pizz: sugo, mozzarella, bazalka
            { label = "Marinara Kousek", price = 1100, icon = "🧄", category = "Pizzy Kousky" },    -- Bez sýra: sugo, česnek, oregano
            { label = "Quattro Formaggi Kousek", price = 1200, icon = "🧀", category = "Pizzy Kousky" }, -- Čtyři druhy sýra
            { label = "Capricciosa Kousek", price = 1150, icon = "🍄", category = "Pizzy Kousky" }, -- Šunka, žampiony, artyčoky, olivy
            { label = "Quattro Stagioni Kousek", price = 1500, icon = "📅", category = "Pizzy Kousky" }, -- Čtyři roční období (rozdělené čtvrtiny)
            { label = "Diavola Kousek", price = 1100, icon = "🔥", category = "Pizzy Kousky" },     -- Pálivý salám a papričky
            ------ pití
            { label = "Becherovka", price = 200, icon = "🍄", category = "Nápoje" }, -- Šunka, žampiony, artyčoky, olivy
            { label = "Pivo", price = 210, icon = "📅", category = "Nápoje" }, -- Čtyři roční období (rozdělené čtvrtiny)
            { label = "Voda", price = 150, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky
            { label = "Jaggermeister", price = 350, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky            
            { label = "Víno", price = 2700, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky
            { label = "Burčák", price = 850, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky
            { label = "Monster", price = 400, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky
            { label = "CocaCola", price = 350, icon = "🔥", category = "Nápoje" },     -- Pálivý salám a papričky  
            ----------jídlo
            { label = "Bramburky", price = 500, icon = "🔥", category = "Ostatní" },     -- Pálivý salám a papričky           

        }
    },
}