dir = scriptPath()
setImagePath(dir)
GameRegion = "EN"
package.path = package.path .. ";" .. dir .. 'modules/?.lua'

GeneralImagePath = "image_" .. GameRegion .. "/"
local IMAGE_WIDTH = 1280
local IMAGE_HEIGHT = 720
local SCRIPT_WIDTH = 2560
local SCRIPT_HEIGHT = 1440

-- imports
local scaling = require("scaling")
scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

-- consts
local SpinClick = Location(834, 860)
local FinishedLotteryBoxRegion = Region(500, 800, 250, 300)
local FullPresentBoxRegion = Region(1280, 720, 1280, 720)
local ResetClick = Location(2200, 480)
local ResetConfirmationClick = Location(1774, 1122)
local ResetCloseClick = Location(1270, 1120)

-- script
local function spin()
	continueClick(SpinClick,400)
end

local function reset()
	click(ResetClick)
	wait(0.5)

	click(ResetConfirmationClick)
	wait(3)

	click(ResetCloseClick)
	wait(2)
end

FinishedLotteryBoxPattern = Pattern(GeneralImagePath .. "lottery.png")
FinishedLotteryBoxPattern:similar(0.6)
FinishedLotteryBoxRegion:highlight(3)
setContinueClickTiming(50, 100)
while(true) do
	if FinishedLotteryBoxRegion:exists(FinishedLotteryBoxPattern) then
		reset()
	elseif FullPresentBoxRegion:exists(GeneralImagePath .. "StopGifts.png") then
		scriptExit("Present Box Full")
	else
		spin()
	end
end
