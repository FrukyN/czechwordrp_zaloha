server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
--[ Breathalyzer Script 0.1 Created By JKSensation ]--
--[ DO NOT RELEASE/LEAK/SHARE CODE WITHOUT PERMISSION FROM JKSENSATION ]--

fx_version 'adamant'
games { 'gta5'}

author "JKSensation"
description "Breathalyzer 0.1"

client_script "client.lua"
server_script "server.lua"

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/index.js",
    "web/styles.css",
    "web/portablebreathalyzer.png",
    "web/digital-7.ttf",
}