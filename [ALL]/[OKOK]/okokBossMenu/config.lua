Config, Locales = {}, {}

Config.Locale = 'cs' -- en / pt / es (not yet) / fr (not yet) / de (not yet)

Config.Debug = false -- true = Debug mode, it will show the debug messages on the console

Config.AutoAddDatabaseTables = true -- true = Auto add the database tables | false = You need to add the database tables manually

Config.AutoCreateSociety = true -- true = Auto create the society on the database tables | false = You need to create the society manually

Config.UseOkokNotify = false -- true = okokNotify | false = esx-notify (You can change the notification system on cl_utils.lua)

Config.UseOkokTextUI = false -- true = okokTextUI | false = esx-textui

Config.UseOkokRequests = false -- true = okokRequests | false = right away

Config.UseOkokBanking = false -- true = okokBanking | false = qb-banking ( For transactions )

Config.UseJobBlip = true -- true = marker or target | false = open with a command

Config.UseJobBlipAndCommand = false -- true = marker or target and command | false = only marker or target

Config.UseTarget = true -- true = Target | false = textUI

Config.EventPrefix = "okokBossMenu"  -- This will change the prefix of the events name so if Config.EventPrefix = "example" the events will be "example:event"

Config.SocietySystem = "addon-account" -- addon-account / okokBanking / custom (you need to implement it on sv_utils.lua)

Config.TargetSystem = "ox-target" -- The target system you are using ( ox-target )

Config.InventorySystem = "ox-inventory" -- The inventory system you are using ( ox-inventory / qs-inventory )

Config.ClothingSystem = "illenium-appearance" -- The clothing system you are using ( esx_skin / illenium-appearance )

Config.OpenBossMenuCommand = "openbossmenu" -- The command to open the boss menu if Config.UseJobBlip = false

Config.OpenGangMenuCommand = "opengangmenu" -- The command to open the gang menu if Config.UseJobBlip = false

Config.OpenDutyCommand = "openduty" -- The command to open the duty menu if Config.UseJobBlip = false

Config.BossGrades = { "boss", "subowner", "managment_ems" } -- The grades that the boss has

Config.Currency = "CZK" -- The currency used on the script

Config.DefaultPaymentAfterFire = 50 -- The default payment after being fired

Config.HireDistance = 3.0 -- The distance that the player needs to be to hire someone

Config.MarkerDistance = 10 -- The distance that the player needs to be to see the marker

Config.MarkerID = 21 -- The marker ID for the job locations

Config.MarkerColors = { r = 31, g = 94, b = 255, a = 90 } -- The marker colors for the job locations

Config.UseOffDutyPrefix = false -- true = It will set the players with the job with the prefix set below (it must exist on the database)

Config.OffDutyPrefix = "off_" -- The prefix for the off duty jobs

Config.UseNewESXDutySystem = true -- true = It will use the new ESX duty system | false = It will use the old ESX duty system

Config.JobLocations = {
        ['police'] = { bossCoords = {vector3(482.8286, -993.3330, 36.7981)}, dutyCoords = {vector3(34.0789, 587.2006, 33.3564)} },
	['ambulance'] = { bossCoords = {vector3(-1882.9768, -297.6407, 84.0563), vector3(-1290.0392, -1347.7986, 4.0697)}, 
                          dutyCoords = {vector3(-1827.0917, -339.8165, 53.7946)} 
			},
	['wine'] = { bossCoords = {vector3(-1897.9171, 2067.4158, 141.0207)}, dutyCoords = {vector3(-1889.1080, 2072.6462, 141.0057)} },
	['mechanic'] = { bossCoords = {vector3(-340.2107, -157.3856, 44.5871)}, dutyCoords = {vector3(-328.5750, -164.1843, 44.5880)} },
	['hzs'] = { bossCoords = {vector3(1204.8403, -1489.4391, 42.4733)}, dutyCoords = {vector3(1221.3120, -1486.7146, 34.6923)} },
	['bratva'] = { bossCoords = {vector3(430.2965, 5.9199, 91.9353)}, dutyCoords = {vector3(420.8847, 9.3426, 91.9461)} },
	['brewery'] = { bossCoords = {vector3(-57.7550, 6444.7134, 35.6713)}, dutyCoords = {vector3(-57.0945, 6447.1113, 35.6920)} },
	['splitsides'] = { bossCoords = {vector3(-442.8672, 279.8017, 83.0220)}, dutyCoords = {vector3(-442.8672, 279.8017, 83.0220)} },
	['pawshop'] = { bossCoords = {vector3(128.4440, -1778.1527, 29.7262)}, dutyCoords = {vector3(127.6413, -1780.9508, 29.7262)} },
	['stk'] = { bossCoords = {vector3(955.69, -1039.03, 39.47)}, dutyCoords = {vector3(951.82, -1046.80, 41.25)} },
	['cernakovci'] = { bossCoords = {vector3(411.4417, -1500.9773, 33.8073)}, dutyCoords = {vector3(414.2050, -1497.5718, 33.8073)} },
	['usti'] = { bossCoords = {vector3(1396.9105, 3612.8535, 34.9809)}, dutyCoords = {vector3(414.2050, -1497.5718, 33.8073)} },
	['profiauto'] = { bossCoords = {vector3(-641.245361,-2384.409424,13.842344)}, dutyCoords = {vector3(-645.510498,-2386.272461,14.028973)} },
	['advokatkancl'] = { bossCoords = {vector3(-521.515381,-170.880997,42.645947)}, dutyCoords = {vector3(-536.443726,-180.696121,42.635860)} },
	['kongrest'] = { bossCoords = {vector3(-1240.585449,-272.671417,38.109581)}, dutyCoords = {vector3(-1234.045410,-267.432495,38.208027)} },
	['hospudka'] = { bossCoords = {vector3(830.4436,-117.6963,80.4329)}, dutyCoords = {vector3(825.7346,-113.2223,80.4329)} },
	['policie_mp'] = { bossCoords = {vector3(-311.6549, -272.4479, 39.8927)}, dutyCoords = {vector3(-339.8186, -261.8748, 39.8071)} },
	['usti'] = { bossCoords = {vector3(-3234.54, 812.93, 13.87)}, dutyCoords = {vector3(-3237.23, 807.69, 13.07)} },
	['pizza'] = { bossCoords = {vector3(-1354.36, -1055.51, 3.65)}, dutyCoords = {vector3(-1352.68, -1061.42, 3.04)} },

}

-------------------------- DISCORD LOGS

Config.BotName = 'ServerName' -- Write the desired bot name

Config.ServerName = 'ServerName' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html

Config.DepositWebhook = true
Config.DepositWebhookColor = '65280'

Config.WithdrawWebhook = true
Config.WithdrawWebhookColor = '16711680'

Config.HireWebhook = true
Config.HireWebhookColor = '65280'

Config.FireWebhook = true
Config.FireWebhookColor = '16711680'

Config.EditEmployeeRankWebhook = true
Config.EditEmployeeRankWebhookColor = '65280'

Config.OnDutyWebhook = true
Config.OnDutyWebhookColor = '65280'

Config.OffDutyWebhook = true
Config.OffDutyWebhookColor = '16711680'

Config.GivenBonusWebhook = true
Config.GivenBonusWebhookColor = '65280'

-------------------------- LOCALES (DON'T TOUCH)

function _okok(id)
	if Locales[Config.Locale][id] then
		return Locales[Config.Locale][id]
	else
		print("The locale '"..id.."' doesn't exist!")
	end
end
