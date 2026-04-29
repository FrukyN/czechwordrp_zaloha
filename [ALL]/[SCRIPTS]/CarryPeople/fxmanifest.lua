server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
-- Resource Metadata
fx_version 'bodacious'
games { 'gta5' }

author 'rubbertoe98'
description 'CarryPeople'
version '1.0.0'


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}


client_script "cl_carry.lua"
server_script "sv_carry.lua"


