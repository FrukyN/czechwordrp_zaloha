exports.ox_target:addGlobalObject({
    {
        name = "itemcollection:pickup",
        icon = "fa-solid fa-hand",
        label = "Sebrat",
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if not entity or not DoesEntityExist(entity) then return false end
            
            local model = GetEntityModel(entity)
            return config[model] ~= nil
        end,
        onSelect = function(data)
            local entity = data.entity
            if not entity or not DoesEntityExist(entity) then return end

            local model = GetEntityModel(entity)
            local mission = IsEntityAMissionEntity(entity)
            local netid = mission and NetworkGetNetworkIdFromEntity(entity) or false
            
            lib.requestAnimDict("anim@mp_snowball")
            TaskPlayAnim(cache.ped, "anim@mp_snowball", "pickup_snowball", 2.0, 2.0, -1, 50, 0, 0, 0, 0)
            
            Wait(900)
            
            StopAnimTask(cache.ped, "anim@mp_snowball", "pickup_snowball", 2.0)

            TriggerServerEvent("itemcollection:pickup", netid, not mission and model)
            
            if not mission and DoesEntityExist(entity) then
                SetEntityAsMissionEntity(entity)
                DeleteEntity(entity)
            end
        end
    }
})

AddStateBagChangeHandler("vehiclesAvoidProp", nil, function(bagName, key, value, reserved, replicated)
    local entity = GetEntityFromStateBagName(bagName)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end
    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end
    SetObjectForceVehiclesToAvoid(entity, value)
end)