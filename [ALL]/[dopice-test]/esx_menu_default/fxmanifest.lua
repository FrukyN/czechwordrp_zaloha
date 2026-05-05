server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'adamant'

game 'gta5'
description 'A basic menu system for ESX Legacy.'
lua54 'yes'
version '1.13.3'

client_scripts { '@es_extended/imports.lua', 'client/main.lua' }

ui_page { 'html/ui.html' }

files { 'html/ui.html', 'html/css/app.css', 'html/js/mustache.min.js', 'html/js/app.js' }

dependencies { 'es_extended' }

