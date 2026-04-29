---@type number
Shared.MaxFrequency = 500.00 -- Max Limit of Radio Channel

---@class Jammer
---@field state boolean
---@field model string
---@field permission string[]
---@field default table
---@field range table

---@type Jammer
Shared.Jammer = {
    state = false, -- to use jammer system or not 
    model = 'sm_prop_smug_jammer', -- prop to spawn for jammer
    permission = {"police"}, -- permission how can setup jammer (job/gang)
    default = {}, -- default jammer setup location 
    range = {
        min = 10.0,
        max = 100.0,
        step = 5.0,
        default = 30.0
    }
}

---@type string[]
Shared.RadioItem = {
    'radio'
}

---@class Battery
---@field state boolean
---@field consume number
---@field depletionTime number

---@type Battery
Shared.Battery = {
    state = false, -- to use battery system or not
    consume = 1, -- battery consume rate
    depletionTime = 1, -- in minute, every 1 minute battery will decrease by consume value
}

---@type [string]: string
Shared.RadioNames = {

}

Shared.RestrictedChannels = {
    [158] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance", "hzs", "policie_mp","gibs", "celnisprava"}
    },
    [156] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance", "hzs", "policie_mp","gibs", "celnisprava"}
    },
    [155] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance", "hzs", "policie_mp","gibs", "celnisprava"}
    },
    [150] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance", "hzs", "policie_mp","gibs", "celnisprava"}
    },

    [261] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance", "hzs", "policie_mp","gibs", "celnisprava"}
    },

}


lib.locale()