server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

server_script 'server.lua'
client_script 'client.lua'