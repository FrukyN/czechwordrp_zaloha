Config = {}

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Enable and disable a marker at the pickup point of the ambulance
-- Set to false or true
Config.DevMode = false

-- PRECONFIG: Input "yes" if stretcher model contains the C5M stretcher attach dummy (misc_z). Input "no" otherwise.

-- HASH: The spawnname of the ambulance (take from the yft file of the model)

-- DOORS: Input all door values as integers in {} (Example: doors = {0, 1, 2, 3, 4, 5})
-- DOORS: 0 = Front Left Door,  1 = Front Right Door, 2 = Back Left Door, 3 = Back Right Door, 4 = Hood, 5 = Trunk
-- DOORS: Set value to 'override' WITHOUT {} to not open doors (Example: doors = 'override')

-- POSITION: The center point of the radius of where the interaction zone is. Can be any number (Recommended to use devmode)

-- POSITIONRANGE: The radius that allows for interaction. Higher number = bigger radius. Anything > 0 (Recommended to use devmode)

-- DEPTH, HEIGHT, OFFSET, YROT: Positioning for the stretcher inside of the ambulance

Config.Ambulance = {
    {
        hash = 'dsa', position = -5.0, positionRange = 2.0,
        preconfig = 'no', depth = -1.5, height = 0.5, offset = 0.0, yrot = 90.0,
        doors = 'override'
    },

    {
        hash = 'ambulance', position = -5.0, positionRange = 2.0,
        preconfig = 'no', depth = 1.5, height = 0.5, offset = 0.0, yrot = 90.0,
        doors = {0, 1, 2, 3, 4, 5}
    },

    {
        hash = 'sprinterzzs2', position = -5.0, positionRange = 2.0,
        preconfig = 'no', depth = -1.3, height = 0.2, offset = 0.0, yrot = 0.0,
        doors = {2, 3}
    },

    {
        hash = 't6zzs', position = -5.0, positionRange = 2.0,
        preconfig = 'no', depth = -1.3, height = 0.5, offset = 0.0, yrot = 0.0,
        doors = {2, 3}
    },

    {
        hash = 'crafterzzs', position = -5.0, positionRange = 2.0,
        preconfig = 'no', depth = -1.84, height = -0.07, offset = -0.3, yrot = 0.0,
        doors = {1, 2}
    },
}

Config.Emotes1 = {
    animationName = "Emote 1",
    animationDictionary = "savecouch@",
    animationClip = "t_sleep_loop_couch",
	offsetX = "0.0",
    offsetY = "0.1",
    offsetZ = "1.0",
}
Config.Emotes2 = {
    animationName = "Emote 2",
    animationDictionary = "nil",
    animationClip = "nil",
	offsetX = "0.0",
    offsetY = "0.0",
    offsetZ = "0.0",
}
Config.Emotes3 = {
    animationName = "Emote 3",
    animationDictionary = "nil",
    animationClip = "nil",
	offsetX = "0.0",
    offsetY = "0.0",
    offsetZ = "0.0",
}
Config.Emotes4 = {
    animationName = "Emote 4",
    animationDictionary = "nil",
    animationClip = "nil",
	offsetX = "0.0",
    offsetY = "0.0",
    offsetZ = "0.0",
}
Config.Emotes5 = {
    animationName = "Emote 5",
    animationDictionary = "nil",
    animationClip = "nil",
	offsetX = "0.0",
    offsetY = "0.0",
    offsetZ = "0.0",
}

Config.Control = {
    menu_prompt = Keys["E"], 				--key to open interaction menu
    stretcher_grab = Keys["E"],				--take/stow/unstow stretcher
    stretcher_place = Keys["E"],			--place stretcher flat
    stretcher_placeStanding = Keys["Y"], 	--place stretcher standing
    ambulance_doors = Keys["G"], 			--open ambulance doors
    dismount = Keys["Y"]
}

Config.Interaction = {
    sit_right = 'Sednout na pravo',
    sit_left = 'Sednout na Levo',
    lie_down = 'Lehnout',
    lie_downRelaxed = 'Lehnout (Relaxed)',
    lie_downStiff = 'Lehnout (Stiff)',
    sit_up1 = 'Sednout (1)',
}

Config.Customization = {
    toggle_sides = 'Fold Side Guard',
    toggle_sheet = 'Toggle Sheet',
    toggle_backpack = 'Toggle Backpack',
    toggle_seat = 'Toggle Seat Position',
    toggle_Defib = 'Toggle Defib',
	toggle_helmet = 'Toggle EMS Helmet',
    toggle_traumabag = 'Toggle Trauma Bag',
    toggle_o2tank = 'Toggle Oxygen Tank',
}

Config.ai = {
    pickup_closest = 'Pickup Closest Dead Ped',
    empty_stretcher = 'Clear Stretcher',
}

Config.Language = {
    menu_prompt = 'Press ~INPUT_CONTEXT~ Otevrit interakci z nositkama',
    stretcher_grab = 'Press ~INPUT_CONTEXT~ vzit nosítka',
	ambulance_prompt = 'Press ~INPUT_DETONATE~ Otevrit dvere.~n~Press ~INPUT_CONTEXT~ Vyndat/Zandat nositka.',
    ambulance_prompt1 = 'Press ~INPUT_CONTEXT~ Vyndat/Zandat nositka.',
    dismount = 'Press ~INPUT_MP_TEXT_CHAT_TEAM~ to dismount stretcher',
}