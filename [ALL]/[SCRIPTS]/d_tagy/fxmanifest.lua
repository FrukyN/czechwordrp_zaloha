server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'

author 'DARO'
description 'Propracované Admin Tagy s ID, Pingem a varováním'
version '1.0.0'

-- Definujeme klientský skript
client_script 'client.lua'

-- Definujeme serverový skript
server_script 'server.lua'

-- Pokud používáš novější verzi ESX, tato metadata pomáhají s kompatibilitou
dependencies {
    'es_extended'
}

-- Volitelné: Pokud chceš, aby se skript nahrál dříve než ostatní
resource_type 'map' { gameTypes = { all = true } } 
-- (Poznámka: Výše uvedený řádek není nutný, pokud to chceš jako běžný skript)