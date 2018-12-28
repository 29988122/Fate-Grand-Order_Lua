-- modules
local stringUtils = require "string-utils"
local ankuluaUtils = require "ankulua-utils"

-- consts
local SupportImagePath = "image_SUPPORT" .. "/"
local ScreenRegion = Region(0 + xOffset,0 + yOffset,110,332)
local ListRegion = Region(70 + xOffset,332 + yOffset,378,1091) -- see docs/support_list_region.png
local ListItemRegionArray = {
	-- see docs/support_list_item_regions_top.png
	Region(76 + xOffset,338 + yOffset,2356,428),
	Region(76 + xOffset,778 + yOffset,2356,390),

	-- see docs/support_list_item_regions_bottom.png
	Region(76 + xOffset,558 + yOffset,2356,390),
	Region(76 + xOffset,991 + yOffset,2356,428),
} 
local FriendRegion = Region(2234 + xOffset, ListRegion:getY(), 120, ListRegion:getH()) -- see docs/friend_region.png
local ListTopClick = Location(2480 + xOffset,360 + yOffset)
local UpdateClick = Location(1670 + xOffset,250 + yOffset)
local UpdateYesClick = Location(1480 + xOffset,1110 + yOffset)
local CraftEssenceHeight = 90
local LimitBrokenCharacter = "*"

-- state vars
local PreferredServantArray = {}
local PreferredCraftEssenceTable = {}

-- functions
local init
local selectSupport
local selectFirst
local selectManual
local selectPreferred
local scrollList
local searchVisible
local decideSearchMethod
local searchMethod
local findServants
local findCraftEssence
local findSupportBounds
local isFriend
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
	ScreenRegion:highlight(.5)
	while not ScreenRegion:exists(GeneralImagePath .. "support_screen.png") do end
		if selectionMode == "first" then
			return selectFirst()

		elseif selectionMode == "manual" then
			selectManual()

		elseif selectionMode == "preferred" then
			local searchMethod = decideSearchMethod()
			return selectPreferred(searchMethod)

		else
			scriptExit("Invalid support selection mode: \"" + selectionMode + "\".")
		end

	return false
end

selectFirst = function()
	click(Location(1900 + xOffset,500 + yOffset))
	return true
end

selectManual = function()
	scriptExit("Support selection mode set to \"manual\".")
end

selectPreferred = function(searchMethod)
	local numberOfSwipes = 0
	local numberOfUpdates = 0

	while (true)
	do
		local result, support = searchVisible(searchMethod)

		if result == "ok" then
			click(support)
			return true

		elseif result == "not-found" and numberOfSwipes < Support_SwipesPerUpdate then
			scrollList()
			numberOfSwipes = numberOfSwipes + 1
			wait(0.3)

		elseif numberOfUpdates < Support_MaxUpdates then
			toast("Support list will be updated in 3 seconds.")
			wait(3)

			click(UpdateClick)
			wait(1)
			click(UpdateYesClick)
			wait(3)

			numberOfUpdates = numberOfUpdates + 1
			numberOfSwipes = 0

		else -- okay, we have run out of options, let's give up
			click(ListTopClick)
			return selectSupport(Support_FallbackTo)
		end
	end
end

scrollList = function()
	local startLocation = Location(35 + xOffset, 1190 + yOffset)
	local endLocation = Location(35 + xOffset, 390 + yOffset)

	local touchActions = {
		{ action = "touchDown", target = startLocation },
		{ action = "touchMove", target =   endLocation },
		{ action =      "wait", target =           0.4 },
		{ action =   "touchUp", target =   endLocation },
		{ action =      "wait", target =           0.5 } -- leaving some room for animations to finish
	}

	-- I want the movement to be as accurate as possible
	setManualTouchParameter(1, 1)
	manualTouch(touchActions)
end

searchVisible = function(searchMethod)
	local function performSearch()
		if not isFriend(FriendRegion) then
			return {"no-friends-at-all"} -- no friends on screen, so there's no point in scrolling anymore
		end

		local support, bounds = searchMethod()
		if support == nil then
			return {"not-found"} -- nope, not found this time. keep scrolling
		end

		-- bounds are already returned by searchMethod.byServantAndCraftEssence, but not by the other methods
		bounds = bounds or findSupportBounds(support)
		if not isFriend(bounds) then
			return {"not-found"} -- found something, but it doesn't belong to a friend. keep scrolling
		end

		return {"ok", support}
	end

	-- see https://www.lua.org/pil/5.1.html for details on "unpack"
	return unpack(ankuluaUtils.useSameSnapIn(performSearch))
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
			local supportBounds = findSupportBounds(servant)
			local craftEssence = findCraftEssence(supportBounds)

			-- CEs are always below Servants in the support list
			-- see docs/support_list_edge_case_fix.png to understand why this conditional exists
			if craftEssence ~= nil and craftEssence:getY() > servant:getY() then
				return craftEssence, supportBounds -- only return if found. if not, try the other servants before scrolling
			end
		end

		return nil -- not found, continue scrolling
	end
}

findServants = function()
	local servants = {}

	for _, preferredServant in ipairs(PreferredServantArray) do
		for _, servant in ipairs(regionFindAllNoFindException(ListRegion, Pattern(SupportImagePath .. preferredServant))) do
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

	return nil
end

findSupportBounds = function(support)
	for _, supportBounds in ipairs(ListItemRegionArray) do
		if ankuluaUtils.doesRegionContain(supportBounds, support) then
			return supportBounds
		end
	end

	-- we're not supposed to end down here, but if we do, there's probably something wrong with ListItemRegionArray or ListRegion
	local message = "The Servant or Craft Essence (X: %i, Y: %i, Width: %i, Height: %i) is not contained in ListItemRegionArray."
	error(message:format(support:getX(), support:getY(), support:getW(), support:getH()))
end

isFriend = function(region)
	local friendPattern = Pattern(GeneralImagePath .. "friend.png")
	return Support_FriendsOnly == 0 or region:exists(friendPattern)
end

isLimitBroken = function(craftEssence)
	local limitBreakRegion = Region(376 + xOffset, craftEssence:getY(), 16, CraftEssenceHeight)
	local limitBreakPattern = Pattern(GeneralImagePath .. "limitBroken.png"):similar(0.8)

	return limitBreakRegion:exists(limitBreakPattern)
end

-- "public" interface
init()
return {
	selectSupport = selectSupport
}
