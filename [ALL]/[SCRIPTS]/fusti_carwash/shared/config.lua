Config = {}

Config.useRadial = false
Config.radialData = {
    icon = 'soap',
    label = 'Automyčka',
    useNotify = true,
    NotifyTitle = 'Automyčka',
    NotifyDescription = 'Use the radial menu to start washing your car!',
    NotifyType = 'inform',
    NotifyDuration = 5000
}

Config.CarWash = {
    price = 200,

    progress = { -- Progressbar
        label = 'Umyvám auto..',
        duration = 5000,
        position = 'bottom'
    },
    InformNotify = {  -- Notify when entering the carwash
        title = 'Automyčka',
        description = 'Stiskni [E] pro mytí. \n Cena: ',
        type = 'inform',
        duration = 5000
    },
    ErrorNotify = {  -- Notify when you trying to use the carwash while already washing the car
        title = 'Error',
        description = 'Toto nemuze udělat!',
        type = 'error'
    },
    SuccessNotify = { -- Notify when washing was successful
        title = 'Success',
        description = 'Uspěšne si umyl auto!',
        type = 'success'
    },
    MoneyNotify = { -- Notify when player doesn't have enough money
        title = 'Error',
        description = 'Nemáš peníze!',
        type = 'error'
    },
    positions = {
        {coord = vector3(24.4675, -1391.8799, 29.3333), rot = 270.0, size = vec3(5, 7, 3), debug = false},
        {coord = vector3(-700.0496, -933.8840, 19.0139), rot = 360.0, size = vec3(5, 11, 6), debug = false}
    }
}