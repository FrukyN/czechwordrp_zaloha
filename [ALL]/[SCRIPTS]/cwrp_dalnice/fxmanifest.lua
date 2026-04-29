fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'cwrp_dalnice'
author 'Codex'
description 'Bezpecny script na dalnicni znamky pro ESX Legacy + ox stack'
version '1.0.0'

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'oxmysql',
    'es_extended'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
