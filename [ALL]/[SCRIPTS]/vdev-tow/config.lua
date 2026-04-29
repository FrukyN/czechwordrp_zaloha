Config = {}

-- Toggle Framework: 'esx' or 'qb'
Config.Framework = 'esx'

Config.AllowedJobs = { -- Add more here as you need
    ['mechanic'] = true,
}

Config.TowSearchDistance = 8.0
Config.TowProgressTime = 5000 -- milliseconds (5 seconds)

Config.TowTrucks = {
    flatbed = {
        model = 'flatbed',
        name = "Flatbed",
        hasRamp = true,
        attachOffsets = {x = -0.5, y = -6.5, z = 1.2},
        detachOffset = {x = 0.0, y = -8.0, z = -1.0}
    },
    odtahovkaczrp = {
        model = 'odtahovkaczrp',
        name = "odtahovkaczrp",
        hasRamp = true,
        attachOffsets = {x = 0.7, y = -2.5, z = -0.9},
        detachOffset = {x = 0.0, y = -8.0, z = -1.0}
    },

    -- Add more trucks like this with their specific offsets
}


Config.Notify = function(data)
    lib.notify({
        title = data.title or 'Tow',
        description = data.description,
        type = data.type or 'info'
    })
end

Config.Locales = {
    tow_success = "Vozidlo bylo úspěšně odtaženo.",
    tow_exists = "Již máte jedno vozidlo připojené.",
    no_valid_vehicle = "Poblíž není žádné platné vozidlo.",
    not_tow_truck = "Toto vozidlo není rozpoznáno jako odtahový vůz.",
    no_ramp_support = "%s nepodporuje animaci rampy.",
    vehicle_released = "Vozidlo bylo uvolněno.",
    target_tow = "Odtáhnout nejbližší vozidlo",
    target_release = "Vypustit odtažené vozidlo",
    tow_in_progress = "Zajišťování vozidla...",
}