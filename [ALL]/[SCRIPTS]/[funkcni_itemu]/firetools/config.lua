-- Misc Options
main = {
    removalDistance = 10.0, -- This is the distance to remove props
    fanSmokeRemovalDistance = 50.0, -- This is the distance for fans to remove smoke
    spawnDistance = 300.0,
    decalType = 5004,
    decalWidth = 0.07,
    decalHeight = 0.07,
}

controls = {
    toggleFanControl = 47,
    breakDoorControl = 191,
    openDoorControl = 19,
    spreadersOpenDefaultKey = "y", -- This utilises FiveM Key Mapping, meaning it is adjustable in Settings > Keybinds > FiveM
    spreadersCloseDefaultKey = "u", -- This utilises FiveM Key Mapping, meaning it is adjustable in Settings > Keybinds > FiveM
}

models = {
    spreadersWeapon = `WEAPON_SPREADER`,
    halliganWeapon = `WEAPON_HALLIGAN`,
    sawWeapon = `WEAPON_SAW`,
    fan = `prop_fan_fire_01`,
    stabilisers = `newstabilisers`
}

FanCommand = {
    enabled = true,
    commandName = "fan",
    Permissions = {
        EnablePermissions = false, -- If set to false, all below job checks will be disabled, even if they are enabled in the config.lua
        AcePermissions = {
            Enabled = true,
        },
    
        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"hzs"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"fireman"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"fireman.usehose"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"fireman.usehose"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBX integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }
}

SpreadersCommand = {
    enabled = true,
    commandName = "spreaders",
    Permissions = {
        EnablePermissions = false, -- If set to false, all below job checks will be disabled, even if they are enabled in the config.lua
        AcePermissions = {
            Enabled = true,
        },

        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"hzs"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"fireman"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"fireman.usehose"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"fireman.usehose"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBX integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }
}

SawCommand = {
    enabled = true,
    commandName = "saw",
    Permissions = {
        EnablePermissions = false, -- If set to false, all below job checks will be disabled, even if they are enabled in the config.lua
        AcePermissions = {
            Enabled = true,
        },
    
        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"hzs"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"fireman"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"fireman.usehose"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"fireman.usehose"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBX integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }
}

HalliganCommand = {
    enabled = true,
    commandName = "halligan",
    Permissions = {
        EnablePermissions = false, -- If set to false, all below job checks will be disabled, even if they are enabled in the config.lua
        AcePermissions = {
            Enabled = true,
        },
    
        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"hzs"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"fireman"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"fireman.usehose"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"fireman.usehose"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBX integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }
}

StabilisersCommand = {
    enabled = true,
    commandName = "stabiliser",
    Permissions = {
        EnablePermissions = false, -- If set to false, all below job checks will be disabled, even if they are enabled in the config.lua
        AcePermissions = {
            Enabled = true,
        },
    
        ESX = {
            Enabled = true,
            CheckJob = {
                Enabled = false, -- Enable this to use ESX job check
                Jobs = {"hzs"} -- A user can have any of the following jobs, allowing you to add multiple
            }
        },
        -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
        vRP = {
            Enabled = false,
            CheckGroup = {
                Enabled = false, -- Enable this to use vRP group check
                Groups = {"fireman"}, -- A user can have any of the following groups, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use vRP permission check
                Permissions = {"fireman.usehose"} -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBCore = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBCore job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            },
            CheckPermission = {
                Enabled = false, -- Enable this to use QBCore permission check
                Permissions = {"fireman.usehose"}, -- A user can have any of the following permissions, allowing you to add multiple
            },
        },
        -- We've added QBX integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
        QBX = {
            Enabled = false,
            CheckJob = {
                Enabled = false, -- Enable this to use QBX job check
                Jobs = {"fireman"}, -- A user can have any of the following jobs, meaning you can add different jobs
            }
        },
    }
}

Inventory = {
    fanItemName = "fan",
    stabilisersItemName = "stabiliser",
    oxInventory = true,
    quasarInventory = false,
    coreInventory = false,
    ESX = false,
    vRP = false,
    qbCore = false,
}

Notifications = {
    Enabled = true,
    Framework = {
        QBCore = false,
        QBX = false,
        ESX = true, 
        vRP = false, 
        okok = false,
    }
}

translations = {
   fanSuggestion = "Nastav a používej odsávací ventilátor",
   fanHelp = "Nastavení nebo odstranění odsávacího ventilátoru",
   stabilisersSuggestion = "Použij stabilizátory na nejbližším vozidle",
   sawSuggestion = "Vyndej a použij okružní pilu",
   halliganSuggestion = "Vyndej a použij Halligan nástroj",
   stabilisersHelp = "Nastavení nebo odstranění stabilizátorů na nejbližším vozidle",
   spreadersSuggestion = "Vyndej a použij hydraulické rozpěrky",
   fanRemoved = "~g~Úspěch~w~: Ventilátor odstraněn",
   noFanFound = "~r~Chyba~w~: Nebyl nalezen žádný ventilátor",
   fanSetup = "~g~Úspěch~w~: Ventilátor byl umístěn",
   noVehicleFound = "~r~Chyba~w~: Nebylo nalezeno žádné vozidlo",
   noStabilisersFound = "~r~Chyba~w~: Nebyly nalezeny žádné stabilizátory",
   outsideVehicle = "~r~Chyba~w~: Nesmíš být uvnitř vozidla",
   stabilisersRemoved = "~g~Úspěch~w~: Stabilizátory odstraněny",
   stabilisersSetupAlready = "~r~Chyba~w~: Stabilizátory již jsou na tomto vozidle umístěny",
   vehicleNotFound = "Vozidlo ~r~nenalezeno",
   vehicleDoorFound = "Dveře vozidla ~g~nalezeny",
   vehicleFound = "Vozidlo ~b~nalezeno",
   setup = "nastavit",
   remove = "odstranit",
   stabilisersError = "~r~Chyba~w~: Použij /stabilisers setup nebo /stabilisers remove",
   fanError = "~r~Chyba~w~: Použij /fan setup nebo /fan remove",
   spreadersUsage = "Stiskni ~b~ENTER~w~ pro otevření nebo ~b~SPACE~w~ pro vytržení dveří vozidla",
   stabilisersSetup = "~g~Úspěch~w~: Stabilizátory umístěny",
   confirmPositioning = "Stiskni ENTER pro potvrzení umístění",
   noItem = "~r~Chyba~w~: Nemáš potřebný předmět",
   noPermission = "~r~Chyba~w~: Nemáš dostatečná oprávnění",
   placementCancelled = "Umístění zrušeno",
   toggleFan = "Stiskni G pro zapnutí/vypnutí ventilátoru",
   fanOff = "Ventilátor vypnut",
   fanOn = "Ventilátor zapnut",
   spreadersWeapon = "WEAPON_SPREADER",
   spreadersWeaponName = "Hydraulické rozpěrky",
   halliganWeapon = "WEAPON_HALLIGAN",
   halliganWeaponName = "Halligan",
   sawWeapon = "WEAPON_SAW",
   sawWeaponName = "Okružní pila",
   openSpreaders = "Otevřít rozpěrky",
   closeSpreaders = "Zavřít rozpěrky",
   grabObject = "Zvednout objekt",
   rotateObject = "Otočit objekt",
   cancelPlacement = "Zrušit umístění",
   placeItem = "Umístit předmět",

}
