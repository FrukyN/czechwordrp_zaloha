----------------------------
-- NIK Kits --
----------------------------
RegisterNetEvent('shark-leotools:nikkit')
AddEventHandler('shark-leotools:nikkit', function()
    lib.progressBar({
        duration = 2000,
        label = 'Testovaní...',
        useWhileDead = false,
        canCancel = false,
    })
end)

----------------------------
-- NVGs, Gas Masks & Vests --
----------------------------
local wearingGoggs, activeGoggs = false, false -- Are Goggles Equipped, Are Goggles Active
local wearType, clothesType, switchType, itemName

-- Function
local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    return animDict
end

local function toggleGoggs()
    local ped = PlayerPedId()
    ensureAnimDict('anim@mp_helmets@on_foot')

    if activeGoggs then
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_up', 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(600)
        SetPedPropIndex(ped, 0, clothesType, 0, 0)
    else 
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_down', 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(600)
        SetPedPropIndex(ped, 0, (clothesType - 1), 0, 0)
    end

    RemoveAnimDict('anim@mp_helmets@on_foot')
    activeGoggs = not activeGoggs
    switchType(activeGoggs)
end

-- Radials
local goggRadial = {
    {
        label = 'Zapnout',
        id = 'shark-leotools:toggle',
        icon = 'power-off',
        onSelect = function()
            toggleGoggs()
        end
    },
    {
        label = 'Sundat',
        id = 'shark-leotools:remove',
        icon = 'eye-slash',
        onSelect = function()
            TriggerEvent('shark-leotools:removeVision')
        end
    },
}

local maskRadial = {
    {
        label = 'Sundat masku',
        id = 'shark-leotools:remove',
        icon = 'mask-ventilator',
        onSelect = function()
            TriggerEvent('shark-leotools:removeVision')
        end
    },
}

local vestRadial = { -- 🦺 VESTA SUPPORT
    {
        label = 'Sundat vestu',
        id = 'shark-leotools:remove',
        icon = 'vest',
        onSelect = function()
            TriggerEvent('shark-leotools:removeVision')
        end
    },
}

--- Events and Exports
exports('vision', function(data, slot)
    local ped = PlayerPedId()

    itemName = data.name
    wearType = Config.Goggles[data.name].type
    clothesType = Config.Goggles[data.name].clothes
    switchType = Config.Goggles[data.name].switch

    if wearingGoggs then
        lib.notify({
            id = 'goggError',
            title = 'Already Wearing',
            description = 'You already have something equipped!',
            type = 'error'
        })
        return false
    else 
        exports.ox_inventory:useItem(data, function(data)
            ensureAnimDict('mp_masks@on_foot')
            TaskPlayAnim(ped, "mp_masks@on_foot", "put_on_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
            Wait(600)
            
            if wearType == 'gas' then
                -- 🧯 Gas Mask Settings
                lib.addRadialItem(maskRadial)
                SetEntityProofs(ped, false, false, false, false, false, false, true, true, false)
                SetPedComponentVariation(ped, 1, clothesType, 0, 0)

            elseif wearType == 'nvg' or wearType == 'thm' then
                -- 👓 Goggle Settings
                lib.addRadialItem(goggRadial)
                SetPedPropIndex(ped, 0, clothesType, 0, 0)

            elseif wearType == 'vesta' then
                -- 🦺 Vest Settings
                lib.addRadialItem(vestRadial)
                -- slot 9 = vest
                SetPedComponentVariation(ped, 9, clothesType, 0, 0)
            end

            RemoveAnimDict('mp_masks@on_foot')
            wearingGoggs = true
        end)
    end
end)

RegisterNetEvent('shark-leotools:removeVision')
AddEventHandler('shark-leotools:removeVision', function() -- Remove Goggles / Mask / Vest
    local ped = PlayerPedId()
    ensureAnimDict('missheist_agency2ahelmet')
    TaskPlayAnim(ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 8.0, -8.0, -1, 48, 0, false, false, false)
    Wait(1000)
    
    if wearType == 'gas' then
        -- 🧯 Gas Mask Disable
        SetEntityProofs(ped, false, false, false, false, false, false, false, false, false)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        lib.removeRadialItem('shark-leotools:remove')

    elseif wearType == 'vesta' then
        -- 🦺 Vest Disable
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        lib.removeRadialItem('shark-leotools:remove')

    else
        -- 👓 Goggle Disable
        switchType(false)
        ClearPedProp(ped, 0)
        lib.removeRadialItem('shark-leotools:toggle')
        lib.removeRadialItem('shark-leotools:remove')
    end

    TriggerServerEvent('shark-leotools:giveBack', itemName)
    RemoveAnimDict('missheist_agency2ahelmet')
    wearingGoggs = false
end)
