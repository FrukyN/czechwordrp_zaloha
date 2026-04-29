local SafeLocations = {
    { coords = vec3(378.1032, 333.4614, 103.5664) }, 
    { coords = vec3(24.52, -1345.12, 29.5) }, 
}

local ShelfModels = {
    `v_ret_247shelves05`, `v_ret_247shelves01`, `v_ret_247shelves02`,
    `v_ret_247shelves03`, `v_ret_247shelves04`, `prop_ff_shelf_01`, 
    `prop_shelf_01`, `v_ret_ml_shelves`, `v_ret_fh_shelf01`
}

local isRobbing = false
local trackerBlips = {}

-- GPS BLIPY PRO POLICII
RegisterNetEvent('gr_robbery:client:updateTrackerBlip', function(robberId, coords)
    if not trackerBlips[robberId] then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 458) 
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1) 
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pachatel - Útěk")
        EndTextCommandSetBlipName(blip)
        trackerBlips[robberId] = blip
    else
        SetBlipCoords(trackerBlips[robberId], coords.x, coords.y, coords.z)
    end
end)

RegisterNetEvent('gr_robbery:client:removeTrackerBlip', function(robberId)
    if trackerBlips[robberId] then
        RemoveBlip(trackerBlips[robberId])
        trackerBlips[robberId] = nil
    end
end)

-- TARGET: POKLADNA
exports.ox_target:addModel(`prop_till_01`, {
    {
        name = 'rob_till',
        icon = 'fas fa-cash-register',
        label = 'Vykrást pokladnu',
        onSelect = function(data)
            if isRobbing then return end
            if not IsPedArmed(cache.ped, 4) then 
                lib.notify({ title = 'Chyba', description = 'Vytáhni zbraň!', type = 'error' })
                return 
            end

            lib.notify({ description = 'Žádost o RP loupež odeslána...', type = 'inform' })
            
            local approved = lib.callback.await('gr_robbery:server:requestApproval', false)
            if approved then
                isRobbing = true
                TriggerServerEvent('gr_robbery:server:startRobbery', GetEntityCoords(data.entity))
                
                local success = lib.progressBar({
                    duration = 15000,
                    label = 'Vybíráš pokladnu...',
                    useWhileDead = false,
                    canCancel = true,
                    disable = { move = true, combat = false },
                    anim = { dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab' }
                })

                if success then
                    TriggerServerEvent('gr_robbery:server:completeCash')
                else
                    TriggerServerEvent('gr_robbery:server:cancelHeist', 'Přerušil jsi loupež.')
                end
                isRobbing = false
            else
                lib.notify({ title = 'Zamítnuto', description = 'Žádost byla zamítnuta.', type = 'error' })
            end
        end
    }
})

-- OSTATNÍ TARGETY (Regály a Trezory)
exports.ox_target:addModel(ShelfModels, {
    {
        label = 'Prohledat regál', icon = 'fas fa-shopping-basket',
        onSelect = function(data)
            local canRob = lib.callback.await('gr_robbery:server:canRobExtras', false)
            if not canRob then return lib.notify({ description = 'Teď nemůžeš vybírat regály!', type = 'error' }) end
            if lib.progressBar({ duration = 5000, label = 'Hledáš...', useWhileDead = false, canCancel = true, disable = { move = true }, anim = { dict = 'random@arrests', clip = 'generic_bin_link_f' } }) then
                TriggerServerEvent('gr_robbery:server:shelfReward', GetEntityCoords(data.entity))
            end
        end
    }
})

for i, loc in ipairs(SafeLocations) do
    exports.ox_target:addBoxZone({
        name = "safe_"..i, coords = loc.coords, size = vec3(1.2, 1.2, 1.8),
        options = {
            {
                label = 'Otevřít trezor', icon = 'fas fa-keypad',
                onSelect = function()
                    local canRob = lib.callback.await('gr_robbery:server:canRobExtras', false)
                    if not canRob then return end
                    local input = lib.inputDialog('Trezor', {{type = 'number', label = 'PIN', required = true}})
                    if input then
                        local ok = lib.callback.await('gr_robbery:server:trySafe', false, input[1])
                        if ok then lib.notify({ description = 'Otevřeno!', type = 'success' })
                        else lib.notify({ description = 'Špatný PIN!', type = 'error' }) end
                    end
                end
            }
        }
    })
end

-- ADMIN UI
lib.callback.register('gr_robbery:client:adminDecision', function(playerName, playerId)
    local alert = lib.alertDialog({
        header = '⚠️ ŽÁDOST O LOUPEŽ',
        content = ('Hráč: **%s** (ID: %s)\n\nSchvaluješ tuto loupež?'):format(playerName, playerId),
        centered = true, cancel = true, labels = { confirm = 'Povolit ✅', cancel = 'Zamítnout ❌' }
    })
    return alert == 'confirm'
end)