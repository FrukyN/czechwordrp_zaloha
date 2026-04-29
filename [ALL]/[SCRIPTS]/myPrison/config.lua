Config = {}
Translation = {}

Config.Locale = 'en'

Config.UpdateInterval = 10000
-- Toggle this when you can't select players in the menu.
Config.useOneSyncInfinity = true

Config.CustomBanner = true
Config.Banner = {dict = 'prisonbanner', file = 'prisonbanner'}

Config.useJailCommand = true
Config.jailCommand = 'jail'

Config.enableManagementPeds = true
Config.ManagementPeds = {
	{x = 1851.36, y = 2585.9, z = 45.67, rot = 273.38, pedmodel = 's_m_y_ranger_01'}
}

-- 'de' or 'us'
Config.dateFormat = 'us' 
Config.useMinutes = false -- otherwise most time units will be in seconds 

Config.jailEnter = {
	x = 1785.982422,
	y = 2568.276856,
	z = 50.544312,
	rot = 0.000000,
}

-- how many log entries should be displayed
Config.Limit = 30

-- remove items and weapons when entering the prison and restore it afterwards
Config.removeItemsAndWeapons = true 

-- Set up how many Cops are required to be able to escape
Config.CopsRequiredToEscape = 5
-- if not enough cops, should the player be teleported back?
Config.teleportBackWhenTryingToEscape = true
Config.EscapeUpdates = 15 -- how long should the GPS be updated after an inmate escaped

Config.RemovePrisonPeds = false

Config.Prisons = {
	{
	name = 'Věznice Mírov',

	blip = {
		Sprite = 252,
		Color = 37, -- 40
		Display = 4,
		Scale = 1.2,
	},

	inside = {x = 1779.573608, y = 2573.340576, z = 48.572876, rot = 0.0},
	escapeRange = 220.0, -- If an inmate leaves this range the police will be informed
	exit = {x = 1838.38684, y = 2590.80004, z = 45.94433, rot = 274.96063},
	setPrisonClothes = true,

	securityPeds = {
		{pedmodel = 's_m_y_ranger_01', x = 1779.94, y = 2589.86, z = 45.79, rot = 175.74, disabled = false, manipulation = true, askForWork = true, food = true}
	},

	prisonJobs = {
		-- {blipColor = 50, x = 1764.76, y = 2560.53, z = 45.56, range = 10.0, animation = {type = 'animation', dict = 'amb@code_human_wander_gardener_leaf_blower@idle_a', anim = 'idle_a'}, workTime = 5000, rewardSeconds = {min = 2, max = 4}}
		{blipColor = 50, x = 1764.76, y = 2560.53, z = 45.56, range = 10.0, animation = {type = 'scenario', anim = 'WORLD_HUMAN_GARDENER_LEAF_BLOWER'}, workTime = 12, rewardSeconds = {min = 2, max = 4}}
		,{blipColor = 50, x = 1757.89, y = 2508.45, z = 45.57, range = 10.0, animation = {type = 'scenario', anim = 'world_human_gardener_plant'}, workTime = 12, rewardSeconds = {min = 2, max = 4}}
	},

	prisonFood = {
		{item = 'burger', quantity = 2},
		{item = 'water', quantity = 3},
	},

	foodCooldown = 2, -- how often to the players get food (in minutes)
	},

	{ -- set up for the Gabz PD
		name = 'CPZ',
	
		blip = nil,
	
		inside = {x = 481.17, y = -1013.72, z = 26.27, rot = 6.0},
		escapeRange = 15.0, -- If an inmate leaves this range the police will be informed
		exit = {x = 441.78, y = -1001.03, z = 30.72, rot = 180.0},
		setPrisonClothes = false,
	
		securityPeds = {},
		prisonJobs = {},

	},

}

-- Bolingbroke Prison Gym
Config.EnableGym = true

Config.Exersices = {
	{type = 'arm exercises', scenario = "world_human_muscle_free_weights", x = 1770.71,y = 2589.74,z = 45.7},
	{type = 'pushups', scenario = "world_human_push_ups", x = 1771.42, y = 2597.7, z = 45.792},
	{type = 'yoga', scenario = "world_human_yoga", x = 1771.305,y = 2593.17, z = 45.79},
	{type = 'situps', scenario = "world_human_sit_ups", x = 1767.5, y = 2593.16040, z = 45.7},
	{type = 'chins', scenario = "prop_human_muscle_chin_ups", x = 1773.17, y = 2596.72, z = 45.79, fixedChinPos = {x = 1773.17, y = 2596.72, z = 45.79, rot = 269.29}},
}

