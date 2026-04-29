server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'Gemini'
description 'Jednoduchý jídelní lístek z Configu'
version '1.0.0'

-- Registrace ox_lib (pokud používáš callbacky nebo exporty)
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

-- Klientské skripty
client_scripts {
    'client.lua'
}

-- UI soubory (aby hra věděla, co má načíst do prohlížeče)
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    -- Pokud máš v UI nějaké obrázky (např. pozadí papíru), přidej je sem:
    -- 'html/img/paper_bg.png'
}