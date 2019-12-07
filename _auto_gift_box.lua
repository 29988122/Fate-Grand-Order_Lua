-- settings
setImmersiveMode(true)
Settings:setCompareDimension(true,1280)
Settings:setScriptDimension(true,1280)
local dir = scriptPath()
setImagePath(dir .. "image_JP")

-- consts
local checkRegion = Region(820, 225, 60, 1050)
local clickCount = 0
local goldThreshold = 3


-- script
local function checkGifts()
	for _, gift in ipairs(listToTable(checkRegion:findAll("Check.png"))) do
		countRegion = Region(355, gift:getY() - 50, 100, 30)
		iconRegion = Region(95, gift:getY() - 58, 115, 120)
		clickSpot = Location(850, gift:getY() + 25)
		if numberOCRNoFindException(countRegion, "Gift") < goldThreshold then
			click(clickSpot)
			clickCount = clickCount + 1
		else
			if iconRegion:exists("GoldXP.png") then
			else
				click(clickSpot)
				clickCount = clickCount + 1
			end
		end
	end
end

local function scrollList()
	local touchActions = {
		{ action = "touchDown", target = Location(700, 700) },
		{ action = "touchMove", target = Location(700, 175) },
		{ action =      "wait", target = 0.4 },
		{ action =   "touchUp", target = Location(700, 175) },
		{ action =      "wait", target = 0.5 } -- leaving some room for animations to finish
	}

	-- the movement has to be as accurate as possible
	setManualTouchParameter(5, 10)
	manualTouch(touchActions)
end

while(clickCount < 99) do
	checkGifts()
	scrollList()
end
