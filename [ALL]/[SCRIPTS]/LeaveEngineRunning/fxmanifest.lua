server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'


client_script "client.lua"


shared_scripts {
    '@ox_lib/init.lua',
}