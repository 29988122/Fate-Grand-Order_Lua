-- modules
local stringUtils = require "string-utils"

-- consts
local SupportImagePath = "image_SUPPORT" .. "/"
local ScreenRegion = Region(0,0,110,332)
local ListRegion = Region(85,350,350,1087) -- see diagrams/support_list_region.png
local ListTopClick = Location(2480,360)
local UpdateClick = Location(1670, 250)
local UpdateYesClick = Location(1660, 1110)
local LimitBrokenCharacter = "*"

-- state vars
local PreferredServantArray = {}
local PreferredCraftEssenceTable = {}

-- functions
local init
local selectSupport
local selectFirst
local selectPreferred
local selectManual
local decideSearchMethod
local searchMethod
local findServants
local findCraftEssence
local isLimitBroken

init = function()
	local function split(str)
		local values = {}
	
		for value in str:gmatch("[^,]+") do
			value = stringUtils.trim(value)
			
			if value:lower() ~= "any" then
				table.insert(values, value)
			end
		end
		
		return values
	end

	-- servants
	for _, servant in ipairs(split(Support_PreferredServants)) do
		servant = stringUtils.trim(servant)
		table.insert(PreferredServantArray, servant)
	end
	
	-- craft essences
	for _, craftEssence in ipairs(split(Support_PreferredCEs)) do
		craftEssence = stringUtils.trim(craftEssence)
		
		local craftEssenceEntry =
		{
			Name = craftEssence:gsub("%" .. LimitBrokenCharacter, ""),
			PreferLimitBroken = stringUtils.starts_with(craftEssence, LimitBrokenCharacter)
		}
		
		table.insert(PreferredCraftEssenceTable, craftEssenceEntry)
	end
end

selectSupport = function(selectionMode)
	if ScreenRegion:exists(GeneralImagePath .. "support_screen.png") then
		if selectionMode == "first" then
			return selectFirst()
			
		elseif selectionMode == "preferred" then
			local searchMethod = decideSearchMethod()
			return selectPreferred(searchMethod)
			
		elseif selectionMode == "manual" then
			selectManual()
			
		else
			scriptExit("Invalid support selection mode: \"" + selectionMode + "\".")
		end
	end

	return false
end

selectFirst = function()
	click(Location(1900,500))
	return true
end

selectPreferred = function(searchMethod)
	local numberOfSwipes = 0
	local numberOfUpdates = 0
	
	while (true)
	do
		local support = searchMethod()
		if support ~= nil then
			click(support)
			return true
		end

		if numberOfSwipes < Support_SwapsPerRefresh then
			swipe(Location(1200, 1150), Location(1200, 800))			
			numberOfSwipes = numberOfSwipes + 1
			wait(0.3)
		elseif numberOfUpdates < Support_MaxRefreshes then		
			click(UpdateClick)
			wait(1)
			click(UpdateYesClick)
			wait(3)

			numberOfUpdates = numberOfUpdates + 1
			numberOfSwipes = 0
		else -- not found :(
			click(ListTopClick)
			return selectSupport(Support_FallbackTo)
		end
	end
end

selectManual = function()
	scriptExit("Support selection mode set to \"manual\".")
end

decideSearchMethod = function()
	local hasServants = #PreferredServantArray > 0
	local hasCraftEssences = #PreferredCraftEssenceTable > 0

	if hasServants and hasCraftEssences then
		return searchMethod.byServantAndCraftEssence
		
	elseif hasServants then
		return searchMethod.byServant
		
	elseif hasCraftEssences then
		return searchMethod.byCraftEssence
		
	else
		scriptExit("When using \"preferred\" support selection mode, specify at least one Servant or Craft Essence.")
	end
end

searchMethod = {	
	byServant = function()
		return findServants()[1]
	end,
	
	byCraftEssence = function()
		return findCraftEssence(ListRegion)
	end,
	
	byServantAndCraftEssence = function()
		local servants = findServants()
		for _, servant in ipairs(servants) do
		
			-- these calculations need to be done, otherwise we might select a CE from the wrong servant
			local maxDistanceFromServantPortraitToCraftEssence = 300
			local craftEssenceHeight = 90
			
			local x = ListRegion:getX()
			local y = servant:getY()
			local width = ListRegion:getW()
			local height = maxDistanceFromServantPortraitToCraftEssence + craftEssenceHeight
			local region = Region(x, y, width, height)
			
			local craftEssence = findCraftEssence(region)
			if craftEssence ~= nil then
				return craftEssence -- only return if found. if not, try the other servants before scrolling
			end
		end
		
		return nil -- not found, continue scrolling
	end
}

findServants = function()
	local servants = {}

	for _, preferredServant in ipairs(PreferredServantArray) do
		for _, servant in ipairs(regionFindAllNoFindException(ListRegion, SupportImagePath .. preferredServant)) do
			table.insert(servants, servant)
		end
	end
	
	return servants
end

findCraftEssence = function(searchRegion)
	for _, preferredCraftEssence in ipairs(PreferredCraftEssenceTable) do
		local craftEssences = regionFindAllNoFindException(searchRegion, Pattern(SupportImagePath .. preferredCraftEssence.Name))
	
		for _, craftEssence in ipairs(craftEssences) do					
			if not preferredCraftEssence.PreferLimitBroken or isLimitBroken(craftEssence) then
				return craftEssence
			end
		end
	end
	
	return nil -- not found, continue scrolling
end

isLimitBroken = function(craftEssence)
	local limitBreakRegion = Region(376, craftEssence:getY(), 16, craftEssence:getH())
	local limitBreakPattern = Pattern(GeneralImagePath .. "limitBroken.png"):similar(0.8)
	
	return limitBreakRegion:exists(limitBreakPattern)
end

-- "public" interface
return {
	init = init,
	selectSupport = selectSupport	
}