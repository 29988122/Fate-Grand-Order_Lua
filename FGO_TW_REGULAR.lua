--預設，建議不要動
dir = scriptPath()
setImagePath(dir)

xOffset = 150
yOffset = 0

GameRegion = "TW"
--StageCountRegion issue comment https://github.com/29988122/Fate-Grand-Order_Lua/issues/39#issuecomment-390208639
StageCountRegion = Region(1710 + xOffset,25 + yOffset,55,60)

--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
--NotJPserverForStaminaRefillExtraClick = 0

--[[Experimental https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 
    UnstableFastSkipDeadAnimation = 1
--]]

--Initalize for user input listnames
Autoskill_List = {}
for i = 1, 10 do
    Autoskill_List[i] = {}
    for j = 1, 2 do
        Autoskill_List[i][j] = 0
    end
end

--自動補體
Refill_Enabled = 0

--[[ Can be set to any of the following:
    "SQ"         Use Saint Quartz for refills
    "All Apples"    Use all available Apples for refills
    "Gold"          Use only Gold Apples for refills
    "Silver"        Use only Silver Apples for refills
    "Bronze"        Use only Bronze Apples for refills
]]
Refill_Resource = "All Apples"

-- Represents the amount of times a refill will happen.
-- Is NOT a counter for number of Apples used when Bronze apples are included
Refill_Repetitions = 0

--自動選擇好友從者
--請到此觀看詳細說明 https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#autosupportselection
Support_SelectionMode = "first"
Support_SwipesPerUpdate = 10
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "*chaldea_lunchtime.png"

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
--]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = ""

--Enable_Autoskill_List = 1的話、腳本啟動時會讓你從以下十組自動技能設定中選擇一組來使用
Enable_Autoskill_List = 0
--以下是使用者預先定義好的自動技能設定清單
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

--[[
可以用這個選項組藍卡隊了安安。這個選項會影響卡片選擇優先順位。 
可選擇兩種模式。
簡單模式:
例： "BAQ"代表weak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

詳細模式:
例： "WA, WB, WQ, A, B, Q, RA, RQ, RB"代表weak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick
Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"

請到此觀看詳細說明 https://github.com/29988122/Fate-Grand-Order_Lua#card-priority-customization
--]]
Battle_CardPriority = "BAQ"

--[[
寶具行為：
• disabled: 不會自己放寶具。如果你有用Autoskill，請選這個選項比較不會出問題。
• danger: 有DANGER或SERVANT敵人出現的時候每回合會自動放寶具。如果你有用Autoskill，這選項有機會讓你的Autoskill順序亂掉。
• spam: 有寶具當回合就會放掉。
請到此觀看詳細說明 https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#noble-phantasm-behavior 
--]]
Battle_NoblePhantasm = "disabled" 

--若活動有另外的獎勵視窗需點選，isEvent = 1。 詳細請見github上的readme
isEvent = 0

dofile(dir .. "regular.lua")
