return {
	-- ███████╗██╗     ███████╗ ██████╗████████╗██████╗  ██████╗ ███╗   ██╗██╗ ██████╗███████╗
	-- ██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║██║██╔════╝██╔════╝
	-- █████╗  ██║     █████╗  ██║        ██║   ██████╔╝██║   ██║██╔██╗ ██║██║██║     ███████╗
	-- ██╔══╝  ██║     ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║██║╚██╗██║██║██║     ╚════██║
	-- ███████╗███████╗███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝██║ ╚████║██║╚██████╗███████║
	-- ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚══════╝


	-- TEMPLATE ITEMů	
	--[[

	['custom_item'] = {
		label = 'Custom Item',
		weight = 100,
		stack = false,
		buttons = {
			{
				label = 'Přejmenovat',
				action = function(slot)
					TriggerEvent('nbs_item_tags:client:wrightTag', slot)
				end
			},
			{
				label = 'Odstranit název',
				action = function(slot)
					TriggerEvent('nbs_item_tags:client:removeTag', slot)
				end
			}
		}
	},
]]

	['dalnicni_znamka'] = {
		label = 'Dalnicni znamka',
		weight = 10,
		stack = false,
		close = true,
		--description = 'Elektronicka dalnicni znamka'
	},

	["vehiclekey"] = {
		label = "Klíče od vozidla",
		--description = 'Klíče patří vozidlu, podle ktérého ',
		weight = 10,
		stack = false
	},

	["keybag"] = {
		label = "Klíčenka",
		--description = 'This is a key bag, you can store all your keys in it',
		weight = 10,
		stack = false
	},

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--	██████╗ ██████╗  ██████╗  ██████╗██╗   ██╗
	--	██╔══██╗██╔══██╗██╔═══██╗██╔════╝╚██╗ ██╔╝
	--	██║  ██║██████╔╝██║   ██║██║  ███╗╚████╔╝
	--	██║  ██║██╔══██╗██║   ██║██║   ██║ ╚██╔╝
	--	██████╔╝██║  ██║╚██████╔╝╚██████╔╝  ██║
	--	╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝

	-- pernik

	['ammonia'] = {
		label = 'Amoniak',
		weight = 500,
		stack = true,
	},

	['sodium_benzoate'] = {
		label = 'Benzoát sodný',
		weight = 750,
		stack = true,
	},

	['meth_tray'] = {
		label = 'Tác s metanfetaminem',
		weight = 1000,
		stack = true,
	},

	['meth'] = {
		label = 'Metanfetamin',
		weight = 1,
		stack = true,
	},

	['plastic_bag'] = {
		label = 'Plastový sáček',
		weight = 40,
		stack = true,
	},

	['meth_syringe'] = {
		label = 'Injekce s metanfetaminem',
		weight = 75,
		stack = true,
	},

	-- Cocaine related items

	['coke_seed'] = {
		label = 'Semínko koky',
		weight = 10,
		stack = true,
	},

	['coke_leaf'] = {
		label = 'List koky',
		weight = 50,
		stack = true,
	},

	['coke_paste'] = {
		label = 'Kokainová pasta',
		weight = 150,
		stack = true,
	},

	['coke'] = {
		label = 'Kokain',
		weight = 1,
		stack = true,
	},

	['coke_bag'] = {
		label = 'Sáček s kokainem ',
		weight = 50,
		stack = true,
	},

	['coke_doll'] = {
		label = 'Panenka',
		weight = 500,
		stack = true,
		description = "panenka plná kokainu"
	},

	-- Weed related items

	['weed_pot'] = {
		label = 'Květináč',
		weight = 500,
		stack = true,
	},

	['weed_seed'] = {
		label = 'Semínko trávy',
		weight = 2,
		stack = true,
	},

	['clean_weed_bud'] = {
		label = 'Čistý květ konopí',
		weight = 20,
		stack = true,
	},

	['weed_bud'] = {
		label = 'Květ konopí',
		weight = 20,
		stack = true,
	},

	['weed_bag'] = {
		label = 'Balíček trávy',
		weight = 20,
		stack = true,
	},

	['cookie_dough'] = {
		label = 'Těsto na sušenky',
		weight = 200,
		stack = true
	},

	['weed_cookie'] = {
		label = 'Weed sušenka',
		weight = 50,
		stack = true
	},

	['weed_papers'] = {
		label = 'Weed papíry',
		weight = 5,
		stack = true,
	},

	-- Heroin related items

	['poppy_seeds'] = {
		label = 'Semínka máku',
		weight = 5,
		stack = true,
	},

	['poppy_plant'] = {
		label = 'Mák',
		weight = 100,
		stack = true,
	},

	['heroin_bag'] = {
		label = 'Sáček s heroinem',
		weight = 50,
		stack = true,
	},

	['heroin_syringe'] = {
		label = 'Stříkačka s heroinem',
		weight = 75,
		stack = true,
	},

	['syringe'] = {
		label = 'Stříkačka',
		weight = 25,
		stack = true,
	},

	-- LSD related items

	['ergot_fungus'] = {
		label = 'Houba',
		weight = 50,
		stack = true,
	},

	['generic_leaf'] = {
		label = 'List',
		weight = 20,
		stack = true,
	},

	['lsd_liquid'] = {
		label = 'LSD tekutina',
		weight = 25,
		stack = true,
	},

	['lsd'] = {
		label = 'LSD',
		weight = 1,
		stack = true,
	},

	['art_papers'] = {
		label = 'Art papíry',
		weight = 5,
		stack = true,
	},

	-- Ecstasy related items

	['safrole_oil'] = {
		label = 'Safrolový olej',
		weight = 300,
		stack = true,
	},

	['ecstasy_crystals'] = {
		label = 'Krystaly extáze',
		weight = 1,
		stack = true,
	},

	['ecstasy_pill'] = {
		label = 'Pilulka extáze',
		weight = 15,
		stack = true,
	},

	-- Mushroom related items

	['mushrooms'] = {
		label = 'Mushrooms',
		weight = 1,
		stack = true,
	},

	['mushroom_powder'] = {
		label = 'Mushroom powder',
		weight = 1,
		stack = true,
	},

	['chocolate_chips'] = {
		label = 'Chocolate chips',
		weight = 30,
		stack = true,
	},

	['mushroom_chocolate'] = {
		label = 'Mushroom chocolate',
		weight = 45,
		stack = true,
	},

	-- Ketamine related items

	['anesthetic'] = {
		label = 'anesthetic',
		weight = 200,
		stack = true,
	},

	['ketamine'] = {
		label = 'Ketamine',
		weight = 1,
		stack = true,
	},

	['ketamine_bag'] = {
		label = 'Ketamine bag',
		weight = 50,
		stack = true,
	},

	-- Crack related items

	['baking_soda'] = {
		label = 'Baking soda',
		weight = 100,
		stack = true,
	},

	['crack'] = {
		label = 'Crack',
		weight = 1,
		stack = true,
	},

	['crack_bag'] = {
		label = 'Crack bag',
		weight = 50,
		stack = true,
	},

	['crack_pipe'] = {
		label = 'Crack pipe',
		weight = 150,
		stack = true,
	},

	['crack_syringe'] = {
		label = 'Crack syringe',
		weight = 75,
		stack = true,
	},

	['pipe'] = {
		label = 'Pipe',
		weight = 100,
		stack = true,
	},

	-- Fentanyl related items

	['npp_chemical'] = {
		label = 'NPP chemical',
		weight = 300,
		stack = true,
	},

	['aniline_solution'] = {
		label = 'Aniline solution',
		weight = 250,
		stack = true,
	},

	['fentanyl'] = {
		label = 'Fentanyl',
		weight = 1,
		stack = true,
	},

	['fentanyl_bag'] = {
		label = 'Fentanyl bag',
		weight = 25,
		stack = true,
	},

	['meth_table'] = {
		label = 'Meth table',
		weight = 2250,
		stack = false
	},

	['coke_table'] = {
		label = 'Coke table',
		weight = 2250,
		stack = false
	},

	['weed_table'] = {
		label = 'Weed table',
		weight = 2250,
		stack = false
	},

	['chem_table'] = {
		label = 'Chemistry table',
		weight = 2250,
		stack = false
	},

	['burner_phone'] = {
		label = 'Burner phone',
		weight = 200,
		stack = true
	},

	['light1'] = {
		label = 'Portable Lamp',
		weight = 2000,
		stack = true
	},

	['light2'] = {
		label = 'Portable Lamp',
		weight = 2000,
		stack = true
	},

	['fertilizer'] = {
		label = 'Fertilizer',
		weight = 250,
		stack = true
	},

	['water_can'] = {
		label = 'Watering can',
		weight = 250,
		stack = true
	},

	---------------------------------------------- DRUGY KONEC --------------------------------------------

	-- 	██████╗ ████████╗██╗  ██╗███████╗██████╗
	-- ██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
	-- ██║   ██║   ██║   ███████║█████╗  ██████╔╝
	-- ██║   ██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
	-- ╚██████╔╝   ██║   ██║  ██║███████╗██║  ██║
	--  ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

	['recycle'] = {
		label = 'Recyklované itemy',
		weight = 2000,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},


	['aluminum'] = {
		label = 'Hliník',
		weight = 1000,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},

	['plastic'] = {
		label = 'Plasty',
		weight = 700,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},

	['rubber'] = {
		label = 'Guma',
		weight = 250,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},

	['copper'] = {
		label = 'Měď',
		weight = 1000,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},

	['iron'] = {
		label = 'Ocel',
		weight = 1700,
		stack = true,
		description = "Tento item můžeš rozstřídit"
	},

	---------	-- propy spawn

	["prop_trojuhelnik"] = {
		label = 'Výstražný trojuhelník',
		description = "",
		prop = `bzzz_prop_vehicle_triangle_a`,
		vehiclesWillAvoid = true,
		weight = 1000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},

	["prop_bariera"] = {
		label = 'Bariéra',
		description = "",
		prop = `prop_barrier_work06a`,
		vehiclesWillAvoid = true,
		weight = 1000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},

	["prop_slowdown"] = {
		label = 'Cedule zpomal',
		description = "",
		prop = `stt_prop_sign_circuit_03`,
		vehiclesWillAvoid = true,
		weight = 1000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},


	["prop_15mph"] = {
		label = 'Cedule s omezením rychlosti',
		description = "",
		prop = `prop_sign_road_06a`,
		vehiclesWillAvoid = true,
		weight = 1000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},


	["prop_kuzel"] = {
		label = 'Kužel',
		description = "",
		prop = `prop_roadcone02b`,
		vehiclesWillAvoid = true,
		weight = 1000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},

	["prop_paka"] = {
		label = 'Stůl na páku',
		description = "",
		prop = `prop_arm_wrestle_01`,
		vehiclesWillAvoid = true,
		weight = 2000,
		stack = false,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},


	-- itemy jako nocni videni

	['nightvision'] = {
		label = 'Noční videní',
		weight = 1000,
		stack = false,
		client = {
			export = 'shark-leotools.vision'
		}
	},

	['thermalvision'] = {
		label = 'Termovize',
		weight = 1000,
		stack = false,
		client = {
			export = 'shark-leotools.vision'
		}
	},

	['gasmask'] = {
		label = 'CBRN maska',
		weight = 1000,
		stack = false,
		client = {
			export = 'shark-leotools.vision'
		}
	},

	['tintmeter'] = {
		label = 'Měřič propustnosti skel',
		weight = 400,
		consume = 0,
		stack = false,
		client = {
			usetime = 2500,
			export = 'fezz_windowtint.CheckTint'
		},
	},

	['drugtest'] = {
		label = 'Drogový test',
		weight = 50,
		stack = true,
		close = true,
		client = {
			export = 'av_drugtest.drugtest'
		}
	},
	
	['atest_kelly'] = {
		label = 'Atest okenních fólií',
		weight = 50,
		stack = false,
		close = true,
		client = {
			export = 'd_atest.showAtest'
		}
	},

	['breathalyzer'] = {
		label = 'Alkoholtester',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = {
			export = 'breathalyzer.useBreathalyzer'
		}
	},

	['megaphone'] = {
		label = 'Megafon',
		weight = 1500,
		allowArmed = false,
		consume = 0,
		client = {
			export = 'cb-megaphone.useMegaphone',
		},
		stack = false,
	},

	["phone"] = {
		label = "Telefon",
		weight = 190,
		stack = false,
		consume = 0
	},

	["tablet"] = {
		label = "Firemní tablet",
		weight = 840,
		stack = false,
		consume = 0,
		client = {
			event = "tablet:toggleOpen"
		}
	},
	-- WEAPON BOX

	['box-ammo-9'] = {
		label = 'Krabička 9 mm',
		description = '60x náboju',
		weight = 200,
		stack = true
	},

	['box-ammo-45'] = {
		label = 'Krabička 45 mm',
		description = '60x náboju',
		weight = 200,
		stack = true
	},

	['box-ammo-rifle'] = {
		label = 'Krabička 5.56 mm',
		description = '250x náboju',
		weight = 200,
		stack = true
	},

	['box-ammo-rifle2'] = {
		label = 'Krabička 7.62 mm',
		description = '250x náboju',
		weight = 200,
		stack = true
	},

	['box-ammo-shotgun'] = {
		label = 'Krabička 12Gauge',
		description = '60x náboju',
		weight = 200,
		stack = true
	},

	-- ostatni

	['fan'] = {
		label = 'Fan',
		weight = 220,
		server = {
			export = 'firetools.OxUseFan',
		},
	},

	['stabiliser'] = {
		label = 'Stabiliser',
		weight = 220,
		server = {
			export = 'firetools.OxUseStabilisers',
		},
	},

	['clamp_lockpick'] = {
		label = 'LockPick na botičku',
		weight = 200,
		stack = true,
	},

	['locker_chain'] = {
		label = 'Řetězová Botička',
		weight = 5000,
		stack = false,
	},

	['locker_wheel'] = {
		label = 'Klasická Botička',
		weight = 6500,
		stack = false,
	},

	['evidencebag'] = {
		label = 'Sáček na důkazy',
		weight = 15,
		stack = false,
		buttons = {
			{
				label = 'Přejmenovat',
				action = function(slot)
					TriggerEvent('nbs_item_tags:client:wrightTag', slot)
				end
			},
			{
				label = 'Odstranit název',
				action = function(slot)
					TriggerEvent('nbs_item_tags:client:removeTag', slot)
				end
			}
		}

	},

	['dl'] = {
		label = 'Řidičský průkaz',
		weight = 11,
		client = {
			image = 'card_ridicak.png'
		}
	},

	['id'] = {
		label = 'Občanský průkaz',
		weight = 11,
		client = {
			image = 'card_op.png'
		}
	},

	['wl'] = {
		label = 'Zbrojní průkaz',
		weight = 11,
		client = {
			image = 'card_zbrojak.png'
		}
	},

	['hl'] = {
		label = 'Lovecká license',
		weight = 11,
		client = {
			image = 'card_lovecka.png'
		}
	},

	['contract'] = {
		label = 'Smlouva',
		weight = 15,
		description = 'Tato smlouva slouží k odkopu vozidla'
	},

	['document'] = {
		label = 'Document',
		consume = 0,
	},

	['poukaz50'] = {
		label = 'Poukaz 50%',
		weight = 15,
	},

	['poukaz25'] = {
		label = 'Poukaz 25%',
		weight = 15,
	},

	['membership'] = {
		label = 'Členství v gymu',
		weight = 15,
	},

	['lscm'] = {
		label = 'Členství v golfu',
		weight = 15,
	},


	["spikestrip"] = {
		label = "Zastavovací pás",
		weight = 500,
		stack = false
	},

	['parachute'] = {
		label = 'Padák',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['gas_mask'] = {
		label = 'Plynová maska',
		weight = 500,
		stack = false,
		close = true,
		description = 'Ochrání vás před nebezpečnými plyny.',
		client = {
			export = 'kleno_heist.gas_mask' -- TADY: název_složky_skriptu.název_exportu
		}
	},

	['screwdriver'] = {
		label = 'Šroubovák',
		weight = 150,
		stack = true,
		close = true,
	},

	['lockpick'] = {
		label = 'Paklíč',
		weight = 150,
		stack = true,
		close = true,
	},

	['advanced-lockpick'] = {
		label = 'Vylepšený Lockpick',
		weight = 300,
		stack = true,
		close = true,
	},

	['headbag'] = {
		label = 'Pytel',
		weight = 150,
		stack = true,
		description = "Pytel, který můžete nasadit na hlavu jiných lidí.",
		client = {
			export = 'wx_headbag.headbag',
		},
	},

	['handcuffs'] = {
		label = 'Pouta',
		weight = 250,
		stack = false,
		close = true,
		consume = 0
	},

	['zipties'] = {
		label = 'Pásky',
		weight = 250,
		stack = false,
		close = true,
		consume = 0
	},

	['vehicle_plate'] = {
		label = 'Registrační značka',
		weight = 100,
		stack = false,
		client = {
			export = 'maku_plate.itemUsage'
		},
	},

	['hackingdevice'] = {
		label = 'Tablet',
		weight = 1000,
		description = 'Tablet s hackovacím zařízením',

	},

	["boombox"] = {
		label = "Boombox",
		weight = 2000,
		stack = false,
	},

	['radio'] = {
		label = 'Vysílačka',
		weight = 1000,
		stack = false,
		allowArmed = true,
	},

  	['radio2'] = {
		label = 'Vysílačka',
		weight = 1000,
		stack = false,
		allowArmed = true,
	},

	['bodycam'] = {
		label = 'Bodycam',
		weight = 200,
		stack = false,
		consume = 0,
	},

	['bandage'] = {
		label = 'Bandáže',
		description = 'Slouží k zastavení krvacení',
		weight = 115,
	},

	['medkit'] = {
		label = 'Lekárnička',
		weight = 250,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 15000,
		}
	},

	['armour'] = {
		label = 'Těžká Vesta',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['armour2'] = {
		label = 'Lehká Vesta',
		weight = 1500,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['outfitbag'] = {
		label = 'Batoh s outfity ',
		weight = 450,
		description = 'Díky tomuto batohu se můžete převléct',
		client = {
			event = 'wx_outfitbag:place'
		}
	},

	['black_money'] = {
		label = 'Špinavé peníze',
	},

	['money'] = {
		label = 'Peníze',
	},

	-- ███████╗ ██████╗  ██████╗ ██████╗
	-- ██╔════╝██╔═══██╗██╔═══██╗██╔══██╗
	-- █████╗  ██║   ██║██║   ██║██║  ██║
	-- ██╔══╝  ██║   ██║██║   ██║██║  ██║
	-- ██║     ╚██████╔╝╚██████╔╝██████╔╝
	-- ╚═╝      ╚═════╝  ╚═════╝ ╚═════╝ 	
-- lovení


['jelen_maso'] = {
    label = 'Jelení maso',
    weight = 500,
    stack = true,
    close = true,
    description = 'Čerstvé maso z jelena.'
},

['jelen_kuze'] = {
    label = 'Jelení kůže',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Kůže z uloveného jelena vhodná k dalšímu zpracování.'
},

['jelen_parohy'] = {
    label = 'Jelení parohy',
    weight = 1500,
    stack = true,
    close = true,
    description = 'Pevné a ostré parohy.'
},

['zvireci_kost'] = {
    label = 'Zvířecí kost',
    weight = 200,
    stack = true,
    close = true,
    description = 'Zbytky kostí z divoké zvěře.'
},

['zajici_maso'] = {
    label = 'Zaječí maso',
    weight = 300,
    stack = true,
    close = true,
    description = 'Křehké maso z divokého zajíce.'
},

['zajeci_kozka'] = {
    label = 'Zaječí kožka',
    weight = 200,
    stack = true,
    close = true,
    description = 'Jemná srst ze zajíce.'
},

['vlci_maso'] = {
    label = 'Vlčí maso',
    weight = 500,
    stack = true,
    close = true,
    description = 'Tuhé maso z divokého vlka.'
},

['vlci_kozesina'] = {
    label = 'Vlčí kožešina',
    weight = 1200,
    stack = true,
    close = true,
    description = 'Hustá a hřejivá kožešina z vlka.'
},

['vlci_zub'] = {
    label = 'Vlčí zub',
    weight = 50,
    stack = true,
    close = true,
    description = 'Ostrý špičák dravé šelmy.'
},

['kanci_maso'] = {
    label = 'Kančí maso',
    weight = 600,
    stack = true,
    close = true,
    description = 'Maso z divokého prasete.'
},

['kanci_kuze'] = {
    label = 'Kančí kůže',
    weight = 1500,
    stack = true,
    close = true,
    description = 'Drsná a silná kůže z divočáka.'
},

['kanci_kly'] = {
    label = 'Kančí kly',
    weight = 400,
    stack = true,
    close = true,
    description = 'Zahnuté kly z dospělého kance.'
},

 -- houby

    ['kosik_na_houby'] = {
        label = 'Košík na houby',
        weight = 200,
        stack = true,
        close = true,
    },
    ['hrib_smrkovy'] = {
        label = 'Hřib smrkový',
        weight = 50,
        stack = true,
        close = true,
        description = 'Krásný pravák do polévky.'
    },
    ['muchomurka_cervena'] = {
        label = 'Muchomůrka červená',
        weight = 50,
        stack = true,
        close = true,
        description = 'Tohle bys asi jíst neměl...'
    },
    ['liska_obecna'] = {
        label = 'Liška obecná',
        weight = 30,
        stack = true,
        close = true,
        description = 'Výborná do omáčky.'
    },
    ['bedla_vysoka'] = {
        label = 'Bedla vysoká',
        weight = 60,
        stack = true,
        close = true,
        description = 'Ideální na řízky.'
    },
    ['klouzek_slicny'] = {
        label = 'Klouzek sličný',
        weight = 40,
        stack = true,
        close = true,
        description = 'Klouže, ale chutná skvěle.'
    },

-- ryby 
    -- ================================= --
    --             NÁVNADY               --
    -- ================================= --
    ['zizaly'] = {
        label = 'Žížaly',
        weight = 50,
        stack = true,
        close = true,
        description = 'Základní návnada, ideální pro začátečníky.'
    },
    ['kukurice'] = {
        label = 'Kukuřice',
        weight = 100,
        stack = true,
        close = true,
        description = 'Sladká kukuřice. Kapři se po ní můžou utlouct.'
    },
    ['cervi'] = {
        label = 'Krabička červů',
        weight = 50,
        stack = true,
        close = true,
        description = 'Živí červi. Ryby na ně reagují rychleji.'
    },
    ['boilies'] = {
        label = 'Boilies',
        weight = 200,
        stack = true,
        close = true,
        description = 'Profesionální kuličky pro lov velkých kaprovitých ryb.'
    },
    ['trpytka'] = {
        label = 'Třpytka',
        weight = 20,
        stack = true,
        close = true,
        description = 'Umělá návnada, perfektní na dravce.'
    },
    ['zakazane_feromony'] = {
        label = 'Zakázané feromony',
        weight = 100,
        stack = true,
        close = true,
        description = 'Vysoce koncentrovaná nelegální látka. Láká ryby okamžitě. Raději se s tím nenech chytit.'
    },

    -- ================================= --
    --               RYBY                --
    -- ================================= --
    ['ouklej'] = {
        label = 'Ouklej',
        weight = 150,
        stack = true,
        close = true,
        description = 'Malá plevelná ryba z mělčiny.'
    },
    ['plotice'] = {
        label = 'Plotice',
        weight = 250,
        stack = true,
        close = true,
        description = 'Běžná ryba, dobrá tak leda pro kočku.'
    },
    ['cejn'] = {
        label = 'Cejn',
        weight = 800,
        stack = true,
        close = true,
        description = 'Plochá ryba, solidní úlovek.'
    },
    ['lin'] = {
        label = 'Lín',
        weight = 1200,
        stack = true,
        close = true,
        description = 'Zelenavá ryba žijící v bažinách a tůních.'
    },
    ['kapr'] = {
        label = 'Kapr',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Zlatá česká klasika. Nejlepší s bramborovým salátem.'
    },
    ['pstruh'] = {
        label = 'Pstruh',
        weight = 600,
        stack = true,
        close = true,
        description = 'Rychlý dravec z chladných horských řek.'
    },
    ['candat'] = {
        label = 'Candát',
        weight = 1800,
        stack = true,
        close = true,
        description = 'Ceněná dravá ryba s výborným masem.'
    },
    ['stika'] = {
        label = 'Štika',
        weight = 3500,
        stack = true,
        close = true,
        description = 'Zubatá královna českých vod.'
    },
    ['uhor'] = {
        label = 'Úhoř',
        weight = 1500,
        stack = true,
        close = true,
        description = 'Vzácná hadovitá ryba. Velmi kluzká!'
    },
    ['sumec'] = {
        label = 'Sumec',
        weight = 15000,
        stack = false, -- Sumec je tak velký, že by se asi neměl stackovat
        close = true,
        description = 'Obří monstrum z hlubin přehrady. Extrémně těžký úlovek.'
    },

    ['basic_rod'] = {
        label = 'Klasický prut',
        weight = 1000,
        stack = false, 
        close = true,
    },

    ['graphite_rod'] = {
        label = 'Kválitnější prut',
        weight = 1500,
        stack = false,
        close = true,
    },

    ['titanium_rod'] = {
        label = 'Titanový prut',
        weight = 1500,
        stack = false, 
        close = true,
    },

	-- jídlo a ingredience

	["cigarette"] = {
		label = 'Cigareta',
		weight = 10,
		stack = true,
	},

	["cigbox"] = {
		label = 'Box cigaret',
		weight = 250,
		stack = true,
	},

	['granule'] = {
		label = 'Granule',
		weight = 250,
		stack = true,
	},

	['rohlik'] = {
		label = 'Rohlík',
		weight = 50,
		stack = true,

	},

	['susenka'] = {
		label = 'Sušenka',
		weight = 80,
		stack = true,

	},

	['donut'] = {
		label = 'Donut',
		weight = 120,
		stack = true,

	},

	['bramburky'] = {
		label = 'Brambůrky',
		weight = 120,
		stack = true,

	},

	['jablko'] = {
		label = 'Jablko',
		weight = 150,
		stack = true,

	},

	['banan'] = {
		label = 'Banán',
		weight = 150,
		stack = true,

	},

	-- ingredience

	['smetana'] = {
		label = 'Smetana na vaření',
		weight = 105,
	},

	['hovezi'] = {
		label = 'Hovězí maso',
		weight = 105,
	},

	['vajicko'] = {
		label = 'Jedno vajíčko',
		weight = 105,
	},

	['knedlik'] = {
		label = 'Knedlík',
		weight = 105,
	},

	['cibule'] = {
		label = 'Cibule',
		weight = 105,
	},

	['kren'] = {
		label = 'křen',
		weight = 105,
	},

	['hermelin'] = {
		label = 'Hermelín',
		weight = 105,
	},

	['hortice'] = {
		label = 'Hořtčice',
		weight = 105,
	},

	['burt'] = {
		label = 'Buřt',
		weight = 105,
	},

	['chleba'] = {
		label = 'Chléb',
		weight = 105,
	},

	['eggs'] = {
		label = 'Plato vajec 30ks',
		weight = 1005,
	},

	['mouka'] = {
		label = 'Mouka',
		weight = 500,
		stack = true,
	},

	['brambory'] = {
		label = 'Brambory',
		weight = 500,
		stack = true,
	},

	['masoveprove'] = {
		label = 'Balené vepřové maso',
		weight = 500,
		stack = true,
	},

	['masokureci'] = {
		label = 'Balené kuřecí maso',
		weight = 500,
		stack = true,
	},

	['sklobasy'] = {
		label = 'Neopečení klobásy',
		weight = 500,
		stack = true,
	},
	['ryze'] = {
		label = 'Rýže',
		weight = 100,
		stack = true,
	},

	['kureci'] = {
		label = 'Syrové kuřecí maso',
		weight = 200,
		stack = true,
	},

	['arasidy'] = {
		label = 'Arašídy',
		weight = 50,
		stack = true,
	},

	['chilli'] = {
		label = 'Chilli paprička',
		weight = 20,
		stack = true,
	},

	['instantni_nudle'] = {
		label = 'Instantní nudle (balení)',
		weight = 80,
		stack = true,
	},

	['horka_voda'] = {
		label = 'Horká voda',
		weight = 200,
		stack = true,
	},

	['nudle_syrove'] = {
		label = 'Syrové nudle',
		weight = 100,
		stack = true,
	},

	['zelenina'] = {
		label = 'Mix zeleniny',
		weight = 150,
		stack = true,
	},

	['ryba'] = {
		label = 'Čerstvá ryba',
		weight = 300,
		stack = true,
	},

	['rasa'] = {
		label = 'Mořská řasa Nori',
		weight = 10,
		stack = true,
	},
	-- normalní pití

	['kofola'] = {
		label = 'Kofola',
		weight = 500,
		stack = true,

	},

	['dzus'] = {
		label = 'Džus',
		weight = 500,
		stack = true,
	},

	['voda2'] = {
		label = 'Voda neperlivá',
		weight = 500,
		stack = true,
	},

	['voda3'] = {
		label = 'Voda perlivá',
		weight = 500,
		stack = true,
	},

	['energetickynapoj'] = {
		label = 'Energetický nápoj',
		weight = 500,
		stack = true,
	},

	['mliko'] = {
		label = 'Mléko',
		weight = 500,
		stack = true,
	},

	['kava'] = {
		label = 'Káva',
		weight = 500,
		stack = true,
	},

	['caj'] = {
		label = 'Čaj',
		weight = 500,
		stack = true,
	},

	-- chlast

	['slivovice'] = {
		label = 'Slivovice 42%',
		weight = 700,
		stack = true,
	},

	['tequilla'] = {
		label = 'Tequilla',
		weight = 700,
		stack = true,
	},

	['vodka'] = {
		label = 'Vodka',
		weight = 700,
		stack = true,
	},

	['wiskey'] = {
		label = 'Whiskey',
		weight = 700,
		stack = true,
	},

	['jager'] = {
		label = 'Jägermeister',
		weight = 700,
		stack = true,
	},

	['tuzemak'] = {
		label = 'Tuzemák',
		weight = 700,
		stack = true,
	},

	['rum'] = {
		label = 'Rum',
		weight = 700,
		stack = true,
	},

	['becherovka'] = {
		label = 'Becherovka',
		weight = 700,
		stack = true,
	},

	['bahamamama'] = {
		label = 'Bahama Mama',
		weight = 500,
		stack = true,
		close = true,
	},

	['pinacolada'] = {
		label = 'Pina Colada',
		weight = 500,
		stack = true,
		close = true,
	},

	['mojito'] = {
		label = 'Mojito',
		weight = 500,
		stack = true,
		close = true,
	},

	['bluelagoon'] = {
		label = 'Blue Lagoon',
		weight = 500,
		stack = true,
		close = true,
	},

	['sexonthebeach'] = {
		label = 'Sex on the Beach',
		weight = 500,
		stack = true,
		close = true,
	},

	['maitai'] = {
		label = 'Mai Tai',
		weight = 500,
		stack = true,
		close = true,
	},

	['zombie'] = {
		label = 'Zombie',
		weight = 500,
		stack = true,
		close = true,
	},

	['cubalibre'] = {
		label = 'Cuba Libre',
		weight = 500,
		stack = true,
		close = true,
	},

	-- HOTOVA JIDLA

	['gulas'] = {
		label = 'Guláš s chlebem',
		weight = 700,
		stack = true,

	},

	['svickova'] = {
		label = 'Svíčková na smetaně',
		weight = 700,
		stack = true,

	},

	['veprovyrizek'] = {
		label = 'Vepřový řízek s bramborem',
		weight = 700,
		stack = true,

	},

	['kurecirizekshranolky'] = {
		label = 'Kuřecí řízek s hranolky',
		weight = 700,
		stack = true,

	},

	['stejkhovezi'] = {
		label = 'Stejk hověží',
		weight = 700,
		stack = true,

	},

	['pecenekoleno'] = {
		label = 'Pečené koleno s chlebem',
		weight = 700,
		stack = true,

	},

	['kung_pao'] = {
		label = 'Kung Pao',
		weight = 350,
		stack = true,
	},

	['cinska_polevka'] = {
		label = 'Čínská polévka',
		weight = 500,
		stack = true,
	},

	['nudle'] = {
		label = 'Nudle',
		weight = 300,
		stack = true,
	},

	['sushi3'] = {
		label = 'Sushi',
		weight = 250,
		stack = true,
	},

	----- Rychlovky

	['parekvrohliku2'] = {
		label = 'Párek v rohlíku',
		weight = 700,
		stack = true,

	},

	['klobasa'] = {
		label = 'Grilovaná klobása',
		weight = 700,
		stack = true,

	},

	['utopenec'] = {
		label = 'Utopenec',
		weight = 700,
		stack = true,

	},

	['nakladanyhermelin'] = {
		label = 'Nakládaný hermelín',
		weight = 700,
		stack = true,

	},

	['tatarecekstopinkou'] = {
		label = 'Tatarák s topinkou',
		weight = 700,
		stack = true,

	},

	--- pochutiny k piti

	['slanetycinky'] = {
		label = 'Slanné tyčinky',
		weight = 700,
		stack = true,

	},

	['arasidy2'] = {
		label = 'Arašídy solené',
		weight = 700,
		stack = true,

	},

	------ Pizzeria daník

	['pizza_margherita'] = {
		label = 'Pizza Margherita',
		weight = 750,
		stack = true,
	},

	['pizza_marinara'] = {
		label = 'Pizza Marinara',
		weight = 700,
		stack = true,
	},

	['pizza_quattroformaggi'] = {
		label = 'Pizza Quattro Formaggi',
		weight = 850,
		stack = true,
	},

	['pizza_capricciosa'] = {
		label = 'Pizza Capricciosa',
		weight = 800,
		stack = true,
	},

	['pizza_quattrostagioni'] = {
		label = 'Pizza Quattro Stagioni',
		weight = 800,
		stack = true,
	},

	['pizza_diavola'] = {
		label = 'Pizza Diavola',
		weight = 780,
		stack = true,
	},

	------ Kousky pizzi

	['slice_margherita'] = {
		label = 'Kousek Margherity',
		weight = 100,
		stack = true,
	},

	['slice_marinara'] = {
		label = 'Kousek Marinary',
		weight = 100,
		stack = true,
	},

	['slice_quattroformaggi'] = {
		label = 'Kousek Quattro Formaggi',
		weight = 110,
		stack = true,
	},

	['slice_capricciosa'] = {
		label = 'Kousek Capricciosy',
		weight = 110,
		stack = true,
	},

	['slice_quattrostagioni'] = {
		label = 'Kousek Quattro Stagioni',
		weight = 110,
		stack = true,
	},

	['slice_diavola'] = {
		label = 'Kousek Diavoly',
		weight = 100,
		stack = true,
	},

	['pizza_dough'] = {
		label = 'Těsto (bochánek)',
		weight = 200,
		stack = true,
		close = true,
	},

	['pizza_ingredients'] = {
		label = 'Sada ingrediencí',
		weight = 300,
		stack = true,
		close = true,
	},

	-- Víno

	["emptywinebottle"] = {
		label = "Prázdná lahev",
		weight = 150,
		stack = true,
		close = true,
	},

	["redgrape"] = {
		label = "redgrape",
		weight = 13,
		stack = true,
		close = true,
	},

	["redwinebottle"] = {
		label = "Lahev červeného vína",
		weight = 10,
		stack = true,
		close = true,
	},

	["whitegrape"] = {
		label = "whitegrape",
		weight = 10,
		stack = true,
		close = true,
	},

	["whitewinebottle"] = {
		label = "Láhev bílého vína",
		weight = 1,
		stack = true,
		close = true,
	},

	["dirty_wine_bottle"] = {
		label = "Špinavá láhev",
		weight = 1,
		stack = true,
		close = true,
	},

	["empty_wine_bottle_labeled"] = {
		label = "Prázdná láhev označená",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_wine_prepared"] = {
		label = "Bílé hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["wine_glass"] = {
		label = "Sklenička",
		weight = 1,
		stack = true,
		close = true,
	},

	["wine_label"] = {
		label = "Etiketa na víno",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_wine_bottle"] = {
		label = "Modrý Portugal",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_wine_glass"] = {
		label = "Sklenička M.Portugal",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_wine_grapes"] = {
		label = "Červené hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_wine_juice"] = {
		label = "Červené lisované hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_wine_prepared"] = {
		label = "Červené hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine_bottle"] = {
		label = "Frankovka rosé",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine_glass"] = {
		label = "Sklenička Fr.rosé",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine_grapes"] = {
		label = "Růžové hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine_juice"] = {
		label = "Růžové lisované hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine_prepared"] = {
		label = "Růžové hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["scissors"] = {
		label = "Nůžky",
		weight = 1,
		stack = true,
		close = true,
	},

	["scissors_dirty"] = {
		label = "Špinavé Nůžky",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_wine_juice"] = {
		label = "Bílé lisované hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_wine_grapes"] = {
		label = "Bílé hrozny",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_wine_glass"] = {
		label = "Sklenička Veltlínského",
		weight = 1,
		stack = true,
		close = true,
	},

	["empty_wine_bottle"] = {
		label = "Umytá Prázdná láhev",
		weight = 10,
		stack = true,
		close = true,
	},

	["white_wine_bottle"] = {
		label = "Veltlínské zelené",
		weight = 10,
		stack = true,
		close = true,
	},

	["burcak_bottle"] = {
		label = "Burčák",
		weight = 10,
		stack = true,
		close = true,
	},

	["svarak_bottle"] = {
		label = "Svařák",
		weight = 10,
		stack = true,
		close = true,
	},

	-- pivo bewerly

	["sud"] = {
		label = "Sud",
		weight = 10,
		stack = true,
		close = true,
	},

	["bottle"] = {
		label = "Skleněná Lahev",
		weight = 10,
		stack = true,
		close = true,
	},

	["water"] = {
		label = "Voda",
		weight = 10,
		stack = true,
		close = true,
	},

	["can"] = {
		label = "Plechovka",
		weight = 10,
		stack = true,
		close = true,
	},

	["hop"] = {
		label = "Chmel",
		weight = 4,
		stack = true,
		close = true,
	},

	["haybale"] = {
		label = "Pšenice",
		weight = 4,
		stack = true,
		close = true,
	},

	["beerbottle"] = {
		label = "Plzeň 12 světlý ležák (sklo)",
		weight = 100,
		stack = true,
		close = true,
	},

	["beersud"] = {
		label = "Plzeň 12 světlý ležák (Sud)",
		weight = 1000,
		stack = true,
		close = true,
	},


	["beercan"] = {
		label = "Plzeň 12 světlý ležák (plechovka)",
		weight = 100,
		stack = true,
		close = true,
	},

	["beerbottlepack"] = {
		label = "Pivo ve sklenici PACK",
		weight = 1000,
		stack = true,
		close = true,
	},

	["beercanpack"] = {
		label = "Pivo v plechovce PACK",
		weight = 1000,
		stack = true,
		close = true,
	},

	['access_card'] = {
		label = 'Přístupová karta (Elektrárna)',
		weight = 150,
		stack = false,
		close = true,
		description = 'Karta s vysokým stupněm oprávnění pro ovládání městské sítě.',
	},


	-- ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗    ██████╗  ██████╗ ██████╗ ██████╗ ███████╗██████╗ ██╗   ██╗
	-- ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝    ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗╚██╗ ██╔╝
	-- ███████║██║   ██║██║   ██║███████╗█████╗      ██████╔╝██║   ██║██████╔╝██████╔╝█████╗  ██████╔╝ ╚████╔╝
	-- ██╔══██║██║   ██║██║   ██║╚════██║██╔══╝      ██╔══██╗██║   ██║██╔══██╗██╔══██╗██╔══╝  ██╔══██╗  ╚██╔╝
	-- ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗    ██║  ██║╚██████╔╝██████╔╝██████╔╝███████╗██║  ██║   ██║
	-- ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   					


	["goldchain"] = {
		label = "Zlatej Náhrdelník",
		weight = 30,
		stack = true,
	},

	["goldtooth"] = {
		label = "Zlatej Zub",
		weight = 30,
		stack = true,
	},

	["stolen_goods"] = {
		label = "Zlatý Mince",
		weight = 50,
		stack = true,
	},

	["contract_tablet"] = {
		label = "Contract Tablet",
		weight = 100,
		stack = false,
	},

	["oxygenmask"] = {
		label = "kyslíková maska",
		weight = 200,
		stack = false,
	},

	["emptyoxygenmask"] = {
		label = "prázdná kyslíková maska",
		weight = 200,
		stack = false,
	},

	["drill"] = {
		label = "Vrtačka",
		weight = 50,
		stack = false,
	},

	["gold_ingot"] = {
		label = "Zlatý cihla",
		weight = 10,
		stack = true,
	},

	['dvd'] = { -- HOUSEROBBERY
		label = 'Přehrávač',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['television'] = { -- HOUSEROBBERY
		label = 'Televize',
		weight = 500,
		stack = true,
		close = true,
		description = nil
	},

	['shoebox'] = { -- HOUSEROBBERY
		label = 'Boty',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},

	['torchkit'] = { -- Provide heist
		label = 'Elektrod',
		weight = 160,
	},

	['trowel'] = { -- Provide heist
		label = 'Lopatka',
		weight = 100,
	},

	['blue_keycard'] = {
		label = 'Blue Keycard',
		weight = 100,
		stack = false
	},

	['purple_keycard'] = {
		label = 'Purple Keycard',
		weight = 100,
		stack = false
	},

	['hack_usb'] = {
		label = 'Phantom USB',
		weight = 100,
		stack = false
	},

	['hack_card'] = {
		label = 'Spoofing Card',
		weight = 100,
		stack = false
	},

	['coins'] = {
		label = 'Coins',
		weight = 10,
	},

	['painting'] = {
		label = 'Painting',
		weight = 100,
	},

	['bomb_c4'] = {
		label = 'C4 Explosive',
		weight = 3000,
	},

	['angle_grinder'] = {
		label = 'Angle Grinder',
		weight = 1500,
	},

	['contracts_tablet'] = {
		label = 'Contract Tablet',
		stack = false,
		weight = 400,
	},

	['classified_docs'] = {
		label = 'Classified Documents',
		weight = 100,
	},

	['diamond_necklace'] = {
		label = 'Diamond Necklace',
		weight = 100,
	},

	['diamonds_box'] = {
		label = 'Diamonds Box',
		weight = 200,
	},

	['luxurious_watch'] = {
		label = 'Luxurious Watch',
		weight = 200,
	},

	['rare_coins'] = {
		label = 'Rare Coins',
		weight = 500,
	},

	['diamond_ring'] = {
		label = 'Diamond Ring',
		weight = 50,
	},

	['gold_bar'] = {
		label = 'Gold Bar',
		weight = 500,
	},

	["large_drill"] = {
		label = "Large Drill",
		weight = 12500,
		stack = true,
		close = true,
	},

	['casino_keycard'] = {
		label = 'Casino Keycard',
		weight = 100,
		stack = false
	},

	["small_drill"] = {
		label = "Small Drill",
		weight = 2000,
		stack = true,
		close = true,
	},

	['explosives'] = {
		label = 'Explosives',
		weight = 3000,
	},

	['tv'] = {
		label = 'Television',
		weight = 12500,
		stack = true,
	},

	['microwave'] = {
		label = 'Microwave',
		weight = 7500,
		stack = true,
	},

	['monitor'] = {
		label = 'Computer Monitor',
		weight = 5000,
		stack = true,
	},

	['printer'] = {
		label = 'Printer',
		weight = 10000,
		stack = true,
	},

	['flat_tv'] = {
		label = 'Flat Screen TV',
		weight = 12500,
		stack = true,
	},

	['old_tv'] = {
		label = 'Old TV',
		weight = 12500,
		stack = true,
	},

	['dj_deck'] = {
		label = 'DJ Deck',
		weight = 7500,
		stack = true,
	},

	['console'] = {
		label = 'Gaming Console',
		weight = 3000,
		stack = true,
	},

	['keyboard'] = {
		label = 'Keyboard',
		weight = 500,
		stack = true,
	},

	['laptop'] = {
		label = 'Laptop',
		weight = 2500,
		stack = true,
	},

	['bong'] = {
		label = 'Bong',
		weight = 1000,
		stack = true,
	},

	['meth_bag'] = {
		label = 'Meth Bag',
		weight = 50,
		stack = true,
	},

	['coke_brick'] = {
		label = 'Coke Brick',
		weight = 200,
		stack = true,
	},

	['weed_brick'] = {
		label = 'Weed Brick',
		weight = 200,
		stack = true,
	},

	['pink_diamond'] = {
		label = 'Pink Diamond',
		weight = 100,
	},

	['rare_tequila'] = {
		label = 'Rare Tequila',
		weight = 300,
	},

	['plasma_cutter'] = {
		label = 'Plasma cutter',
		weight = 1000,
		stack = true,
	},

	['thermite'] = {
		label = 'Thermite',
		weight = 1500,
		stack = false
	},

	["gsr_cloth"] = {
		label = "GSR Cloth",
		weight = 100,
		stack = true,
		close = true,
	},

	["gsr_test_kit"] = {
		label = "GSR Test Kit",
		weight = 100,
		stack = true,
		close = true,
	},

	["uv_light"] = {
		label = "UV Flashlight",
		weight = 250,
		stack = true,
		close = true,
	},

	["evidence_camera"] = {
		label = "Evidence Camera",
		weight = 500,
		stack = true,
		close = true,
	},

	["fingerprint_scanner"] = {
		label = "Fingerprint Scanner",
		weight = 250,
		stack = true,
		close = true,
	},

	["bullet_casing"] = {
		label = "Bullet Casing",
		weight = 1,
		stack = false,
	},

	["bullet_fragment"] = {
		label = "Bullet Fragment",
		weight = 1,
		stack = false,
	},

	["blood_sample"] = {
		label = "Blood Sample",
		weight = 1,
		stack = false,
	},

	["fingerprint"] = {
		label = "Fingerprint Sample",
		weight = 1,
		stack = false,
	},

	["evidence"] = {
		label = "Evidence",
		weight = 1,
		stack = false,
	},

	["bullet_hole"] = {
		label = "Impact Sample",
		weight = 1,
		stack = false,
	},

	['crowbar'] = {
		label = 'Páčidlo',
		weight = 2000,
		stack = false,
		close = true,
	},

	-- Spotřební materiál pro loupež
	['gas_canister'] = {
		label = 'Plyn do ventilace',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Těžká nádoba s dýmovým plynem. Ideální pro vyřazení alarmů.'
	},

	-- Hlavní loot (předměty, co hráč získá)
	['jewel_emerald'] = {
		label = 'Smaragd',
		weight = 50,
		stack = true,
		close = true,
		description = 'Vzácný broušený smaragd vysoké hodnoty.'
	},

	['jewel_diamond'] = {
		label = 'Diamant',
		weight = 50,
		stack = true,
		close = true,
		description = 'Čistý diamant. Na černém trhu za něj dostaneš balík.'
	},

	['gold_ring'] = {
		label = 'Zlatý prsten',
		weight = 100,
		stack = true,
		close = true,
		description = 'Prsten z 24 karátového zlata.'
	},
	['processor'] = {
		label = 'Procesor',
		weight = 100,
		stack = true,
		close = true,
		description = 'Klíčová součástka vytažená ze staré elektroniky.'
	},

	['broken_phone'] = {
		label = 'Opotřebený telefon',
		weight = 350,
		stack = true,
		close = true,
		description = 'Starý křáp, který se dá využít na náhradní díly.'
	},

	['antenna'] = {
		label = 'Anténka',
		weight = 150,
		stack = true,
		close = true,
		description = 'Zesilovač signálu, nezbytný pro bezdrátové spojení.'
	},

	['car_door'] = {
		label = 'Dveře z auta',
		weight = 5000,
		stack = true,
		close = true
	},

	['car_hood'] = {
		label = 'Kapota',
		weight = 7000,
		stack = true,
		close = true
	},

	['car_trunk'] = {
		label = 'Kufr',
		weight = 6000,
		stack = true,
		close = true
	},

	['car_seat'] = {
		label = 'Autosedačka',
		weight = 4000,
		stack = true,
		close = true
	},

	['fluid_canister'] = {
		label = 'Kanystr s kapalinou',
		weight = 3000,
		stack = true,
		close = true
	},

	['car_electronics'] = {
		label = 'Autoelektronika',
		weight = 2000,
		stack = true,
		close = true
	},

	['fishing_rod'] = {
		label = 'Rybářský prut',
		weight = 1000,
		stack = false,
		close = true,
	},

	['fishing_bait'] = {
		label = 'Návnada',
		weight = 50,
		stack = true,
		close = true,
	},

	['carp'] = {
		label = 'Kapr',
		weight = 2000,
		stack = true,
	},

	['pike'] = {
		label = 'Štika',
		weight = 1500,
		stack = true,
	},

	['perch'] = {
		label = 'Okoun',
		weight = 800,
		stack = true,
	},

	['event1'] = {
		label = 'Event Coin 1',
		weight = 0,
		stack = true,
		close = true
	},

	['event2'] = {
		label = 'Event Coin 2',
		weight = 0,
		stack = true,
		close = true
	},

	['event3'] = {
		label = 'Event Coin 3',
		weight = 0,
		stack = true,
		close = true
	},

	['obvaz'] = {
		label = 'Sterilní obvaz',
		weight = 100,
		stack = true,
		close = true,
		description = 'Základní krytí ran. Používá se na tržné rány a tupá traumata.'
	},

	['siti'] = {
		label = 'Lékařské šití',
		weight = 150,
		stack = true,
		close = true,
		description = 'Sada pro uzavření hlubokých ran. Nezbytné pro střelná zranění.'
	},

	['dezinfekce'] = {
		label = 'Dezinfekční sprej',
		weight = 200,
		stack = true,
		close = true,
		description = 'Čistí rány a zabraňuje infekci. Používá se na odřeniny.'
	},

	['dlaha'] = {
		label = 'Fixační dlaha',
		weight = 500,
		stack = true,
		close = true,
		description = 'Pevná dlaha pro znehybnění zlomených končetin.'
	},

	['skrtidlo'] = {
		label = 'Škrtidlo (Tourniquet)',
		weight = 100,
		stack = true,
		close = true,
		description = 'Zastavuje masivní tepenné krvácení na rukou a nohou.'
	},

	['gel'] = {
		label = 'Chladivý gel',
		weight = 150,
		stack = true,
		close = true,
		description = 'Okamžitá pomoc při popáleninách.'
	},

	['lekarnicka'] = {
		label = 'Trauma Kit',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Komplexní lékařská sada pro vnitřní zranění a pneumotorax.'
	},

	['kyslik_maska'] = {
		label = 'Kyslíková maska',
		weight = 800,
		stack = true,
		close = true,
		description = 'Zvyšuje hladinu kyslíku v krvi a stabilizuje oxidaci.'
	},

	['adrenalin'] = {
		label = 'Adrenalinová injekce',
		weight = 50,
		stack = true,
		close = true,
		description = 'Stimuluje srdce při zástavě nebo kriticky nízkém tepu.'
	},

  -- novacek


["newscam"] = {
	label = "News Camera",
	weight = 100,
	stack = false,
	close = true,
	consume = 0,
	description = "A camera for the news",
	client = {
		event = 'shark-newscam:toggleCam'
	}
},

["newsbmic"] = {
	label = "Boom Microphone",
	weight = 100,
	stack = false,
	close = true,
	description = "A Useable BoomMic",
	client = {
		event = 'shark-newscam:togglebmic'
	}
},

["newsmic"] = {
	label = "News Microphone",
	weight = 100,
	stack = false,
	close = true,
	description = "A microphone for the news",
	client = {
		event = 'shark-newscam:togglemic'
	}
},  
  
    ['paper_blank'] = {
        label = 'Blank Sheet',
        weight = 10,
        stack = false,
        close = true,
        client = {
            image = 'nui://b2b_documents/web/images/paper.png',
            export = 'b2b_documents.usePaper'
        }
    },

    ['document'] = {
        label = 'Document',
        weight = 10,
        stack = false,
        close = true,
        client = {
            image = 'nui://b2b_documents/web/images/document.png',
            export = 'b2b_documents.usePaper'
        }
    },


}
