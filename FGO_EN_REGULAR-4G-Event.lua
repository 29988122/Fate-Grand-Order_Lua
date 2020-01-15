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
--AutoRefill Stamina
Refill_Enabled = 1
Refill_Resource = "Silver"
Refill_Repetitions = 5

--AutoSupportSelection
Support_SelectionMode = "preferred"
Support_SwipesPerUpdate = 3
Support_MaxUpdates = 5
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_FriendNames = ""
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
--Support_PreferredServants = "merlin1.png, merlin2.png, merlin4.png"
Support_PreferredCEs = "gentle_affection.png, scholars_of_chaldea.png"
--Support_PreferredCEs = "gentle_affection.png"
--Support_PreferredCEs = "art_of_the_poisonous_snake.png"
--Support_PreferredCEs = "art_of_death.png"
--Support_PreferredCEs = "any"

--Bond CE Get
StopAfterBond10 = 0 
--This option is switched to 1 if you want to stop the script after retreiving a Bond 10 CE card
--TODO: move this explanation to documentation

--BoostItem
BoostItem_SelectionMode = "disabled" 
--possible values: disabled, 1, 2 or 3
--if you want to use this, make sure "Confirm Use of Boost Item" is off
	
--TODO: move this explanation to the documentation

StorySkip = 0
--People really want this feature.

--AutoSkill
Enable_Autoskill = 1
Skill_Confirmation = 0
Skill_Command = "abc,#,def,#,ghi"

--AutoSkillList
Enable_Autoskill_List = 1

Autoskill_List[1][1] = "Caster Gold Currency Hearts"
Autoskill_List[1][2] = "ab4,#,x13a2bcf5,#,degijt2k65"

Autoskill_List[2][1] = "Lancer Bronze"
Autoskill_List[2][2] = "d,#,b,ac3x11aei5,#,bc3gjkh6"

Autoskill_List[3][1] = "Assasin Silver"
Autoskill_List[3][2] = "geh,#,abc3x12afd5,5,#,c3bij6,ghik"

Autoskill_List[4][1] = "G4 Candles"
Autoskill_List[4][2] = "d,0,af,#,age5,#,d1e1f1k1bhi1j1t24,c"

Autoskill_List[5][1] = "Event Conqueror"
Autoskill_List[5][2] = "agi6,#,ex33fhijkg15,#,bcdf14"

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
--Battle_CardPriority = "BAQ"
Battle_CardPriority = "WB, WA, WQ, A, B, Q, RA, RQ, RB"
--AutoChooseTarget
Battle_AutoChooseTarget = 1
--NoblePhantasm Casting
Battle_NoblePhantasm = "danger" 
--FastSkipDeadAnimation
UnstableFastSkipDeadAnimation = 0

dofile(dir .. "regular.lua")
