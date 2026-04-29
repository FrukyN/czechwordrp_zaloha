Config = {}

Config.BasketProp = `prop_cs_shopping_bag`
Config.Currency = "Kč"
Config.CashierJob = "tesco" -- Název tvého jobu pro prodavače

Config.Locations = {
    BasketPickup = vec3(528.444580,-159.357605,56.518799),
    Counter = vec3(533.898071,-153.770828,57.245422), -- Sem zákazník položí nákup
}

Config.Departments = {
    {
        label = "Pekárna",
        coords = vec3(527.948914,-154.549637,56.854187),
        icon = "fa-solid fa-bread-slice",
        items = {
            { name = "rohlik", label = "Rohlík", price = 30 },
            { name = "donut", label = "Kobliha", price = 15 }
        }
    },
    {
        label = "Mrazáky",
        coords = vec3(538.669861,-160.871399,56.959831),
        icon = "fa-solid fa-snowflake",
        isFrozen = true,
        items = {
            { name = "pizza", label = "Mražená Pizza", price = 95 }
        }
    },
    {
        label = "Policejní výstroj",
        coords = vec3(541.527161,-155.414719,57.011547),
        icon = "fa-solid fa-shield-halved",
        groups = { unemployed = 0 }, -- Pouze pro job 'police'
        items = {
            { name = "handcuffs", label = "Pouta", price = 500 },
            { name = "radio", label = "Vysílačka", price = 1200 }
        }
    }
}