client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Code5Mods'
description 'Code5Mods Stretcher Resource (Script)'
version '1.69.1'
lua54 'yes'

client_scripts {
    "@NativeUI/NativeUI.lua",
    "config.lua",
    "client/main.lua",
    "client/command.lua",
}

exports {
    'spawnStretcher'
}

escrow_ignore {
    "config.lua",
    "client/command.lua",
  }
dependency '/assetpacks'