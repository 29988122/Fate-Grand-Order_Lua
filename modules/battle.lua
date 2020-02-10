-- modules
local _game = require("game")
local _ankuluaUtils = require("ankulua-utils")
local _luaUtils = require("lua-utils")
local _autoskill
local _card

-- state vars
local _currentStage
local _currentTurn
local _hasChosenTarget
local _hasTakenFirstStageSnapshot
local _hasClickedAttack

-- functions
local init
local resetState
local isIdle

local getCurrentStage
local getCurrentTurn

local performBattle
local onTurnStarted
local skipDeathAnimation

local checkCurrentStage
local didStageChange
local takeStageSnapshot
local onStageSnapshotTaken
local onStageChanged

local autoChooseTarget
local isPriorityTarget
local chooseTarget
local onTargetChosen
local hasChosenTarget

local clickAttack
local onAttackClicked
local hasClickedAttack

init = function(autoskill, card)
	_autoskill = autoskill
	_card = card

	resetState()
end

resetState = function()
	_autoskill.ResetState()
	_currentStage = 0
	_currentTurn = 0
	_hasTakenFirstStageSnapshot = false
	_hasChosenTarget = false
	_hasClickedAttack = false
end

isIdle = function()
	return _game.BATTLE_SCREEN_REGION:exists(GeneralImagePath .. "battle.png")
end

getCurrentStage = function()
	return _currentStage
end

getCurrentTurn = function()
	return _currentTurn
end

performBattle = function()
	_ankuluaUtils.UseSameSnapIn(onTurnStarted)
	wait(2)
	
	local NPsClicked = false
	if Enable_Autoskill == 1 then
		NPsClicked = _autoskill.Execute()
		_autoskill.ResetNPTimer()
	end

	-- maybe Autoskill already did this, so we need to check
	if not _hasClickedAttack then
		clickAttack()
	end
	
	if _card.canClickNpCards() then
		NPsClicked = _card.clickNpCards()
	end
	
	_card.clickCommandCards(5)

	if UnstableFastSkipDeadAnimation == 1 then
		skipDeathAnimation()
	end
	
	_game.resetCommandCards()
	
	if NPsClicked then
		wait(25)
	else
		wait(5)
	end
end

onTurnStarted = function()
	checkCurrentStage()
	_currentTurn = _currentTurn + 1
	_hasClickedAttack = false

	if not _hasChosenTarget and Battle_AutoChooseTarget == 1 then
		autoChooseTarget()
	end
end

skipDeathAnimation = function()
	-- https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 Experimental
	for i = 1, 3 do
		click(_game.BATTLE_SKIP_DEATH_ANIMATION_CLICK)
		wait(1)
	end
end

checkCurrentStage = function()
	if not _hasTakenFirstStageSnapshot or didStageChange() then
		onStageChanged()
		takeStageSnapshot()
	end
end

didStageChange = function()
	-- Alternative fix for different font of stage count number among different regions, worked pretty damn well tho.
	-- This will compare last screenshot with current screen, effectively get to know if stage changed or not.
	
	local currentStagePattern = Pattern(GeneralImagePath .. "_GeneratedStageCounterSnapshot" .. ".png"):similar(0.8)
	return not _game.BATTLE_STAGE_COUNT_REGION:exists(currentStagePattern)
end

takeStageSnapshot = function()
	_game.BATTLE_STAGE_COUNT_REGION:save(GeneralImagePath .. "_GeneratedStageCounterSnapshot" .. ".png")
	onStageSnapshotTaken()
end

onStageSnapshotTaken = function()
	_hasTakenFirstStageSnapshot = true
end

onStageChanged = function()
	_currentStage = _currentStage + 1
	_currentTurn = 0
	_hasChosenTarget = false
end

autoChooseTarget = function()
	-- from my experience, most boss stages are ordered like (Servant 1)(Servant 2)(Servant 3),
	-- where (Servant 3) is the most powerful one. see docs/boss_stage.png
	-- that's why the table is iterated backwards.

	for i, target in _luaUtils.Reverse(_game.BATTLE_TARGET_REGION_ARRAY) do
		if isPriorityTarget(target) then
			chooseTarget(i)			
			return
		end
	end
end

isPriorityTarget = function(target)
	local isDanger = target:exists(GeneralImagePath .. "target_danger.png")
	local isServant = target:exists(GeneralImagePath .. "target_servant.png")

	return isDanger or isServant
end

chooseTarget = function(targetIndex)
	click(_game.BATTLE_TARGET_CLICK_ARRAY[targetIndex])
	wait(0.5)
	click(_game.BATTLE_EXTRAINFO_WINDOW_CLOSE_CLICK)
	onTargetChosen()
end

onTargetChosen = function()
	_hasChosenTarget = true
end

hasChosenTarget = function()
	return _hasChosenTarget
end

clickAttack = function()
	click(_game.BATTLE_ATTACK_CLICK)
	wait(1.5) -- Although it seems slow, make it no shorter than 1 sec to protect user with less processing power devices.

	onAttackClicked()
	_game.readCommandCards()
end

onAttackClicked = function()
	_hasClickedAttack = true
end

hasClickedAttack = function()
	return _hasClickedAttack
end

-- "public" interface
return {
	init = init,
	resetState = resetState,
	isIdle = isIdle,
	getCurrentStage = getCurrentStage,
	getCurrentTurn = getCurrentTurn,
	performBattle = performBattle,
	chooseTarget = chooseTarget,
	hasChosenTarget = hasChosenTarget,
	clickAttack = clickAttack,
	hasClickedAttack = hasClickedAttack
}
