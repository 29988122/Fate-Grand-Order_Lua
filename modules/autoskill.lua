-- modules
local module_battleLogic = require "battleLogic"

--Autoskill click regions.
local _SKILL_1_CLICK = (Location(140,1160))
local _SKILL_2_CLICK = (Location(340,1160))
local _SKILL_3_CLICK = (Location(540,1160))

local _SKILL_4_CLICK = (Location(770,1160))
local _SKILL_5_CLICK = (Location(970,1160))
local _SKILL_6_CLICK = (Location(1140,1160))

local _SKILL_7_CLICK = (Location(1400,1160))
local _SKILL_8_CLICK = (Location(1600,1160))
local _SKILL_9_CLICK = (Location(1800,1160))

local _MASTER_SKILL_1_CLICK = (Location(1820,620))
local _MASTER_SKILL_2_CLICK = (Location(2000,620))
local _MASTER_SKILL_3_CLICK = (Location(2160,620))

local _SERVANT_1_CLICK = (Location(700,880))
local _SERVANT_2_CLICK = (Location(1280,880))
local _SERVANT_3_CLICK = (Location(1940,880))

--Autoskill related variables, check function DecodeSkill(str, isFirstSkill).
local _SKILL_CLICK_ARRAY = {_SKILL_1_CLICK, _SKILL_2_CLICK, _SKILL_3_CLICK, _SKILL_4_CLICK, _SKILL_5_CLICK, _SKILL_6_CLICK, _SKILL_7_CLICK, _SKILL_8_CLICK, _SKILL_9_CLICK, _MASTER_SKILL_1_CLICK, _MASTER_SKILL_2_CLICK, _MASTER_SKILL_3_CLICK}
--Servant and NP card selection
_SKILL_CLICK_ARRAY[-47] = _SERVANT_1_CLICK
_SKILL_CLICK_ARRAY[-46] = _SERVANT_2_CLICK
_SKILL_CLICK_ARRAY[-45] = _SERVANT_3_CLICK
_SKILL_CLICK_ARRAY[-44] = module_battleLogic.getUltcard(1)
_SKILL_CLICK_ARRAY[-43] = module_battleLogic.getUltcard(2)
_SKILL_CLICK_ARRAY[-42] = module_battleLogic.getUltcard(3)

--Skill array holding skills for every stage
local _STAGE_SKILL_ARRAY = {}
_STAGE_SKILL_ARRAY[1] = {}
_STAGE_SKILL_ARRAY[2] = {}
_STAGE_SKILL_ARRAY[3] = {}
_STAGE_SKILL_ARRAY[4] = {}
_STAGE_SKILL_ARRAY[5] = {}

--Order Change main servant locations
local _STARTING_MEMBER_1_CLICK = (Location(280,700))
local _STARTING_MEMBER_2_CLICK = (Location(680,700))
local _STARTING_MEMBER_3_CLICK = (Location(1080,700))
local _STARTING_MEMBER_CLICK_ARRAY = {}
_STARTING_MEMBER_CLICK_ARRAY[-47] = _STARTING_MEMBER_1_CLICK
_STARTING_MEMBER_CLICK_ARRAY[-46] = _STARTING_MEMBER_2_CLICK
_STARTING_MEMBER_CLICK_ARRAY[-45] = _STARTING_MEMBER_3_CLICK

--Order Change sub servant locations
local _SUB_MEMBER_1_CLICK = (Location(1480,700))
local _SUB_MEMBER_2_CLICK = (Location(1880,700))
local _SUB_MEMBER_3_CLICK = (Location(2280,700))
local _SUB_MEMBER_CLICK_ARRAY = {}
_SUB_MEMBER_CLICK_ARRAY[-47] = _SUB_MEMBER_1_CLICK
_SUB_MEMBER_CLICK_ARRAY[-46] = _SUB_MEMBER_2_CLICK
_SUB_MEMBER_CLICK_ARRAY[-45] = _SUB_MEMBER_3_CLICK

--Autoskill and Autoskill exception handling related, waiting for cleanup.
local _isCastingNpFromAutoskill = 0
local _stageCountByUserInput = 1
local _totalNeededTurnArray = {0, 0, 0, 0, 0}
local _turnCounterForEveryStageArray = {0, 0, 0, 0, 0}
local _mysticCodeOrderChangeStatus = 0
local _snapshotGeneratedForStageCounter = 0
local _stageCounter = 1

