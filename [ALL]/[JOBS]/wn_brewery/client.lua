ESX = exports["es_extended"]:getSharedObject()
local CurrentShopBlips = {}
local PlayerData = {}
local PlayerJob
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerJob = PlayerData.job
	Wait(2000)
    CreateBlip()
    SpawnObjects()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	PlayerJob = job
	Wait(500)
    DeleteBlip()
    CreateBlip()
end)

RegisterNetEvent('wn_brewery:harvesthop')
AddEventHandler('wn_brewery:harvesthop', function()
    if Config.SkillCheck then 
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'e', 'e', 'e', 'e'})
        if success then
            if lib.progressBar({
                duration = 2000,
                label = TranslateCap('harvesting_hop'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
			        combat = true,
                },
                anim = {
                    dict = 'mp_ped_interaction',
                    clip = 'hugs_guy_b'
                },
                
            }) then TriggerServerEvent('wn_brewery:givehop')
            else 
                lib.notify({
                    title = TranslateCap('brewery'),
                    description = TranslateCap('you_failed'),
                    type = 'error'
                })
            end
        else    
            lib.notify({
                title = TranslateCap('brewery'),
                description = TranslateCap('you_failed'),
                type = 'error'
            })
        end
    else 
        if lib.progressBar({
            duration = Config.BarleyHopDuration,
            label = TranslateCap('harvesting_hop'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'mp_ped_interaction',
                clip = 'hugs_guy_b'
            },
        }) then TriggerServerEvent('wn_brewery:givehop')
        else 
            lib.notify({
                title = TranslateCap('brewery'),
                description = TranslateCap('you_failed'),
                type = 'error'
            })
        end
	end
end)

RegisterNetEvent('wn_brewery:harvestbarley')
AddEventHandler('wn_brewery:harvestbarley', function()
    if Config.SkillCheck then 
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'e', 'e', 'e', 'e'})
        if success then
            if lib.progressBar({
                duration = 2000,
                label = TranslateCap('harvesting_barley'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
			        combat = true,
                },
                anim = {
                    dict = 'random@mugging3',
                    clip = 'pickup_low'
                },
                prop = {
                    model = `prop_haybale_01`,
                    bone = 28422,
                    pos = vec3(0.03, 0.03, 0.02),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            }) then TriggerServerEvent('wn_brewery:givebarley')
            else 
                lib.notify({
                    title = TranslateCap('brewery'),
                    description = TranslateCap('you_failed'),
                    type = 'error'
                })
            end
        else    
            lib.notify({
                title = TranslateCap('brewery'),
                description = TranslateCap('you_failed'),
                type = 'error'
            })
        end
    else 
        if lib.progressBar({
            duration = Config.BarleyHarvestDuration,
            label = TranslateCap('harvesting_barley'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'random@mugging3',
                clip = 'pickup_low'
            },
            prop = {
                model = `prop_haybale_01`,
                bone = 28422,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            },
        }) then TriggerServerEvent('wn_brewery:givebarley')
        else 
            lib.notify({
                title = TranslateCap('brewery'),
                description = TranslateCap('you_failed'),
                type = 'error'
            })
        end
	end
end)

---

CreateThread(function()
    for k,v in pairs(Config.HopSpawnCoords) do  

        exports.ox_target:addSphereZone({
            coords = v - 1,
            radius = 2,
            debug = Config.EnableDebug,
            options = {
                {
                    name = 'harvesthop',
                    event = "wn_brewery:harvesthop",
                    icon = "fas fa-sign-in-alt",
                    label = TranslateCap('start_harvesth'),
                    groups = Config.JobName,
                    distance = 4,
                }
            }
        })
    end
end)

function SpawnObjects()
    CreateThread(function()
        for k,v in pairs(Config.HopSpawnCoords) do 
            plant = CreateObject(Config.HopModel, v - 1, false, false, false)
            FreezeEntityPosition(plant, true)
        end
        for k,v in pairs(Config.BarleySpawnCoords) do 
            haybale = CreateObject(Config.BarleyModel, v - 1, false, false, false)
            FreezeEntityPosition(haybale, true)
        end
    end)
