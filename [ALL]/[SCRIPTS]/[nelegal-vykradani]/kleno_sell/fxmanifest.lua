server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

lua54 'yes' -- Přidáme podporu pro novější Lua
shared_script '@ox_lib/init.lua' 

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}