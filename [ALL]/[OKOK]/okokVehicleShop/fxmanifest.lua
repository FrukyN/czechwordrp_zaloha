server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokVehicleShop'
version '1.1.2'
lua54 'yes'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/img/*.png'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

shared_script 'config.lua'

client_scripts {
	'cl_utils.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'sv_utils.lua',
	'server.lua',

}

lua54 'yes'

escrow_ignore {
	'config.lua',
	'sv_utils.lua',
	'cl_utils.lua'
}
dependency '/assetpacks'