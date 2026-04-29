fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Gemini AI - Advanced Gaming Solutions'
version '2.5.0'

shared_scripts {
    '@es_extended/imports.lua', -- ESX Importy
    'config.lua',
    'shared/sh_utils.lua'
}

client_scripts {
    'client/cl_threads.lua',    -- Neustálé smyčky
    'client/cl_logic.lua',      -- Logika zápasů
    'client/cl_nui.lua',        -- Komunikace s UI
    'client/cl_zones.lua',      -- Správa markerů a zón
    'client/cl_fx.lua'          -- Efekty a animace
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_database.lua',   -- Statistiky hráčů
    'server/sv_sync.lua'        -- Synchronizace mezi hráči
}

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/assets/*.png', -- Zde měj loga týmů
    'html/assets/hit.mp3' -- Zvuk při zásahu
}