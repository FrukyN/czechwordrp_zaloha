server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'CzechWorld RP'
description 'Moderní CZ Taxametr'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

shared_scripts {
    'config.lua' -- 🔥 TOTO JE DŮLEŽITÉ
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

escrow_ignore {
    'config.lua',
    'html/*'
}
dependency '/assetpacks'