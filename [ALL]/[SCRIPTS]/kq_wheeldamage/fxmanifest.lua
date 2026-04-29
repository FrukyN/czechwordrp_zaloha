server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games      { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Realistic wheel damage by KuzQuality'
version '1.4.2'


--
-- Server
--

server_scripts {
    'config.lua',
    'server/server.lua',
}

--
-- Client
--

client_scripts {
    'config.lua',
    'client/client.lua',
    'client/editable/editable.lua',
}

escrow_ignore {
    'config.lua',
    'client/editable/*.lua',
}

dependency '/assetpacks'