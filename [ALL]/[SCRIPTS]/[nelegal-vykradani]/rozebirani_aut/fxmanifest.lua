server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'DARO'
description 'Kompletní Chop Shop: Schránka -> 3 Lokace -> Dealer'
version '1.0.0'

-- Importy pro ESX
shared_script '@es_extended/imports.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server.lua'
}

-- Ujisti se, že máš v server.cfg: ensure gemini_chopshop