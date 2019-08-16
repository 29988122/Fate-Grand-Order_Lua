--Internal settings - do not modify.
--***************************************************************************
dir = scriptPath()
setImagePath(dir)
GameRegion = "EN"
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



--Script Configuration, check instructions here: https://github.com/29988122/Fate-Grand-Order_Lua/wiki/Script-configuration-English
--***************************************************************************
--[[
AutoSkill:

AutoSkill allows you to execute a series of turn-based skill commands, via user-predefined strings. 
Change Enable_Autoskill to 1 to enable it, 0 to disable.

Skill_Confirmation allows you to skip the Confirm Skill Use window. 
Modify it according to your Battle Menu setting:

OFF = 0
ON = 1

That is, if you need to click through confirmation window to use a skill, make this option Skill_Confirmation = 1. 
Otherwise, leave it as Skill_Confirmation = 0.

Skill_Command strings should be composed by the following rules:

',' = Turn counter
',#,' = Battle counter
'0' = Skip 1 turn

Servant skill = a b c	d e f	g h i
Master skill = j k l
Target Servant = 1 2 3
Activate Servant NP = 4 5 6

e.g.
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

We did not implement skill cooldown check yet.
However by planning ahead, wrote commands for many rounds(putting a lot of zeros), you can prevent the script accidently clicked the skills that were still on cooldown.

Chaldea Combat Uniform: Order Change

x - activates Order Change
Starting Member Position - 1  2  3
Sub-member position - 1  2  3

e.g. 
Skill_Command = "x13"
Exchange starting member 1 with sub-member 3
Of course, you can mix the Order Change command with normal Autoskill commands:
e.g.
Skill_Command = "bce,0,f3hi,#,j2d,#,4,x13a1g3"

AutoSkill List
Set Enable_Autoskill_List = 1 to enable this feature. 
You can setup a predefined autoskill list from 1~10, and the script whould let you choose from it when it starts running.
This especially helps if you need to farm different stages during events.

AutoRefill Stamina
Set Refill_Enabled = 1 to enable AutoRefill.

There are five options available for Refill_Resource:
    SQ: will consume Saint Quartz
    Gold: will consume Gold Apples
    Silver: will consume Silver Apples
    Bronze: will consume Bronze Apples
    All Apples: will consume all available apples in the following order: Bronze, Silver, Gold. This option is used when you need to do a full throttle farming.
Refill_Repetitions controls how many apples you want to use to refill your AP.
However, this option is only accurate when you're using SQ or Gold Apples.
On average, it will consume 3x the amount from Refill_Repetitions when using Bronze Apples, 1.2x the amount when using Silver Apples.

--]]

--AutoRefill Stamina
Refill_Enabled = 0
Refill_Resource = "All Apples"
Refill_Repetitions = 0

--AutoSupportSelection
Support_SelectionMode = "preferred"
Support_SwipesPerUpdate = 3
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "any"

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

--AutoSkill
Enable_Autoskill = 1
Skill_Confirmation = 0
Skill_Command = "abc,#,def,#,ghi"

--AutoSkillList
Enable_Autoskill_List = 1

Autoskill_List[1][1] = "Fran,Arash,Shake,Spart,0,Supp"
Autoskill_List[1][2] = "jfgi2x335,#,g1hief5,#,c4"

Autoskill_List[2][1] = "Spam Everything"
Autoskill_List[2][2] = "abcdefghi,0,0,0,0,0,0,0,0,abcdefghi,0,0,0,0,0,0,0,0,abcdefghi"

Autoskill_List[3][1] = "Spam at Battle 1,3"
Autoskill_List[3][2] = "abcdefghi,#,#,abcdefghi"

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

--Card Priority Customization
Battle_CardPriority = "BAQ"
--AutoChooseTarget
Battle_AutoChooseTarget = 1
--NoblePhantasm Casting
Battle_NoblePhantasm = "danger" 
--FastSkipDeadAnimation
UnstableFastSkipDeadAnimation = 0
--Event Stage
isEvent = 0

dofile(dir .. "regular.lua")
