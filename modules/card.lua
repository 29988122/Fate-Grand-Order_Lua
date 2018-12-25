-- modules
local _ankuluaUtils = require("ankulua-utils")
local _stringUtils = require("string-utils")
local _autoskill
local _battle

-- consts
local CARD_AFFINITY_REGION_ARRAY = {
	-- see docs/card_affinity_regions.png
	Region( 295 + xOffset,650 + yOffset,250,200),
	Region( 810 + xOffset,650 + yOffset,250,200),
	Region(1321 + xOffset,650 + yOffset,250,200),
	Region(1834 + xOffset,650 + yOffset,250,200),
	Region(2348 + xOffset,650 + yOffset,250,200)
}

local CARD_TYPE_REGION_ARRAY = {
	-- see docs/card_type_regions.png
	Region(   0 + xOffset,1060 + yOffset,512,200),
	Region( 512 + xOffset,1060 + yOffset,512,200),
	Region(1024 + xOffset,1060 + yOffset,512,200),
	Region(1536 + xOffset,1060 + yOffset,512,200),
	Region(2048 + xOffset,1060 + yOffset,512,200)
}

local COMMAND_CARD_CLICK_ARRAY = {
	Location( 300 + xOffset,1000 + yOffset),
	Location( 750 + xOffset,1000 + yOffset),
	Location(1300 + xOffset,1000 + yOffset),
	Location(1800 + xOffset,1000 + yOffset),
	Location(2350 + xOffset,1000 + yOffset),
}

local NP_CARD_CLICK_ARRAY = {
	Location(1000 + xOffset,220 + yOffset),
	Location(1300 + xOffset,400 + yOffset),
	Location(1740 + xOffset,400 + yOffset)
}

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

-- functions
local init
local initCardPriorityArraySimple
local initCardPriorityArrayDetailed
local getCardAffinity
local getCardType
local getCommandCards
local getNpCardLocation
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
		card = _stringUtils.trim(card:upper())
		
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
	if region:exists(GeneralImagePath .. "weak.png") then
		return CARD_AFFINITY.WEAK;
	elseif region:exists(GeneralImagePath .. "resist.png") then
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
			local cardAffinity = getCardAffinity(CARD_AFFINITY_REGION_ARRAY[cardSlot])
			local cardType = getCardType(CARD_TYPE_REGION_ARRAY[cardSlot])
			local cardScore = cardAffinity * cardType

			local properStorage = storagePerScore[cardScore]
			table.insert(properStorage, cardSlot)
		end
	end
	
	_ankuluaUtils.useSameSnapIn(storeCards)
	return storagePerPriority
end

clickCommandCards = function()
	local commandCards = getCommandCards()

	for _, cardPriority in pairs(_cardPriorityArray) do
		local currentCardTypeStorage = commandCards[cardPriority]
	
		for _, cardSlot in pairs(currentCardTypeStorage) do
			click(COMMAND_CARD_CLICK_ARRAY[cardSlot])
		end
	end
end

canClickNpCards = function()
	local weCanSpam = Battle_NoblePhantasm == "spam"
	local weAreInDanger = Battle_NoblePhantasm == "danger" and _battle.hasChosenTarget()

	return (weCanSpam or weAreInDanger) and _autoskill.hasFinishedCastingNp()
end

clickNpCards = function()
	for _, npCard in pairs(NP_CARD_CLICK_ARRAY) do
		click(npCard)
	end
end

getNpCardLocation = function(servantIndex)
	return NP_CARD_CLICK_ARRAY[servantIndex]
end

-- "public" interface
return {
	init = init,
	getNpCardLocation = getNpCardLocation,
	clickCommandCards = clickCommandCards,
	canClickNpCards = canClickNpCards,
	clickNpCards = clickNpCards
}
