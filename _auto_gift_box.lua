-- constants
local dir = scriptPath()
setImagePath(dir .. "image_JP")
package.path = package.path .. ";" .. dir .. 'modules/?.lua'

local IMAGE_WIDTH = 1280
local IMAGE_HEIGHT = 720
local SCRIPT_WIDTH = 1280
local SCRIPT_HEIGHT = 720

local scaling = require("scaling")
scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

local checkRegion = Region(820, 225, 60, 1050)
local clickCount = 0
local NACountRegionX = 420
local JPCountRegionX = 355
--*****************************************

-- user configuration
--stack size limitation for 4* EXP cards, any stacks with a size < threshold will be collected
local Gold_Threshold = 3
--either use NACountRegionX or JPCountRegionX
local Count_Region_X = NACountRegionX
local Max_Click_Count = 99
--*****************************************

-- script
local function checkGifts()
	for _, gift in ipairs(listToTable(checkRegion:findAll("Check.png"))) do
		countRegion = Region(Count_Region_X, gift:getY() - 50, 100, 30)
		iconRegion = Region(95, gift:getY() - 58, 115, 120)
		clickSpot = Location(850, gift:getY() + 25)
		if numberOCRNoFindException(countRegion, "Gift") < Gold_Threshold then
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
		{ action =      "wait", target = 0.5 }
	}
	
	--[[
	alternative values that work with navigation gestures turned on.
	read https://github.com/29988122/Fate-Grand-Order_Lua/pull/293 for more info
	
	local touchActions = {
		{ action = "touchDown", target = Location(700, 680) },
		{ action = "touchMove", target = Location(700, 130) },
		{ action =      "wait", target = 0.4 },
		{ action =   "touchUp", target = Location(700, 130) },
		{ action =      "wait", target = 0.5 }
	}
	--]]

	setManualTouchParameter(5, 10)
	manualTouch(touchActions)
end

while(clickCount < Max_Click_Count) do
	checkGifts()
	scrollList()
end
