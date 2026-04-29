-- Změněno z 'bodacious' na 'cerulean' pro lepší kompatibilitu s moderními funkcemi
fx_version 'cerulean'
game 'gta5'

version '1.0.0'
description 'An example money system using KVS.'
repository 'https://github.com/citizenfx/cfx-server-data'
author 'Cfx.re <root@cfx.re>'

-- Povolení nejnovější verze Lua
lua54 'yes'

server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'

client_script 'client.lua'
server_script 'server.lua'

-- Odkomentováno, protože server.lua reálně využívá tento export
dependency 'cfx.re/playerData.v1alpha1'