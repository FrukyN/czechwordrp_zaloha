Config = {}

Config.AllLogs = false											-- Enable/Disable All Logs Channel
Config.postal = true  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "CRWP" 							-- Bot Username
Config.avatar = "https://via.placeholder.com/30x30"				-- Bot Avatar
Config.communtiyName = "LOGBOT"					-- Icon top of the Embed
Config.communtiyLogo = "https://via.placeholder.com/30x30"		-- Icon top of the Embed

Config.weaponLog = true  			-- set to false to disable the shooting weapon logs

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs
Config.license = true				-- set to false to disable license in the logs
Config.IP = false					-- set to false to disable IP in the logs


-- Change color of the default embeds here
-- It used Decimal or Hex color codes. They will both work.
Config.joinColor = "#3AF241" 	 	-- Player Connecting
Config.leaveColor = "#F23A3A"		-- Player Disconnected
Config.chatColor = "#A1A1A1"		-- Chat Message
Config.shootingColor = "#2E66F2"	-- Shooting a weapon
Config.deathColor = "#000000"		-- Player Died
Config.resourceColor = "#EBEE3F"	-- Resource Stopped/Started



Config.webhooks = {
	all = "DISCORD_WEBHOOK",
	chat = "DISCORD_WEBHOOK",
	joins = "",
	leaving = "https://discord.com/api/webhooks/1406557623251239064/GcxItO3bJJbjhh_LupvXUq1keZbNyY2YvwFYo90Y4hUuGS-mUetN9DMPvwh8DvGTD4HP",
	deaths = "https://discord.com/api/webhooks/1421812108558995587/lmmmtNBgZ1988mLrbJZcX248Z6fGxE5Pwnv8SpIuQmTILEThR9wZAsvzKM-I2LwWGBh4",
	shooting = "https://discord.com/api/webhooks/1421812337870114977/wBDAauke7hOiQbFkHm87M171PKBWRJEw2zZ8xR5yP9qXH0_vOgBCjiLkmhSz4dUMsb2k",
	resources = "https://discord.com/api/webhooks/1421553555768344649/sUa9Sqt3ouFKuaRQulRtxDQ8VoTUEfKl03p4JnO5bw--Om3VW9hAbe70uLF7zsbOe_Sp",
	popelar = "https://discord.com/api/webhooks/1459361901879492608/yF9MOhznUlFg9OQhYo1XSP4SwM5gAgO8ewxWgs1TZFdb_ycn7hJweqdKdx14eDBsQCUf",
	odtahovka = "https://discord.com/api/webhooks/1460542893654675521/cJ_IPokHJo19rCyJAuq0RAlMdbvh3scdlRLXNA2dKn05jIH7CTJVvPKAi3t8wdIBcyXZ",
	autobusak = "https://discord.com/api/webhooks/1460544887517745316/YTKDLn1S0t461n1cDRCaofGHw7UZE3-CK4eo50EXhEjXqFDXXhzHC82JhnAwjjRD-Vmn",
	wine = "https://discord.com/api/webhooks/1460545981757001778/3mVvJFbdcg7ze74776CHxKwJdi3UmLESdLI7WrUyC8Q2UqSoNkWhp0I9zBx-fio82MnG",
	ambulance = "https://discord.com/api/webhooks/1460547067444461631/jp63Rn2gvww5Uu-zyFGJ-MU4eteO3_ASqaL2Et92D-qYLn3GTV0bKNCnOYiWFUhM7NDZ",
	pivovar = "https://discord.com/api/webhooks/1460547579531100273/FiOpO63OCwxYVuu9g0dE45_NTLxrBfd-vdacRoyNCQSPrCme3DQdwn2jeObtmJUhUs_f",
	banka = "https://discord.com/api/webhooks/1466782431154667552/iLpVwyH4rZNhw40BKN2E7_EVnNR4Vm4IJil_zmar7MhuCSUckAXjQ5t_Xrc4OYrl1E_O",


}


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.1.3"
