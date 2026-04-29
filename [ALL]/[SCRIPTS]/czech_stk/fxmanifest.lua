server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Daro'
description 'Realistická STK s NUI Tabletem'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/tablet_bg.png' -- Volitelné: pozadí tabletu
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target'
}

escrow_ignore {
    'config.lua',
    'ui/*',
    'czech_stk.sql'
}
dependency '/assetpacks'