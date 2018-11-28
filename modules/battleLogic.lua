--[[
	"A moment of silence for my old Ipad 3 as FGO EN ditched support for iOS 9"
	- ryuga93
--]]

local ankuluaUtils = require "ankulua-utils"

--Constants
--Weak, resist, etc. Compatiable for most server, but tricky, frequently fail.
local Card1AffinRegion = Region( 295,650,250,200)
local Card2AffinRegion = Region( 810,650,250,200)
local Card3AffinRegion = Region(1321,650,250,200)
local Card4AffinRegion = Region(1834,650,250,200)
local Card5AffinRegion = Region(2348,650,250,200)

local CardAffinRegionArray = {Card1AffinRegion, Card2AffinRegion, Card3AffinRegion, Card4AffinRegion, Card5AffinRegion}

--Buster, Art, Quick, etc.
local Card1TypeRegion = Region(200,1060,200,200)
local Card2TypeRegion = Region(730,1060,200,200)
local Card3TypeRegion = Region(1240,1060,200,200)
local Card4TypeRegion = Region(1750,1060,200,200)
local Card5TypeRegion = Region(2280,1060,200,200)

local CardTypeRegionArray = {Card1TypeRegion, Card2TypeRegion, Card3TypeRegion, Card4TypeRegion, Card5TypeRegion}

--*Rough* damage calculation by formula, you may tinker these to change card selection priority.
--https://pbs.twimg.com/media/C2nSYxcUoAAy_F2.jpg
local WeakMulti = 2.0
local NormalMulti = 1.0
local ResistMulti = 0.5

local BCard = 150
local ACard = 100
local QCard = 80

local ResistBuster = BCard * ResistMulti
local ResistArt = ACard * ResistMulti
local ResistQuick = QCard * ResistMulti

local WeakBuster = BCard * WeakMulti
local WeakArt = ACard * WeakMulti
local WeakQuick = QCard * WeakMulti

--User customizable BAQ selection priority.
local CardPriorityArray = {}

--Card selection pos for click, and array for AutoSkill.
local Card1Click = (Location(300,1000))
local Card2Click = (Location(750,1000))
local Card3Click = (Location(1300,1000))
local Card4Click = (Location(1800,1000))
local Card5Click = (Location(2350,1000))

local CardClickArray = {Card1Click, Card2Click, Card3Click, Card4Click, Card5Click}

--functions
local init
local checkCardAffin
local checkCardType
local ultcard
local calculateCardScore
local clickCommandCards

function init()
	--[[Considering:
	Battle_CardPriority = "BAQ"
	then:
	CardPriorityArray = {"WB", "B", "RB", "WA", "A", "RA", "WQ", "Q", "RQ"}
	--]]

	for card in Battle_CardPriority:gmatch(".") do
		table.insert(CardPriorityArray, "W" .. card)
		table.insert(CardPriorityArray, card)
		table.insert(CardPriorityArray, "R" .. card)
	end
end

checkCardAffin = function(region)
	if region:exists(GeneralImagePath .. "weak.png") then
		return WeakMulti
	end

	if region:exists(GeneralImagePath .. "resist.png") then
		return ResistMulti
	else
		return NormalMulti
	end
end

checkCardType = function(region)
	if region:exists(GeneralImagePath .. "buster.png") then
		return BCard
	end

	if region:exists(GeneralImagePath .. "art.png") then
		return ACard
	end

	if region:exists(GeneralImagePath .. "quick.png") then
		return QCard
	else
		return BCard
	end
end

ultcard = function()
	local weCanSpam = Battle_NoblePhantasm == "spam"
	local weAreInDanger = Battle_NoblePhantasm == "danger" and TargetChoosen == 1
	local isAutoskillFinished = Enable_Autoskill == 0 or CleartoSpamNP == 1

	if (weCanSpam or weAreInDanger) and isAutoskillFinished then
		click(Ultcard1Click)
		click(Ultcard2Click)
		click(Ultcard3Click)
	end
end

calculateCardScore = function(allCardTypeStorage)
	local function calculate()
		for cardSlot = 1, 5 do
			local cardAffinity = checkCardAffin(CardAffinRegionArray[cardSlot])
			local cardType = checkCardType(CardTypeRegionArray[cardSlot])
			local cardScore = cardAffinity * cardType
	
			if cardScore == WeakBuster then
				table.insert(allCardTypeStorage.WB, cardSlot)
			elseif cardScore == BCard then
				table.insert(allCardTypeStorage.B, cardSlot)
			elseif cardScore == ResistBuster then
				table.insert(allCardTypeStorage.RB, cardSlot)
	
			elseif cardScore == WeakArt then
				table.insert(allCardTypeStorage.WA, cardSlot)
			elseif cardScore == ACard then
				table.insert(allCardTypeStorage.A, cardSlot)
			elseif cardScore == ResistArt then
				table.insert(allCardTypeStorage.RA, cardSlot)
	
			elseif cardScore == WeakQuick then
				table.insert(allCardTypeStorage.WQ, cardSlot)
			elseif cardScore == QCard then
				table.insert(allCardTypeStorage.Q, cardSlot)
			else
				table.insert(allCardTypeStorage.RQ, cardSlot)
			end
		end
		
		return allCardTypeStorage
	end
	
	return ankuluaUtils.useSameSnapIn(calculate)
end

clickCommandCards = function()
	local allCardTypeStorage =
	{
		WB = {}, B = {}, RB = {},
		WA = {}, A = {}, RA = {},
		WQ = {}, Q = {}, RQ = {}
	}
	local currentAllCardTypeStorages = calculateCardScore(allCardTypeStorage)
	
	local clickCount = 0
	
	ultcard()

	wait(0.5)
	
	for _, cardPriority in pairs(CardPriorityArray) do
		local currentCardTypeStorage = currentAllCardTypeStorages[cardPriority]
	
		for _, cardSlot in pairs(currentCardTypeStorage) do
			click(CardClickArray[cardSlot])
			clickCount = clickCount + 1
	
			if clickCount == 3 then
				return
			end
		end
	end
end

return {
	init = init,
	clickCommandCards = clickCommandCards,
}