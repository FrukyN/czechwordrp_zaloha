Config = {}
Config.Locale = 'en'

Config.Framework = "ESX" -- ESX, qbcore, qbcore-new

Config.EnableDebug = false -- Enable/Disable prints and showing box of targets
Config.Target = "ox_target" -- ox_target or qb-target

Config.Craftings = {
    ["dylinabar"] = {
        jobs = {["hospudka"] = 0}, -- Required jobs to access table or nil
        gang = nil, -- Required gang to access table or nil (QB ONLY)
        model = gr_prop_gr_bench_04b, -- Table model.
        label = 'otevrit menu', -- Target label
        icon = "fas fa-shield",
        item = "badge", -- item name or nil for no item QB ONLY
        coords = { -- Table Coords
      --      [1] = vector4(829.2480, -110.7757, 79.7303, 326.7903),
      --      [2] = vector4(829.2480, -110.7757, 79.7303, 326.7903),
        },
        items = { -- Items in the crafting table.
            {
                title = "Guláš",
                description = "Guláš",
                progressbar = "Dělaš guláš",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 100, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "cibule", amount = 1},
                    {name = "hovezim", amount = 1},
                    {name = "chleba", amount = 2},                    
                },
                additems = { -- Items that will be given after craft is done
                    {name = "gulas", amount = 1},
                },
            },
            {
                title = "Hovezi Kebab",
                description = "1x salat, 1x rajce, 1x cesnekom, 1x hovezi",
                progressbar = "Delas Kebab",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "salat", amount = 1},
                    {name = "rajce", amount = 1},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "kebab1", amount = 1},
                },
            },
            {
                title = "Kureci Tortilla",
                description = "1x kureci, 1x salat, 1x rajce, 1x bylom",
                progressbar = "Delas Tortillu",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "kureci", amount = 1},
                    {name = "salat", amount = 1},
                    {name = "rajce", amount = 1},
                    {name = "bylom", amount = 1},                                                            
                },
                additems = { -- Items that will be given after craft is done
                    {name = "tortilla22", amount = 1},
                },
            },
            {
                title = "kebab2",
                description = "1x kurureci, 1x salat, 1x rajce, 1x cesnekom",
                progressbar = "Delas Kebab",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "kureci", amount = 1},
                    {name = "salat", amount = 1},
                    {name = "rajce", amount = 1},
                    {name = "cesnekom", amount = 1},                                                            
                },
                additems = { -- Items that will be given after craft is done
                    {name = "kebab2", amount = 1},
                },
            },
            {
                title = "kebab3",
                description = "1x jehneci, 1x salat, 1x rajce, 1x cesnekom",
                progressbar = "Delas Kebab",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "jehneci", amount = 1},
                    {name = "salat", amount = 1},
                    {name = "rajce", amount = 1},
                    {name = "cesnekom", amount = 1},                                                            
                },
                additems = { -- Items that will be given after craft is done
                    {name = "kebab3", amount = 1},                    
                },
            },
            {
                title = "losos",
                description = "1x losos, 1x bylom",
                progressbar = "Delas Lososa",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "losos", amount = 1},
                    {name = "bylom", amount = 1},                                                          
                },
                additems = { -- Items that will be given after craft is done
                    {name = "losos2", amount = 1},
                },
            },
            {
                title = "cibulovekrozky",
                description = "10x cibule",
                progressbar = "Delas Cib Krouzky",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",                
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "cibule", amount = 10},                                                         
                },
                additems = { -- Items that will be given after craft is done
                    {name = "cibule2", amount = 1},

                },
            },
        },
    },
           
        ["KongRestaurace"] = {
        jobs = {["kongrest"] = 0}, -- Required jobs to access table or nil
        gang = nil, -- Required gang to access table or nil (QB ONLY)
        model = gr_prop_gr_bench_04b, -- Table model.
        label = 'otevrit menu', -- Target label
        icon = "fas fa-shield",
        item = "badge", -- item name or nil for no item QB ONLY
        coords = { -- Table Coords
            [1] = vector4(-1238.2343, -268.9691, 37.5989, 190.3601),
      --      [2] = vector4(829.2480, -110.7757, 79.7303, 326.7903),
        },
        items = { -- Items in the crafting table.
            {
                title = "Kung Pao",
                description = "1x kureci, 1x ryze, 1x arasidy, 1x chilli",
                progressbar = "Pripravujes Kung Pao",
                image = "https://cdn.discordapp.com/attachments/.../kungpao.png", -- Sem si dej vlastní odkaz
                duration = 6000,
                requireditems = {
                    {name = "kureci", amount = 1},
                    {name = "ryze", amount = 1},
                    {name = "arasidy", amount = 1},
                    {name = "chilli", amount = 1},
                },
                additems = {
                    {name = "kung_pao", amount = 1},
                },
            },
            {
                title = "Cinska polevka",
                description = "1x instantni_nudle, 1x horka_voda",
                progressbar = "Varis polevku",
                image = "https://cdn.discordapp.com/attachments/.../polevka.png",
                duration = 4000,
                requireditems = {
                    {name = "instantni_nudle", amount = 1},
                    {name = "horka_voda", amount = 1},
                },
                additems = {
                    {name = "cinska_polevka", amount = 1},
                },
            },
            {
                title = "Smazene Nudle",
                description = "1x nudle_syrove, 1x zelenina, 1x kureci",
                progressbar = "Smazis nudle",
                image = "https://cdn.discordapp.com/attachments/.../nudle.png",
                duration = 5500,
                requireditems = {
                    {name = "nudle_syrove", amount = 1},
                    {name = "zelenina", amount = 1},
                    {name = "kureci", amount = 1},
                },
                additems = {
                    {name = "nudle", amount = 1},
                },
            },
            {
                title = "Sushi Set",
                description = "1x ryba, 1x ryze, 1x rasa",
                progressbar = "Motas sushi",
                image = "https://cdn.discordapp.com/attachments/.../sushi.png",
                duration = 7000,
                requireditems = {
                    {name = "ryba", amount = 1},
                    {name = "ryze", amount = 1},
                    {name = "rasa", amount = 1},
                },
                additems = {
                    {name = "sushi2", amount = 1},
                },
            },
        },
    },
}