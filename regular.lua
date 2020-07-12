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
local MatchClick = nil

-- functions

--Refill stamina based on selected option within FGO_REGULAR.lua
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

local function NeedsToWithdraw()
	MatchClick = game.WITHDRAW_REGION:exists(GeneralImagePath .. "withdraw.png")	-- MatchClick used to click on the found image
	return MatchClick
end

local function Withdraw()
	if Withdraw_Enabled then
		click(MatchClick)
		MatchClick = nil		-- Return MatchClick to default state, to avoid any false positive clicking
		wait(.5)
		click(game.WITHDRAW_ACCEPT_CLICK)	-- Click the "Accept" button after choosing to withdraw
		wait(1)
		click(game.STAMINA_BRONZE_CLICK)	-- Click the "Close" button after accepting the withdrawal
	else
		scriptExit("All servants have been defeated and auto-withdrawing is disabled.")
	end
end

--[[
	Starts the quest after the support has already been selected. The following features are done optionally:
	1. The configured party is selected if Party_Number is set
	2. A boost item is selected if BoostItem_SelectionMode is set (needed in some events)
	3. The story is skipped if StorySkip is activated
]]
local function StartQuest()
	if Party_Number ~= nil then
		if game.PARTY_SELECTION_ARRAY[Party_Number] ~= nil then
			--Start Quest Button becomes unresponsive if the same party is clicked. So we switch to one party and then to the user-specified one.
			if Party_Number == 1 then
				click(game.PARTY_SELECTION_ARRAY[2])
			else
				click(game.PARTY_SELECTION_ARRAY[1])
			end
			wait(1)
			click(game.PARTY_SELECTION_ARRAY[Party_Number])
			wait(1.2)
		else
			scriptExit("Invalid party number selected: \"" .. Party_Number .. "\".")
		end
	end
	
	click(game.MENU_START_QUEST_CLICK)

	if game.MENU_BOOST_ITEM_CLICK_ARRAY[BoostItem_SelectionMode] ~= nil then
		wait(2)
		click(game.MENU_BOOST_ITEM_CLICK_ARRAY[BoostItem_SelectionMode])
		click(game.MENU_BOOST_ITEM_SKIP_CLICK) -- in case you run out of items
	else
		scriptExit("Invalid boost item selection mode: \"" + BoostItem_SelectionMode + "\".")
	end
	
	if StorySkip == 1 then
		wait(10)
		if game.MENU_STORY_SKIP_REGION:exists(GeneralImagePath .. "storyskip.png") then
			click(game.MENU_STORY_SKIP_CLICK)
			wait(0.5)
			click(game.MENU_STORY_SKIP_YES_CLICK)
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
	
	if Refill_Repetitions > 0 then
		-- Prints a message containing the amount of apple used
		toast(StoneUsed .. " refills used out of " .. Refill_Repetitions)
	end

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
	continueClick(game.RESULT_NEXT_CLICK,55)

	--Checking if there was a Bond CE reward
	if game.RESULT_CE_REWARD_REGION:exists(GeneralImagePath .. "ce_reward.png") ~= nil then
		
		if StopAfterBond10 == 1 then
			scriptExit("Bond 10 CE GET!")
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
	if (GameRegion == "JP" or GameRegion == "EN") and game.CONTINUE_REGION:exists(GeneralImagePath .. "confirm.png") then
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
	if StorySkip == 1 then
		if game.MENU_STORY_SKIP_REGION:exists(GeneralImagePath .. "storyskip.png") then
			click(game.MENU_STORY_SKIP_CLICK)
			wait(0.5)
			click(game.MENU_STORY_SKIP_YES_CLICK)
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
		wait(1)
		click(game.RESULT_NEXT_CLICK)
	end
end

--Checks if Support Selection menu is up
local function IsInSupport()
	return game.SUPPORT_SCREEN_REGION:exists(Pattern(GeneralImagePath .. "support_screen.png"):similar(.85))
end

--Selections Support option, code located in modules/support.lua
local function Support()
	--Friend selection.
	local hasSelectedSupport = support.selectSupport(Support_SelectionMode)
	if hasSelectedSupport == true then
		if IsContinuing == 0 then
			wait(2.5)
			StartQuest()
		end
	end
end

--[[
	Initialize Aspect Ratio adjustment for different sized screens,ask for input from user for Autoskill plus confirming Apple/Stone usage
	Then initialize the Autoskill, Battle, and Card modules in modules/.
]]--
local function Init()
	--Set only ONCE for every separated script run.
	scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

	autoskill.Init(battle, card)
	battle.init(autoskill, card)
	card.init(autoskill, battle)
end

--[[
	SCREENS represents list of Validators and Actors
	When Validator returns true/1, perform the Actor
	Code for Retry can be found on line 66 of this Script
	Code for battle.performBattle can be found in modules/battle.lua
	Code for Menu is on line 108 of this Script
	Code for Result is on line 128 of this Script
	Code for Support is on line 208 of this Script
]]--
local SCREENS = {
	{ Validator = game.NeedsToRetry,  Actor = game.Retry },
	{ Validator = battle.isIdle, Actor = battle.performBattle },
	{ Validator = IsInMenu,      Actor = Menu },
	{ Validator = IsInResult,    Actor = Result },
	{ Validator = IsInSupport,   Actor = Support },
	{ Validator = NeedsToWithdraw, Actor = Withdraw}
}

Init()
while(Debug_Mode) do
	game.MENU_SCREEN_REGION:highlight(5)
	game.SUPPORT_SCREEN_REGION:highlight(5)
	game.BATTLE_SCREEN_REGION:highlight(5)
	game.RESULT_SCREEN_REGION:highlight(5)
end
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
