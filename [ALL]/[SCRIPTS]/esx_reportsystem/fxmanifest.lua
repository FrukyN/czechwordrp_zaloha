server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'CzechWorld Edition'
description 'CzechWorld Advanced Ticket System'
version '4.0.0'

ui_page 'html/index.html'

files {
    'html/index.html'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended'
}

escrow_ignore {
    'html/*'
}
dependency '/assetpacks'