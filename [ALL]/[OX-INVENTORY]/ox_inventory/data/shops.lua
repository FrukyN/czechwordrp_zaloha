return {
	Lekarna = {
		name = 'OBCHOD: Lekárna',
		inventory = {
			{ name = 'bandage', price = 100 }
		},
		targets = {
			{ loc = vec3(-1832.5726, -381.3010, 49.4005), length = 4.0, width = 4.0, heading = 21.2307, minZ = 49.0, maxZ = 49.6, distance = 6 }
		}
	},

	dvacetdnisedm = {
		name = "OBCHOD: Malý obchod",
		blip = {
			id = 59, colour = 69, scale = 0.8
		},
		inventory = {
			{ name = 'contract', price = 300 },
			{ name = 'voda2', price = 20 },
			{ name = 'mliko', price = 25 },
			{ name = 'energetickynapoj', price = 35 },
			{ name = 'rohlik', price = 3 },
			{ name = 'donut', price = 15 },
			{ name = 'tatranka', price = 15 },
			{ name = 'bramburky', price = 62 },
			{ name = 'jablko', price = 5 },
			{ name = 'banan', price = 6 },
			{ name = 'prop_trojuhelnik', price = 700 },
			{ name = 'cigbox', price = 140 },
			{ name = 'outfitbag', price = 1500 },


		},
		locations = {
			vec3(25.7, -1347.3, 29.49),
			vec3(-3038.71, 585.9, 7.9),
			vec3(-3241.47, 1001.14, 12.83),
			vec3(1728.66, 6414.16, 35.03),
			vec3(1961.48, 3739.96, 32.34),
			vec3(547.79, 2671.79, 42.15),
			vec3(2679.25, 3280.12, 55.24),
			vec3(2557.94, 382.05, 108.62),
			vec3(373.55, 325.56, 103.56),
			vec3(-1820.6238, 792.8839, 138.1107), 
			vec3(1163.1954, -323.8600, 69.2050), 
			vec3(-707.7231, -913.7519, 19.2156), 
			vec3(1697.99, 4924.4, 42.06), 
			vec3(-48.6176, -1758.2260, 29.4210), 


		},
		targets = {
			{ loc = vec3(25.06, -1347.32, 29.5),   length = 0.7, width = 0.5, heading = 0.0,   minZ = 29.5,   maxZ = 29.9,   distance = 1.5 },
			{ loc = vec3(-3039.18, 585.13, 7.91),  length = 0.6, width = 0.5, heading = 15.0,  minZ = 7.91,   maxZ = 8.31,   distance = 1.5 },
			{ loc = vec3(-3242.2, 1000.58, 12.83), length = 0.6, width = 0.6, heading = 175.0, minZ = 12.83,  maxZ = 13.23,  distance = 1.5 },
			{ loc = vec3(1728.39, 6414.95, 35.04), length = 0.6, width = 0.6, heading = 65.0,  minZ = 35.04,  maxZ = 35.44,  distance = 1.5 },
			{ loc = vec3(1960.54, 3740.28, 32.34), length = 0.6, width = 0.5, heading = 120.0, minZ = 32.34,  maxZ = 32.74,  distance = 1.5 },
			{ loc = vec3(548.5, 2671.25, 42.16),   length = 0.6, width = 0.5, heading = 10.0,  minZ = 42.16,  maxZ = 42.56,  distance = 1.5 },
			{ loc = vec3(2678.29, 3279.94, 55.24), length = 0.6, width = 0.5, heading = 330.0, minZ = 55.24,  maxZ = 55.64,  distance = 1.5 },
			{ loc = vec3(2557.19, 381.4, 108.62),  length = 0.6, width = 0.5, heading = 0.0,   minZ = 108.62, maxZ = 109.02, distance = 1.5 },
			{ loc = vec3(373.13, 326.29, 103.57),  length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 },
			{ loc = vec3(-1820.465332, 793.816589, 138.212799), length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 
			{ loc = vec3(1164.206055, -322.890167, 69.319183),  length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 
			{ loc = vec3(-706.638184, -913.688660, 19.329681),  length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 
			{ loc = vec3(1698.37, 4923.43, 42.06),        length = 0.5, width = 0.5, heading = 235.0, minZ = 42.06,  maxZ = 42.46,  distance = 1.5 }, 
			{ loc = vec3(-47.198711, -1757.670044, 29.535088),  length = 0.6, width = 0.6, heading = 0.0, minZ = 29.06,  maxZ = 29.56,  distance = 1.5 },


		}
	},
	alkohol = {
		name = "OBCHOD: Obchod s alkoholem",
		blip = {
			id = 59, colour = 19, scale = 0.8
		},
		inventory = {
			{ name = 'slivovice', price = 300 },
			{ name = 'tequilla', price = 700 },
			{ name = 'vodka', price = 500 },
			{ name = 'wiskey', price = 1000 },
			{ name = 'jager', price = 500 },
			{ name = 'tuzemak', price = 200 },
			{ name = 'rum', price = 300 },
			{ name = 'becherovka', price = 260},
		},
		locations = {
			vec3(1165.7450, 2708.9531, 38.1577), 
			vec3(-1222.9139, -906.8416, 12.3263), 
			vec3(1135.6448, -982.2766, 46.4158), 
			vec3(-1486.1653, -380.1234, 40.1634), 

		},
		targets = {
			{ loc = vec3(1165.958130, 2710.200928, 38.262173),  length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 
			{ loc = vec3(-1222.330566, -907.823364, 12.430837), length = 0.6, width = 0.5, heading = 345.0, minZ = 12, maxZ = 12.47, distance = 1.5 }, 
			{ loc = vec3(1134.811523, -982.361511, 46.520309),  length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 
			{ loc = vec3(-1486.672729, -378.463806, 40.267895), length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 }, 

		}
	},

	Elektronika = {
		name = "OBCHOD: Obchod s elektronikou",
		blip = {
			id = 521, colour = 29, scale = 0.8
		},
		inventory = {
			{ name = 'phone',                 price = 5000 },
			{ name = 'boombox',               price = 3000 },
			{ name = 'radio',                 price = 3000 },
			
		},
		locations = {
			vec3(1137.4890, -470.6948, 66.6651),
			vec3(65.8729, -1467.1633, 29.3000),
			vec3(-1523.0831, -408.0756, 35.5919),
			vec3(392.7372, -831.7038, 29.2917),
		},
		targets = {
			{ loc = vec3(1137.4890, -470.6948, 66.6651),  length = 0.8, width = 3.5, heading = 65.0, minZ = 66.0, maxZ = 66.8, distance = 4.0 },
			{ loc = vec3(65.8729, -1467.1633, 29.3000),   length = 0.8, width = 3.5, heading = 65.0, minZ = 29.0, maxZ = 29.5, distance = 4.0 },
			{ loc = vec3(-1523.0831, -408.0756, 35.5919), length = 0.8, width = 3.5, heading = 35.4, minZ = 35.6, maxZ = 29.5, distance = 4.0 },
			{ loc = vec3(392.7372, -831.7038, 29.2917),   length = 0.8, width = 3.5, heading = 29.2, minZ = 29.2, maxZ = 29.5, distance = 4.0 },
		}
	},


	YouTool = {
		name = "OBCHOD: Kutilské potřeby",
		blip = {
			id = 402, colour = 69, scale = 0.8
		},
		inventory = {
			{ name = 'lockpick',         price = 600 },
			{ name = 'screwdriver',      price = 200 },
			{ name = 'WEAPON_HAMMER',    price = 1500 },
			{ name = 'headbag',          price = 350 },
			{ name = 'contracts_tablet', price = 40000 },
			--{ name = 'zipties',          price = 250, }
		},
		locations = {
			vec3(2748.0, 3473.0, 55.67),
			vec3(46.7944, -1749.5803, 29.6328),
		},
		targets = {
			{ loc = vec3(2746.8, 3473.13, 55.67),       length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 },
			{ loc = vec3(46.7944, -1749.5803, 29.6328), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 } -- Heading 52.2693
		}
	},

	Ammunation = {
		name = "Obchod se zbraněni",
		blip = {
			id = 110, colour = 59, scale = 0.8
		},
		inventory = {
			{ name = 'WEAPON_PISTOL',     price = 35000, metadata = { registered = true }, license = 'weapon' },
			{ name = 'WEAPON_KNIFE',      price = 2000 },
			{ name = 'WEAPON_FLASHLIGHT', price = 1500 },
			{ name = 'WEAPON_BAT',        price = 1350 },
			{ name = 'ammo-9',            price = 3,     license = 'weapon' },
			{ name = 'ammo-45',           price = 5,     license = 'weapon' },
			{ name = 'box-ammo-9',        price = 180,   license = 'weapon' },
			{ name = 'box-ammo-45',       price = 300,   license = 'weapon' },
		},
		locations = {
			vec3(-662.180, -934.961, 21.829),
			vec3(810.25, -2157.60, 29.62),
			vec3(1693.44, 3760.16, 34.71),
			vec3(-330.24, 6083.88, 31.45),
			vec3(252.63, -50.00, 69.94),
			vec3(22.56, -1109.89, 29.80),
			vec3(2567.69, 294.38, 108.73),
			vec3(-1117.58, 2698.61, 18.55),
			vec3(842.44, -1033.42, 28.19)
		},
		targets = {
			{ loc = vec3(-660.92, -934.10, 21.94),  length = 0.6, width = 0.5, heading = 180.0,  minZ = 21.8,  maxZ = 22.2,  distance = 2.0 },
			{ loc = vec3(808.86, -2158.50, 29.73),  length = 0.6, width = 0.5, heading = 360.0,  minZ = 29.6,  maxZ = 30.0,  distance = 2.0 },
			{ loc = vec3(1693.57, 3761.60, 34.82),  length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7,  maxZ = 35.1,  distance = 2.0 },
			{ loc = vec3(-330.29, 6085.54, 31.57),  length = 0.6, width = 0.5, heading = 225.0,  minZ = 31.4,  maxZ = 31.8,  distance = 2.0 },
			{ loc = vec3(252.85, -51.62, 70.0),     length = 0.6, width = 0.5, heading = 70.0,   minZ = 69.9,  maxZ = 70.3,  distance = 2.0 },
			{ loc = vec3(23.68, -1106.46, 29.91),   length = 0.6, width = 0.5, heading = 160.0,  minZ = 29.8,  maxZ = 30.2,  distance = 2.0 },
			{ loc = vec3(2566.59, 293.13, 108.85),  length = 0.6, width = 0.5, heading = 360.0,  minZ = 108.7, maxZ = 109.1, distance = 2.0 },
			{ loc = vec3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5,  maxZ = 18.9,  distance = 2.0 },
			{ loc = vec3(841.05, -1034.76, 28.31),  length = 0.6, width = 0.5, heading = 360.0,  minZ = 28.2,  maxZ = 28.6,  distance = 2.0 }
		}
	},

	PoliceArmoury = {
		name = 'PCR Zbrojnice',
		groups = {
			['police'] = 0,
			['policie_mp'] = 0,
			['celnisprava'] = 0

		},
		inventory = {
			{ name = 'WEAPON_COMBATPISTOL',   price = 0,     metadata = { registered = true, serial = 'LEO' }, },
			{ name = 'WEAPON_STUNGUN',        price = 0,     metadata = { registered = true, serial = 'LEO' } },
			{ name = 'WEAPON_SPECIALCARBINE', price = 0,     metadata = { registered = true, serial = 'LEO' }, grade = 4 },
			{ name = 'WEAPON_BEANBAG',        price = 0,     metadata = { registered = true, serial = 'LEO' }, grade = 3 },
			{ name = 'WEAPON_SMG',            price = 0,     metadata = { registered = true, serial = 'LEO' }, grade = 3 },
			{ name = 'WEAPON_PUMPSHOTGUN',    price = 0,     metadata = { registered = true, serial = 'LEO' }, grade = 3 },
			{ name = 'WEAPON_FLASHLIGHT',     price = 0 },
			{ name = 'WEAPON_NIGHTSTICK',     price = 0 },
			{ name = 'at_flashlight',         price = 0 },
			{ name = 'at_scope_medium',       price = 0,     grade = 4 },
			{ name = 'at_grip',               price = 0,     grade = 4 },
			{ name = 'radio',                 price = 0 },
			{ name = 'bodycam',               price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 0 },
			{ name = 'prop_bariera',              price = 0 },
			{ name = 'prop_slowdown',              price = 0 },
			{ name = 'prop_15mph',              price = 0 },
			{ name = 'prop_kuzel',              price = 0 },
			{ name = 'tablet',                price = 0 },
			{ name = 'handcuffs',             price = 0 }, 	
			{ name = 'weapon_colbaton',       price = 0 },
			{ name = 'breathalyzer',          price = 0 },
			{ name = 'tintmeter',             price = 0 },
      			{ name = 'locker_chain',             price = 0 },
      			{ name = 'locker_wheel',             price = 0 },
      			{ name = 'clamp_lockpick',             price = 0 },
			{ name = 'armour',                price = 0 },
			{ name = 'armour2',               price = 0 },
			{ name = 'ammo-rifle',            price = 1, },
			{ name = 'ammo-rifle2',           price = 1,     grade = 8 },
			{ name = 'ammo-9',                price = 1 },
			{ name = 'ammo-shotgun',          price = 1 },
			{ name = 'box-ammo-rifle',        price = 1, },
			{ name = 'box-ammo-rifle2',       price = 1,     grade = 8 },
			{ name = 'box-ammo-9',            price = 1 },
			{ name = 'box-ammo-shotgun',      price = 1 },
			{ name = 'ammo-beanbag',          price = 1 },
			{ name = 'weapon_flashbang',      price = 0,     grade = 5 },
			{ name = 'spikestrip',            price = 0 },
			{ name = 'megaphone',             price = 0 },
			{ name = 'evidencebag',           price = 0 },
			{ name = 'WEAPON_SNIPERRIFLE',    price = 15000, metadata = { registered = true, serial = 'LEO' }, grade = 8 },
			{ name = 'WEAPON_RADARGUN',       price = 0 },
			{ name = 'drugtest',              price = 0 },
			
		},
		targets = {
			{ loc = vec3(452.1583, -975.9738, 30.2522),        length = 3.0, width = 3.0, heading = 345.0, minZ = 34.4, maxZ = 34.7, distance = 6 }, -- pcr zbrojnice
			{ loc = vec3(365.604400, -1609.556030, 29.279908), length = 3.0, width = 3.0, heading = 345.0, minZ = 30.5, maxZ = 32.0, distance = 6 },
			{ loc = vec3(1550.531860, 842.043946, 77.655640),  length = 3.0, width = 3.0, heading = 345.0, minZ = 30.5, maxZ = 32.0, distance = 6 },
			{ loc = vec3(-334.6553, -247.1754, 34.3954),  length = 3.0, width = 3.0, heading = 345.0, minZ = 34.4, maxZ = 34.7, distance = 6 }, -- mp
			{ loc = vec3(622.1030, -19.0718, 82.7784),  length = 4.0, width = 4.0, heading = 345.0, minZ = 82.6, maxZ = 82.9, distance = 6 }, -- celnisprava

		}
	},

	ZZSArmoury = {
		name = 'ZZS Zbrojnice',
		groups = {
			['ambulance'] = 0
		},
		inventory = {
			{ name = 'tablet',                  price = 0 },
			{ name = 'bandage',                 price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 0 },
			{ name = 'megaphone',               price = 0 },
			{ name = 'radio',                   price = 0 },
			{ name = 'outfitbag',                   price = 0 },
		},
		targets = {
			{ loc = vec3(-1814.320922, -353.116486, 49.465942), length = 3.0, width = 3.0, heading = 345.0, minZ = 30.5, maxZ = 32.0, distance = 6 }
		}
	},
	Hasic = {
		name = 'HZS Zbrojnice',
		groups = {
			['hzs'] = 0
		},
		inventory = {
			{ name = 'tablet',                  price = 0 },
			{ name = 'radio',                   price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 0 },
			{ name = 'WEAPON_HATCHET',          price = 0 },
			{ name = 'megaphone',               price = 0 },
			{ name = 'bandage',                 price = 0 },
			{ name = 'fan',                     price = 0 },
			{ name = 'WEAPON_SPREADER',               price = 0 },
			{ name = 'WEAPON_SAW',                     price = 0 },
			{ name = 'WEAPON_HALLIGAN',                price = 0 },
			{ name = 'stabiliser',              price = 0 },
			{ name = 'outfitbag',                   price = 0 },
			{ name = 'prop_bariera',              price = 0 },
			{ name = 'prop_slowdown',              price = 0 },
			{ name = 'prop_15mph',              price = 0 },
			{ name = 'prop_kuzel',              price = 0 },
		},
		targets = {
			{ loc = vec3(1211.367066, -1487.881348, 34.688598), length = 3.0, width = 3.0, heading = 21.2307, minZ = 34.0, maxZ = 36.0, distance = 6 }
		}
	},

	Bahama = {
		name = 'Bahama',
		groups = {
			['bahama'] = 0
		},
		inventory = {
			{ name = 'WEAPON_STUNGUN',        price = 0 },
			{ name = 'handcuffs',             price = 0 }, 
			{ name = 'WEAPON_NIGHTSTICK',     price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		},
		targets = {
			{ loc = vec3(-1389.2158, -592.0040, 30.3195), length = 4.5, width = 4.5, heading = 21.2307, minZ = 30.0, maxZ = 31.0, distance = 6 }
		}
	},

}