-- functions
local Init
local ResetForNextQuest
local GetIsNPCasting
local GenerateStageCounterSnapshot
local InitForUpdateStageCounter
local UpdateStageCounter
local ExecuteSkill
local DecodeSkill

Init = function()
--Autoskill exception handling.
	if Enable_Autoskill == 1 then
		for temp_char in string.gmatch(Skill_Command, "[^,]+") do
			if string.match(temp_char, "[^0]") ~= nil then
				if string.match(temp_char, "^[1-3]") ~= nil then
					scriptExit("Error at '" ..temp_char.. "': Skill Command cannot start with number '1', '2' and '3'!")
				elseif string.match(temp_char, "[%w+][#]") ~= nil or string.match(temp_char, "[#][%w+]") ~= nil then
					scriptExit("Error at '" ..temp_char.. "': '#' must be preceded and followed by ','! Correct: ',#,' ")
				elseif string.match(temp_char, "[^a-l^1-6^#^x]") ~= nil then
					scriptExit("Error at '" ..temp_char.. "': Skill Command exceeded alphanumeric range! Expected 'x' or range 'a' to 'l' for alphabets and '0' to '6' for numbers.")
				end
			end
			if temp_char == '#' then
				_stageCountByUserInput = _stageCountByUserInput + 1
				if _stageCountByUserInput > 5 then
					scriptExit("Error: Detected commands for more than 5 stages")
				end
			end
			--Autoskill table popup.
			if temp_char ~= '#' then
				table.insert(_STAGE_SKILL_ARRAY[_stageCountByUserInput], temp_char)
				_totalNeededTurnArray[_stageCountByUserInput] = _totalNeededTurnArray[_stageCountByUserInput] + 1
			end
		end
	end
end

ResetForNextQuest = function()
	module_battleLogic.ResetCleartoSpamNP()
	module_battleLogic.ResetTargetChoosen()
	_isCastingNpFromAutoskill = 0
	_turnCounterForEveryStageArray = {0, 0, 0, 0, 0}
	_snapshotGeneratedForStageCounter = 0
end

GetIsNPCasting = function()
	return _isCastingNpFromAutoskill
end

