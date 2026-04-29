server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Randolio'
description 'City Worker Job'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'bridge/client/**.lua',
    'cl_cityworker.lua'
}

server_scripts {
    'bridge/server/**.lua',
    'sv_config.lua',
    'sv_cityworker.lua',
}

lua54 'yes'
