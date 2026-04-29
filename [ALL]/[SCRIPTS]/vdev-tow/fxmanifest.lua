server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Vulture Network'
name 'Towing System'
version '1.2'

shared_script '@ox_lib/init.lua'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/target.lua'
}

server_scripts {
    '@es_extended/imports.lua', -- Comment if using QBCore
    'config.lua',
    'server/main.lua'
}

dependencies {
    'ox_target',
    'ox_lib',
    'es_extended' -- Comment if using QBCore
}

escrow_ignore {
    'config.lua'
}

dependency '/assetpacks'