server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'CruiseControl / Seatbelt System for ESX Legacy'

version '1.2'

lua54 'yes'

dependency 'ox_lib'

shared_script '@ox_lib/init.lua'

client_scripts {
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config.lua',
  'client/cruisecontrol.lua',
  'client/utils.lua',
  'client/keybind.lua'
}

