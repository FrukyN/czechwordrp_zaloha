server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'

game 'gta5'
fx_version 'cerulean'

author 'JokeDevil'
description 'FXServer logs to Discord (https://www.jokedevil.com/)'
version '1.1.3'
url 'https://jokedevil.com'

-- Config
server_script 'config.lua'

-- Server Scripts
server_script 'server/server.lua'

--Client Scripts
client_script 'client/client.lua'


file 'postals.json'
postal_file 'postals.json'

