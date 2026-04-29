Config = {}

-- Debug mode (prints additional information to console)
Config.Debug = false

-- Command to open the ped menu
Config.Command = 'ped'

-- Which identifiers to check for authorization (steam, license, discord, etc.)
Config.IdentifierType = 'discord' -- Options: 'steam', 'license', 'discord', 'ip', 'live'

-- List of authorized identifiers that can use the ped menu
Config.AuthorizedIdentifiers = {
    'discord:931968097353621525', -- Michal
    'discord:546348489131556866', --- FrukyN
    'discord:386842049527152640', -- pes1 k
    'discord:1017791722585067632', -- pes2 dejvoo
    'discord:841269650133876756', -- pes3 milošek
    'discord:1052985366774304849', -- pes4 dexo 
    'discord:753260184473960501',-- pes5 Taurenisek
    'discord:672878849515716618',-- DARO
    'discord:1192454555556905052' -- pes6 miki 
   
   
}

-- All available peds that can be selected from the menu
Config.Peds = {
    {
        label = 'Husky',
        model = 'a_c_husky',
        preview = 'https://docs.fivem.net/peds/a_c_husky.png' -- This URL is for illustration, ox_lib will handle this differently
    },
    {
        label = 'pes domaci',
        model = 'dwxunit',
        preview = 'https://docs.fivem.net/peds/a_c_husky.png' -- This URL is for illustration, ox_lib will handle this differently
    },

    {
        label = 'Rottweiler',
        model = 'a_c_rottweiler',
        preview = 'https://docs.fivem.net/peds/A_C_Pig.png' -- This URL is for illustration, ox_lib will handle this differently
    },
    -- Add more peds as needed
}

-- Default ped to return to when resetting
Config.DefaultPed = {
    model = 'mp_m_freemode_01', -- Male multiplayer ped (default)
    female = 'mp_f_freemode_01' -- Female multiplayer ped (used if player's original ped was female)
}

-- Notification settings
Config.Notifications = {
    notAuthorized = {
        title = 'ZX-PedMenu',
        description = 'You are not authorized to use this command',
        type = 'error'
    },
    pedChanged = {
        title = 'ZX-PedMenu',
        description = 'You have changed your ped to %s',
        type = 'success'
    },
    pedReset = {
        title = 'ZX-PedMenu',
        description = 'Your ped has been reset',
        type = 'success'
    },
    error = {
        title = 'ZX-PedMenu',
        description = 'An error occurred: %s',
        type = 'error'
    }
}
