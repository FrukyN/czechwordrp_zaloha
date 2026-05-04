--[[
---------------------------------------------------
LUXART VEHICLE CONTROL V3 (FOR FIVEM)
---------------------------------------------------
Coded by Lt.Caine
ELS Clicks by Faction
Additions by TrevorBarns
---------------------------------------------------
FILE: SIRENS.lua
PURPOSE: Associate specific sirens with specific
vehicles. Siren assignments.
---------------------------------------------------
SIREN TONE TABLE:
	ID- Generic Name	(SIREN STRING)								[vehicles.awc name]
	1 - Airhorn 		(SIRENS_AIRHORN)							[AIRHORN_EQD]
	2 - Wail 		(VEHICLES_HORNS_SIREN_1)						[SIREN_PA20A_WAIL]
	3 - Yelp 		(VEHICLES_HORNS_SIREN_2)						[SIREN_2]
	4 - Priority 		(VEHICLES_HORNS_POLICE_WARNING)						[POLICE_WARNING]
	5 - CustomA* 		(RESIDENT_VEHICLES_SIREN_WAIL_01)					[SIREN_WAIL_01]
	6 - CustomB* 		(RESIDENT_VEHICLES_SIREN_WAIL_02)					[SIREN_WAIL_02]
	7 - CustomC* 		(RESIDENT_VEHICLES_SIREN_WAIL_03)					[SIREN_WAIL_03]
	8 - CustomD* 		(RESIDENT_VEHICLES_SIREN_QUICK_01)					[SIREN_QUICK_01]
	9 - CustomE* 		(RESIDENT_VEHICLES_SIREN_QUICK_02)					[SIREN_QUICK_02]
	10 - CustomF* 		(RESIDENT_VEHICLES_SIREN_QUICK_03)					[SIREN_QUICK_03]
	11 - Powercall 		(VEHICLES_HORNS_AMBULANCE_WARNING)					[AMBULANCE_WARNING]
	12 - FireHorn	 	(VEHICLES_HORNS_FIRETRUCK_WARNING)					[FIRE_TRUCK_HORN]
	13 - Firesiren 		(RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01)				[SIREN_FIRETRUCK_WAIL_01]
	14 - Firesiren2 	(RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01)				[SIREN_FIRETRUCK_QUICK_01]
]]

RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_LSPD_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_LSPD_OLD", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCFD_OLD", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCSO_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCFD_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_LSFD_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_LSSD_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_LSSD_OLD", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_FIB_NEW", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_ETC", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_RHPD_OLD", false)
RequestScriptAudioBank("DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_SANFIRE_OLD", false)



