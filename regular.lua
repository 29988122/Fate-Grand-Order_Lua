--Other import such as ankulua-utils or string-utils are defined in support.lua.
package.path = package.path .. ";" .. dir .. 'modules/?.lua'
local support = require("support")
local card = require("card")
local battle = require("battle")
local autoskill = require("autoskill")

--[[このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
	私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
	お願いします。このプログラムを禁止しないでください。
--]]

--Main loop, pattern detection regions.
--Click pos are hard-coded into code, unlikely to change in the future.
MenuRegion = Region(2100,1200,1000,1000)
ResultRegion = Region(100,300,700,200)
BondRegion = Region(2000,820,120,120)
QuestrewardRegion = Region(1630,140,370,250)
FriendrequestRegion = Region(660, 120, 140, 160)
StaminaRegion = Region(600,200,300,300)

StoneClick = (Location(1270,340))
AppleClick = (Location(1270,640))

StartQuestClick = Location(2400,1350)
StartQuestWithoutItemClick = Location(1652,1304) -- see docs/start_quest_without_item_click.png
QuestResultNextClick = Location(2200, 1350) -- see docs/quest_result_next_click.png

--[[For future use:
	NpbarRegion = Region(280,1330,1620,50)
	Ultcard1Region = Region(900,100,200,200)
	Ultcard2Region = Region(1350,100,200,200)
	Ultcard3Region = Region(1800,100,200,200)
--]]

--File paths
GeneralImagePath = "image_" .. GameRegion .. "/"

--TBD:Autoskill execution optimization, switch target during Autoskill, Do not let Targetchoose().ultcard() interfere with Autoskill, battle()execution order cleanup.
--TBD:Screenshot function refactoring: https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-428015815

--[[recognize speed realated functions:
	1.setScanInterval(1)
	2.Settings:set("MinSimilarity", 0.5)
	3.Settings:set("AutoWaitTimeout", 1)
	4.usePreviousSnap(true)
	5.resolution 1280
	6.exists(var ,0)
--]]

function menu()
	battle.resetState()
	turnCounter = {0, 0, 0, 0, 0}

	--Click uppermost quest.
	click(Location(1900,400))
	wait(1.5)

	--Auto refill.
	if StaminaRegion:exists(GeneralImagePath .. "stamina.png", 0) then
		RefillStamina()
	end

	--Friend selection.
	local hasSelectedSupport = support.selectSupport(Support_SelectionMode)
	if hasSelectedSupport then
		wait(2.5)
		startQuest()
	end
end

function RefillStamina()
	if Refill_or_Not == 1 and StoneUsed < How_Many then
		if Use_Stone == 1 then
			click(StoneClick)
			toast("Auto Refilling Stamina")
			wait(1.5)
			click(Location(1650,1120))
			StoneUsed = StoneUsed + 1
		else
			click(AppleClick)
			toast("Auto Refilling Stamina")
			wait(1.5)
			click(Location(1650,1120))
			StoneUsed = StoneUsed + 1
		end
		wait(3)
		if NotJPserverForStaminaRefillExtraClick == nil then
			--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089
			click(Location(1900,400))
			wait(1.5)
		end
	else
		scriptExit("AP ran out!")
	end
end

function startQuest()
	click(StartQuestClick)

	if isEvent == 1 then
		wait(2)
		click(StartQuestWithoutItemClick)
	end
end

function result()
	--Bond exp screen.
	wait(2)
	click(QuestResultNextClick)

	--Bond level up screen.
	if BondRegion:exists(GeneralImagePath .. "bond.png") then
		wait(1)
		click(QuestResultNextClick)
	end

	--Master exp screen.
	wait(2)
	click(QuestResultNextClick)

	--Obtained item screen.
	wait(1.5)
	click(QuestResultNextClick)

	--Extra event item screen.
	if isEvent == 1 then
		wait(1.5)
		click(QuestResultNextClick)
	end

	--Friend request screen. Non-friend support was selected this battle.  Ofc it's defaulted not sending request.
	wait(1.5)
	if FriendrequestRegion:exists(GeneralImagePath .. "friendrequest.png") ~= nil then
		click(Location(600,1200))
	end

	wait(15)

	--1st time quest reward screen.
	if QuestrewardRegion:exists(GeneralImagePath .. "questreward.png") ~= nil then
		click(Location(100,100))
	end
end

--User option PSA dialogue. Also choosble list of perdefined skill.
function PSADialogue()
	if PSADialogueShown ~= 0 then
		return
	end
	dialogInit()
	--Auto Refill dialogue content generation.
	if Refill_or_Not == 1 then
		if Use_Stone == 1 then
			RefillType = "stones"
		else
			RefillType = "apples"
		end
		addTextView("Auto Refill Enabled:")
		newRow()
		addTextView("You are going to use")
		newRow()
		addTextView(How_Many .. " " .. RefillType .. ", ")
		newRow()
		addTextView("remember to check those values everytime you execute the script!")
		addSeparator()
	end

	--Autoskill dialogue content generation.
	if Enable_Autoskill == 1 then
		addTextView("AutoSkill Enabled:")
		newRow()
		addTextView("Start the script from memu or Battle 1/3 to make it work properly.")
		addSeparator()
	end

	--Autoskill list dialogue content generation.
	if Enable_Autoskill_List == 1 then
		addTextView("Please select your predefined Autoskill setting:")
		newRow()
		addRadioGroup("AutoskillListIndex", 1)
		addRadioButton(Autoskill_List[1][1] .. ": " .. Autoskill_List[1][2], 1)
		addRadioButton(Autoskill_List[2][1] .. ": " .. Autoskill_List[2][2], 2)
		addRadioButton(Autoskill_List[3][1] .. ": " .. Autoskill_List[3][2], 3)
		addRadioButton(Autoskill_List[4][1] .. ": " .. Autoskill_List[4][2], 4)
		addRadioButton(Autoskill_List[5][1] .. ": " .. Autoskill_List[5][2], 5)
		addRadioButton(Autoskill_List[6][1] .. ": " .. Autoskill_List[6][2], 6)
		addRadioButton(Autoskill_List[7][1] .. ": " .. Autoskill_List[7][2], 7)
		addRadioButton(Autoskill_List[8][1] .. ": " .. Autoskill_List[8][2], 8)
		addRadioButton(Autoskill_List[9][1] .. ": " .. Autoskill_List[9][2], 9)
		addRadioButton(Autoskill_List[10][1] .. ": " .. Autoskill_List[10][2], 10)
	end

	--Show the generated dialogue.
	dialogShow("CAUTION")
	PSADialogueShown = 1

	--Put user selection into list for later exception handling.
	if Enable_Autoskill_List == 1 then
		Skill_Command = Autoskill_List[AutoskillListIndex][2]
	end
end

function init()
	--Set only ONCE for every separated script run.
	PSADialogueShown = 0
	PSADialogue()

	autoskill.init(battle, card)
	battle.init(autoskill, card)
	card.init(autoskill, battle)
	
	setImmersiveMode(true)
	Settings:setCompareDimension(true,1280)
	Settings:setScriptDimension(true,2560)

	StoneUsed = 0
end

init()
while(1) do
	if MenuRegion:exists(GeneralImagePath .. "menu.png", 0) then
		toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
		menu()
	end
	if battle.isIdle() then
		battle.performBattle()
	end
	if ResultRegion:exists(GeneralImagePath .. "result.png", 0) then
		result()
	end
end
