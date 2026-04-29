server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game {'rdr3', 'gta5'}
author 'Füsti'
version '1.0'
lua54 'yes'
description 'carwash script using ox_lib'

client_scripts {
    'shared/config.lua',
    'client/client.lua'
}

server_scripts {
    'shared/config.lua',
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}
