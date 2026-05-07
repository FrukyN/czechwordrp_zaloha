Config = {}

Config.Debug = false
Config.MaxNeed = 1000000
Config.SaveInterval = 120000
Config.ServerTick = 10000
Config.SpoilageCheckInterval = 300000
Config.ConsumptionCooldownMs = 1200
Config.MaxInvalidAttempts = 3
Config.UsePromptTimeoutMs = 12000

Config.Defaults = { hunger = 850000, thirst = 850000, stress = 150000, alcohol = 0, drug = 0 }
Config.Decay = { hunger = 130, thirst = 170, stressRelief = 25, addictionDecay = 90 }
Config.Starvation = { hungerThreshold = 100000, thirstThreshold = 100000, stressPerTick = 450, damageEveryMs = 12000, damage = 4, blackoutChance = 6 }
Config.Stress = { highThreshold = 700000, shakeThreshold = 850000, blurDurationMs = 3000 }
Config.Withdrawal = { threshold = 280000, stressPerTick = 700, stumbleChance = 8 }

Config.TargetDrinkStations = {
    { coords = vec3(441.2, -982.0, 30.7), radius = 0.9, label = 'Napit se vody', icon = 'fa-solid fa-glass-water', thirstGain = 120000, stressRelief = 15000 }
}

Config.Items = {
    water = {
        type = 'drink', remove = true, uses = 1,
        denyInVehicle = false, denyWhileSwimming = true, denyWhileSprinting = false,
        spoilage = { enabled = false },
        thirst = 230000, hunger = 0, stress = -10000, alcohol = 0, drug = 0
    },
    bread = {
        type = 'food', remove = true, uses = 2,
        denyInVehicle = true, denyWhileSwimming = true, denyWhileSprinting = true,
        spoilage = { enabled = true, hours = 48, onSpoil = { action = 'replace', item = 'spoiled_food', count = 1 } },
        hunger = 220000, thirst = 0, stress = -5000, alcohol = 0, drug = 0
    },
    beer = {
        type = 'drink', remove = true, uses = 1,
        denyInVehicle = false, denyWhileSwimming = true, denyWhileSprinting = false,
        spoilage = { enabled = false },
        thirst = 120000, hunger = 0, stress = -25000, alcohol = 65000, drug = 0
    },
    beer_crate = {
        type = 'utility', remove = true, uses = 1,
        denyInVehicle = true, denyWhileSwimming = true, denyWhileSprinting = true,
        spoilage = { enabled = false },
        hunger = 0, thirst = 0, stress = 0, alcohol = 0, drug = 0,
        giveItems = { { name = 'beer', count = 10 } }
    },
    joint = {
        type = 'drug', remove = true, uses = 3,
        denyInVehicle = false, denyWhileSwimming = true, denyWhileSprinting = true,
        spoilage = { enabled = true, hours = 72, onSpoil = { action = 'delete' } },
        thirst = -15000, hunger = 10000, stress = -50000, alcohol = 0, drug = 80000
    }
}
