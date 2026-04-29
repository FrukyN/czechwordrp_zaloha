client_script '@ElectronAC/src/include/client.lua'
-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy"
description "Andyyy 3D radargun with first person"
version "2.1.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"
use_experimental_fxv2_oal "yes"

fx_version "cerulean"
game "gta5"
lua54 "yes"

escrow_ignore {
    "config.lua"
}

files {
    "source/assets/digital-counter-7.ttf",
    "source/assets/subway-ticker.regular.ttf",
    "source/assets/radargun.png",
    "source/assets/screen.png",
    "source/assets/scope.png",
	"source/index.html",
	"source/script.js",
	"source/style.css",

    "data/weaponarchetypes.meta",
	"data/weaponanimations.meta",
    "data/weapons_radargun.meta"
}

data_file "WEAPON_METADATA_FILE" "data/weaponarchetypes.meta"
data_file "WEAPON_ANIMATIONS_FILE" "data/weaponanimations.meta"
data_file "WEAPONINFO_FILE" "data/weapons_radargun.meta"

ui_page "source/index.html"

client_scripts {
    "@ox_lib/init.lua",
    "config.lua",
    "source/functions.lua",
    "source/client.lua"
}
dependency '/assetpacks'