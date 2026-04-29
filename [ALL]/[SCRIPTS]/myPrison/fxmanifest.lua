server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games { 'gta5' }

author 'myScripts'
description 'myPrison'
version '1.0.1'

lua54 'yes'

escrow_ignore {
	'config.lua',
	'client.lua',
	'server.lua',
}

client_scripts {
	'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'config.lua',
	'client_escrow.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

dependencies {
	'NativeUILua_Reloaded'
}
dependency '/assetpacks'