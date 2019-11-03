--內部設定，請勿更動
--***************************************************************************
dir = scriptPath()
setImagePath(dir)
GameRegion = "CN"
StageCountRegion = Region(1722,25,46,53)
SupportSwipeEndClick  = Location(35,390)

--Initalize for user input listnames
Autoskill_List = {}
for i = 1, 10 do
    Autoskill_List[i] = {}
    for j = 1, 2 do
        Autoskill_List[i][j] = 0
    end
end
--***************************************************************************



--腳本設定說明請參照： https://github.com/29988122/Fate-Grand-Order_Lua/wiki/Script-configuration-正體中文/
--***************************************************************************
--Project Avalon
Use_Avalon = 0

--自動補體
Refill_Enabled = 0
Refill_Resource = "All Apples"
Refill_Repetitions = 0

--自動選擇好友從者
Support_SelectionMode = "first"
Support_SwipesPerUpdate = 10
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_FriendNames = ""
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "*chaldea_lunchtime.png"

--Bond CE Get
StopAfterBond10 = 0--[[
	This option is switched to 1 if you want to stop the script after retreiving a Bond 10 CE card
	TODO: move this explanation to documentation
--]]

--BoostItem
BoostItem_SelectionMode = "disabled" --[[
	possible values: disabled, 1, 2 or 3
	if you want to use this, make sure "Confirm Use of Boost Item" is off
	
	TODO: move this explanation to the documentation
--]]

StorySkip = 0 --[[
	People really want this feature.
]]

--自動施放技能
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = ""

--自動技能列表
Enable_Autoskill_List = 0

Autoskill_List[1][1] = "Settings No.1"
Autoskill_List[1][2] = "abc,#,def,#,ghi"

Autoskill_List[2][1] = "Settings No.2"
Autoskill_List[2][2] = ""

Autoskill_List[3][1] = "Settings No.3"
Autoskill_List[3][2] = ""

Autoskill_List[4][1] = "Settings No.4"
Autoskill_List[4][2] = ""

Autoskill_List[5][1] = "Settings No.5"
Autoskill_List[5][2] = ""

Autoskill_List[6][1] = "Settings No.6"
Autoskill_List[6][2] = ""

Autoskill_List[7][1] = "Settings No.7"
Autoskill_List[7][2] = ""

Autoskill_List[8][1] = "Settings No.8"
Autoskill_List[8][2] = ""

Autoskill_List[9][1] = "Settings No.9"
Autoskill_List[9][2] = ""

Autoskill_List[10][1] = "Settings No.10"
Autoskill_List[10][2] = ""

--自訂卡片選擇優先順序
Battle_CardPriority = "BAQ"
--自動選擇目標
Battle_AutoChooseTarget = 1
--自動寶具施放
Battle_NoblePhantasm = "disabled"
--快速跳過死亡動畫
UnstableFastSkipDeadAnimation = 0

dofile(dir .. "regular.lua")
