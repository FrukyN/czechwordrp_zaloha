server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games { 'gta5' }

author 'London Studios'
description 'Fire Tools resource'
version '1.0.0'
lua54 'yes'

client_scripts {
    'cl_utils.lua',
    'cl_spooner.lua',
    'cl_firetools.lua',
}

server_scripts {
    'sv_utils.lua',
    'sv_firetools.lua',
}

escrow_ignore {
    'config.lua',
    'cl_utils.lua',
    'sv_utils.lua',
    'data/**',
}

shared_script 'config.lua'

files {
    'data/audioexample_sounds.dat54.rel',
    'audiodirectory/firetools_sounds.awc',
	'data/**/weaponarchetypes.meta',
	'data/**/weaponanimations.meta',
	'data/**/pedpersonality.meta',
	'data/**/weapons.meta',
    'stream/*.ytyp',
}

data_file 'WEAPON_METADATA_FILE' 'data/**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'data/**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'data/**/weapons.meta'
data_file 'AUDIO_WAVEPACK' 'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/audioexample_sounds.dat'
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'
dependency '/assetpacks'