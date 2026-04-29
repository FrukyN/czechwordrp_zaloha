server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Daro'
description 'Pizzeria Order System - KFC Style'

shared_script '@ox_lib/init.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}