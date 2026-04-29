Config = {}

Config.ExtrasEnabled = true

Config.Locales = {
    ['no_variants'] = "Zdá se, že pro toto nejsou žádné varianty!",
    ['wrong_ped'] = "Tento model postavy nepodporuje tuto možnost",
    ['already_wearing'] = "To už máš na sobě!",
    ['nothing_to_remove'] = "Nemáš na sobě nic, co by šlo sundat",
}

Config.Commands = {
    ["top"] = {
        Func = function() ToggleClothing("Top") end,
        Sprite = "top",
        Desc = "Sundat/obléct tričko",
        Button = 1,
        Name = "Triko"
    },
    ["gloves"] = {
        Func = function() ToggleClothing("gloves") end,
        Sprite = "gloves",
        Desc = "Sundat/nasadit rukavice",
        Button = 2,
        Name = "Rukavice"
    },
    ["visor"] = {
        Func = function() ToggleProps("visor") end,
        Sprite = "visor",
        Desc = "Přepnout variantu kšiltovky/čepice",
        Button = 3,
        Name = "Kšilt"
    },
    ["shoes"] = {
        Func = function() ToggleClothing("Shoes") end,
        Sprite = "shoes",
        Desc = "Sundat/obout boty",
        Button = 5,
        Name = "Boty"
    },
    ["vest"] = {
        Func = function() ToggleClothing("Vest") end,
        Sprite = "vest",
        Desc = "Sundat/nasadit vestu",
        Button = 14,
        Name = "Vesta"
    },
    ["hair"] = {
        Func = function() ToggleClothing("hair") end,
        Sprite = "hair",
        Desc = "Upravit účes (rozpuštěné, culík, drdol...)",
        Button = 7,
        Name = "Vlasy"
    },
    ["hat"] = {
        Func = function() ToggleProps("Hat") end,
        Sprite = "hat",
        Desc = "Sundat/nasadit čepici/klobouk",
        Button = 4,
        Name = "Čepice"
    },
    ["glasses"] = {
        Func = function() ToggleProps("Glasses") end,
        Sprite = "glasses",
        Desc = "Sundat/nasadit brýle",
        Button = 9,
        Name = "Brýle"
    },
    ["ear"] = {
        Func = function() ToggleProps("Ear") end,
        Sprite = "ear",
        Desc = "Sundat/nasadit doplněk do ucha",
        Button = 10,
        Name = "Ucho"
    },
    ["neck"] = {
        Func = function() ToggleClothing("Neck") end,
        Sprite = "neck",
        Desc = "Sundat/nasadit doplněk na krk",
        Button = 11,
        Name = "Krk"
    },
    ["watch"] = {
        Func = function() ToggleProps("Watch") end,
        Sprite = "watch",
        Desc = "Sundat/nasadit hodinky",
        Button = 12,
        Name = "Hodinky",
        Rotation = 5.0
    },
    ["bracelet"] = {
        Func = function() ToggleProps("Bracelet") end,
        Sprite = "bracelet",
        Desc = "Sundat/nasadit náramek",
        Button = 13,
        Name = "Náramek"
    },
    ["mask"] = {
        Func = function() ToggleClothing("Mask") end,
        Sprite = "mask",
        Desc = "Sundat/nasadit masku",
        Button = 6,
        Name = "Maska"
    },
    ["bagoff"] = {
        Func = function() ToggleClothing("Bagoff", true) end,
        Sprite = "bagoff",
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
            local BagOff = LastEquipped["Bagoff"]
            if LastEquipped["Bagoff"] then
                if bags[BagOff.Drawable] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            end
            if Bag ~= 0 then
                if bags[Bag] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            else
                return false
            end
        end,
        Desc = "Sundat/nasadit batoh",
        Name = "Batoh dolů",
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}

local bags = {[40] = true, [41] = true, [44] = true, [45] = true}

Config.ExtraCommands = {
    ["pants"] = {
        Func = function() ToggleClothing("Pants", true) end,
        Sprite = "pants",
        Desc = "Sundat/obléct kalhoty",
        Name = "Kalhoty",
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ["shirt"] = {
        Func = function() ToggleClothing("Shirt", true) end,
        Sprite = "shirt",
        Desc = "Sundat/obléct košili/tričko",
        Name = "Košile",
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ["reset"] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Není co resetovat', 'error')
            end
        end,
        Sprite = "reset",
        Desc = "Vrátit vše zpět do původního stavu",
        Name = "Reset",
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ["bag"] = {
        Func = function() ToggleClothing("Bag") end,
        Sprite = "bag",
        Desc = "Otevřít nebo zavřít batoh",
        Button = 8,
        Name = "Batoh"
    },
}