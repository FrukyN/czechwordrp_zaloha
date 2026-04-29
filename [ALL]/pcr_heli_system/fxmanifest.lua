fx_version 'cerulean'
game 'gta5'

author 'Daro'
description 'PCR Advanced Helicopter System'
version '1.0.0'

-- DEFINICE SKRIPTŮ
client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua' -- TOTO TI CHYBĚLO! Bez toho synchronizace světla nepůjde.
}

-- NUI KONFIGURACE
ui_page 'nui/ui.html'

files {
    'nui/ui.html',
    'nui/style.css',
    'nui/script.js'
}

-- OSTATNÍ NASTAVENÍ
lua54 'yes'