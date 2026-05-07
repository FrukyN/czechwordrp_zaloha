fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'cwrp'
description 'Unified ESX needs, stress and addiction system (ox_lib, ox_inventory, ox_target)'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'oxmysql'
}
