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
MenuRegion = Region(2100 + xOffset,1200 + yOffset,1000,1000)
ResultRegion = Region(100 + xOffset,300 + yOffset,700,200)
BondRegion = Region(2000 + xOffset,820 + yOffset,120,120)
QuestrewardRegion = Region(1630 + xOffset,140 + yOffset,370,250)
FriendrequestRegion = Region(660 + xOffset, 120 + yOffset, 140, 160)
StaminaRegion = Region(600 + xOffset,200 + yOffset,300,300)

AcceptClick = (Location(1650 + xOffset,1120 + yOffset))

StoneClick = (Location(1270 + xOffset,345 + yOffset))
GoldClick = (Location(1270 + xOffset,634 + yOffset))
SilverClick = (Location(1270 + xOffset,922 + yOffset))
BronzeClick = (Location(1270 + xOffset,2048 + yOffset))

StartQuestClick = Location(2400 + xOffset,1350 + yOffset)
StartQuestWithoutItemClick = Location(1652 + xOffset,1304 + yOffset) -- see docs/start_quest_without_item_click.png
QuestResultNextClick = Location(2200 + xOffset, 1350 + yOffset) -- see docs/quest_result_next_click.png

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
	click(Location(1900 + xOffset,400 + yOffset))
	wait(1.5)

	--Auto refill.
	while StaminaRegion:exists(GeneralImagePath .. "stamina.png", 0) do
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
	if Refill_Enabled == 1 and StoneUsed < Refill_Repetitions then
		if Refill_Resource == "SQ" then
			click(StoneClick)
			wait(1)
			click(AcceptClick)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "All Apples" then
			click(BronzeClick)
			click(SilverClick)
			click(GoldClick)
			wait(1)
			click(AcceptClick)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Gold" then
			click(GoldClick)
			wait(1)
			click(AcceptClick)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Silver" then
			click(SilverClick)
			wait(1)
			click(AcceptClick)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Bronze" then
			click(BronzeClick)
			wait(1)
			click(AcceptClick)
			StoneUsed = StoneUsed + 1
		end
		wait(3)
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
	
	-- Click through all of the Result screen items. Does NOT account for Max Bond CE acquisition (yet)
	continueClick(QuestResultNextClick,35)

	wait(5)

	--Friend request screen. Non-friend support was selected this battle.  Ofc it's defaulted not sending request.
	if FriendrequestRegion:exists(Pattern(GeneralImagePath .. "friendrequest.png")) ~= nil then
		click(Location(600 + xOffset,1200 + yOffset))
	end

	wait(15)

	--1st time quest reward screen.
	if QuestrewardRegion:exists(Pattern(GeneralImagePath .. "questreward.png")) ~= nil then
		click(Location(100 + xOffset,100 + yOffset))
	end
end

--User option PSA dialogue. Also choosble list of perdefined skill.
function PSADialogue()
	dialogInit()
	--Auto Refill dialogue content generation.
	if Refill_Enabled == 1 then
		if Refill_Resource == "SQ" then
			RefillType = "sq"
		elseif Refill_Resource == "All Apples" then
			RefillType = "all apples"
		elseif Refill_Resource == "Gold" then
			RefillType = "gold apples"
		elseif Refill_Resource == "Silver" then
			RefillType = "silver apples"
		else
			RefillType = "bronze apples"
		end
		addTextView("Auto Refill Enabled:")
		newRow()
		addTextView("You are going to use")
		newRow()
		addTextView(Refill_Repetitions .. " " .. RefillType .. ", ")
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
	
	--Put user selection into list for later exception handling.
	if Enable_Autoskill_List == 1 then
		Skill_Command = Autoskill_List[AutoskillListIndex][2]
	end
end

function init()
	--Set only ONCE for every separated script run.
	toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
		
	StoneUsed = 0
	PSADialogue()

	autoskill.init(battle, card)
	battle.init(autoskill, card)
	card.init(autoskill, battle)
	
end

init()
while(1) do
	if MenuRegion:exists(GeneralImagePath .. "menu.png", 0) then
		menu()
	end
	if battle.isIdle() then
		battle.performBattle()
	end
	if DebugMode then
		ResultRegion:highlight(2)
		BondRegion:highlight(2)
	end
	if ResultRegion:exists(Pattern(GeneralImagePath .. "result.png"), 0) or BondRegion:exists(Pattern(GeneralImagePath .. "bond.png"), 0) then
		result()
	end
end
