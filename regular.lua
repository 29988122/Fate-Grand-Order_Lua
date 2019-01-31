--[[このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
	私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
	お願いします。このプログラムを禁止しないでください。
--]]
package.path = package.path .. ";" .. dir .. 'modules/?.lua'

-- consts
GeneralImagePath = "image_" .. GameRegion .. "/"
local IMAGE_WIDTH = 1280
local IMAGE_HEIGHT = 720
local SCRIPT_WIDTH = 2560
local SCRIPT_HEIGHT = 1440

-- imports
local scaling = require("scaling")
local game = require("game")
local support = require("support")
local card = require("card")
local battle = require("battle")
local autoskill = require("autoskill")

-- functions
function menu()
	battle.resetState()
	turnCounter = {0, 0, 0, 0, 0}

	--Click uppermost quest.
	click(game.MENU_SELECT_QUEST_CLICK)
	wait(1.5)

	--Auto refill.
	while game.STAMINA_SCREEN_REGION:exists(GeneralImagePath .. "stamina.png", 0) do
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
			click(game.STAMINA_SQ_CLICK)
			wait(1)
			click(game.STAMINA_OK_CLICK)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "All Apples" then
			click(game.STAMINA_BRONZE_CLICK)
			click(game.STAMINA_SILVER_CLICK)
			click(game.STAMINA_GOLD_CLICK)
			wait(1)
			click(game.STAMINA_OK_CLICK)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Gold" then
			click(game.STAMINA_GOLD_CLICK)
			wait(1)
			click(game.STAMINA_OK_CLICK)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Silver" then
			click(game.STAMINA_SILVER_CLICK)
			wait(1)
			click(game.STAMINA_OK_CLICK)
			StoneUsed = StoneUsed + 1
		elseif Refill_Resource == "Bronze" then
			click(game.STAMINA_BRONZE_CLICK)
			wait(1)
			click(game.STAMINA_OK_CLICK)
			StoneUsed = StoneUsed + 1
		end
		wait(3)
	else
		scriptExit("AP ran out!")
	end
end

function startQuest()
	click(game.MENU_START_QUEST_CLICK)

	if isEvent == 1 then
		wait(2)
		click(game.MENU_START_QUEST_WITHOUT_ITEM_CLICK)
	end
end

function result()
	--Check document https://github.com/29988122/Fate-Grand-Order_Lua/wiki/In-Game-Result-Screen-Flow for detail.
	continueClick(game.RESULT_NEXT_CLICK,45)
	wait(10)

	if game.RESULT_CE_REWARD_REGION:exists(Pattern(GeneralImagePath .. "ce_reward.png")) ~= nil then
		click(game.RESULT_CE_REWARD_CLOSE_CLICK)
		continueClick(game.RESULT_NEXT_CLICK,35) --Still need to proceed through reward screen.
	end

	--Friend request dialogue. Appears when non-friend support was selected this battle.  Ofc it's defaulted not sending request.
	if game.RESULT_FRIEND_REQUEST_REGION:exists(Pattern(GeneralImagePath .. "friendrequest.png")) ~= nil then
		click(game.RESULT_FRIEND_REQUEST_REJECT_CLICK)
	end

	wait(15)

	--1st time quest reward screen.
	if game.RESULT_QUEST_REWARD_REGION:exists(Pattern(GeneralImagePath .. "questreward.png")) ~= nil then
		click(game.RESULT_NEXT_CLICK)
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
	Settings:setCompareDimension(true, IMAGE_WIDTH)
	Settings:setScriptDimension(true, SCRIPT_WIDTH)
	scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT)
	
	StoneUsed = 0
	PSADialogue()

	autoskill.Init(battle, card)
	battle.init(autoskill, card)
	card.init(autoskill, battle)

	toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
end

init()
while(1) do
	if game.MENU_SCREEN_REGION:exists(GeneralImagePath .. "menu.png", 0) then
		menu()
	end
	if battle.isIdle() then
		battle.performBattle()
	end
	if game.RESULT_SCREEN_REGION:exists(Pattern(GeneralImagePath .. "result.png"), 0) or game.RESULT_BOND_REGION:exists(Pattern(GeneralImagePath .. "bond.png"), 0) then
		result()
	end
end