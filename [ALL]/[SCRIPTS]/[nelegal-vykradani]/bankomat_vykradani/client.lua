local atmModels = {
    `prop_atm_01`, `prop_atm_02`, `prop_atm_03`, `prop_fleeca_atm`
}

exports.ox_target:addModel(atmModels, {
    {
        name = 'atm_robbery',
        icon = 'fa-solid fa-laptop-code',
        label = 'Hacknout bankomat',
        distance = 1.5,
        onSelect = function(data)
            -- 1. Kontrola oprávnění na serveru (Item + Cooldown + POLICIE)
            lib.callback('atm_robbery:canRob', false, function(status)
                if status == "success" then
                    local ped = cache.ped
                    
                    -- Startovací animace (vytahování zařízení)
                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_TOURIST_MOBILE", 0, true)
                    
                    -- 2. Spuštění PS-UI Hacking (Maze - Bludiště)
                    -- Hráč má 20 sekund na dokončení
                    exports['ps-ui']:Maze(function(success)
                        if success then
                            -- ÚSPĚCH V HACKINGU
                            ClearPedTasks(ped)
                            
                            -- Volání Dispatche
                            local coords = GetEntityCoords(ped)
                            TriggerServerEvent('atm_robbery:callPolice', coords)

                            -- 3. Finální progress (stahování hotovosti)
                            if lib.progressBar({
                                duration = 15000,
                                label = 'Stahování hotovosti z kazet bankomatu...',
                                useWhileDead = false,
                                canCancel = true,
                                disable = { move = true, car = true, combat = true },
                                anim = {
                                    dict = 'anim@heists@ornate_bank@hack',
                                    clip = 'hack_loop'
                                },
                            }) then
                                TriggerServerEvent('atm_robbery:reward')
                            else
                                lib.notify({ title = 'Zrušeno', description = 'Spojení bylo přerušeno!', type = 'error' })
                            end
                        else
                            -- FAIL V HACKINGU
                            ClearPedTasks(ped)
                            local coords = GetEntityCoords(ped)
                            -- Policie jede i při failu (tichý alarm)
                            TriggerServerEvent('atm_robbery:callPolice', coords)
                            lib.notify({ title = 'Alarm', description = 'Zabezpečení tě odpojilo, policie je na cestě!', type = 'error' })
                            TriggerServerEvent('atm_robbery:breakDevice')
                        end
                    end, 20) 

                elseif status == "no_police" then
                    lib.notify({ 
                        title = 'Chyba', 
                        description = 'V oblasti není dostatek policejních hlídek!', 
                        type = 'error' 
                    })
                elseif status == "no_item" then
                    lib.notify({ title = 'Chyba', description = 'Nemáš u sebe hackovací zařízení!', type = 'error' })
                elseif status == "cooldown" then
                    lib.notify({ title = 'Chyba', description = 'Bankomaty jsou v nouzovém režimu. Zkus to později!', type = 'error' })
                end
            end)
        end
    }
})