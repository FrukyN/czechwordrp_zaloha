Config = {}

Config.Police = {
    jobs = {'police', 'sheriff', 'policie_mp' }, -- Seznam jobů, které se počítají jako policie
    alertDelay = 5000
}

-- Souřadnice pro Target na dveřích (shodné s dveřmi)
Config.MineEntrance = vec3(-596.0233, 2088.3342, 131.4129) 

-- Model dveří a sudů
Config.DoorModel = `prop_mineshaft_door`
Config.BarrelModels = {
    `prop_wooden_barrel` -- Tvůj nový model
}

-- Itemy
Config.ExplosiveItem = 'thermite' 

-- Odměny
Config.Rewards = {
    { item = 'gas_mask', chance = 30, amount = 1 },
    { item = 'gas_canister', chance = 60, amount = 1 }
}

-- Reset a Policie
Config.ResetTime = 30 * 60 * 1000 -- 30 minut
Config.Police = {
    alertDelay = math.random(60000, 120000),
    jobs = { 'police', 'sheriff', 'policie_mp' } 
}

Config.Strings = {
    ['place_bomb'] = 'Položit nálož',
    ['searching'] = 'Prohledáváš sud...',
    ['bomb_placed'] = 'Nálož je na místě! Utíkej dál!',
    ['mine_opened'] = 'Dveře byly proraženy!',
    ['already_open'] = 'Důl je již otevřený nebo nedávno vybraný.',
    ['mine_reset'] = 'Důl byl opět uzavřen.',
    ['found_item'] = 'Našel jsi: '
}