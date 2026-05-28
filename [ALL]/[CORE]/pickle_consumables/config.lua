Config = {}

Config.Debug = true

Config.Language = "cs" -- Language to use.

Config.RenderDistance = 100.0 -- Scenario display Radius.

Config.InteractDistance = 2.0 -- Interact Radius

Config.UseTarget = true -- When set to true, it'll use targeting instead of key-presses to interact.

Config.NoModelTargeting = true -- When set to true and using Target, it'll spawn a small invisible prop so you can third-eye when no entity is defined.

Config.Marker = { -- This will only be used if enabled, not using target, and no model is defined in the interaction.
    enabled = false,
    id = 2,
    scale = 0.25, 
    color = {255, 255, 255, 127}
}

Config.Effects = {
    ["high"] = {
        canOverlap = false, -- If the effect can be started on-top of others (recommended: false)
        process = function(data)
            local time = data.time or 5000
            local intensity = data.intensity or 1.0
            local player = PlayerId()
            local ped = PlayerPedId()
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Wait(0)
            end    
            SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
            SetPedMotionBlur(ped, true)
            SetPedIsDrunk(ped, true)
            SetTimecycleModifier("spectator6")
            for i=1, 100 do 
                SetTimecycleModifierStrength(i * 0.01)
                ShakeGameplayCam("DRUNK_SHAKE", i * 0.01)
                Wait(10)
            end
            Wait(time)
            for i=1, 100 do 
                SetTimecycleModifierStrength(1.0 - (i * 0.01))
                ShakeGameplayCam("DRUNK_SHAKE", (1.0 - (i * 0.01)))
                Wait(10)
            end
            SetPedMoveRateOverride(player, 1.0)
            SetRunSprintMultiplierForPlayer(player, 1.0)
            SetPedIsDrunk(ped, false)
            SetPedMotionBlur(ped, false)
            ResetPedMovementClipset(ped, 1.0)
        end
    },
    ["drunk"] = {
        canOverlap = false, -- If the effect can be started on-top of others (recommended: false)
        process = function(data)
            local time = data.time or 5000
            local intensity = data.intensity or 1.0
            local player = PlayerId()
            local ped = PlayerPedId()
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Wait(0)
            end    
            SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
            SetPedMotionBlur(ped, true)
            SetPedIsDrunk(ped, true)
            SetTimecycleModifier("drug_wobbly")
            for i=1, 100 do 
                SetTimecycleModifierStrength(i * 0.01)
                ShakeGameplayCam("DRUNK_SHAKE", i * 0.01)
                Wait(10)
            end
            Wait(time)
            for i=1, 100 do 
                SetTimecycleModifierStrength(1.0 - (i * 0.01))
                ShakeGameplayCam("DRUNK_SHAKE", (1.0 - (i * 0.01)))
                Wait(10)
            end
            SetPedMoveRateOverride(player, 1.0)
            SetRunSprintMultiplierForPlayer(player,1.0)
            SetPedIsDrunk(ped, false)		
            SetPedMotionBlur(ped, false)
            ResetPedMovementClipset(ped, 1.0)
        end
    },
}

Config.ExternalStatus = function(source, name, amount) -- (Server-Sided) Implement custom exports and events for external status resources.
    if amount == 0 then return end
    if amount > 0 then -- Add Status
        if amount > 200 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", amount)
        else
            TriggerEvent("evidence:client:SetStatus", "alcohol", amount)
        end
        if GetResourceState("ps_buffs") == "started" then
            local amount = math.abs(amount)
            exports.ps_buffs:AddBuff(source, GetIdentifier(source), name, amount)
        end
    else -- Remove Status
        if GetResourceState("ps_buffs") == "started" then
            local amount = math.abs(amount)
            exports.ps_buffs:RemoveBuff(source, GetIdentifier(source), name)
        end
    end
end

Config.Options = { -- Item Options
    drop = {
        despawnTime = 120, -- Seconds until it deletes the entity after dropping it.
    },
    throwing = { 
        despawnTime = 5, -- Seconds until it deletes the entity after throwing it.
        power = 20, -- The amount of power to use when throwing the entity.
    }
}

Config.MaxValues = { -- If you want a custom maximum for a value, change -1 to the number. This is already handled in the bridge.
    hunger  = -1,
    thirst  = -1,
    stress  = -1,
    armor   = -1,
    stamina = -1,
}

