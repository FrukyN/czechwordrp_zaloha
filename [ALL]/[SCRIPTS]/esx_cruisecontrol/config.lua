Config = {
    Locale = GetConvar('esx:locale', 'en'),
    Cruise = {
        Enable = true,
        Key = "CAPITAL",
        Export = function (state)
          --  exports[Config.HudResource]:CruiseControlState(state)
        end,
    },
}