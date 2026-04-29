Config = {}
Config.JobName = 'stk'
Config.STKPrice = 1500
Config.ValidityDays = 30
Config.STKZones = {
    { -- Stanice 1 (Hlavní město)
        coords = vec3(939.7545, -1022.7733, 40.5418),
        size = vec3(5, 5, 3),
        rotation = 0.0
    },
    { -- Stanice 2 (Paleto Bay)
        coords = vec3(939.5309, -1015.2227, 40.5418),
        size = vec3(6, 6, 3),
        rotation = 45.0
    },
    { -- Stanice 2 (Paleto Bay)
        coords = vec3(939.3598, -1030.2351, 40.5418),
        size = vec3(6, 6, 3),
        rotation = 45.0
    },

    -- Sem můžeš přidávat další...
}Config.InspectionPoints = {
    {id = 'engine', label = 'Diagnostika motoru', bone = 'engine', minHealth = 850, anim = 'map_watcher'},
    {id = 'wheel_lf', label = 'Přední levé kolo', bone = 'wheel_lf', minHealth = 950, anim = 'world_human_vehicle_mechanic'},
    {id = 'wheel_rf', label = 'Přední pravé kolo', bone = 'wheel_rf', minHealth = 950, anim = 'world_human_vehicle_mechanic'},
    {id = 'wheel_lr', label = 'Zadní levé kolo', bone = 'wheel_lr', minHealth = 950, anim = 'world_human_vehicle_mechanic'},
    {id = 'wheel_rr', label = 'Zadní pravé kolo', bone = 'wheel_rr', minHealth = 950, anim = 'world_human_vehicle_mechanic'},
    {id = 'lights', label = 'Osvětlení a skla', bone = 'windscreen', minHealth = 1000, anim = 'prop_controller_test_02'},
    {id = 'chassis', label = 'Karoserie', bone = 'boot', minHealth = 800, anim = 'world_human_sunbathe_back'}
}
