server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'

local postalFile = 'postals.json'

fx_version 'cerulean'
game 'gta5'

version '1.0'
lua54 'yes'

shared_scripts {
	'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua',
    "stream/minimap.gfx",
}


server_script 'server.lua'
use_fxv2_oal 'yes'

ui_page 'assets/index.html'


file(postalFile)
postal_file(postalFile)

files {
	'assets/*',
	'assets/sounds/*',
}

dependency '/assetpacks'

