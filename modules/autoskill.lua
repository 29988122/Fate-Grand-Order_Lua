-- modules
local _battle
local _card

-- consts
local SKILL_OK_CLICK = Location(1680,850)
local MASTER_SKILL_OPEN_CLICK = Location(2380,640)
local ORDER_CHANGE_OK_CLICK = Location(1280,1260)

local SKILL_1_CLICK = Location( 140,1160)
local SKILL_2_CLICK = Location( 340,1160)
local SKILL_3_CLICK = Location( 540,1160)
local SKILL_4_CLICK = Location( 770,1160)
local SKILL_5_CLICK = Location( 970,1160)
local SKILL_6_CLICK = Location(1140,1160)
local SKILL_7_CLICK = Location(1400,1160)
local SKILL_8_CLICK = Location(1600,1160)
local SKILL_9_CLICK = Location(1800,1160)

local MASTER_SKILL_1_CLICK = Location(1820,620)
local MASTER_SKILL_2_CLICK = Location(2000,620)
local MASTER_SKILL_3_CLICK = Location(2160,620)

local SERVANT_1_CLICK = Location(700,880)
local SERVANT_2_CLICK = Location(1280,880)
local SERVANT_3_CLICK = Location(1940,880)

local SKILL_CLICK_ARRAY = {
	[  1] = SKILL_1_CLICK,
	[  2] = SKILL_2_CLICK,
	[  3] = SKILL_3_CLICK,
	[  4] = SKILL_4_CLICK,
	[  5] = SKILL_5_CLICK,
	[  6] = SKILL_6_CLICK,
	[  7] = SKILL_7_CLICK,
	[  8] = SKILL_8_CLICK,
	[  9] = SKILL_9_CLICK,
	[ 10] = MASTER_SKILL_1_CLICK,
	[ 11] = MASTER_SKILL_2_CLICK,
	[ 12] = MASTER_SKILL_3_CLICK,
	[-47] = SERVANT_1_CLICK,
	[-46] = SERVANT_2_CLICK,
	[-45] = SERVANT_3_CLICK
}

-- Order Change (front)
local STARTING_MEMBER_1_CLICK = Location( 280,700)
local STARTING_MEMBER_2_CLICK = Location( 680,700)
local STARTING_MEMBER_3_CLICK = Location(1080,700)
local STARTING_MEMBER_CLICK_ARRAY = {
	[-47] = STARTING_MEMBER_1_CLICK,
	[-46] = STARTING_MEMBER_2_CLICK,
	[-45] = STARTING_MEMBER_3_CLICK
}

-- Order Change (back)
local SUB_MEMBER_1_CLICK = Location(1480,700)
local SUB_MEMBER_2_CLICK = Location(1880,700)
local SUB_MEMBER_3_CLICK = Location(2280,700)
local SUB_MEMBER_CLICK_ARRAY = {
	[-47] = SUB_MEMBER_1_CLICK,
	[-46] = SUB_MEMBER_2_CLICK,
	[-45] = SUB_MEMBER_3_CLICK
}

--  state vars
local _hasFinishedCastingNp
local _isOrderChanging = 0
local _stageCountByUserInput = 1
local _commandsForEachStageArray = {{}, {}, {}, {}, {}}
local _totalNeededTurnArray = {0, 0, 0, 0, 0}
local _turnCounterForEachStageArray
local _castingNP = false

-- functions
local init
local initDependencies
local initCommands
local resetState
local executeSkill
local decodeSkill
local hasFinishedCastingNp

init = function(battle, card)
	initDependencies(battle, card)

	if Enable_Autoskill == 1 then
		initCommands()
	end

	resetState()
end

initDependencies = function(battle, card) 
	_battle = battle
	_card = card

	SKILL_CLICK_ARRAY[-44] = _card.getNpCardLocation(1)
	SKILL_CLICK_ARRAY[-43] = _card.getNpCardLocation(2)
	SKILL_CLICK_ARRAY[-42] = _card.getNpCardLocation(3)
end

initCommands = function()
	for char in string.gmatch(Skill_Command, "[^,]+") do
		if string.match(char, "[^0]") ~= nil then
			if string.match(char, "^[1-3]") ~= nil then
				scriptExit("Error at '" .. char .. "': Skill Command cannot start with number '1', '2' and '3'!")
			elseif string.match(char, "[%w+][#]") ~= nil or string.match(char, "[#][%w+]") ~= nil then
				scriptExit("Error at '" .. char .. "': '#' must be preceded and followed by ','! Correct: ',#,' ")
			elseif string.match(char, "[^a-l^1-6^#^x]") ~= nil then
				scriptExit("Error at '" .. char .. "': Skill Command exceeded alphanumeric range! Expected 'x' or range 'a' to 'l' for alphabets and '0' to '6' for numbers.")
			end
		end

		if char == '#' then
			_stageCountByUserInput = _stageCountByUserInput + 1

			if _stageCountByUserInput > 5 then
				scriptExit("Error: Detected commands for more than 5 stages")
			end
		end

		-- Autoskill table popup.
		if char ~= '#' then
			table.insert(_commandsForEachStageArray[_stageCountByUserInput], char)
			_totalNeededTurnArray[_stageCountByUserInput] = _totalNeededTurnArray[_stageCountByUserInput] + 1
		end
	end
