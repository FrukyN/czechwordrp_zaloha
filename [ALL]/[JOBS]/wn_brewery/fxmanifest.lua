server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'sh0rtys'
description 'Brewery job for ESX'
version '1.0.0'
lua54 'yes'

client_scripts {
    '@es_extended/locale.lua',
	'locales/*.lua',
    'client.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
	'locales/*.lua',
    'server.lua'
}

escrow_ignore {
    'locales/*.lua',
    'server.lua',
    'config.lua',
    'client.lua',
}

shared_scripts {'@es_extended/imports.lua','@ox_lib/init.lua','config.lua'}

dependencies {
    'es_extended',
    'ox_lib'
}
dependency '/assetpacks'