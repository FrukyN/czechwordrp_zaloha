fx_version 'cerulean'
game 'gta5'
lua54 'true'

author 'Fearx'
description 'FearX-OxRobV2 - Enhanced Robbing System'
version '2.2.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/version.lua'
}

server_scripts {
    'config/sv_config.lua',
    'server/main.lua',
    'server/version.lua'
}

dependencies {
    'ox_lib'
}
