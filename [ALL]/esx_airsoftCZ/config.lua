Config = {}

-- Debug mód (pokud je true, uvidíš v konzoli F8 pomocné výpisy)
Config.Debug = false

-- Základní nastavení
Config.Locale = 'cs' -- Jazyk skriptu
Config.CommandName = "airsoft_stats" -- Příkaz pro zobrazení statistik hráče

-- Nastavení zápasu
Config.Settings = {
    RespawnTime = 5000,      -- Čas na respawn (5 sekund)
    MatchDuration = 600,     -- Základní trvání zápasu (10 minut v sekundách)
    BleedEffect = true,      -- Červený záblesk obrazovky při zásahu
    EntryFee = 1500,         -- Cena za vstup do arény (pokud používáš ESX)
    UseUniforms = true,      -- Automaticky převléknout hráče do týmového oblečení
}

-- Definice zbraní a jejich poškození
-- hitsNeeded: kolikrát musí být hráč trefen touto zbraní, aby byl vyřazen
Config.Weapons = {
    [`weapon_pistol`] = { label = "Glock 17 Airsoft", hitsNeeded = 2 },
    [`weapon_smg`] = { label = "MP5 SD Airsoft", hitsNeeded = 3 },
    [`weapon_carbinerifle`] = { label = "M4A1 Airsoft", hitsNeeded = 4 },
}

-- Lokace a Arény
-- Můžeš přidat další arény zkopírováním celého bloku
Config.Arenas = {
    ['tovarna_v1'] = {
        label = "Stará Textilka (Industrial)", -- Název v menu
        price = 1500,                           -- Cena za hru
        time = 600,                             -- Čas vteřiny
        minPlayers = 2,
        maxPlayers = 12,
        
        -- Bod, kde se otevírá menu (Lobby)
        lobby = vector3(451.6827, -3079.0762, 6.0696), 
        
        -- Týmy a jejich spawny
        teams = {
            ['blue'] = {
                name = "PČR Tactical", -- Název týmu v UI
                spawn = vector4(451.3000, -3107.4045, 6.0701, 109.9545), -- x, y, z, heading
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 50, ['torso_2'] = 0, 
                        ['pants_1'] = 31, ['pants_2'] = 0,
                        ['arms'] = 31, 
                        ['helmet_1'] = 125, ['helmet_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 40, ['torso_2'] = 0, 
                        ['pants_1'] = 30, ['pants_2'] = 0 
                    }
                }
            },
            ['red'] = {
                name = "Opfor Rebels",
                spawn = vector4(463.1539, -3072.5818, 6.0696, 288.1255),
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 100, ['torso_2'] = 0, 
                        ['pants_1'] = 25, ['pants_2'] = 0,
                        ['arms'] = 31,
                        ['mask_1'] = 35, ['mask_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 90, ['torso_2'] = 0, 
                        ['pants_1'] = 24, ['pants_2'] = 0 
                    }
                }
            }
        }
    }, -- <--- TATO ČÁRKA JE EXTRÉMNĚ DŮLEŽITÁ!
    ['les_v1'] = {
        label = "Les", -- Název v menu
        price = 1500,                           -- Cena za hru
        time = 600,                             -- Čas vteřiny
        minPlayers = 2,
        maxPlayers = 12,
        
        -- Bod, kde se otevírá menu (Lobby)
        lobby = vector3(-700.8500, 5435.4458, 45.6950), 
        
        -- Týmy a jejich spawny
        teams = {
            ['blue'] = {
                name = "PČR Tactical", -- Název týmu v UI
                spawn = vector4(-622.5712, 5510.2910, 50.7677, 312.9945), -- x, y, z, heading
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 50, ['torso_2'] = 0, 
                        ['pants_1'] = 31, ['pants_2'] = 0,
                        ['arms'] = 31, 
                        ['helmet_1'] = 125, ['helmet_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 40, ['torso_2'] = 0, 
                        ['pants_1'] = 30, ['pants_2'] = 0 
                    }
                }
            },
            ['red'] = {
                name = "Opfor Rebels",
                spawn = vector4(-497.1467, 5571.9629, 71.1113, 304.1562),
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 100, ['torso_2'] = 0, 
                        ['pants_1'] = 25, ['pants_2'] = 0,
                        ['arms'] = 31,
                        ['mask_1'] = 35, ['mask_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 90, ['torso_2'] = 0, 
                        ['pants_1'] = 24, ['pants_2'] = 0 
                    }
                }
            }
        }
    },
        ['firma_v1'] = {
        label = "Opustěná firma", -- Název v menu
        price = 1500,                           -- Cena za hru
        time = 600,                             -- Čas vteřiny
        minPlayers = 2,
        maxPlayers = 12,
        
        -- Bod, kde se otevírá menu (Lobby)
        lobby = vector3(183.7215, 2805.0210, 45.6177), 
        
        -- Týmy a jejich spawny
        teams = {
            ['blue'] = {
                name = "PČR Tactical", -- Název týmu v UI
                spawn = vector4(221.9100, 2801.3054, 45.8399, 91.8169), -- x, y, z, heading
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 50, ['torso_2'] = 0, 
                        ['pants_1'] = 31, ['pants_2'] = 0,
                        ['arms'] = 31, 
                        ['helmet_1'] = 125, ['helmet_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 40, ['torso_2'] = 0, 
                        ['pants_1'] = 30, ['pants_2'] = 0 
                    }
                }
            },
            ['red'] = {
                name = "Opfor Rebels",
                spawn = vector4(222.6898, 2770.5112, 43.4263, 139.7094),
                clothing = {
                    ['male'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 100, ['torso_2'] = 0, 
                        ['pants_1'] = 25, ['pants_2'] = 0,
                        ['arms'] = 31,
                        ['mask_1'] = 35, ['mask_2'] = 0 
                    },
                    ['female'] = { 
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
                        ['torso_1'] = 90, ['torso_2'] = 0, 
                        ['pants_1'] = 24, ['pants_2'] = 0 
                    }
                }
            }
        }
    }
}    


-- Textové překlady
Config.Locales = {
    ['no_money'] = "Nemáš dost peněz na startovné (%s CZK).",
    ['joined_team'] = "Vstoupil jsi do týmu: %s",
    ['match_start'] = "Zápas začíná! Připravte se.",
    ['match_end'] = "Zápas v aréně %s skončil!",
    ['eliminated'] = "Byl jsi vyřazen! Čekej na respawn.",
    ['in_battle'] = "Jsi zpět v boji!",
    ['press_e'] = "Stiskni ~y~[E]~w~ pro vstup do Airsoft Lobby",
}