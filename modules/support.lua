-- modules
local game = require("game")
local stringUtils = require("string-utils")
local ankuluaUtils = require("ankulua-utils")

-- consts
local SupportImagePath = "image_SUPPORT" .. "/"
local CraftEssenceHeight = 90
local LimitBrokenCharacter = "*"

-- state vars
local PreferredServantArray = {}
local PreferredCraftEssenceTable = {}
local FriendNameArray = {}

-- functions
local init
local selectSupport
local selectFirst
local selectManual
local selectPreferred
local selectFriend
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
			value = stringUtils.Trim(value)

			if value:lower() ~= "any" then
				table.insert(values, value)
			end
		end

		return values
	end

	-- servants
	for _, servant in ipairs(split(Support_PreferredServants)) do
		servant = stringUtils.Trim(servant)
		table.insert(PreferredServantArray, servant)
	end

	-- craft essences
	for _, craftEssence in ipairs(split(Support_PreferredCEs)) do
		craftEssence = stringUtils.Trim(craftEssence)

		local craftEssenceEntry =
		{
			Name = craftEssence:gsub("%" .. LimitBrokenCharacter, ""),
			PreferLimitBroken = stringUtils.StartsWith(craftEssence, LimitBrokenCharacter)
		}

		table.insert(PreferredCraftEssenceTable, craftEssenceEntry)
	end
	
	-- friends
	for _, friend in ipairs(split(Support_FriendNames)) do
		friend = stringUtils.Trim(friend)
		table.insert(FriendNameArray, friend)
	end
end

selectSupport = function(selectionMode)
	while not game.SUPPORT_SCREEN_REGION:exists(GeneralImagePath .. "support_screen.png") do end
		if selectionMode == "first" then
			return selectFirst()

		elseif selectionMode == "manual" then
			selectManual()

		elseif selectionMode == "preferred" then
			local searchMethod = decideSearchMethod()
			return selectPreferred(searchMethod)

		elseif selectionMode =="friend" then
			return selectFriend()
		else
			scriptExit("Invalid support selection mode: \"" + selectionMode + "\".")
		end

	return false
end

selectFirst = function()
	click(game.SUPPORT_FIRST_SUPPORT_CLICK)
	--https://github.com/29988122/Fate-Grand-Order_Lua/issues/192 , band-aid fix but it's working well. 
	if game.SUPPORT_SCREEN_REGION:exists(GeneralImagePath .. "support_screen.png") then
		wait(2)
		while game.SUPPORT_SCREEN_REGION:exists(GeneralImagePath .. "support_screen.png")
		do
			wait(10)
			click(game.SUPPORT_UPDATE_CLICK)
			wait(1)
			click(game.SUPPORT_UPDATE_YES_CLICK)
			wait(3)
			click(game.SUPPORT_FIRST_SUPPORT_CLICK)
			wait(1)
		end
	end
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

			click(game.SUPPORT_UPDATE_CLICK)
			wait(1)
			click(game.SUPPORT_UPDATE_YES_CLICK)
			wait(3)

			numberOfUpdates = numberOfUpdates + 1
			numberOfSwipes = 0

		else -- okay, we have run out of options, let's give up
			click(game.SUPPORT_LIST_TOP_CLICK)
			return selectSupport(Support_FallbackTo)
		end
	end
end

selectFriend = function()
	local numberOfSwipes = 0
	local numberOfUpdates = 0
	
	while(true)
	do
		local result, support = searchFriends()
		if result == "ok" then
			click( support )
			
		elseif result == "not-found" and numberOfSwipes < Support_SwipesPerUpdate then
			scrollList()
			numberOfSwipes = numberOfSwipes + 1
			wait(0.3)
	
		elseif numberOfUpdates < Support_MaxUpdates then
			toast("Support list will be updated in 3 seconds.")
			wait(3)
			
			click(game.SUPPORT_UPDATE_CLICK)
			wait(1)
			click(game.SUPPORT_UPDATE_YES_CLICK)
			wait(3)

			numberOfUpdates = numberOfUpdates + 1
			numberOfSwipes = 0
			
		else
			click(game.SUPPORT_LIST_TOP_CLICK)
			return selectSupport(Support_FallbackTo)
		end
	end
end

scrollList = function()
	local touchActions = {
		{ action = "touchDown", target = game.SUPPORT_SWIPE_START_CLICK },
		{ action = "touchMove", target = game.SUPPORT_SWIPE_END_CLICK },
		{ action =      "wait", target = 0.4 },
		{ action =   "touchUp", target = game.SUPPORT_SWIPE_END_CLICK },
		{ action =      "wait", target = 0.5 } -- leaving some room for animations to finish
	}

	-- the movement has to be as accurate as possible
	setManualTouchParameter(5, 5)
	manualTouch(touchActions)
end

searchVisible = function(searchMethod)
	local function performSearch()
		if not isFriend(game.SUPPORT_FRIEND_REGION) then
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
	return unpack(ankuluaUtils.UseSameSnapIn(performSearch))
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
		return findCraftEssence(game.SUPPORT_LIST_REGION)
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
		for _, servant in ipairs(regionFindAllNoFindException(game.SUPPORT_LIST_REGION, Pattern(SupportImagePath .. preferredServant))) do
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
	for _, supportBounds in ipairs(game.SUPPORT_LIST_ITEM_REGION_ARRAY) do
		if ankuluaUtils.DoesRegionContain(supportBounds, support) then
			return supportBounds
		end
	end

	-- we're not supposed to end down here, but if we do, there's probably something wrong with SUPPORT_LIST_ITEM_REGION_ARRAY or SUPPORT_LIST_REGION
	local message = "The Servant or Craft Essence (X: %i, Y: %i, Width: %i, Height: %i) is not contained in SUPPORT_LIST_ITEM_REGION_ARRAY."
	error(message:format(support:getX(), support:getY(), support:getW(), support:getH()))
end

isFriend = function(region)
	local friendPattern = Pattern(GeneralImagePath .. "friend.png")
	return Support_FriendsOnly == 0 or region:exists(friendPattern)
end

isLimitBroken = function(craftEssence)
	local limitBreakRegion = ankuluaUtils.SetY(game.SUPPORT_LIMIT_BREAK_REGION, craftEssence:getY())
	local limitBreakPattern = Pattern(GeneralImagePath .. "limitBroken.png"):similar(0.8)

	return limitBreakRegion:exists(limitBreakPattern)
end

searchFriends = function()
		local function performSearch()
		
		if not isFriend(game.SUPPORT_FRIEND_REGION) then
			return {"no-friends-at-all"} -- no friends on screen, so there's no point in scrolling anymore
		end

		local support = findFriendName()
		if support == nil then
			return {"not-found"} -- nope, not found this time. keep scrolling
		end

		return {"ok", support}
	end

	-- see https://www.lua.org/pil/5.1.html for details on "unpack"
	return unpack(ankuluaUtils.UseSameSnapIn(performSearch))
end

findFriendName = function()
	local friends = {}

	for _, preferredServant in ipairs(PreferredServantArray) do
		for _, theFriend in ipairs(regionFindAllNoFindException(game.SUPPORT_FRIENDS_REGION, Pattern(SupportImagePath .. friend))) do
			table.insert(friends, theFriend)
		end
	end

	return friends[1]
end

-- "public" interface
init()
return {
	selectSupport = selectSupport
}
