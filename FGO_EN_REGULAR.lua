--Default, I suggest you not to modify them
dir = scriptPath()
setImagePath(dir .. "image_EN")
StageCountRegion = Region(1722,25,46,53)

--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
NotJPserverForStaminaRefillExtraClick = 1

--[[Experimental https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 
    UnstableFastSkipDeadAnimation = 1]]

--StaminaRefill
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

--[[
AutoSkill:
',' = Turn counter
',#,' = Battle counter
'0' = Skip 1 turn

Servant skill = a b c	d e f	g h i
Master skill = j k l
Target Servant = 1 2 3
Activate Servant NP = 4 5 6

Please insert your command in between the "".

eg:
Skill_Command = "bce,0,f3hi,#,j2d,#,4,a1g3"

Battle 1:
Turn 1 - Servant 1 skill b, c, Servant 2 skill e
Turn 2 - No skill
Turn 3 - Servant 2 skill f on servant 3, Servant 3 skill h, i

Battle 2:
Turn 1 - Master skill j on servant 2, Servant 2 skill d

Battle 3:
Turn 1 - Activate NP servant 1
Turn 2 - Servant 1 skill a on self, Servant 3 skill g on self

Skill_Confirmation: OFF = 0
(When you need to confirm skill use) ON = 1
]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = ""

--When Enable_Autoskill_List = 1, the script starts with a dialogue for you to choose Autoskill setting from one of the predefined list
Enable_Autoskill_List = 0
Autoskill_List = {}
--The folllowing are predefined settings by user
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

--You can change card selection priority. For example, BAQ stands for: weak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

--Whenever there's additional event point reward window to be clicked through, isEvent = 1. Please check the details on github.
isEvent = 1

dofile(dir .. "regular.lua")