GenerateStageCounterSnapshot = function()
	toast("Taking snapshot for stage recognition")
	StageCountRegion:save(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png")
end

InitForUpdateStageCounter = function()
	--Generate a snapshot ONCE in the beginning of battle(). Will re-run itself after entered memu().
	if _snapshotGeneratedForStageCounter ~= 1 then
		GenerateStageCounterSnapshot()
		_snapshotGeneratedForStageCounter = 1
		_stageCounter = 1
	end
end

UpdateStageCounter = function(temp_region)
	--Alternative fix for different font of stagecount number among different regions, worked pretty damn well tho.
	--This will compare last screenshot with current screen, effectively get to know if stage changed or not.
	InitForUpdateStageCounter()
	
	local temp_stageCounterSnapshot = temp_region:exists(Pattern(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png"):similar(0.8))

	--Pattern found, stage did not change.
	if temp_stageCounterSnapshot ~= nil then
		toast("Battle ".._stageCounter.."/3")
		return
	end

	--Pattern not found, which means that stage changed. Generate another snapshot te be used next time.
	if temp_stageCounterSnapshot == nil then
		GenerateStageCounterSnapshot()
		_stageCounter = _stageCounter + 1
		module_battleLogic.ResetCleartoSpamNP()
		module_battleLogic.ResetTargetChoosen()
		toast("Battle ".._stageCounter.."/3")
		return
	end
end

ExecuteSkill = function ()
	_isCastingNpFromAutoskill = 0
	
	local temp_currentStage = _stageCounter
	_turnCounterForEveryStageArray[temp_currentStage] = _turnCounterForEveryStageArray[temp_currentStage] + 1
	local temp_currentTurn = _turnCounterForEveryStageArray[temp_currentStage]

	if temp_currentTurn	<= _totalNeededTurnArray[temp_currentStage] then
		--_STAGE_SKILL_ARRAY is a two-dimensional array with something like abc1jkl4.
		local temp_currentSkill = _STAGE_SKILL_ARRAY[temp_currentStage][temp_currentTurn]

		--[[Prevent exessive delay between skill clickings.
			temp_isFirstSkill = 1 means more delay, cause one has to wait for battle animation.
			temp_isFirstSkill = 0 means less delay.
		--]]
		local temp_isFirstSkill = 1
		if temp_currentSkill ~= '0' and temp_currentSkill ~= '#' then
			for temp_command in string.gmatch(temp_currentSkill, ".") do
				DecodeSkill(temp_command, temp_isFirstSkill)
				temp_isFirstSkill = 0
			end
		end
		if _isCastingNpFromAutoskill == 0 then
			--Wait for regular servant skill animation executed last time. Then proceed to next turn.
			wait(2.7)
		end
	end

	--NP spam AFTER all of the autoskill commands finished.
	if temp_currentStage >= _stageCountByUserInput and _STAGE_SKILL_ARRAY[_stageCounter][temp_currentTurn] == nil then
		module_battleLogic.setCleartoSpamNP()
	end
end

DecodeSkill = function(temp_str, temp_isFirstSkill)
	--magic number - check ascii code, a == 97. http://www.asciitable.com/
	local temp_index = string.byte(temp_str) - 96

	--[[temp_isFirstSkill == 0: Not yet proceeded to next turn.
		_isCastingNpFromAutoskill == 0: Not currently casting NP(not in card selection screen).
		temp_index >= -44 and _mysticCodeOrderChangeStatus == 0: Not currently doing Order Change.

		Therefore, script is casting regular servant skills.
	--]]
	if temp_isFirstSkill == 0 and _isCastingNpFromAutoskill == 0 and temp_index >= -44 and _mysticCodeOrderChangeStatus == 0 then
		--Wait for regular servant skill animation executed last time.
		--Do not make it shorter, at least 2.9s. Napoleon's skill animation is ridiculously long.
		wait(3.3)
	end

	--[[In ascii, char(4, 5, 6) command for servant NP456 = decimal(52, 53, 54) respectively.
		Hence:
		52 - 96 = -44
		53 - 96 = -43
		54 - 96 = -42
	--]]
	if temp_index >= -44 and temp_index <= -42 and _isCastingNpFromAutoskill == 0 then
		---Enter card selection screen, ready to cast NP.
		click(Location(2300,1200))
		_isCastingNpFromAutoskill = 1
		wait(1)
		--Although it seems slow, make it no shorter than 1 sec to protect user with less processing power devices.
	end

	--[[In ascii, char(j, k, l) and char(x) command for master skill = decimal(106, 107, 108) and decimal(120) respectively.
		Hence:
		106 - 96 = 10
		107 - 96 = 11
		108 - 96 = 12
		120 - 96 = 24
	--]]
	if temp_index >= 10 then
		--Click master skill menu icon, ready to cast master skill.
		click(Location(2380, 640))
		wait(0.3)
	end

	--[[Enter Order Change Mode.
		In ascii, char(x) = decimal(120)
		120 - 96 = 24
	--]]
	if temp_index == 24 then
		_mysticCodeOrderChangeStatus = 1
	end

	--MysticCode-OrderChange master skill implementation.
	--Actual clicking is done by the default case here.
	if _mysticCodeOrderChangeStatus == 1 then
		--Click Order Change icon.
		click(_SKILL_CLICK_ARRAY[12])
		_mysticCodeOrderChangeStatus = 2
	elseif _mysticCodeOrderChangeStatus == 2 then
		click(_STARTING_MEMBER_CLICK_ARRAY[temp_index])
		_mysticCodeOrderChangeStatus = 3
	elseif _mysticCodeOrderChangeStatus == 3 then
		click(_SUB_MEMBER_CLICK_ARRAY[temp_index])
		wait(0.3)
		click(Location(1280,1260))
		_mysticCodeOrderChangeStatus = 0
		wait(5)
	else
		--Cast skills, NPs, or select target.
		click(_SKILL_CLICK_ARRAY[temp_index])
	end
	if temp_index > 0 and Skill_Confirmation == 1 then
		click(Location(1680,850))
	end
end

return {
	Init = Init,
	ResetForNextQuest = ResetForNextQuest,
	GetIsNPCasting = GetIsNPCasting,
	ExecuteSkill= ExecuteSkill,
	UpdateStageCounter = UpdateStageCounter
}