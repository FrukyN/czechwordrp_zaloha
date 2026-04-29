server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'

games { 'gta5' }

author 'London Studios'
description 'Advanced clamping system'
version '1.0.0'
lua54 'yes'

shared_script 'config.lua'

client_scripts {
    "client.lua",
    "cl_utils.lua"
}
server_scripts {
    "sv_utils.lua",
    "server.lua",
}

files {
    'stream/*.ytyp',
    'stream/*.ydr',
}

escrow_ignore {
	'stream/**',
	'config.lua',
	'cl_utils.lua',
    'sv_utils.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'
lua54 'yes'
dependency '/assetpacks'