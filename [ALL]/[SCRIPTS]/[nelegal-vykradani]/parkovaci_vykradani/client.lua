local meterModels = {
    `prop_parknmeter_01`,
    `prop_parknmeter_02`
}

exports.ox_target:addModel(meterModels, {
    {
        name = 'rob_meter',
        icon = 'fa-solid fa-screwdriver',
        label = 'Vykrást automat',
        distance = 1.5,
        onSelect = function(data)
            lib.callback('parking_robbery:canRob', false, function(response)
                if response == "success" then
                    -- 1. Minihra
                    local success = lib.skillCheck({'easy', 'medium', 'hard'}, {'w', 'a', 's', 'd'})
                    
                    if success then
                        -- 2. Dispatch
                        local playerCoords = GetEntityCoords(cache.ped)
                        pcall(function()
                            TriggerServerEvent('cd_dispatch:AddNotification', {
                                job_table = {'police'},
                                coords = playerCoords,
                                title = 'Vykrádání automatu',
                                message = 'Byl nahlášen pokus o vloupání do parkovacího automatu',
                                flash = 0,
                                unique_id = tostring(math.random(1111, 9999)),
                                blip = {
                                    sprite = 67, scale = 1.1, color = 1, flashes = true, text = 'Vykrádání automatu', time = 5,
                                }
                            })
                        end)

                        -- 3. Progress Bar
                        if lib.progressBar({
                            duration = 5000,
                            label = 'Vybíráš drobné...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, car = true },
                            anim = {
                                dict = 'amb@prop_human_bum_bin@base',
                                clip = 'base'
                            },
                        }) then
                            TriggerServerEvent('parking_robbery:reward')
                        end
                    else
                        -- TADY SE LOCKPICK ZLOMÍ PŘI NEÚSPĚCHU
                        lib.notify({ title = 'Chyba', description = 'Lockpick se zlomil!', type = 'error' })
                        TriggerServerEvent('parking_robbery:breakLockpick')
                    end
                elseif response == "no_item" then
                    lib.notify({ title = 'Chyba', description = 'Nemáš u sebe lockpick!', type = 'error' })
                elseif response == "cooldown" then
                    lib.notify({ title = 'Pauza', description = 'Teď nemůžeš krást, počkej na pauzu.', type = 'error' })
                end
            end)
        end
    }
})