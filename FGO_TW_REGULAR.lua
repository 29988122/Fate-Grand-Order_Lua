--預設，建議不要動
dir = scriptPath()
setImagePath(dir)

GameRegion = "TW"
--StageCountRegion issue comment https://github.com/29988122/Fate-Grand-Order_Lua/issues/39#issuecomment-390208639
StageCountRegion = Region(1710,25,55,60)

--[[Experimental https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 
    UnstableFastSkipDeadAnimation = 1]]

--自動補體
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

--自動選擇好友從者
--請到此觀看詳細說明 https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#autosupportselection
Support_SelectionMode = "first"
Support_PreferredImage = "waver4.png"
Support_SwapsPerRefresh = 10
Support_MaxRefreshes = 3
Support_FallbackTo = "manual"

--[[
自動技能:
',' = 回合數
',#,' = BATTLE 數
'0' = 跳過1回合(不發動技能)

從者技能 = a b c	d e f	g h i
(戰鬥服)禮裝技能 = j k l
技能對象 = 1 2 3
從者寶具發動 = 4 5 6

請將指令輸入於 "" 之間。

例:
Skill_Command = "bce,0,f3hi,#,j2d,#,4,a1g3"

BATTLE 1:
第1回 - 從者 1 使用其技能 b, c, 從者 2 使用其技能 e
第2回 - 跳過
第3回 - 從者 2 使用其技能 f 在從者 3 身上, 從者 3 使用其技能 h, i

BATTLE 2:
第1回 - 禮裝技能 j 使用在從者 2 身上, 從者 2 使用其技能 d

BATTLE 3:
第1回 - 從者 1 寶具發動
第2回 - 從者 1 使用其技能 a 在自己身上, 從者 3 使用其技能 g 在自己身上

Skill_Confirmation: OFF = 0
(若您在遊戲內需要點選確認視窗才能使用技能) ON = 1
]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = ""

--Enable_Autoskill_List = 1的話、腳本啟動時會讓你從以下十組自動技能設定中選擇一組來使用
Enable_Autoskill_List = 0
Autoskill_List = {}
--以下是使用者預先定義好的自動技能設定清單
Autoskill_List[1] = "gac4,#,def5,#,x11abchi1j4"
Autoskill_List[2] = ""
Autoskill_List[3] = ""
Autoskill_List[4] = ""
Autoskill_List[5] = ""
Autoskill_List[6] = ""
Autoskill_List[7] = ""
Autoskill_List[8] = ""
Autoskill_List[9] = ""
Autoskill_List[10] = ""

--可以用這個選項組藍卡隊了安安。這個選項會影響卡片選擇優先順位，例：BAQ代表weak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

--若活動有另外的獎勵視窗需點選，isEvent = 1。 詳細請見github上的readme
isEvent = 0

dofile(dir .. "regular.lua")