end

function DeleteObjects()
    DeleteEntity(plant)
    DeleteEntity(haybale)
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteObjects()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    SpawnObjects()
end)

CreateThread(function()
    for k,v in pairs(Config.BarleySpawnCoords) do  

        exports.ox_target:addSphereZone({
            coords = v - 1,
            radius = 2,
            debug = Config.EnableDebug,
            options = {
                {
                    name = 'harvestharvestbarley',
                    event = "wn_brewery:harvestbarley",
                    icon = "fas fa-sign-in-alt",
                    label = TranslateCap('start_harvestb'),
                    groups = Config.JobName,
                    distance = 4,
                }
            }
        })
    end
end)

CreateThread(function()
    TriggerServerEvent("wn_brewery:registershop")
end)

function CreateBlip()
    if ESX.GetPlayerData().job.name == Config.JobName then 
        for _, v in pairs(Config.JobBlips) do
            local ShopBlips = AddBlipForCoord(v.BlipCoords)
            SetBlipSprite(ShopBlips, v.Sprite)
            SetBlipDisplay(ShopBlips, v.Display)
            SetBlipScale(ShopBlips, v.Scale)
            SetBlipColour(ShopBlips, v.Color)
            SetBlipAsShortRange(ShopBlips, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(v.Name)
            EndTextCommandSetBlipName(ShopBlips)

            table.insert(CurrentShopBlips, ShopBlips)
        end
    end
end

function DeleteBlip()
	if CurrentShopBlips[1] ~= nil then
		for i=1, #CurrentShopBlips, 1 do
		RemoveBlip(CurrentShopBlips[i])
		CurrentShopBlips[i] = nil
		end
	end
end

RegisterNetEvent('wn_brewery:openshop')
AddEventHandler('wn_brewery:openshop', function()
    exports.ox_inventory:openInventory('shop', { type = "BreweryShop", id = 1 })
end)

exports.ox_target:addSphereZone({
    coords = Config.BreweryShop,
    radius = 2,
    debug = Config.EnableDebug,
    options = {
        {
            name = 'breweryshop',
            event = "wn_brewery:openshop",
            icon = "fas fa-sign-in-alt",
            label = TranslateCap('open_shop'),
            groups = Config.JobName,
            distance = 4,
        }
    }
})

RegisterNetEvent('wn_brewery:openmenucooking', function()
    lib.registerContext({
        id = 'cookingmenu',
        title = TranslateCap('cooking_menu_title'),
        options = {
            {
                title = TranslateCap('cooking_menu_title_b_beer'),
                description = TranslateCap('cooking_menu_des_b_beer'),
                icon = 'circle',
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805195028840468/beerbottle.png",
                onSelect = function()
                    TriggerServerEvent("wn_brewery:bottlebeer")
                end     
            },
            {
                title = TranslateCap('cooking_menu_title_c_beer'),
                description = TranslateCap('cooking_menu_des_c_beer'),
                icon = 'circle',
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805323672322048/beercan.png",
                onSelect = function()
                    TriggerServerEvent("wn_brewery:canbeer")
                end     
            },
            {
                title = TranslateCap('cooking_menu_title_c_beer'),
                description = TranslateCap('cooking_menu_des_c_beer'),
                icon = 'circle',
                disabled = true,
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805323672322048/beercan.png",
                onSelect = function()
                    TriggerServerEvent("wn_brewery:soudekbeer")
                end     
            }

        }
    })


    lib.showContext('cookingmenu')
end)

exports.ox_target:addSphereZone({
    coords = Config.Cooking,
    radius = 2,
    debug = Config.EnableDebug,
    options = {
        {
            name = 'cooking',
            event = "wn_brewery:openmenucooking",
            icon = "fas fa-sign-in-alt",
            label = TranslateCap('start_cooking'),
            groups = Config.JobName,
            distance = 4,
        }
    }
})

lib.callback.register('wn_brewery:startprogressb', function()

	return lib.progressCircle({
		label = TranslateCap('cooking_b_beer'),
		duration = Config.BottleCookingDuration,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)

lib.callback.register('wn_brewery:startprogressc', function()

	return lib.progressCircle({
		label = TranslateCap('cooking_c_beer'),
		duration = Config.CanCookingDuration,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)

lib.callback.register('wn_brewery:startprogresspack', function()

	return lib.progressCircle({
		label = TranslateCap('packing_pack'),
		duration = Config.PackingDuration,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)

lib.callback.register('wn_brewery:startsellingpack', function()

	return lib.progressCircle({
		label = TranslateCap('selling_beer'),
		duration = Config.SellPackingDuration,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)


RegisterNetEvent('wn_brewery:packingmenu', function()
    lib.registerContext({
        id = 'packingmenu',
        title = TranslateCap('packing_menu_title'),
        options = {
            {
                title = TranslateCap('packing_menu_title_b_pack'),
                description = TranslateCap('packing_menu_des_b_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805408883802163/beerbottlepack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:packbeerb")
                end     
            },
            {
                title = TranslateCap('packing_menu_title_c_pack'),
                description = TranslateCap('packing_menu_des_c_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805442853478471/beercanpack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:packbeerc")
                end     
            },
            {
                title = TranslateCap('packing_menu_title_c_pack'),
                description = TranslateCap('packing_menu_des_c_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805442853478471/beercanpack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sudbeerpack")
                end     
            }
        }
    })


    lib.showContext('packingmenu')
end)

exports.ox_target:addSphereZone({
    coords = Config.PackingCoords,
    radius = 2,
    debug = Config.EnableDebug,
    options = {
        {
            name = 'packingstation',
            event = "wn_brewery:packingmenu",
            icon = "fas fa-sign-in-alt",
            label = TranslateCap('start_packing'),
            groups = Config.JobName,
            distance = 4,
        }
    }
})


RegisterNetEvent('wn_brewery:sellbeer', function()
    lib.registerContext({
        id = 'sellingmenu',
        title = TranslateCap('sell_beer_title'),
        options = {
            {
                title = TranslateCap('sell_beer_title_b_beer'),
                description = TranslateCap('sell_beer_des_b_beer'),
                icon = 'circle',
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805195028840468/beerbottle.png",
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellbeer")
                end     
            },
            {
                title = TranslateCap('sell_beer_title_c_beer'),
                description = TranslateCap('sell_beer_des_c_beer'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805323672322048/beercan.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellcan")
                end     
            },
            {
                title = TranslateCap('sell_beer_title_b_pack'),
                description = TranslateCap('sell_beer_des_b_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805408883802163/beerbottlepack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellbeerpack")
                end     
            },
                        {
                title = TranslateCap('sell_beer_title_c_beer'),
                description = TranslateCap('sell_beer_des_c_beer'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805323672322048/beercan.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellsuoudek")
                end     
            },
            {
                title = TranslateCap('sell_beer_title_b_pack'),
                description = TranslateCap('sell_beer_des_b_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805408883802163/beerbottlepack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellsoudekpack")
                end     
            },
            {
                title = TranslateCap('sell_beer_title_c_pack'),
                description = TranslateCap('sell_beer_des_c_pack'),
                image = "https://cdn.discordapp.com/attachments/906655633833623553/1146805442853478471/beercanpack.png",
                icon = 'circle',
                onSelect = function()
                    TriggerServerEvent("wn_brewery:sellcanpack")
                end     
            }
        }
    })


    lib.showContext('sellingmenu')
end)



exports.ox_target:addSphereZone({
    coords = vector3(316.9546, 2622.7971, 44.4550),
    radius = 2,
    debug = Config.EnableDebug,
    options = {
        {
            name = 'sellbeer',
            event = "wn_brewery:sellbeer",
            icon = "fas fa-sign-in-alt",
            label = TranslateCap('start_selling'),
            distance = 4,
            groups = Config.JobName,
        }
    }
})
