server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games {'gta5'}
lua54 'yes'



shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'config/config.lua',
    'client/main.lua'
}

server_scripts {
    'config/config.lua',
    'server/main.lua'
}
client_script "@Badger-Anticheat/acloader.lua"