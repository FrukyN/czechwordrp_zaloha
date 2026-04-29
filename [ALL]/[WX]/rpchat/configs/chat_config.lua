wx = {}

wx.Logs = true -- Enable logging for messages. Make sure to configure webhooks in configs/webhook_config.lua

wx.MaxHereTexts = 5 -- How many /here texts can one player place?
wx.MaxDocCount = 60 -- Maximum /doc time player can do
wx.MeDoDisplayTime = 5000 -- [in ms] How long should /me and /do 3D texts be displayed
wx.OnlyInicials = true -- In commands like /me, /do, use only char name inicials. (John Doe -> J. D.)
wx.Reports = true -- Enable reports? /report
wx.AdminChat = true -- Enable admin chat? /a
wx.TransparentStatusHere = false -- Enable transparent background for /here and /status texts
wx.AdCost = 1000 -- Price for sending advertisements, money will be checked and removed from bank
wx.AdCooldown = 15000 -- in ms, how long should the cooldown between sending ads should be
wx.LOOCAdminPrefixes = true -- Enable admin prefixes for LOOC messages. (If admin has group admin, the mssage will be - [ADMIN] PlayerName: Message )

wx.Commands = {
-- Don't Touch             /command name
    ["Status"]              = "stav",
    ["Here"]                = "zde",
    ["Advertisement"]       = "ad",
    ["EMS"]                 = "ems",
    ["Blackmarket"]         = "bm",
    ["Staff Announcement"]  = "oznameni",
    ["Job"]                 = "job",
}

wx.Suggestions = { -- /command suggestions that will pop up in chat (Make sure to add /)
    ['/me'] = {
        description = "/me",
        argument = { ["ZPRÁVA"] = "[TEXT]" }
    },
    ['/do'] = {
        description = "/do",
        argument = { ["ZPRÁVA"] = "[TEXT]" }
    },
    ['/doc'] = {
        description = "/doc",
        argument = { ["ZPRÁVA"] = "[ČAS V SEKUNDÁCH]" }
    },
    [wx.Commands["Advertisement"]] = {
        description = "Sdílej reklamu "..wx.AdCost.."$",
        argument = { ["ZPRÁVA"] = "[TEXT]" }
    },
    ['/report'] = {
        description = "Reportni problém adminům",
        argument = { ["OBSAH REPORTU"] = "Co chceš reportnout?" }
    },
}

wx.Jobs = {
-- Don't Touch  Job Name
    ['LSPD']  =   'police',
    ['EMS']   =   'ambulance',
    ['LSSD']  =   'hzs',
}

wx.AdminGroups = { -- Which groups should have access to the admin commands and optionally the prefix?
-- GROUP NAME   true/false
    ["owner"] = true,
    ["cowner"] = true,
    ["managment"] = true,
    ["dev"] = true,
    ["hos"] = true,
    ["admin"] = true,
    ["senior"] = true,
    ["staff"] = true,
    ["junior"] = true,
    ["trial"] = true,
}

wx.AutoMessages = true
wx.AutoMessageInterval = 25 -- In minutes
wx.AutoMessagesList = { -- List of messages that will be randomly sent
--    "discord.gg/czechstateroleplay",
    "Pokud naleznete nějaký bug nebo potřebujete pomoct tak si napište /report",
}

Notify = function(title,desc) -- You can add your own notify function
    lib.notify({
        title = title,
        description = desc,
         duration = 5000
    })
end