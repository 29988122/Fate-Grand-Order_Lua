-- modules
local _game = require("game")
local _ankuluaUtils = require("ankulua-utils")
local _stringUtils = require("string-utils")
local _autoskill
local _battle

-- consts
-- see docs/card_formula.jpg
-- a translation of it would be appreciated (lol)
local CARD_AFFINITY = {
	WEAK   = 2.0,
	NORMAL = 1.0,
	RESIST = 0.5
}

local CARD_TYPE = {
	BUSTER = 150,
	ARTS   = 100,
	QUICK  =  80
}

local CARD_SCORE = {
	BUSTER        = CARD_TYPE.BUSTER,
	ARTS          = CARD_TYPE.ARTS,
	QUICK         = CARD_TYPE.QUICK,
	RESIST_BUSTER = CARD_AFFINITY.RESIST * CARD_TYPE.BUSTER,
	RESIST_ARTS   = CARD_AFFINITY.RESIST * CARD_TYPE.ARTS,
	RESIST_QUICK  = CARD_AFFINITY.RESIST * CARD_TYPE.QUICK,
	WEAK_BUSTER   = CARD_AFFINITY.WEAK * CARD_TYPE.BUSTER,
	WEAK_ARTS     = CARD_AFFINITY.WEAK * CARD_TYPE.ARTS,
	WEAK_QUICK    = CARD_AFFINITY.WEAK * CARD_TYPE.QUICK
}

-- state vars
local _cardPriorityArray = {}
local _commandCards = {}

local cardsClickedSoFar = 0

-- functions
local init
local initCardPriorityArraySimple
local initCardPriorityArrayDetailed
local getCardAffinity
local getCardType
local getCommandCards
local clickCommandCards
local canClickNpCards
local clickNpCards

init = function(autoskill, battle)
	_autoskill = autoskill
	_battle = battle

	initCardPriorityArray()
end

initCardPriorityArray = function()
	local errorString = "Battle_CardPriority Error at '"
	
	if Battle_CardPriority:len() == 3 then
		initCardPriorityArraySimple(errorString)
	else
		initCardPriorityArrayDetailed(errorString)
	end
end

initCardPriorityArraySimple = function(errorString)
	for card in Battle_CardPriority:gmatch(".") do
		if card:match("[^B^A^Q]") then
			scriptExit(errorString .. card .. "': Only 'B', 'A' and 'Q' are allowed in simple mode.")
		end

		table.insert(_cardPriorityArray, "W" .. card)
		table.insert(_cardPriorityArray, card)
		table.insert(_cardPriorityArray, "R" .. card)
	end
end

initCardPriorityArrayDetailed = function(errorString)
	local cardCounter = 0

	for card in Battle_CardPriority:gmatch("[^,]+") do
		card = _stringUtils.Trim(card:upper())
		
		if card:len() < 1 or card:len() > 2 then
			scriptExit(errorString .. card .. "': Invalid card length.")
		elseif card:len() == 1 and not card:match("[BAQ]") then
			scriptExit(errorString .. card .. "': Only 'B', 'A' and 'Q' are valid single character inputs.")
		elseif card:len() == 2 and not card:match("[WR][BAQ]") then
			scriptExit(errorString .. card .. "': Only 'WB', 'RB', 'WA', 'RA', 'WQ' and 'RQ' are valid double characters inputs.")
		end

		table.insert(_cardPriorityArray, card)
		cardCounter = cardCounter + 1
	end
	
	if cardCounter ~= 9 then
		scriptExit(errorString .. Battle_CardPriority .. "': Expected 9 cards, but " .. cardCounter .. " found.")
	end
end

getCardAffinity = function(region)
	if region:exists(Pattern(GeneralImagePath .. "weak.png")) then
		return CARD_AFFINITY.WEAK;
	elseif region:exists(Pattern(GeneralImagePath .. "resist.png")) then
		return CARD_AFFINITY.RESIST;
	else
		return CARD_AFFINITY.NORMAL;
	end
end

getCardType = function(region)
	if region:exists(GeneralImagePath .. "buster.png") then
		return CARD_TYPE.BUSTER;
	elseif region:exists(GeneralImagePath .. "art.png") then
		return CARD_TYPE.ARTS;
	elseif region:exists(GeneralImagePath .. "quick.png") then
		return CARD_TYPE.QUICK;
	end

	local message = "Failed to determine Card type (X: %i, Y: %i, Width: %i, Height: %i)"
	toast(message:format(region:getX(), region:getY(), region:getW(), region:getH()))
	return CARD_TYPE.BUSTER;
end

getCommandCards = function()
	local storagePerPriority = {
		WB = {}, B = {}, RB = {},
		WA = {}, A = {}, RA = {},
		WQ = {}, Q = {}, RQ = {}
	}

	local storagePerScore = {
		[CARD_SCORE.WEAK_BUSTER]   = storagePerPriority.WB,
		[CARD_SCORE.BUSTER]        = storagePerPriority.B,
		[CARD_SCORE.RESIST_BUSTER] = storagePerPriority.RB,
		[CARD_SCORE.WEAK_ARTS]     = storagePerPriority.WA,
		[CARD_SCORE.ARTS]          = storagePerPriority.A,
		[CARD_SCORE.RESIST_ARTS]   = storagePerPriority.RA,
		[CARD_SCORE.WEAK_QUICK]    = storagePerPriority.WQ,
		[CARD_SCORE.QUICK]         = storagePerPriority.Q,
		[CARD_SCORE.RESIST_QUICK]  = storagePerPriority.RQ
	}

	local function storeCards()
		for cardSlot = 1, 5 do
			local cardAffinity = getCardAffinity(_game.BATTLE_CARD_AFFINITY_REGION_ARRAY[cardSlot])
			local cardType = getCardType(_game.BATTLE_CARD_TYPE_REGION_ARRAY[cardSlot])
			local cardScore = cardAffinity * cardType

			local properStorage = storagePerScore[cardScore]
			table.insert(properStorage, cardSlot)
		end
	end
	
	_ankuluaUtils.UseSameSnapIn(storeCards)
	return storagePerPriority
end

clickCommandCards = function(clicks)

	for _, cardPriority in pairs(_cardPriorityArray) do
		local currentCardTypeStorage = _commandCards[cardPriority]
	
		local i = 1
		for _, cardSlot in pairs(currentCardTypeStorage) do
			if(i > cardsClickedSoFar) then
				click(_game.BATTLE_COMMAND_CARD_CLICK_ARRAY[cardSlot])
			end
			
			if (clicks <= i) then
				cardsClickedSoFar = i
				return
			end
			
			i++
		end
	end
end

canClickNpCards = function()
	local weCanSpam = Battle_NoblePhantasm == "spam"
	local weAreInDanger = Battle_NoblePhantasm == "danger" and _battle.hasChosenTarget()

	return (weCanSpam or weAreInDanger) and _autoskill.IsFinished()
end

clickNpCards = function()
	local NPsClicked = false
	for _, npCard in pairs(_game.BATTLE_NP_CARD_CLICK_ARRAY) do
		click(npCard)
		NPsClicked = true
	end
	
	return NPsClicked
end

readCommandCards = function()
	_commandCards = getCommandCards()
end

resetCommandCards = function()
	_commandCards = {}
	cardsClickedSoFar = 0
end

-- "public" interface
return {
	init = init,
	clickCommandCards = clickCommandCards,
	canClickNpCards = canClickNpCards,
	clickNpCards = clickNpCards,
	readCommandCards = readCommandCards,
	resetCommandCards = resetCommandCards
}