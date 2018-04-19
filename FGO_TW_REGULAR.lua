--預設
dir = scriptPath()
setImagePath(dir .. "image_TW")

--自動補體
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

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

--若活動有另外的獎勵視窗需點選，isEvent = 1。 詳細請見github上的readme。
isEvent = 0

dofile(dir .. "regular.lua")