end

resetState = function()
	_hasFinishedCastingNp = Enable_Autoskill == 0
	_turnCounterForEachStageArray = {0, 0, 0, 0, 0}
end

executeSkill = function ()
	local currentStage = _battle.getCurrentStage()
	_turnCounterForEachStageArray[currentStage] = _turnCounterForEachStageArray[currentStage] + 1
	local currentTurn = _turnCounterForEachStageArray[currentStage]

	if currentTurn	<= _totalNeededTurnArray[currentStage] then
		-- _commandsForEachStageArray is a two-dimensional array with something like abc1jkl4.
		local currentSkill = _commandsForEachStageArray[currentStage][currentTurn]

		if currentSkill ~= '0' and currentSkill ~= '#' then
			for command in string.gmatch(currentSkill, ".") do
				-- Check that skills can be clicked
				while not _battle.hasClickedAttack() and not BATTLE_REGION:exists(GeneralImagePath .. "battle.png" ) do end
				
				-- With the use of screen recognition, I do not believe it is necessary to use isFirstSkill anymore /TryBane
				decodeSkill(command)
				
				wait(.2)
			end
		end
		
		if not _battle.hasClickedAttack() then
			-- Wait for regular servant skill animation executed last time. Then proceed to next turn.
			wait(2.7)
		end
	end

	-- this will allow NP spam AFTER all of the autoskill commands finish
	if currentStage >= _stageCountByUserInput and _commandsForEachStageArray[currentStage][currentTurn] == nil then
		_hasFinishedCastingNp = true
	end
end

decodeSkill = function(str)
	-- NOTE: We can compare strings instead of converting to ascii numbers. Do this by str > "0" as an example.
	-- I believe this is a bit more intuitive than commenting explanations of ascii values
	-- Out comments can consist only of "Casting NPs" or "Casting Master Skill"
	
	-- magic number - check ascii code, a == 97. http://www.asciitable.com/
	local index = string.byte(str) - 96

	--[[isFirstSkill == 0: Not yet proceeded to next turn.
		index >= -44 and _isOrderChanging == 0: Not currently doing Order Change.

		Therefore, script is casting regular servant skills.
	--]]
	
	--[[In ascii, char(4, 5, 6) command for servant NP456 = decimal(52, 53, 54) respectively.
		Hence:
		52 - 96 = -44
		53 - 96 = -43
		54 - 96 = -42
	--]]
	if index >= -44 and index <= -42 and not _battle.hasClickedAttack() then
		_battle.clickAttack()
	end

	--[[In ascii, char(j, k, l) and char(x) command for master skill = decimal(106, 107, 108) and decimal(120) respectively.
		Hence:
		106 - 96 = 10
		107 - 96 = 11
		108 - 96 = 12
		120 - 96 = 24
	--]]
	if index >= 10 then
		-- Click master skill menu icon, ready to cast master skill.
		click(MASTER_SKILL_OPEN_CLICK)
		wait(0.3)
	end

	--[[Enter Order Change Mode.
		In ascii, char(x) = decimal(120)
		120 - 96 = 24
	--]]
	if index == 24 then
		_isOrderChanging = 1
	end

	-- MysticCode-OrderChange master skill implementation.
	-- Actual clicking is done by the default case here.
	if _isOrderChanging == 1 then
		-- click Order Change icon.
		click(SKILL_CLICK_ARRAY[12])
		_isOrderChanging = 2
	elseif _isOrderChanging == 2 then
		click(STARTING_MEMBER_CLICK_ARRAY[index])
		_isOrderChanging = 3
	elseif _isOrderChanging == 3 then
		click(SUB_MEMBER_CLICK_ARRAY[index])
		wait(0.3)
		click(ORDER_CHANGE_OK_CLICK)
		_isOrderChanging = 0
	else
		-- cast skills, NPs, or select target.
		click(SKILL_CLICK_ARRAY[index])
	end

	if index > 0 and Skill_Confirmation == 1 then
		click(SKILL_OK_CLICK)
	end
end

local hasFinishedCastingNp = function()
	return _hasFinishedCastingNp
end

-- "public" interface
return {
	init = init,
	resetState = resetState,
	executeSkill = executeSkill,
	hasFinishedCastingNp = hasFinishedCastingNp
}
