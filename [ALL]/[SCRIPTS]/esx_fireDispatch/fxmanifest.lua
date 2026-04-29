fx_version 'cerulean'
game 'gta5'

author 'Gemini'
description 'Opravený Výjezdový Systém'

-- DŮLEŽITÉ: Přidání ox_lib
shared_script '@ox_lib/init.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'sounds/alarm.ogg'
}

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}