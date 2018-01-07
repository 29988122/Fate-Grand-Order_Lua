dir = scriptPath()
setImagePath(dir .. "image_TW")

--體力恢復
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

--[[
自動技能:
',' = 回合數
',#,' = BATTLE 數
'0' = 跳過1回合(不發動技能)

從者技能 = a b c	d e f	g h i
主人公技能 = j k l
技能對象 = 1 2 3
從者寶具發動 = 4 5 6

請將指令輸入於 "" 之間。

例:
Skill_Command = "bce,0,f3hi,#,j2d,#,4,a1g3"

BATTLE 1:
第1回 - 從者 1 技能 b, c, 從者 2 技能 e
第2回 - 跳過
第3回 - 從者 2 技能 f 對象從者 3, 從者 3 技能 h, i

BATTLE 2:
第1回 - 主人公技能 j 對象從者 2, 從者 2 技能 d

BATTLE 3:
第1回 - 從者 1 寶具發動
第2回 - 從者 1 技能 a 對象自己, 從者 3 技能 g on 對象自己
]]
Enable_Autoskill = 0
Skill_Command = ""

--額外活動點數獎勵
isEvent = 0

dofile(dir .. "regular.lua")