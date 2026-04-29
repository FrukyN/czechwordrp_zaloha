server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Randolio'
description 'Newspaper Delivery.'

shared_scripts { 'shared.lua', '@ox_lib/init.lua', }

client_scripts { 'bridge/client/**.lua', 'cl_delivery.lua' }

server_scripts { 'bridge/server/**.lua', 'sv_delivery.lua' }

lua54 'yes'
