server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'cb-megaphone'
version '1.0.0'
description 'FiveM megaphone script'
author 'cb'
url 'https://cb-development.tebex.io/'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua',
}
