Config = {}

Config.Framework = "esx"

Config.Debug = false

Config.Progress = "ox_lib"

Config.MINUTE = 60 * 1000
Config.SECONDS = 1000

Config.MaxEntities = 3

Config.Item = 'WEAPON_KNIFE'


-- Loot format:
-- { item = 'item_name', min = 1, max = 3 }
Config.Zones = {
    Zone1 = {
        position = vector3(-592.0656, 5937.9824, 26.3164),
        radius = 110.0,
        Blip = {
            color = 33,
            sprite = 273,
        },
        Animals = {
            ['jelen'] = {
                model = 'A_C_Deer',
                loots = {
                    { item = 'zvireci_kost', min = 1, max = 2 },
                    { item = 'jelen_maso', min = 1, max = 3 },
                    { item = 'jelen_kuze', min = 1, max = 2 },
                    { item = 'jelen_parohy', min = 1, max = 1 },
                },
                rarity = 30
            },
        },
    },
    Zone2 = {
        position = vector3(2590.8093, 6176.8433, 166.5282),
        radius = 350.0,
        Blip = {
            color = 33,
            sprite = 273,
        },
        Animals = {
            ['zajic'] = {
                model = 'A_C_Rabbit_01',
                loots = {
                    { item = 'zajici_maso', min = 1, max = 2 },
                    { item = 'zajeci_kozka', min = 1, max = 2 },
                },
                rarity = 70
            },

        },
    },
    Zone3 = {
        position = vector3(-937.2933, 4836.8037, 310.7200),
        radius = 300.0,
        Blip = {
            color = 33,
            sprite = 273,
        },
        Animals = {
            ['vlk'] = {
                model = 'A_C_Wolf',
                loots = {
                    { item = 'vlci_maso', min = 1, max = 3 },
                    { item = 'vlci_kozesina', min = 1, max = 2 },
                    { item = 'vlci_zub', min = 1, max = 1 },
                    { item = 'zvireci_kost', min = 1, max = 2 },
                },
                rarity = 10
            },
        },
    },
    Zone4 = {
        position = vector3(-419.6801, 2208.7939, 180.4328),
        radius = 240.0,
        Blip = {
            color = 33,
            sprite = 273,
        },
        Animals = {
            ['divocak'] = {
                model = 'A_C_Boar',
                loots = {
                    { item = 'kanci_maso', min = 1, max = 3 },
                    { item = 'kanci_kuze', min = 1, max = 2 },
                    { item = 'kanci_kly', min = 1, max = 1 },
                    { item = 'zvireci_kost', min = 1, max = 2 },
                },
                rarity = 20
            }
        }
    }
}
