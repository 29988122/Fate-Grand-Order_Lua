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
local ankuluaUtils = require("ankulua-utils")
local scaling = require("scaling")
local game = require("game")
local support = require("support")
local card = require("card")
local battle = require("battle")
local autoskill = require("autoskill")

-- fields
local StoneUsed = 0
local IsContinuing = 0

-- functions

--Refill stamina based on selected option within FGO_XX_REGULAR.lua
local function RefillStamina()
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

--Click begin quest in Formation selection, then select boost item, if applicable, then confirm selection.
local function StartQuest()
	click(game.MENU_START_QUEST_CLICK)

	-- old scripts might not have this option set
	-- don't wanna force everyone to update their configs
	if BoostItem_SelectionMode ~= nil then	
		if game.MENU_BOOST_ITEM_CLICK_ARRAY[BoostItem_SelectionMode] ~= nil then
			wait(2)
			click(game.MENU_BOOST_ITEM_CLICK_ARRAY[BoostItem_SelectionMode])
			click(game.MENU_BOOST_ITEM_SKIP_CLICK) -- in case you run out of items
		else
			scriptExit("Invalid boost item selection mode: \"" + BoostItem_SelectionMode + "\".")
		end
	end

	if StorySkip ~= nil then
		if StorySkip == 1 then
			wait(10)
			if game.MENU_STORY_SKIP_REGION:exists(GeneralImagePath .. "storyskip.png") then
				click(game.MENU_STORY_SKIP_CLICK)
				wait(0.5)
				click(game.MENU_STORY_SKIP_YES_CLICK)
			end
		end
	end
end

--Checking if in menu.png is on screen, indicating you are in the screen to choose your quest
local function IsInMenu()
	return game.MENU_SCREEN_REGION:exists(GeneralImagePath .. "menu.png")
end

--Reset battle state, then click quest and refill stamina if needed.
local function Menu()
	battle.resetState()
	turnCounter = {0, 0, 0, 0, 0}

	--Click uppermost quest.
	click(game.MENU_SELECT_QUEST_CLICK)
	wait(1.5)

	--Auto refill.
	while game.STAMINA_SCREEN_REGION:exists(GeneralImagePath .. "stamina.png") do
		RefillStamina()
	end
end

--Checking if Quest Completed screen is up, specifically if Bond point/reward is up.
local function IsInResult()
	return game.RESULT_SCREEN_REGION:exists(GeneralImagePath .. "result.png") or game.RESULT_BOND_REGION:exists(GeneralImagePath .. "bond.png")
end

--Click through reward screen, continue if option presents itself, otherwise continue clicking through
local function Result()
	--Validator document https://github.com/29988122/Fate-Grand-Order_Lua/wiki/In-Game-Result-Screen-Flow for detail.
	continueClick(game.RESULT_NEXT_CLICK,35)

	--Checking if there was a Bond CE reward
	if game.RESULT_CE_REWARD_REGION:exists(GeneralImagePath .. "ce_reward.png") ~= nil then
		
		if StopAfterBond10 ~= nil then --Making sure they can still run it without updating FGO_XX_REGULAR files
			if StopAfterBond10 == 1 then
				scriptExit("Bond 10 CE GET!")
			end
		end
		
		click(game.RESULT_CE_REWARD_CLOSE_CLICK)
		continueClick(game.RESULT_NEXT_CLICK,35) --Still need to proceed through reward screen.
	end

	wait(5)

	--Friend request dialogue. Appears when non-friend support was selected this battle.  Ofc it's defaulted not sending request.
	if game.RESULT_FRIEND_REQUEST_REGION:exists(GeneralImagePath .. "friendrequest.png") ~= nil then
		click(game.RESULT_FRIEND_REQUEST_REJECT_CLICK)
	end

	wait(1)

	--Only for JP currently. Searches for the Continue option after select Free Quests
	if GameRegion == "JP" and game.CONTINUE_REGION:exists(GeneralImagePath .. "confirm.png") then
		IsContinuing = 1 -- Needed to show we don't need to enter the "StartQuest" function
	
		-- Pressing Continue option after completing a quest, reseting the state as would occur in "Menu" function
		click(game.CONTINUE_CLICK)
		battle.resetState()
		turnCounter = {0, 0, 0, 0, 0}

		wait(1.5)
	
		--If Stamina is empty, follow same protocol as is in "Menu" function
		--Auto refill.
		while game.STAMINA_SCREEN_REGION:exists(GeneralImagePath .. "stamina.png") do
			RefillStamina()
		end
		return
	end

	--Post-battle story is sometimes there.
	if StorySkip ~= nil then
		if StorySkip == 1 then
			if game.MENU_STORY_SKIP_REGION:exists(GeneralImagePath .. "storyskip.png") then
				click(game.MENU_STORY_SKIP_CLICK)
				wait(0.5)
				click(game.MENU_STORY_SKIP_YES_CLICK)
			end
		end
	end

	wait(10)

	--Quest Completion reward. Exits the screen when it is presented.
	if game.RESULT_CE_REWARD_REGION:exists(GeneralImagePath .. "ce_reward.png") ~= nil then
		click(game.RESULT_CE_REWARD_CLOSE_CLICK)
		wait(1)
		click(game.RESULT_CE_REWARD_CLOSE_CLICK)
	end

	wait(5)

	--1st time quest reward screen, eg. Mana Prisms, Event CE, Materials, etc.
	if game.RESULT_QUEST_REWARD_REGION:exists(GeneralImagePath .. "questreward.png") ~= nil then
		click(game.RESULT_NEXT_CLICK)
	end
end

--Checks if Support Selection menu is up
local function IsInSupport()
        return game.SUPPORT_SCREEN_REGION:exists(GeneralImagePath .. "support_screen.png")
end

--Selections Support option, code located in modules/support.lua
local function Support()
	--Friend selection.
	local hasSelectedSupport = support.selectSupport(Support_SelectionMode)
	if hasSelectedSupport == true then
		if IsContinuing == 0 then
			wait(2.5)
			StartQuest()
		elseif IsContinuing == nil then
			wait(2.5)
			StartQuest()
		end
	end
end

--User option PSA dialogue. Also choosble list of perdefined skill.
local function PSADialogue()
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
		addTextView("Start the script from menu or Battle 1/3 to make it work properly.")
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

--[[
	Initialize Aspect Ratio adjustment for different sized screens,ask for input from user for Autoskill plus confirming Apple/Stone usage
	Then initialize the Autoskill, Battle, and Card modules in modules/.
]]--
local function Init()
	--Set only ONCE for every separated script run.
	scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

	PSADialogue()

	autoskill.Init(battle, card)
	battle.init(autoskill, card)
	card.init(autoskill, battle)

	toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
end

--[[
	SCREENS represents list of Validators and Actors
	When Validator returns true/1, perform the Actor
	Code for battle.performBattle can be found in modules/battle.lua
	Code for Menu is on line 89 of this Script
	Code for Result is on line 109 of this Script
	Code for Support is on line 174 of this Script
]]--
local SCREENS = {
	{ Validator = battle.isIdle, Actor = battle.performBattle },
	{ Validator = IsInMenu,      Actor = Menu },
	{ Validator = IsInResult,    Actor = Result},
    { Validator = IsInSupport,   Actor = Support}
}

Init()

--Loop through SCREENS until a Validator returns true/1
while(true) do
	local actor = ankuluaUtils.UseSameSnapIn(function()
		for _, screen in pairs(SCREENS) do
			if screen.Validator() then
				return screen.Actor
			end
		end
	end)

	if actor ~= nil then
		actor()
	end

	wait(1)
end
