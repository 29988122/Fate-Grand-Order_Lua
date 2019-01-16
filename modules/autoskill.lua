local autoskill = {}

-- modules
local game = require("game")
local battle
local card

-- fields
local commandTable = {} -- this is a two-dimensional array with something like "abc1jkl4"
local currentArray
local isFinished

-- command framework
local DEFAULT_FUNCTION_ARRAY
local STARTING_MEMBER_FUNCTION_ARRAY
local SUB_MEMBER_FUNCTION_ARRAY

local function DoAbsolutelyNothing()
	return function()
	end
end

local function WaitForAnimationToFinish(timeout)
	local image = GeneralImagePath .. "battle.png"

	game.BATTLE_SCREEN_REGION:waitVanish(image, 2) -- slow devices need this. do not remove.
	game.BATTLE_SCREEN_REGION:exists(image, timeout or 5)
end

local function CastSkill(location)
	return function()
		click(location)
		if Skill_Confirmation == 1 then
			click(game.BATTLE_SKILL_OK_CLICK)
		end

		WaitForAnimationToFinish()
	end
end

local function SelectSkillTarget(location)
	return function()
		click(location)
		WaitForAnimationToFinish()
	end
end

local function CastNoblePhantasm(location)
	return function()
		if not battle.hasClickedAttack() then
			battle.clickAttack()
		end

		click(location)
	end
end

local function OpenMasterSkillMenu()
	click(game.BATTLE_MASTER_SKILL_OPEN_CLICK)
	wait(0.3)
end

local function CastMasterSkill(location)
	return function()
		OpenMasterSkillMenu()
		CastSkill(location)()
	end
end

local function ChangeArray(newArray)
	currentArray = newArray
end

local function BeginOrderChange()
	return function()
		OpenMasterSkillMenu()
		click(game.BATTLE_MASTER_SKILL_3_CLICK)
		wait(0.3)

		ChangeArray(STARTING_MEMBER_FUNCTION_ARRAY)
	end
end

local function SelectStartingMember(location)
	return function()
		click(location)
		ChangeArray(SUB_MEMBER_FUNCTION_ARRAY)
	end
end

local function SelectSubMember(location)
	return function()
		click(location)
		wait(0.3)
		click(game.BATTLE_ORDER_CHANGE_OK_CLICK)
		WaitForAnimationToFinish(15)

		ChangeArray(DEFAULT_FUNCTION_ARRAY)
	end
end

DEFAULT_FUNCTION_ARRAY = {
	["a"] = CastSkill(game.BATTLE_SKILL_1_CLICK),
	["b"] = CastSkill(game.BATTLE_SKILL_2_CLICK),
	["c"] = CastSkill(game.BATTLE_SKILL_3_CLICK),
	["d"] = CastSkill(game.BATTLE_SKILL_4_CLICK),
	["e"] = CastSkill(game.BATTLE_SKILL_5_CLICK),
	["f"] = CastSkill(game.BATTLE_SKILL_6_CLICK),
	["g"] = CastSkill(game.BATTLE_SKILL_7_CLICK),
	["h"] = CastSkill(game.BATTLE_SKILL_8_CLICK),
	["i"] = CastSkill(game.BATTLE_SKILL_9_CLICK),
	["j"] = CastMasterSkill(game.BATTLE_MASTER_SKILL_1_CLICK),
	["k"] = CastMasterSkill(game.BATTLE_MASTER_SKILL_2_CLICK),
	["l"] = CastMasterSkill(game.BATTLE_MASTER_SKILL_3_CLICK),
	["x"] = BeginOrderChange(),
	["0"] = DoAbsolutelyNothing(),
	["1"] = SelectSkillTarget(game.BATTLE_SERVANT_1_CLICK),
	["2"] = SelectSkillTarget(game.BATTLE_SERVANT_2_CLICK),
	["3"] = SelectSkillTarget(game.BATTLE_SERVANT_3_CLICK),
	["4"] = CastNoblePhantasm(game.BATTLE_NP_CARD_CLICK_ARRAY[1]),
	["5"] = CastNoblePhantasm(game.BATTLE_NP_CARD_CLICK_ARRAY[2]),
	["6"] = CastNoblePhantasm(game.BATTLE_NP_CARD_CLICK_ARRAY[3])
}

STARTING_MEMBER_FUNCTION_ARRAY = {
	["1"] = SelectStartingMember(game.BATTLE_STARTING_MEMBER_1_CLICK),
	["2"] = SelectStartingMember(game.BATTLE_STARTING_MEMBER_2_CLICK),
	["3"] = SelectStartingMember(game.BATTLE_STARTING_MEMBER_3_CLICK)
}

SUB_MEMBER_FUNCTION_ARRAY = {
	["1"] = SelectSubMember(game.BATTLE_SUB_MEMBER_1_CLICK),
	["2"] = SelectSubMember(game.BATTLE_SUB_MEMBER_2_CLICK),
	["3"] = SelectSubMember(game.BATTLE_SUB_MEMBER_3_CLICK)
}

-- other stuff
local function InitCommands()
	local stageCount = 1

	for commandList in string.gmatch(Skill_Command, "[^,]+") do
		if string.match(commandList, "[^0]") then
			if string.match(commandList, "^[1-3]") then
				scriptExit("Error at '" .. commandList .. "': Skill Command cannot start with number '1', '2' and '3'!")
			elseif string.match(commandList, "[%w+][#]") or string.match(commandList, "[#][%w+]") then
				scriptExit("Error at '" .. commandList .. "': '#' must be preceded and followed by ','! Correct: ',#,' ")
			elseif string.match(commandList, "[^a-l^1-6^#^x]") then
				scriptExit("Error at '" .. commandList .. "': Skill Command exceeded alphanumeric range! Expected 'x' or range 'a' to 'l' for alphabets and '0' to '6' for numbers.")
			end
		end

		commandTable[stageCount] = commandTable[stageCount] or {}
		if commandList == '#' then
			stageCount = stageCount + 1
		else
			table.insert(commandTable[stageCount], commandList)
		end
	end
end

function autoskill.Init(battleModule, cardModule)
	battle = battleModule
	card = cardModule

	if Enable_Autoskill == 1 then
		InitCommands()
	end

	autoskill.ResetState()
end

function autoskill.ResetState()
	isFinished = Enable_Autoskill == 0
	ChangeArray(DEFAULT_FUNCTION_ARRAY)
end

local function GetCommandListFor(stage, turn)
	local commandList = commandTable[stage]
	if commandList ~= nil then
		commandList = commandList[turn]
	end

	return commandList
end

local function ExecuteCommandList(commandList)
	for command in string.gmatch(commandList, ".") do
		currentArray[command]()
	end
end

function autoskill.Execute()
	local currentStage = battle.getCurrentStage()
	local currentTurn = battle.getCurrentTurn()
	local commandList = GetCommandListFor(currentStage, currentTurn)

	if commandList ~= nil then
		ExecuteCommandList(commandList)
	elseif currentStage >= #commandTable then
		isFinished = true -- this will allow NP spam after all commands have been executed
	end
end

function autoskill.IsFinished()
	return isFinished
end

return autoskill