server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games { 'gta5' }
author 'maku#5434'
version '1.1'
lua54 'yes'
repository 'itIsMaku/maku_plate'

shared_scripts {
    '@ox_lib/init.lua',
    'configs/sh-config.lua',
}

client_scripts {
    'client/cl-main.lua',
    'client/cl-progressbar.lua'
}

server_scripts {
    'server/sv-version.lua',
    'server/sv-main.lua',
    'server/sv-progressbar.lua'
}

client_export 'itemUsage'

dependencies {
    'ox_inventory'
}

ox_libs {
    'interface'
}
