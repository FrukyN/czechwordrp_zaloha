main = {
    commandEnabled = true,
    defaultClamp = "locker_chain", -- locker_wheel or locker_chain
    lockpickSuccessRate = 50, -- 50/100 chance that the lockpick will get the clamp off
    lockpickTime = 10, -- in seconds
    installationTime = 5, -- PD installation time 
    clampLoadDistance = 50.0,
}

Inventory = {
    clampItemNames = {"locker_chain", "locker_wheel"}, -- Don't change the item names, you can just change the labels for your players.
    lockpickItem = "clamp_lockpick",
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
        okok = false, -- https://okok.tebex.io/package/4724993
    }
}

-- This section allows you to translate the resource into another language
translations = {
    ["CLAMP_COMMAND"] = "botička",
    ["CLAMP_COMMAND_SUGGESTION"] = "Nasadit nebo odstranit botičku",
    ["CLAMP_COMMAND_REMOVE_SUGGESTION"] = "Odstranit botičku",
    ["CLAMP_COMMAND_SETUP"] = "nasadit",
    ["CLAMP_COMMAND_SETUP_CHAIN"] = "řetěz",
    ["CLAMP_COMMAND_SETUP_WHEEL"] = "kolo",
    ["CLAMP_COMMAND_REMOVE"] = "odstranit",
    ["CLAMP_COMMAND_HELP"] = "Nasazení nebo odstranění",
    ["CLAMP_COMMAND_ERROR"] = "~r~Chyba~w~: Použij /clamp nasadit [řetěz/kolo] nebo /clamp odstranit",
    ["CLAMP_NO_VEHICLE_FOUND"] = "~r~Chyba~w~: Nebylo nalezeno žádné vozidlo",
    ["CLAMP_NO_TYRE_FOUND"] = "~r~Chyba~w~: Musíš být blízko pneumatiky",
    ["CLAMP_NO_CLAMP_FOUND"] = "~r~Chyba~w~: Na tomto vozidle není žádná botička",
    ["CLAMP_NO_CLAMP_FOUND_ON_TYRE"] = "~r~Chyba~w~: Na tomto kole není žádná botička",
    ["CLAMP_FOUND_ON_TYRE"] = "~r~Chyba~w~: Na tomto kole už je botička nasazena",
    ["CLAMP_LOCKPICK_FAILED"] = "~r~Chyba~w~: Nepodařilo se ti vypáčit zámek",
    ["CLAMP_LOCKPICK_SUCCESS"] = "~g~Úspěch~w~: Zámek byl vypáčen",
    ["CLAMP_REMOVED"] = "~g~Úspěch~w~: Botička byla odstraněna",
    ["CLAMP_INSTALLED"] = "~g~Úspěch~w~: Botička byla nasazena",
    ["VEHICLE_NOT_STOPPED"] = "~r~Chyba~w~: Vozidlo musí stát",
    ["NO_PERMISSION"] = "~r~Chyba~w~: Nemáš potřebné oprávnění",
    ["NO_ITEM"] = "~r~Chyba~w~: Nemáš potřebný předmět",

}

wheelBones = {
    "wheel_lf",
    "wheel_rf",
    "wheel_lm",
    "wheel_rm",
    "wheel_lr",
    "wheel_rr",
}

Permissions = {
    EnablePermissions = false,
    AcePermissions = {
        Enabled = false,
        -- This enables ace permissions on the clamp command
    },
    -- We've added ESX integration. All you need to do is enable it below and configure which jobs can use the command
    ESX = {
        Enabled = true,
        CheckJob = {
            Enabled = false, -- Enable this to use ESX job check
            Jobs = {"police, policie_mp"} -- A user can have any of the following jobs, allowing you to add multiple
        }
    },
    -- We've added vRP integration. All you need to do is enable it below. Then, configure if you wish to check for groups or permissions, or even both
    vRP = {
        Enabled = false,
        CheckGroup = {
            Enabled = false, -- Enable this to use vRP group check
            Groups = {"police"}, -- A user can have any of the following groups, meaning you can add different jobs
        },
        CheckPermission = {
            Enabled = false, -- Enable this to use vRP permission check
            Permissions = {"police"} -- A user can have any of the following permissions, allowing you to add multiple
        },
    },
    -- We've added QBCore integration. All you need to do is enable it below. Then, configure if you wish to check for jobs or permissions, or even both
    QBCore = {
        Enabled = false,
        CheckJob = {
            Enabled = false, -- Enable this to use QBCore job check
            Jobs = {"police"}, -- A user can have any of the following jobs, meaning you can add different jobs
        },
        CheckPermission = {
            Enabled = false, -- Enable this to use QBCore permission check
            Permissions = {"police"}, -- A user can have any of the following permissions, allowing you to add multiple
        },
    },
    QBX = {
        Enabled = false,
        CheckJob = {
            Enabled = false, -- Enable this to use QBX job check
            Jobs = {"police"}, -- A user can have any of the following jobs, meaning you can add different jobs
        }
    },
}

-- We do not recommend you editing this section:
main.offsets = {
    ["wheel_lf"] = {
        ["locker_chain"] = {-0.14, 0.03, -0.09, 0.0, 0.0, 0.0},
        ["locker_wheel"] = {-0.09, 0.5, -0.18, -8.0, 0.0, 0.0}
    },
    ["wheel_rf"] = {
        ["locker_chain"] = {0.14, 0.03, -0.09, 0.0, 0.0, 180.0},
        ["locker_wheel"] = {0.0, 0.5, -0.18, -8.0, 0.0, 0.0}
    },
    ["wheel_lr"] = {
        ["locker_chain"] = {-0.14, 0.03, -0.09, 0.0, 0.0, 0.0},
        ["locker_wheel"] = {-0.2, -0.3, 0.0, 8.0, 0.0, 180.0}
    },
    ["wheel_rr"] = {
        ["locker_chain"] = {0.14, 0.03, -0.09, 0.0, 0.0, 180.0},
        ["locker_wheel"] = {0.0, -0.3, 0.0, 8.0, 0.0, 180.0}
    },
    ["wheel_lm"] = {
        ["locker_chain"] = {-0.14, 0.03, -0.09, 0.0, 0.0, 0.0},
        ["locker_wheel"] = {-0.09, 0.5, -0.18, -8.0, 0.0, 0.0}
    },
    ["wheel_rm"] = {
        ["locker_chain"] = {-0.14, 0.03, -0.09, 0.0, 0.0, 0.0},
        ["locker_wheel"] = {-0.09, 0.5, -0.18, -8.0, 0.0, 0.0}
    },       
}

if not main.offsets[main.defaultClamp] then
    main.defaultClamp = "locker_chain"
end