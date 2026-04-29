fx_version 'cerulean'
game 'gta5'

author 'Gemini'
description 'Imersivní Tesco nakupování pro ESX'

ui_page 'web/ui.html'

files {
    'web/ui.html',
    'web/style.css',
    'web/script.js'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}