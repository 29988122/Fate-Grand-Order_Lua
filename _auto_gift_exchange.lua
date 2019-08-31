-- settings
xOffset = 0
yOffset = 0

xDifferential = getAppUsableScreenSize():getX() / 1280
yDifferential = getAppUsableScreenSize():getY() / 720

if yDifferential > xDifferential then
    yOffset = ( getAppUsableScreenSize():getY() - ( xDifferential * 720 ) ) / xDifferential / 2
    Settings:setCompareDimension(true,1280)
    Settings:setScriptDimension(true,1280)
elseif yDifferential < xDifferential then
    xOffset = ( getAppUsableScreenSize():getX() - ( yDifferential * 1280 ) ) / yDifferential / 2
    Settings:setCompareDimension(false,720)
    Settings:setScriptDimension(false,720)
else
    Settings:setCompareDimension(true,1280)
    Settings:setScriptDimension(true,1280)
end

setImmersiveMode(true)
local dir = scriptPath()
setImagePath(dir .. "image_EN")

-- consts
local SpinClick = Location(417 + xOffset, 430 + yOffset)
local FinishedLotteryBoxRegion = Region(177 + xOffset, 411 + yOffset, 258, 151)
local FullPresentBoxRegion = Region(640 + xOffset, 360 + yOffset, 640, 360)
local ResetClick = Location(1100 + xOffset, 240 + yOffset)
local ResetConfirmationClick = Location(837 + xOffset, 561 + yOffset)
local ResetCloseClick = Location(635 + xOffset, 560 + yOffset)

-- script
local function spin()
	continueClick(SpinClick,620)
end

local function reset()
	click(ResetClick)
	wait(0.2)

	click(ResetConfirmationClick)
	wait(3)

	click(ResetCloseClick)
	wait(2)
end

while(true) do
	if FinishedLotteryBoxRegion:exists("lottery.png") then
		reset()
	elseif FullPresentBoxRegion:exists("StopGifts.png") then
		scriptExit("Present Box Full")
	else
		spin()
	end
end
