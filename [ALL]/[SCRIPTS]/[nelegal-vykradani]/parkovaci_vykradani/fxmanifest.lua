server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'DARO'
description 'Vykrádání parkovacích automatů pro ESX'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', -- Načte ESX automaticky
    '@ox_lib/init.lua'          -- Načte ox_lib funkce
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_target',
    'ox_lib',
    'cd_dispatch'
}