Config.Items = {
    ["cigarette"] = {
        uses = 10,
        prop = { model = `prop_cigar_03`, boneId = 28422, offset = vec3(-0.05, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_aa_smoke@male@base", anim = "base", time = 10000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_aa_smoke@male@idle_a", anim = "idle_b", time = 10000, params = { nil, nil, nil, 49 } },
        --effect = { name = "high", time = 5000, intensity = 1.0 },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 20,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    ["cigbox"] = {
        uses = 20,
        prop = { model = `v_res_tt_cigs01`, boneId = 28422, offset = vec3(0.0476, 0.02817, -0.0104), rotation = vec3(0.0, 0.0, 0.0) },
        animation = { dict = "mp_arresting", anim = "a_uncuff", time = 2000, params = { nil, nil, nil, 49 } },
        rewards = { -- Per use. Types include: "item", "money"
            {type = "item", name = "cigarette", amount = 1},
        },
    },

    ["granule"] = {
        uses = 1,
      --  prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
      --  animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },


    ["rohlik"] = {
        uses = 3,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 3,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["susenka"] = {
        uses = 2,
        prop = { model = `prop_choc_ego`, boneId = 60309, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "satisfaction", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 2,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["donut"] = {
        uses = 3,
        prop = { model = `prop_donut_02b`, boneId = 60309, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
      --  idle = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "satisfaction", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 2,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["bramburky"] = {
        uses = 1,
        prop = { model = `v_ret_ml_chips2`, boneId = 28422, offset = vec3(0.01, -0.05, -0.1), rotation = vec3(0.0, 0.0, 90.0) },
        idle = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "satisfaction", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 4,
            thirst  = -4,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
     },

    ["jablko"] = {
        uses = 1,
        prop = { model = `sf_prop_sf_apple_01a`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-50.0, 16.0, 60.0) },
        idle = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "satisfaction", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 6,
            thirst  = 7,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["banan"] = {
        uses = 1,
        prop = { model = `v_res_tre_banana`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-50.0, 16.0, 60.0) },
        idle = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "satisfaction", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 7,
            thirst  = 6,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

 -- PITí

     ["kofola"] = {
        uses = 1,
        prop = { model = `prop_ecola_can`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["dzus"] = {
        uses = 1,
        prop = { model = `prop_ecola_can`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["voda2"] = {
        uses = 3,
        prop = { model = `prop_ecola_can`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["voda3"] = {
        uses = 3,
        prop = { model = `prop_ecola_can`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["energetickynapoj"] = {
        uses = 1,
        prop = { model = `prop_ecola_can`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },


    ["kava"] = {
        uses = 1,
        prop = { model = `p_amb_coffeecup_01`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "caffeine_boost", time = 360000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 50,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["caj"] = {
        uses = 1,
        prop = { model = `p_amb_coffeecup_01`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "caffeine_boost", time = 360000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 75,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    -- hotová jídla

    ["gulas"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["svickova"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["veprovyrizek"] = {
        uses = 1,
        prop = { model = `prop_cs_steak`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

        ["kurecirizekshranolky"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["stejkhovezi"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["pecenekoleno"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

 -- rychlovky

    ["parekvrohliku2"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["klobasa"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["utopenec"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["nakladanyhermelin"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["tatarecekstopinkou"] = {
        uses = 1,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 100,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['kung_pao'] = {
        uses = 1,
        prop = { model = `prop_food_cb_nu_takeout`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 15000,
            thirst  = 0, -- pálivé jídlo, trochu ubere žízeň
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
  
    ['cinska_polevka'] = {
        uses = 1,
        prop = { model = `prop_food_cb_nu_takeout`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
   
    ['nudle'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 10000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
   
    ['sushi2'] = {
        uses = 1,
        prop = { model = `v_res_tt_sushitray`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 15000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_margherita'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_marinara'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 4500,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_quattroformaggi'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 6500,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_capricciosa'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5500,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_quattrostagioni'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5500,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['pizza_diavola'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-150.0, 80.0, 10.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 3500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5200,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_margherita'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1200,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_marinara'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_quattroformaggi'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1500,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_capricciosa'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1300,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_quattrostagioni'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1300,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    
    ['slice_diavola'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.13, 0.05, 0.02), rotation = vec3(-100.0, 90.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 1250,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },    

 -- ostatní picoviny

    ["slanetycinky"] = {
        uses = 4,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 200000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["arasidy"] = {
        uses = 4,
        prop = { model = `prop_cs_burger_01`, boneId = 18905, offset = vec3(0.1114, 0.0389, 0.0497), rotation = vec3(160.2057, 77.8283, -7.5425) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 200000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

   


 -- chlast

    ["beerbottle2"] = {
        uses = 3,
        prop = { model = `prop_cs_beer_bot_01`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 100000,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },

    ["beerbottle3"] = {
        uses = 3,
        prop = { model = `prop_cs_beer_bot_01`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 100000,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },


    ["beerbottle4"] = {
        uses = 3,
        prop = { model = `prop_cs_beer_bot_01`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 100000,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },


    ["beerbottle5"] = {
        uses = 3,
        prop = { model = `prop_cs_beer_bot_01`, boneId = 18905, offset = vec3(0.1, 0.01, 0.01), rotation = vec3(100.0, 0.0, -180.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2000, params = { nil, nil, nil, 49 } },
       -- effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = { -- Per use. Values are based on percentage of the max value of the status. If below zero, it will remove the status percentage.
            hunger  = 0,
            thirst  = 100000,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },



    ["slivovice"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 60,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["tequilla"] = {
        uses = 2,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["vodka"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["wiskey"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["jager"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["tuzemak"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["rum"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 10000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 20,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ["becherovka"] = {
        uses = 1,
        prop = { model = `p_cs_shot_glass_s`, boneId = 28422, offset = vec3(-0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 100000, intensity = 2.0 },
        status = {
            hunger  = 0,
            thirst  = 20000,  -- Adjusted for a gin_shot
            stress  = 0,
            armor   = 0,
            alcohol = 210,  -- Adjusted for a gin_shot
            stamina = 0,
        },
    },
    ['kung_pao'] = {
        uses = 1,
        prop = { model = `prop_food_cb_nu_takeout`, boneId = 18905, offset = vec3(0.12, 0.05, 0.05), rotation = vec3(160.0, 80.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 15000,
            thirst  = -5, -- pálivé jídlo, trochu ubere žízeň
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    ['cinska_polevka'] = {
        uses = 1,
        prop = { model = `prop_food_cb_nu_takeout`, boneId = 18905, offset = vec3(0.12, 0.05, 0.05), rotation = vec3(160.0, 80.0, 0.0) },
        animation = { dict = "mp_player_intdrink", anim = "loop_bottle", time = 2500, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 5000,
            thirst  = 30,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    ['nudle'] = {
        uses = 1,
        prop = { model = `prop_food_bs_chips`, boneId = 18905, offset = vec3(0.12, 0.05, 0.05), rotation = vec3(160.0, 80.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 10000,
            thirst  = 0,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    ['sushi'] = {
        uses = 1,
        prop = { model = `v_res_tt_sushitray`, boneId = 18905, offset = vec3(0.15, 0.05, 0.05), rotation = vec3(160.0, 80.0, 0.0) },
        animation = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger_fp", time = 2000, params = { nil, nil, nil, 49 } },
        status = {
            hunger  = 15000,
            thirst  = 5,
            stress  = 0,
            armor   = 0,
            alcohol = 0,
            stamina = 0,
        }
    },
    ["bahamamama"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 8000, intensity = 0.8 },
        status = {
            hunger  = 0,
            thirst  = 30000,
            stress  = 0,
            armor   = 0,
            alcohol = 25,
            stamina = 0,
        },
    },
    ["pinacolada"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 6000, intensity = 0.6 },
        status = {
            hunger  = 0,
            thirst  = 35000,
            stress  = 0,
            armor   = 0,
            alcohol = 20,
            stamina = 0,
        },
    },
    ["mojito"] = {
        uses = 2,
        prop = { model = `prop_drink_wht500l`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 5000, intensity = 0.5 },
        status = {
            hunger  = 0,
            thirst  = 40000,
            stress  = 0,
            armor   = 0,
            alcohol = 15,
            stamina = 0,
        },
    },
    ["bluelagoon"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 7000, intensity = 0.7 },
        status = {
            hunger  = 0,
            thirst  = 30000,
            stress  = 0,
            armor   = 0,
            alcohol = 22,
            stamina = 0,
        },
    },
    ["sexonthebeach"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 7000, intensity = 0.7 },
        status = {
            hunger  = 0,
            thirst  = 32000,
            stress  = 0,
            armor   = 0,
            alcohol = 20,
            stamina = 0,
        },
    },
    ["maitai"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 10000, intensity = 1.0 },
        status = {
            hunger  = 0,
            thirst  = 25000,
            stress  = 0,
            armor   = 0,
            alcohol = 35,
            stamina = 0,
        },
    },
    ["zombie"] = {
        uses = 2,
        prop = { model = `prop_cocktail_glass`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 15000, intensity = 1.5 },
        status = {
            hunger  = 0,
            thirst  = 20000,
            stress  = 0,
            armor   = 0,
            alcohol = 50,
            stamina = 0,
        },
    },
    ["cubalibre"] = {
        uses = 2,
        prop = { model = `prop_drink_wht500l`, boneId = 28422, offset = vec3(0.0, 0.0, 0.0), rotation = vec3(0.0, 0.0, 0.0) },
        idle = { dict = "amb@world_human_drinking@beer@male@base", anim = "base", time = 2000, params = { nil, nil, nil, 49 } },
        animation = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_b", time = 2000, params = { nil, nil, nil, 49 } },
        effect = { name = "drunk", time = 6000, intensity = 0.6 },
        status = {
            hunger  = 0,
            thirst  = 35000,
            stress  = 0,
            armor   = 0,
            alcohol = 25,
            stamina = 0,
        },
    },
}
