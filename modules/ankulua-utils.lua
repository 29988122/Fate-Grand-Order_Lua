-- determines if a match is completely contained in a region
-- algorithm taken from https://referencesource.microsoft.com/#System.Drawing/commonui/System/Drawing/Rectangle.cs,366
local function doesRegionContain(region, match)
	return region:getX() <= match:getX()
		and match:getX() + match:getW() <= region:getX() + region:getW()
		
		and region:getY() <= match:getY()
		and match:getY() + match:getH() <= region:getY() + region:getH()
end

-- see http://ankulua.boards.net/thread/7/settings#snapshot
local function useSameSnapIn(func)
	snapshot()
	local value = func()
	usePreviousSnap(false)
	
	return value
end

return {
	doesRegionContain = doesRegionContain,
	useSameSnapIn = useSameSnapIn
}