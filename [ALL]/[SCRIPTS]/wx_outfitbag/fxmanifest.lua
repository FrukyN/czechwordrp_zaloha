server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'wx / woox'
description 'Simple, target based outfit bag'

version '1.0.0'

server_script {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

shared_scripts {'@ox_lib/init.lua','configs/*.lua'}
