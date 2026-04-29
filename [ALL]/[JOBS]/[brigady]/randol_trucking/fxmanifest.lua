server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Randolio'
description 'Trucking Job'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'bridge/client/**.lua',
    'cl_trucking.lua'
}

server_scripts {
    'bridge/server/**.lua',
    'sv_config.lua',
    'sv_trucking.lua',
}

lua54 'yes'
