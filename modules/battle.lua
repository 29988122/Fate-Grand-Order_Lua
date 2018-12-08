-- modules
local _ankuluaUtils = require("ankulua-utils")
local _autoskill
local _card

-- consts
local BATTLE_REGION = Region(2200,200,1000,600)
local ATTACK_CLICK = Location(2300,1200)
local SKIP_DEATH_ANIMATION_CLICK = Location(1700, 100) -- see docs/skip_death_animation_click.png

-- see docs/target_regions.png
local TARGET_REGION_ARRAY = {
	Region(  0,0,485,220),
	Region(485,0,482,220),
	Region(967,0,476,220)
}

local TARGET_CLICK_ARRAY = {
	Location(  90,80),
	Location( 570,80),
	Location(1050,80)
}

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
	_autoskill.resetState()
	_currentStage = 0
	_currentTurn = 0
	_hasTakenFirstStageSnapshot = false
	_hasChosenTarget = false
	_hasClickedAttack = false
end

isIdle = function()
	return BATTLE_REGION:exists(GeneralImagePath .. "battle.png")
end

getCurrentStage = function()
	return _currentStage
end

getCurrentTurn = function()
	return _currentTurn
end

performBattle = function()
	_ankuluaUtils.useSameSnapIn(onTurnStarted)
	wait(2)
	
	if Enable_Autoskill == 1 then
		_autoskill.executeSkill()
	end

	-- maybe Autoskill already did this, so we need to check
	if not _hasClickedAttack then
		clickAttack()
	end
	
	if _card.canClickNpCards() then
		_card.clickNpCards()
	end
	
	_card.clickCommandCards()

	if UnstableFastSkipDeadAnimation == 1 then
		skipDeathAnimation()
	end

	wait(2)
end

onTurnStarted = function()
	checkCurrentStage()
	_currentTurn = _currentTurn + 1
	_hasClickedAttack = false

	if not _hasChosenTarget then
		autoChooseTarget()
	end
end

skipDeathAnimation = function()
	-- https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 Experimental
	for i = 1, 3 do
		click(SKIP_DEATH_ANIMATION_CLICK)
		wait(1)
	end
end

checkCurrentStage = function()
	if not _hasTakenFirstStageSnapshot or didStageChange() then
		takeStageSnapshot()
		onStageChanged()
	end

	toast("Battle " .. _currentStage .. "/3")
end

didStageChange = function()
	-- Alternative fix for different font of stage count number among different regions, worked pretty damn well tho.
	-- This will compare last screenshot with current screen, effectively get to know if stage changed or not.

	local currentStagePattern = Pattern(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png"):similar(0.8)
	return not StageCountRegion:exists(currentStagePattern)
end

takeStageSnapshot = function()
	toast("Taking snapshot for stage recognition")
	StageCountRegion:save(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png")

	onStageSnapshotTaken()
end

onStageSnapshotTaken = function()
	_hasTakenFirstStageSnapshot = true
end

onStageChanged = function()
	_currentStage = _currentStage + 1
	_hasChosenTarget = false
end

autoChooseTarget = function()
	for i, target in ipairs(TARGET_REGION_ARRAY) do
		if isPriorityTarget(target) then
			chooseTarget(i)
			toast("Switched to priority target")
			
			return
		end
	end

	toast("No priority target selected")
end

isPriorityTarget = function(target)
	local isDanger = target:exists(GeneralImagePath .. "target_danger.png")
	local isServant = target:exists(GeneralImagePath .. "target_servant.png")

	return isDanger or isServant
end

chooseTarget = function(targetIndex)
	click(TARGET_CLICK_ARRAY[targetIndex])
	onTargetChosen()
end

onTargetChosen = function()
	_hasChosenTarget = true
end

hasChosenTarget = function()
	return _hasChosenTarget
end

clickAttack = function()
	click(ATTACK_CLICK)
	wait(1.5) -- Although it seems slow, make it no shorter than 1 sec to protect user with less processing power devices.

	onAttackClicked()
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