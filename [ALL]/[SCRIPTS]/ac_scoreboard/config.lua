-----------------------------------------------------------------
-- Visit https://docs.acscripts.dev/scoreboard for documentation
-----------------------------------------------------------------

return {
    settings = {
        title = {
            text = 'CZECH WORLD RP',
            logo = 'https://cfx-nui-ac_scoreboard/web/build/czechstate.png',
        },

        side = 'right',

        showOverlay = false,

        closeOnEscape = true,

        closeOnOutsideClick = true,

        uppercaseNames = false,

        highlightEmptyGroups = true,

        compactPlayers = false,

        compactGroups = false,

        playerColumns = 1,

        groupColumns = 1,
    },

    visibleSections = {
        groups = true,
        groupCount = true,
        players = true,
        playerNames = true,
        playerIds = true,
        statusIndicators = true,
        footer = true,
    },

    -- Command name for opening the scoreboard
    commandName = 'scoreboard',

    -- Default keybind for the '/scoreboard' command
    commandKey = 'DELETE',

    -- Whether to include off-duty players in group count (if not defined in the group row itself)
    includeOffDuty = false,

    -- Group list shown in the scoreboard
    groups = {
        {
            label = 'Policie',
            groups = {'police'},
            includeOffDuty = false,
            icon = 'ic:round-local-police',
        },
        {
            label = 'Městská Policie',
            groups = {'policie_mp'},
            includeOffDuty = false,
            icon = 'ic:round-local-police',
        },
        {
            label = 'Záchranka',
            groups = {'ambulance'},
            includeOffDuty = false,
            icon = 'mdi:ambulance',
        },
        {
            label = 'Hasiči',
            groups = {'hzs'},
            includeOffDuty = false,
            icon = 'mdi:fire-extinguisher',
        },
        {
            label = 'Mechanici',
            groups = {'mechanic'},
            includeOffDuty = false,
            icon = 'mdi:wrench',
        },
--[[
        {
            label = 'Zastavárna',
            groups = {'pawshop'},
            includeOffDuty = false,
            icon = 'mdi:lock',
        },
        {
            label = 'Taxi',
            groups = {'taxi'},
            includeOffDuty = false,
            icon = 'mdi:taxi',
            
            label = 'STK',
            groups = {'stk'},
            includeOffDuty = false,
            icon = 'mdi:wrench',
        },
]]
    },

    -- Status indicators shown in the scoreboard
    statusIndicators = {
        {
            id = 'house_robbery',
            label = 'House robbery',
            icon = 'mdi:house',
            defaultState = false,
        },
        {
            id = 'store_robbery',
            label = 'Store robbery',
            icon = 'mdi:store',
            defaultState = false,
        },
        {
            id = 'bank_robbery',
            label = 'Bank robbery',
            icon = 'mdi:bank',
            groupTrigger = {
                groups = {'police', 'sheriff'},
                minimumCount = 12,
                includeOffDuty = true,
            },
        },
    },
}
