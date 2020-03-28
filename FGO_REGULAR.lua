-- Can be EN, JP, CN or TW
GameRegion = "EN"

--Script Configuration, check instructions in the README and wiki: https://github.com/29988122/Fate-Grand-Order_Lua/wiki/Script-configuration-English
--***************************************************************************
--AutoRefill Stamina
Refill_Enabled = 0
Refill_Resource = "All Apples"
Refill_Repetitions = 0

--AutoSupportSelection Defaults
Support_SelectionMode = "first"
Support_SwipesPerUpdate = 10
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_FriendNames = ""
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "*chaldea_lunchtime.png"

--AutoSkill
Enable_Autoskill = 0
Skill_Confirmation = 0

Autoskill_List =
{
	{
		Name = "QP",
		Skill_Command = "4,#,f5,#,i6",
		Support_SelectionMode = "preferred",
		Support_PreferredServants = "",
		Support_PreferredCEs = "*mona_lisa.png"
	},
	{
		Name = "Dust",
		Skill_Command = "cdg5,#,e5,#,abi1k14",
		Support_SelectionMode = "preferred",
		Support_PreferredServants = "merlin1.png, merlin23.png, merlin4.png, merlin_c.png"
	},
	{
		Name = "Gear",
		Skill_Command = "6,#,h6,#,bx31fed1gj46",
		Support_SelectionMode = "preferred"
	}
}

--Card Priority Customization
Battle_CardPriority = "BAQ"
--AutoChooseTarget
Battle_AutoChooseTarget = 1
--NoblePhantasm Casting
Battle_NoblePhantasm = "disabled"

-- Do not modify below this line
dir = scriptPath()
dofile(dir .. "middleware.lua")
