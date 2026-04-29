server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'DARO'
description 'Propracovaná Pizzeria pro job piyya'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/sounds/ticking.mp3',
    'html/sounds/alarm.mp3'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}