Config.GymKey = 38 -- E
Config.GymDuration = 10 -- how long in seconds an exercise have to be done to receive a time reward (see below)
Config.GymReward = {min = 3, max = 6} -- in seconds 
-- 

Config.policeJobs = {
	'police',
	'sheriff',
}

Config.allowedGradesForJailManagement = {
	'boss',
	'chief',
	'lieutenant',
}

-- set up the chances of a player to be successfull when corrupting the guard.
Config.ManipulateAmounts = {
	{from = 0, to = 100, releaseChance = 10}, -- when the player gives between 0 and 100$ to the guard, the chance of being successfull is 10%
	{from = 100, to = 999999999, releaseChance = 50},
}
Config.defaultReleaseChance = 50
-- when the guard is manipulated how many seconds are removed from the remaining prison time: NewPrisonTime = OldPrisonTime - (OldPrisonTime *  FailMultiplier)
Config.SuccessMultiplier = 0.5 
-- when the guard rejects this attempt how many extra seconds are being added: NewPrisonTime = OldPrisonTime + (OldPrisonTime *  FailMultiplier)
Config.FailMultiplier = 0.25

Config.PrisonClothes = {
	['male'] = {
		{type = 'shoes_1', number = 12},
		{type = 'shoes_2', number = 0},
		{type = 'pants_1', number = 5},
		{type = 'pants_2', number = 7},
		{type = 'arms', number = 5},
		{type = 'decals_1', number = 0},
		{type = 'torso_1', number = 237},
		{type = 'torso_2', number = 0},
		{type = 'tshirt_1', number = 15},
		{type = 'tshirt_2', number = 0},
	},

	['female'] = {
		{type = 'shoes_1', number = 31},
		{type = 'shoes_2', number = 3},
		{type = 'pants_1', number = 64},
		{type = 'pants_2', number = 6},
		{type = 'arms', number = 5},
		{type = 'decals_1', number = 0},
		{type = 'torso_1', number = 237},
		{type = 'torso_2', number = 0},
		{type = 'tshirt_1', number = 15},
		{type = 'tshirt_2', number = 0},
	},
}


