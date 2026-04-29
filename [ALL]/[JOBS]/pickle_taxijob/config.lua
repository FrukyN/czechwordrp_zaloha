Config = {}

Config.Debug = true

Config.Language = "en"

Config.Businesses = {
    {
        info = { 
            id = "taxi",
            society = "taxi",
            label = "Taxi služba",
        },
        blip = {
            Label = "Taxi služba",
            Location = vector3(912.0522, -174.0470, 74.2908),
            ID = 198,
            Display = 4,
            Scale = 0.8,
            Color = 5
        },
        groups = {
            ["taxi"] = 0,
        },
        bossgroups = {
            ["taxi"] = 4,
        },
        vehicles = {
            {
                label = "Taxi", 
                model = `taxi`, 
                groups = {
                    ["taxi"] = 0,
                }
            },
--[[
            {
                label = "OctaviaTaxi", 
                model = `taxioct`, 
                groups = {
                    ["taxi"] = 0,
                }
            },
            {
                label = "Limo", 
                model = `stretch`, 
                groups = {
                    ["taxi"] = 1,
                }
            },
            {
                label = "Dodávka", 
                model = `trans_mbv250`, 
                groups = {
                    ["taxi"] = 1,
                }
            },

]]
        },
        locations = {
            vehicle = vector4(885.019776, -150.329666, 69.382446, 150.236222),
            boss = vector3(902.953858, -164.386810, 74.218262),
            duty = vector3(904.826354, -155.709884, 74.218262)
        }
    }
}

Config.Missions = {
    loop = false, -- Keep doing missions until /taxijob is used.
    reward = {name = "money", min = 250, max = 1000, miles = 0.5}, -- multiples reward by miles traveled.
    models = {
        `s_m_m_cntrybar_01`,
        `u_f_y_comjane`,
        `a_f_y_hipster_04`,
        `s_m_m_highsec_02`,
        `a_m_y_hipster_03`,
    },
    locations = {
        vector4(946.3250, -171.7351, 74.5242, 56.1620),
        vector4(963.3705, -149.6545, 73.9146, 239.3231), -- REMOVE THIS
        vector4(397.9923, -870.3594, 29.2102, 322.1986),
        vector4(59.2745, -1483.8176, 29.2773, 270.6085),
        vector4(1246.3237, -1453.9513, 34.9354, 344.2509),
        vector4(-289.3166, -1847.9614, 26.2498, 4.3302),
        vector4(-45.8459, -1029.7800, 28.6224, 71.5370),
        vector4(181.9603, -322.1017, 43.9382, 211.4422),
        vector4(-514.8563, -260.6308, 35.5337, 211.8925),
        vector4(-1284.6191, 297.2318, 64.9439, 154.2817),
        vector4(-1440.0933, -773.8246, 23.4396, 343.2090),
    }
}