-- CHANGE SIREN NAMES, AUDIONAME, AUDIOREF
SIRENS = {
	--[[1]] { Name = 'Airhorn', String = 'SIRENS_AIRHORN',                             Ref = 0 },                                               --1
	--[[2]] { Name = 'Wail',    String = 'VEHICLES_HORNS_SIREN_1',                     Ref = 0 },                                               --2
	--[[3]] { Name = 'Yelp',    String = 'VEHICLES_HORNS_SIREN_2',                     Ref = 0 },                                               --3
	--[[4]] { Name = 'Priority', String = 'VEHICLES_HORNS_POLICE_WARNING',             Ref = 0 },                                               --4
	--[[5]] { Name = 'CustomA', String = 'RESIDENT_VEHICLES_SIREN_WAIL_01',            Ref = 0 },                                               --5
	--[[6]] { Name = 'CustomB', String = 'RESIDENT_VEHICLES_SIREN_WAIL_02',            Ref = 0 },                                               --6
	--[[7]] { Name = 'CustomC', String = 'RESIDENT_VEHICLES_SIREN_WAIL_03',            Ref = 0 },                                               --7
	--[[8]] { Name = 'CustomD', String = 'RESIDENT_VEHICLES_SIREN_QUICK_01',           Ref = 0 },                                               --8
	--[[9]] { Name = 'CustomE', String = 'RESIDENT_VEHICLES_SIREN_QUICK_02',           Ref = 0 },                                               --9
	--[[10]] { Name = 'CustomF', String = 'RESIDENT_VEHICLES_SIREN_QUICK_03',          Ref = 0 },                                               --10
	--[[11]] { Name = 'Powercall', String = 'VEHICLES_HORNS_AMBULANCE_WARNING',        Ref = 0 },                                               --11
	--[[12]] { Name = 'Fire Horn', String = 'VEHICLES_HORNS_FIRETRUCK_WARNING',        Ref = 0 },                                               --12
	--[[13]] { Name = 'Fire Yelp', String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', Ref = 0 },                                             --13
	--[[14]] { Name = 'Fire Wail', String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', Ref = 0 },                                            --14
	--[[15]] { Name = "New BCSO HORN", String = "OISS_SSA_VEHAUD_BCSO_NEW_HORN",       Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },             --15
	--[[16]] { Name = "New BCSO ADAM", String = "OISS_SSA_VEHAUD_BCSO_NEW_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },             --16
	--[[17]] { Name = "New BCSO BOY", String = "OISS_SSA_VEHAUD_BCSO_NEW_SIREN_BOY",   Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },             --17
	--[[18]] { Name = "New BCSO CHARLES", String = "OISS_SSA_VEHAUD_BCSO_NEW_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },       --18
	--[[19]] { Name = "New BCSO DAVID", String = "OISS_SSA_VEHAUD_BCSO_NEW_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },           --19
	--[[20]] { Name = "New BCSO EDWARD", String = "OISS_SSA_VEHAUD_BCSO_NEW_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET" },         --20
	--[[21]] { Name = "New LSPD HORN", String = "OISS_SSA_VEHAUD_LSPD_NEW_HORN",       Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },             --21
	--[[22]] { Name = "New LSPD ADAM", String = "OISS_SSA_VEHAUD_LSPD_NEW_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },             --22
	--[[23]] { Name = "New LSPD BOY", String = "OISS_SSA_VEHAUD_LSPD_NEW_SIREN_BOY",   Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },             --23
	--[[24]] { Name = "New LSPD CHARLES", String = "OISS_SSA_VEHAUD_LSPD_NEW_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },       --24
	--[[25]] { Name = "New LSPD DAVID", String = "OISS_SSA_VEHAUD_LSPD_NEW_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },           --25
	--[[26]] { Name = "New LSPD EDWARD", String = "OISS_SSA_VEHAUD_LSPD_NEW_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_LSPD_NEW_SOUNDSET" },         --26
	--[[27]] { Name = "New LSFD HORN", String = "OISS_SSA_VEHAUD_LSFD_NEW_HORN",       Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },             --27
	--[[28]] { Name = "New LSFD ADAM", String = "OISS_SSA_VEHAUD_LSFD_NEW_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },             --28
	--[[29]] { Name = "New LSFD BOY", String = "OISS_SSA_VEHAUD_LSFD_NEW_SIREN_BOY",   Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },             --29
	--[[30]] { Name = "New LSFD CHARLES", String = "OISS_SSA_VEHAUD_LSFD_NEW_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },       --30
	--[[31]] { Name = "New LSFD DAVID", String = "OISS_SSA_VEHAUD_LSFD_NEW_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },           --31
	--[[32]] { Name = "New LSFD EDWARD", String = "OISS_SSA_VEHAUD_LSFD_NEW_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_LSFD_NEW_SOUNDSET" },         --32
	--[[33]] { Name = "Old LSPD HORN", String = "OISS_SSA_VEHAUD_LSPD_OLD_HORN",       Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },             --33
	--[[34]] { Name = "Old LSPD ADAM", String = "OISS_SSA_VEHAUD_LSPD_OLD_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },             --34
	--[[35]] { Name = "Old LSPD BOY", String = "OISS_SSA_VEHAUD_LSPD_OLD_SIREN_BOY",   Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },             --35
	--[[36]] { Name = "Old LSPD CHARLES", String = "OISS_SSA_VEHAUD_LSPD_OLD_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },       --36
	--[[37]] { Name = "Old LSPD DAVID", String = "OISS_SSA_VEHAUD_LSPD_OLD_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },           --37
	--[[38]] { Name = "Old LSPD EDWARD", String = "OISS_SSA_VEHAUD_LSPD_OLD_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_LSPD_OLD_SOUNDSET" },         --38
	--[[39]] { Name = "New LSSD HORN", String = "OISS_SSA_VEHAUD_LSSD_NEW_HORN",       Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },             --39
	--[[40]] { Name = "New LSSD ADAM", String = "OISS_SSA_VEHAUD_LSSD_NEW_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },             --40
	--[[41]] { Name = "New LSSD BOY", String = "OISS_SSA_VEHAUD_LSSD_NEW_SIREN_BOY",   Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },             --41
	--[[42]] { Name = "New LSSD CHARLES", String = "OISS_SSA_VEHAUD_LSSD_NEW_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },       --42
	--[[43]] { Name = "New LSSD DAVID", String = "OISS_SSA_VEHAUD_LSSD_NEW_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },           --43
	--[[44]] { Name = "New LSSD EDWARD", String = "OISS_SSA_VEHAUD_LSSD_NEW_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_LSSD_NEW_SOUNDSET" },         --44
	--[[45]] { Name = "HORN",   String = "OISS_SSA_VEHAUD_ETC_HORN",                   Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --45
	--[[46]] { Name = "ADAM",   String = "OISS_SSA_VEHAUD_ETC_ADAM",                   Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --46
	--[[47]] { Name = "BOY",    String = "OISS_SSA_VEHAUD_ETC_BOY",                    Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --47
	--[[48]] { Name = "CHARLES", String = "OISS_SSA_VEHAUD_ETC_CHARLES",               Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --48
	--[[49]] { Name = "DAVID",  String = "OISS_SSA_VEHAUD_ETC_DAVID",                  Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --49
	--[[50]] { Name = "EDWARD", String = "OISS_SSA_VEHAUD_ETC_EDWARD",                 Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --50
	--[[51]] { Name = "FRANK",  String = "OISS_SSA_VEHAUD_ETC_FRANK",                  Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --51
	--[[52]] { Name = "GEORGE", String = "OISS_SSA_VEHAUD_ETC_GEORGE",                 Ref = "OISS_SSA_VEHAUD_ETC_SOUNDSET" },                  --52
	--[[53]] { Name = "New FIB HORN", String = "OISS_SSA_VEHAUD_FIB_NEW_HORN",         Ref = "OISS_SSA_VEHAUD_FIB_NEW_SOUNDSET" },              --53
	--[[54]] { Name = "New FIB ADAM", String = "OISS_SSA_VEHAUD_FIB_NEW_SIREN_ADAM",   Ref = "OISS_SSA_VEHAUD_FIB_NEW_SOUNDSET" },              --54
	--[[55]] { Name = "New FIB BOY", String = "OISS_SSA_VEHAUD_FIB_NEW_SIREN_BOY",     Ref = "OISS_SSA_VEHAUD_FIB_NEW_SOUNDSET" },              --55
	--[[56]] { Name = "New FIB CHARLES", String = "OISS_SSA_VEHAUD_FIB_NEW_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_FIB_NEW_SOUNDSET" },          --56
	--[[57]] { Name = "New FIB DAVID", String = "OISS_SSA_VEHAUD_FIB_NEW_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_FIB_NEW_SOUNDSET" },              --57
	--[[58]] { Name = "Staff HORN", String = "OISS_SSA_VEHAUD_RHPD_OLD_HORN",          Ref = "OISS_SSA_VEHAUD_RHPD_OLD_SOUNDSET" },             --58
	--[[59]] { Name = "Staff ADAM", String = "OISS_SSA_VEHAUD_RHPD_OLD_SIREN_ADAM",    Ref = "OISS_SSA_VEHAUD_RHPD_OLD_SOUNDSET" },             --59
	--[[60]] { Name = "Staff BOY", String = "OISS_SSA_VEHAUD_RHPD_OLD_SIREN_BOY",      Ref = "OISS_SSA_VEHAUD_RHPD_OLD_SOUNDSET" },             --60
	--[[61]] { Name = "Staff CHARLES", String = "OISS_SSA_VEHAUD_RHPD_OLD_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_RHPD_OLD_SOUNDSET" },          --61
	--[[62]] { Name = "Staff DAVID", String = "OISS_SSA_VEHAUD_RHPD_OLD_SIREN_DAVID",  Ref = "OISS_SSA_VEHAUD_RHPD_OLD_SOUNDSET" },             --62
	--[[63]] { Name = "VB Sireny - Horn", String = "OISS_SSA_VEHAUD_BCFD_OLD_HORN",    Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },             --63
	--[[64]] { Name = "VB Sireny - Adam", String = "OISS_SSA_VEHAUD_BCFD_OLD_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },          --64
	--[[65]] { Name = "VB Sireny - Boy", String = "OISS_SSA_VEHAUD_BCFD_OLD_SIREN_BOY", Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },            --65
	--[[66]] { Name = "VB Sireny - Charles", String = "OISS_SSA_VEHAUD_BCFD_OLD_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },    --66
	--[[67]] { Name = "VB Sireny - David", String = "OISS_SSA_VEHAUD_BCFD_OLD_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },        --67
	--[[68]] { Name = "VB Sireny - Edward", String = "OISS_SSA_VEHAUD_BCFD_OLD_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_BCFD_OLD_SOUNDSET" },      --68
	--[[69]] { Name = "Motorka - Horn", String = "OISS_SSA_VEHAUD_LSIA_OLD_HORN",      Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },             --69
	--[[70]] { Name = "Motorka - Adam", String = "OISS_SSA_VEHAUD_LSIA_OLD_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },            --70
	--[[71]] { Name = "Motorka - Boy", String = "OISS_SSA_VEHAUD_LSIA_OLD_SIREN_BOY",  Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },             --71
	--[[72]] { Name = "Motorka - Charles", String = "OISS_SSA_VEHAUD_LSIA_OLD_SIREN_CHARLES", Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },      --72
	--[[73]] { Name = "Motorka - David", String = "OISS_SSA_VEHAUD_LSIA_OLD_SIREN_DAVID", Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },          --73
	--[[74]] { Name = "Motorka - Edward", String = "OISS_SSA_VEHAUD_LSIA_OLD_SIREN_EDWARD", Ref = "OISS_SSA_VEHAUD_LSIA_OLD_SOUNDSET" },        --74
	--[[75]] { Name = "Italian Tone Holomy", String = "OISS_SSA_VEHAUD_BCFD_NEW_SIREN_ADAM", Ref = "OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET" },       --75
	--[[76]] { Name = "AZD 500", String = "OISS_SSA_VEHAUD_NOOSE_OLD_HORN",          Ref = "OISS_SSA_VEHAUD_NOOSE_OLD_SOUNDSET" },                 --76
	--[[77]] { Name = "AZD 500", String = "OISS_SSA_VEHAUD_NOOSE_OLD_SIREN_ADAM",    Ref = "OISS_SSA_VEHAUD_NOOSE_OLD_SOUNDSET" },          --77
}

-- 53, 54, 55, 56, 57 hasici
--  27, 28, 29, 30, 31, 75 cetnici
--  15, 16, 17, 18 zachranka


--ASSIGN SIRENS TO VEHICLES
SIREN_ASSIGNMENTS = {
	--['<gameName>'] = {tones},
	['o2pcr3nonfl'] = { 27, 28, 29, 30, 31, 75 },
	['o2pcr3'] = { 27, 28, 29, 30, 31, 75 },
	['t5pcr3'] = { 27, 28, 29, 30, 31, 75 },
	['o2pcr2nonfl'] = { 27, 28, 29, 30, 31, 75 },
	['vtusdis77'] = { 39, 40, 41, 43, 44 },
	['ovecoles'] = { 39, 40, 41, 43, 44 },
	['o3flram'] = { 53, 54, 55, 56, 57 },
	['o3fl2'] = { 27, 28, 29, 30, 31, 75 },
	--['scalapcr'] = { 27, 28, 29, 30, 31, 75 },
	['o3flram2'] = { 21, 22, 23, 24, 25, 26, 44 },
	['ovceHZS'] = { 27, 28, 29, 30, 31, 75 },
	['ovceZZS'] = { 15, 16, 17, 18 },
	['t6mpo'] = { 27, 28, 29, 30, 31, 75 },
	['crafter'] = { 27, 28, 29, 30, 31, 75 },
	['superbdp'] = { 27, 28, 29, 30, 31, 75 },
	['o3new3'] = { 27, 28, 29, 30, 31, 75 },
	['karoqcs'] = { 27, 28, 29, 30, 31, 75 },
	['o3fl'] = { 53, 54, 55, 56, 57 },
	['o3flbb'] = { 53, 54, 55, 56, 57 },
	['o1pcr'] = { 63, 64, 65, 66 },
	['o1mpo'] = { 63, 64, 65, 66 },
	['o3new2'] = { 27, 28, 29, 30, 31, 75 },
	['o3newcs'] = { 27, 28, 29, 30, 31, 75 },
	['terrno'] = { 27, 28, 29, 30, 31, 75 },
	['jsdhterrno'] = { 27, 28, 29, 30, 31, 75 },
	['fireboat'] = { 27, 28, 29, 30, 31, 75 },
	['CGDINGHY'] = { 27, 28, 29, 30, 31, 75 },
	['hazmat'] = { 27, 28, 29, 30, 31, 75 },
	['t81522'] = { 27, 28, 29, 30, 31, 75 },
	['epan'] = { 27, 32, 29, 30, 28 },
	['t6zzs'] = { 15, 16, 17, 18 },
	['crafterzzs'] = { 15, 16, 17, 18 },
	['kodiaqzzsfl'] = { 15, 16, 17, 18 },
	['touaregok'] = { 15, 16, 17, 18 },
	['SprinterZZS'] = { 15, 16, 17, 18 },
	['sprinterzzs2'] = { 15, 16, 17, 18 },
	['Kodiaqun'] = { 27, 28, 29, 30, 31, 75 },
	['techres'] = { 27, 28, 29, 30, 31, 75 },
	['ranger'] = { 27, 28, 29, 30, 31, 75 },
	['ranger2'] = { 27, 28, 29, 30, 31, 75 },
	['ranger3'] = { 27, 28, 29, 30, 31, 75 },
	['fdf150'] = { 27, 28, 29, 30, 31, 75 },
	['ivecoles'] = { 27, 28, 29, 30, 31, 75 },
	['hilux'] = { 53, 54, 55, 56, 57 },
	['hilux1'] = { 27, 28, 29, 30, 31, 75 },
	['hilux2'] = { 15, 16, 17, 18 },
	['o3new3mpo'] = { 27, 28, 29, 30, 31, 75 },
	['enyaqmp'] = { 27, 28, 29, 30, 31, 75 },
	['fabiamp'] = { 27, 28, 29, 30, 31, 75 },
	['o2pcr2nonfl'] = { 27, 28, 29, 30, 31, 75 },
	['ohso3new'] = { 27, 28, 29, 30, 31, 75 },
	['pmjo3new'] = { 27, 28, 29, 30, 31, 75 },
	['passatbana'] = { 27, 28, 29, 30, 31, 75 },
	['tucpcr'] = { 53, 54, 55, 56, 57 },
	['bearcat'] = { 27, 28, 29, 30, 31, 75 },
	['pcrsuperbDP'] = { 27, 28, 29, 30, 31, 75 },
	['o3bb'] = { 27, 28, 29, 30, 31, 75 },
	['vwt61'] = { 15, 16, 17, 18 },
	['o3newcs2'] = { 15, 16, 17, 18 },
	['transitcs'] = { 15, 16, 17, 18 },
	['o3flcs'] = { 15, 16, 17, 18 },
	['vitocs'] = { 21, 22, 23, 24, 25, 26, 44 },
	['superb21'] = { 53, 54, 55, 56, 57 },
	['superbdp'] = { 53, 54, 55, 56, 57 },
	['sprintersprava'] = { 27, 28, 29, 30, 31, 75 },
	['14mbsprintercs'] = { 27, 28, 29, 30, 31, 75 },
	['polcaddy'] = { 15, 16, 17, 18 },
	['spravesonata'] = { 15, 16, 17, 18 },
	['csovce'] = { 15, 16, 17, 18 },
	['t6cs'] = { 33, 34, 35, 36 },
	['t6csold'] = { 33, 34, 35, 36 },
	['o2cs'] = { 39, 40, 41, 43 },
	['felicievakci'] = { 0, 76, 77 },
	['t6csold2'] = { 39, 40, 41, 43 },
	['o2cs2'] = { 33, 34, 35, 36 },
	['o2sedancs'] = { 33, 34, 35, 36 },
	['ambulance'] = { 33, 34, 35, 36 },
	['AMBULANCE'] = { 33, 34, 35, 36 },
	['craftercs'] = { 53, 54, 55, 56, 57 },
	['540touring'] = { 53, 54, 55, 56, 57 },
	['bmw540'] = { 53, 54, 55, 56, 57 }, 
	--['scalapcr'] = { 27, 28, 29, 30, 31, 75 },
	['scalapcr'] = { 53, 54, 55, 56, 57 },
	['sonata'] = { 53, 54, 55, 56, 57 },
	['t6policen'] = { 53, 54, 55, 56, 57 },
	['21540iunmk'] = { 53, 54, 55, 56, 57 },
	['actgdrpaddy'] = { 53, 54, 55, 56, 57 },
	['nypdcvpi'] = { 58, 59, 60, 61, 62 },
	['nypdhwyexplorer'] = { 58, 59, 60, 61, 62 },
	['nypdtaurus'] = { 58, 59, 60, 61, 62 },
	['nypdtraffic'] = { 58, 59, 60, 61, 62 },
	['cvpi98'] = { 63, 64, 65, 66, 67, 68 },
	['13fpiu'] = { 63, 64, 65, 66, 67, 68 },
	['pwcart'] = { 63, 64, 65, 66, 67, 68 },
	['NWCVPI'] = { 63, 64, 65, 66, 67, 68 },
	['sepchrg'] = { 63, 64, 65, 66, 67, 68 },
	['nddexpl'] = { 63, 64, 65, 66, 67, 68 },
	['lc79pod'] = { 63, 64, 65, 66, 67, 68 },
	--['o3fl'] = { 21, 22, 23, 24, 25, 26, 44 },
	['o2zj'] = { 53, 54, 55, 56, 57 },
	['t5zj'] = { 53, 54, 55, 56, 57 },
	['disco'] = { 27, 28, 29, 30, 31, 75 },
	['t61skpv'] = { 15, 16, 17, 18 },
	['t61pcr'] = { 15, 16, 17, 18 },
	['t6zj'] = { 15, 16, 17, 18 },
	['t6long'] = { 15, 16, 17, 18 },
	['t815spj'] = { 63, 64, 65, 66 },
	['x5leos'] = { 27, 28, 29, 30, 31, 75 },
	['745leos'] = { 27, 28, 29, 30, 31, 75 },
	['rs6pcr'] = { 27, 28, 29, 30, 31, 75 },
	['osa8'] = { 27, 28, 29, 30, 31, 75 },
	['liaz'] = { 1, 75, 77 },
	['kodiaqpcr'] = { 53, 54, 55, 56, 57 },
	['pcrkodiaqDP'] = { 53, 54, 55, 56, 57 },
	['vwt61new'] = { 15, 16, 17, 18 },
	['o4vea'] = { 53, 54, 55, 56, 57 },
	['t6rzajsdh'] = { 27, 28, 29, 30, 31, 75 },
	['t153'] = { 27, 28, 29, 30, 31, 75 },
	['gatorhzs'] = { 27, 28, 29, 30, 31, 75} ,
	['vwt61hzs'] = { 27, 28, 29, 30, 31, 75 },
	['terrno2'] = { 27, 28, 29, 30, 31, 75 },
	['scanka'] = { 27, 28, 29, 30, 31, 75 },
	['scanxt'] = { 27, 28, 29, 30, 31, 75 },
	['scanxtaz'] = { 27, 28, 29, 30, 31, 75 },
	['t6rza'] = { 27, 28, 29, 30, 31, 75 },
	['t815'] = { 27, 28, 29, 30, 31, 75 },
	['DOCKodiaq'] = { 15, 16, 17, 18 },
	['hazmat2'] = {27, 28, 29, 30, 31, 75},
	['kodiaqflhzs'] = {27, 28, 29, 30, 31, 75 },
	['kodiaqHZS'] = { 27, 28, 29, 30, 31, 75 },
	['techres'] = {53, 54, 55, 56, 57 },
	['kodiaqflramvel'] = { 53, 54, 55, 56, 57 },
	['kodiaqflram2'] = { 53, 54, 55, 56, 57 },
	['KODIAQ MP'] = { 53, 54, 55, 56, 57 },
	['Octavia 3 C'] = { 53, 54, 55, 56, 57 },
	['24kodiaqpcr'] = { 53, 54, 55, 56, 57 },
	['ACTRPavantum'] = { 53, 54, 55, 56, 57 },
	['r1200rtp'] = { 53, 54, 55, 56, 57 },
	['r1200rtp2'] = { 53, 54, 55, 56, 57 },
	['touaregpcr'] = { 53, 54, 55, 56, 57 },
	['458 ITALIA'] = { 53, 54, 55, 56, 57 },
	['24kodiaqpc'] = { 53, 54, 55, 56, 57 },
	['pcrsuperbDP'] = { 53, 54, 55, 56, 57 },
	['o3flram'] = { 53, 54, 55, 56, 57 },
	['AFPskoda'] = { 53, 54, 55, 56, 57 },
	['o2pcr2nonfl'] = { 53, 28, 29, 30, 31, 75 },
	['o2fl'] = { 53, 28, 29, 30, 31, 75 },
	['amarok2'] = { 53, 28, 29, 30, 31, 75 },
	['amarok'] = { 53, 28, 29, 30, 31, 75 },
	['prado'] = { 53, 28, 29, 30, 31, 75 },
	['prado2'] = { 53, 28, 29, 30, 31, 75 },
	['o3un'] = { 53, 28, 29, 30, 31, 75 },
	['o3new'] = { 53, 28, 29, 30, 31, 75 },
	['passatdp2'] = { 53, 28, 29, 30, 31, 75 },
	['dppassatpcr'] = { 53, 28, 29, 30, 31, 75 },
	['o3com'] = { 53, 28, 29, 30, 31, 75 },
	['o2flcom'] = { 53, 28, 29, 30, 31, 75 },
	['wvtran'] = { 53, 54, 55, 56, 57 },
	['kodiaqVELit'] = { 53, 54, 55, 56, 57 },
	['kodiaqflram'] = { 53, 54, 55, 56, 57 },
	['crafter'] = { 15, 16, 17, 18 },
	['kodiaqflohs'] = { 53, 54, 55, 56, 57 },
	['kodiaqmp'] = { 53, 54, 55, 56, 57 },
	['octaviabac'] = { 53, 54, 55, 56, 57 },
	['sprinterzzs2'] = { 15, 16, 17, 18 },
	['fenixzzs'] = { 15, 16, 17, 18 },
	['GleZZSIP'] = { 15, 16, 17, 18 },
	['kodiaqflzzs'] = { 15, 16, 17, 18},
	['o4zzs'] = {15, 16, 17, 18 },
	['DEFAULT'] = { 53, 54, 55, 56, 57 },
	['pbike'] = { 0, 0 },
	['t6rsd'] = { 0, 0 },
	['tucsonrsd'] = { 0, 0 },
}