fx_version 'cerulean'
game 'gta5'

author 'Tvoje Jméno / SKRP'
description 'Pokročilý EMS Systém s Diagnostikou a MedBagem'
version '2.1.0'

-- Registrace exportů, aby ostatní scripty mohly číst data o pacientech
exports {
    'getPatientData'
}

-- Definice hlavního NUI okna
ui_page 'html/index.html'

-- Klientské skripty (pořadí je důležité)
client_scripts {
    '@es_extended/imports.lua',      -- Automatický import ESX (pokud tvoje verze podporuje)
    'client/damage_engine.lua',      -- Detekce zranění a kostí
    'client/ems_main.lua',           -- Hlavní logika, targety a NUI callbacky
    'client/bag_system.lua'          -- Systém batohu (nošení, pokládání)
}

-- Serverové skripty
server_scripts {
    '@es_extended/imports.lua',
    'server/main.lua',
    'server/items.lua'
}

-- Soubory, ke kterým má mít přístup NUI (prohlížeč) a hra
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/body_map.png',             -- Hlavní silueta těla
    
    -- Ikonky pro MedicBag (The Forest style)
    'html/img/medikit.png',
    'html/img/bandage.png',
    'html/img/defib.png'
}

-- Metadata pro ox_target (volitelné, ale doporučené)
dependencies {
    'es_extended',
    'ox_target',
    'ox_lib'
}