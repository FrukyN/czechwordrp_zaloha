server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Nevera Development'
description 'OX Debug Menu'
version '1.0.0'

shared_scripts { '@ox_lib/init.lua' }
client_scripts { 'client/client.lua' }
dependency '/assetpacks'