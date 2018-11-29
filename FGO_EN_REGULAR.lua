--Default, I suggest you not to modify them
dir = scriptPath()
setImagePath(dir)

GameRegion = "EN"
StageCountRegion = Region(1722,25,46,53)

--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
NotJPserverForStaminaRefillExtraClick = 1

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

--StaminaRefill
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

--Support selection possible options: "first"; "preferred"; "manual"
--Please check the details here https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#autosupportselection
Support_SelectionMode = "first"
Support_SwipesPerUpdate = 10
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "*chaldea_lunchtime.png"

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
--]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = "abc,#,def,#,ghi"

--When Enable_Autoskill_List = 1, the script starts with a dialogue for you to choose Autoskill setting from one of the predefined list
Enable_Autoskill_List = 0
--The folllowing are predefined settings by user
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
You can change card selection priority. 
Two modes are available.
Simple Mode:
For example, "BAQ" stands for weak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

Detailed Mode:
For example, "WA, WB, WQ, A, B, Q, RA, RQ, RB" stands for weak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick
Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"

Refer https://github.com/29988122/Fate-Grand-Order_Lua#card-priority-customization for details.
--]]
Battle_CardPriority = "BAQ"

--[[
Noble Phantasm Behavior:
• disabled: Will never cast NPs automatically. If you have Autoskill enabled, please use this option.
• danger: Will cast NPs only when there are DANGER or SERVANT enemies on the screen. This option will probably mess up your Autoskill orders.
• spam: Will cast NPs as soon as they are available.
Check https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#noble-phantasm-behavior for further detail.
--]]
Battle_NoblePhantasm = "disabled" 

--Whenever there's additional event point reward window to be clicked through, isEvent = 1. Please check the details on github.
isEvent = 0

dofile(dir .. "regular.lua")