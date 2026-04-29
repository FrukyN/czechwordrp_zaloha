local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    personCarrying = {
        animDict = "missfinale_c2mcs_1",
        anim = "fin_c2_mcs_1_camman",
        flag = 49,
    },
    personCarried = {
        animDict = "nm",
        anim = "firemans_carry",
        attachX = 0.27,
        attachY = 0.15,
        attachZ = 0.63,
        flag = 33,
    }
}

local function startCarry()
    local ped = cache.ped or PlayerPedId()

    if not carry.InProgress then
        -- Využití ox_lib pro rychlejší získání nejbližšího hráče
        local playerCoords = GetEntityCoords(ped)
        local closestPlayer, closestDistance = lib.getClosestPlayer(playerCoords, 3.0, false)

        if closestPlayer then
            local targetSrc = GetPlayerServerId(closestPlayer)
            if targetSrc ~= 0 then
                carry.InProgress = true
                carry.targetSrc = targetSrc
                TriggerServerEvent("CarryPeople:sync", targetSrc)
                
                lib.requestAnimDict(carry.personCarrying.animDict)
                carry.type = "carrying"
            else
                lib.notify({ title = "Carry", description = "Nikdo poblíž!", type = "error" })
            end
        else
            lib.notify({ title = "Carry", description = "Nikdo poblíž!", type = "error" })
        end
    else
        carry.InProgress = false
        ClearPedSecondaryTask(ped)
        DetachEntity(ped, true, false)
        TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
        carry.targetSrc = 0
    end
end

-- command /carry
RegisterCommand("carry", function()
    startCarry()
end, false)

-- target (radial menu)
lib.addRadialItem({
    id = 'carry_menu',
    label = 'Nošení lidí',
    icon = 'user-friends',
    menu = 'carry_submenu'
})

lib.registerRadial({
    id = 'carry_submenu',
    items = {
        {
            label = 'Přes záda',
            icon = 'child',
            onSelect = function()
                startCarry()
            end
        },
    }
})

-- SYNC
RegisterNetEvent("CarryPeople:syncTarget", function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    local ped = cache.ped or PlayerPedId()
    
    carry.InProgress = true
    lib.requestAnimDict(carry.personCarried.animDict)
    
    AttachEntityToEntity(
        ped, targetPed,
        0,
        carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ,
        0.5, 0.5, 180.0,
        false, false, false, false, 2, false
    )
    carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop", function()
    local ped = cache.ped or PlayerPedId()
    carry.InProgress = false
    ClearPedSecondaryTask(ped)
    DetachEntity(ped, true, false)
end)

-- Kontrola animací s dynamickým uspáváním (0.00 ms v klidu)
CreateThread(function()
    while true do
        local sleep = 1000 -- Výchozí spánek, pokud se nic neděje
        
        if carry.InProgress then
            sleep = 0
            local ped = cache.ped or PlayerPedId()
            
            if carry.type == "beingcarried" then
                if not IsEntityPlayingAnim(ped, carry.personCarried.animDict, carry.personCarried.anim, 3) then
                    TaskPlayAnim(ped, carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
                end
            elseif carry.type == "carrying" then
                if not IsEntityPlayingAnim(ped, carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
                    TaskPlayAnim(ped, carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
                end
            end
        end
        
        Wait(sleep)
    end
end)