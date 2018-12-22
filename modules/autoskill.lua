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
	["a"] = SKILL_1_CLICK,
	["b"] = SKILL_2_CLICK,
	["c"] = SKILL_3_CLICK,
	["d"] = SKILL_4_CLICK,
	["e"] = SKILL_5_CLICK,
	["f"] = SKILL_6_CLICK,
	["g"] = SKILL_7_CLICK,
	["h"] = SKILL_8_CLICK,
	["i"] = SKILL_9_CLICK,
	["j"] = MASTER_SKILL_1_CLICK,
	["k"] = MASTER_SKILL_2_CLICK,
	["l"] = MASTER_SKILL_3_CLICK,
	["1"] = SERVANT_1_CLICK,
	["2"] = SERVANT_2_CLICK,
	["3"] = SERVANT_3_CLICK
}

-- Order Change (front)
local STARTING_MEMBER_1_CLICK = Location( 280,700)
local STARTING_MEMBER_2_CLICK = Location( 680,700)
local STARTING_MEMBER_3_CLICK = Location(1080,700)
local STARTING_MEMBER_CLICK_ARRAY = {
	["1"] = STARTING_MEMBER_1_CLICK,
	["2"] = STARTING_MEMBER_2_CLICK,
	["3"] = STARTING_MEMBER_3_CLICK
}

-- Order Change (back)
local SUB_MEMBER_1_CLICK = Location(1480,700)
local SUB_MEMBER_2_CLICK = Location(1880,700)
local SUB_MEMBER_3_CLICK = Location(2280,700)
local SUB_MEMBER_CLICK_ARRAY = {
	["1"] = SUB_MEMBER_1_CLICK,
	["2"] = SUB_MEMBER_2_CLICK,
	["3"] = SUB_MEMBER_3_CLICK
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

	SKILL_CLICK_ARRAY["4"] = _card.getNpCardLocation(1)
	SKILL_CLICK_ARRAY["5"] = _card.getNpCardLocation(2)
	SKILL_CLICK_ARRAY["6"] = _card.getNpCardLocation(3)
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
				while not _battle.hasClickedAttack() and not _battle.isIdle() do end
				
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
	
	-- Enter Card selection for NP casting
	if str >= "4" and str <= "6" and not _battle.hasClickedAttack() then
		_battle.clickAttack()
	end
	
	-- Master Skill selected, opening Master Skill sub-menu
	if str >= "j" then
		-- Click master skill menu icon, ready to cast master skill.
		click(MASTER_SKILL_OPEN_CLICK)
		wait(0.3)
	end

	-- Order change selected, enter order change mode
	if index == "x" then
		_isOrderChanging = 1
	end

	-- MysticCode-OrderChange master skill implementation.
	-- Actual clicking is done by the default case here.
	if _isOrderChanging == 1 then
		-- click Order Change icon.
		click(SKILL_CLICK_ARRAY[12])
		_isOrderChanging = 2
	elseif _isOrderChanging == 2 then
		click(STARTING_MEMBER_CLICK_ARRAY[str])
		_isOrderChanging = 3
	elseif _isOrderChanging == 3 then
		click(SUB_MEMBER_CLICK_ARRAY[str])
		wait(0.3)
		click(ORDER_CHANGE_OK_CLICK)
		_isOrderChanging = 0
	else
		-- cast skills, NPs, or select target.
		click(SKILL_CLICK_ARRAY[str])
	end

	-- Complete Skill Confirmation sub-menu
	if str >= "a" and Skill_Confirmation == 1 then
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