Translation = {
	['de'] = {
		['jail_menu'] = 'Gefängnisverwaltung',
        ['cop_notify'] = '~r~Fußfessel von ~o~',
		['cop_notify2'] = ' ~s~befindet sich in ~y~',
        ['cop_notify3'] = ' ~s~ausgelöst. GPS übermittelt!',
        ['cop_heading'] = '~r~Ausbruchsalarm',
		['gym_start'] = 'Drücke ~g~E ~s~und starte ~y~',
		['gym_stop'] = 'Drücke ~g~E~s~, um die Übung zu beenden',
		['infobar_guard'] = 'Drücke ~g~E~s~, um mit dem Wärter zu sprechen',
		['infobar_work'] = 'Drücke ~g~E~s~, um zu arbeiten',
		['gym_no_success'] = '~y~Trainiere länger, um deine Haftzeit zu verkürzen!',
		['longer_1'] = 'Haftzeit ~r~',
		['longer_2'] = ' Sekunden ~s~verlaengert',
		['shorter_1'] = 'Haftzeit ~g~',
		['shorter_2'] = ' Sekunden ~s~verringert',
		['actionbar_currenttime'] = ' seconds ~s~remaining',
		['actionbar_currenttime_minutes'] = ' minutes ~s~remaining',
		['actionbar_currenttime_sub'] = 'until you will be ~o~released',
		['guard_blip'] = 'Security Guard',
		['work_blip'] = 'Work',
		['gym_blip'] = 'Gym',
		['guard_manipulate'] = '~p~Wärter bestechen',
		['guard_desc'] = 'Entweder wird die Haftzeit halbiert oder verdoppelt. Lehnt der Wärter ab ist das Geld verloren!',
		['guard_money'] = 'Wie viel Geld bietest du?',
		['manipulate_success'] = '~o~Wärter~s~: ~g~Ich werde mal schauen was ich machen kann...',
		['manipulate_fail'] = '~o~Wärter~s~: ~r~Keine Chance! ~s~Der Versuch wird sofort an die Gefängnisleitung gemeldet!',
		['not_enough_money'] = '~r~Du hast nicht genügend Geld!',
		['guard_work'] = 'Nach Arbeit fragen',
		['guard_work_info'] = '~y~Wärter: ~s~Schau doch mal hier vorbei...\n>> ~p~Wegpunkt ~s~wurde ~p~gesetzt!',
		['guard_no_work'] = '~r~Hier gibt es leider keine Arbeit zu erledigen!',
		['guard_food'] = 'Essensration erhalten',
		['guard_food_give'] = '~g~Hier hast du deine Mahlzeit',
		['guard_food_not_available'] = '~r~Du erhältst deine erneute Essensration in ~o~',
		['guard_food_not_available2'] = ' Minuten',
		['menu_prisons'] = 'Gefängnisse verwalten',
		['menu_playername'] = 'Name: ',
		['menu_waypoint'] = 'Wegpunkt setzen',
		['menu_inmates'] = 'Häftlinge:',
		['inmate_desc'] = 'Es verbleiben ~y~',
		['inmate_desc2'] = ' ~s~Minuten',
		['menu_inmate'] = 'Häftling:',
		['menu_reason'] = 'Grund:',
		['menu_remaining_time'] = 'Verbleibende Zeit:',
		['menu_remaining_time2'] = ' Minuten',
		['menu_officer_name'] = 'Inhaftiert von:',
		['menu_time'] = 'Inhaftiert am:',
		['menu_change_time'] = '~o~Haftzeit ändern',
		['menu_arrestTime'] = 'Dauer:',
		['menu_seconds'] = ' Sekunden',
		['menu_minutes'] = ' Minuten',
		['menu_confirm'] = '~g~Bestätigen',
		['menu_confirm_desc'] = 'Haftzeitänderung bestätigen',
		['time_changed'] = '~r~Die Haftzeit wurde auf ~s~',
		['time_changed2'] = ' Sekunden ~r~geändert.',
		['menu_release'] = '~g~Häftling freilassen',
		['menu_release_confirm'] = 'Häftling wirklich entlassen?',
		['released_officer'] = ' ~g~wird nun entlassen...',
		['no_inmates'] = '- Aktuell keine Häftlinge',
		['arrest_player'] = 'Spieler verhaften',
		['menu_arrest'] = 'Spieler inhaftieren',
		['reason_dialog'] = 'Grund?',
		['time_dialog'] = 'Dauer?',
		['arrest_confirm'] = '~o~Spieler inhaftieren',
		['arrest_desc'] = 'Klicke, um den Spieler zu inhaftieren',
		['send_to_prison'] = 'Klicke, um den Spieler ins ~y~',
		['send_to_prison2'] = ' ~s~zu schicken.',
		['invalid'] = '~r~Ungültige Eingabe!',
		['prison_log'] = 'Haftlog',
		['prison_state'] = 'Haftstatus: ',
		['escaped'] = '~r~Geflohen',
		['released'] = '~g~Entlassen',
		['in_prison'] = '~o~In Haft',
		['prisonname'] = 'Gefängnis:',
		['escaped_time'] = 'Geflohen am:',
		['released_time'] = 'Entlassen am:',
		['start_jail'] = 'Deine Haftstrafe für ~o~',
		['start_jail2'] = ' ~s~startet jetzt.\nDauer: ~o~',
		['start_jail3'] = ' Sekunden\n',
		['start_jail4'] = '~s~Zuständig: ~b~',
		['gps_off'] = '~r~Das GPS der Fußfessel liefert keine Daten mehr!',
		['released_early'] = '~g~Du wurdest von ~w~',
		['released_early2'] = ' ~g~vorzeitig aus der Haft entlassen!',
		['server_imprisoned'] = ' ~s~wurde für ~o~',
		['server_imprisoned2'] = ' ~s~eingesperrt. \nGrund: ~o~',
		['not_enough_cops'] = '~r~Es sind nicht genügend Polizisten online, um auszubrechen',
		['infobar_management'] = 'Drücke ~g~E~s~, um die Gefängnisvewaltung zu öffnen',
	},
	['en'] = {
		['jail_menu'] = 'Prison Management',
        ['cop_notify'] = '~r~GPS signal of ~o~',
		['cop_notify2'] = ' ~s~is near ~y~',
        ['cop_notify3'] = ' ~s~GPS-Tracking started!',
        ['cop_heading'] = '~r~Escape Alert',
		['gym_start'] = 'Press ~g~E ~s~to do some ',
		['gym_stop'] = 'Press ~g~E ~s~to abort working out',
		['infobar_guard'] = 'Press ~g~E~s~, to talk to the ~o~guard',
		['infobar_work'] = 'Press ~g~E~s~, to work',
		['gym_no_success'] = '~y~You have to work out longer to be rewarded!',
		['longer_1'] = 'Jail time now ~r~',
		['longer_2'] = ' seconds ~s~longer',
		['shorter_1'] = 'Jail time now ~g~',
		['shorter_2'] = ' seconds ~s~reduced',
		['actionbar_currenttime'] = ' seconds ~s~remaining',
		['actionbar_currenttime_minutes'] = ' minutes ~s~remaining',
		['actionbar_currenttime_sub'] = 'until you will be ~o~released',
		['guard_blip'] = 'Security Guard',
		['work_blip'] = 'Work',
		['gym_blip'] = 'Gym',
		['guard_manipulate'] = '~p~Bribe the guard',
		['guard_desc'] = 'Either the detention time is halved or doubled. If the guard refuses, the money is lost!',
		['guard_money'] = 'How much do you offer?',
		['manipulate_success'] = '~o~Guard~s~: ~g~I will see what I can do...',
		['manipulate_fail'] = '~o~Guard~s~: ~r~No chance! ~s~The attempt will be reported immediately to the prison administration!',
		['not_enough_money'] = '~r~You do not have enough money!',
		['guard_work'] = 'Ask for work',
		['guard_work_info'] = '~y~Guard: ~s~Have a look here...\n>> ~p~Waypoint ~s~was ~p~set!',
		['guard_no_work'] = '~r~Unfortunately there is no work to be done here!',
		['guard_food'] = 'Receive food ration',
		['guard_food_give'] = '~g~Here is your meal for today!',
		['guard_food_not_available'] = '~r~You can get your next meal in ~o~',
		['guard_food_not_available2'] = ' minutes',
		['menu_prisons'] = 'Manage prisons',
		['menu_playername'] = 'Name: ',
		['menu_waypoint'] = 'Set waypoint',
		['menu_inmates'] = 'Inmates:',
		['inmate_desc'] = 'Remaining ~y~',
		['inmate_desc2'] = ' ~s~minutes',
		['menu_inmate'] = 'Inmate:',
		['menu_reason'] = 'Reason:',
		['menu_remaining_time'] = 'Remaining time:',
		['menu_remaining_time2'] = ' minutes',
		['menu_officer_name'] = 'Imprisoned by:',
		['menu_time'] = 'Imprisoned at:',
		['menu_change_time'] = '~o~Change remaining time',
		['menu_arrestTime'] = 'Remaining time:',
		['menu_seconds'] = ' seconds',
		['menu_minutes'] = ' minutes',
		['menu_confirm'] = '~g~Confirm',
		['menu_confirm_desc'] = 'Confirm your action',
		['time_changed'] = '~r~The Jail-time was changed to ~s~',
		['time_changed2'] = ' seconds~r~.',
		['menu_release'] = '~g~Release inmate',
		['menu_release_confirm'] = 'Really want to release the inmate?',
		['released_officer'] = ' ~g~is now being released...',
		['no_inmates'] = '- Currently no inmates',
		['arrest_player'] = 'Arrest somebody',
		['menu_arrest'] = 'Arrest this player',
		['reason_dialog'] = 'Reason?',
		['time_dialog'] = 'How long?',
		['arrest_confirm'] = '~o~Arrest this player',
		['arrest_desc'] = 'Click to confirm this player',
		['send_to_prison'] = 'Click to send this player to the ~y~',
		['send_to_prison2'] = '~s~',
		['invalid'] = '~r~Invalid details!',
		['prison_log'] = 'Prisonlog',
		['prison_state'] = 'Satte: ',
		['escaped'] = '~r~Escaped',
		['released'] = '~g~Released',
		['in_prison'] = '~o~In prison',
		['prisonname'] = 'Prison:',
		['escaped_time'] = 'Escaped at:',
		['released_time'] = 'Released at:',
		['start_jail'] = 'Your imprisonment for ~o~',
		['start_jail2'] = ' ~s~starts now.\nRemaining time: ~o~',
		['start_jail3'] = ' seconds\n',
		['start_jail4'] = '~s~Officer: ~b~',
		['gps_off'] = '~r~The GPS no longer provides any data!',
		['released_early'] = '~g~You were released by ~w~',
		['released_early2'] = ' ~g~Enjoy your freedom!',
		['server_imprisoned'] = ' ~s~was imprisioned for  ~o~',
		['server_imprisoned2'] = ' seconds~s~. \nReason: ~o~',
		['not_enough_cops'] = '~r~There are not enough cops online to escape',
		['infobar_management'] = 'Press ~g~E~s~, to open the management'
	}
}