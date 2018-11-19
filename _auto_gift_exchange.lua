-- settings
setImmersiveMode(true)
Settings:setCompareDimension(true, 1280)
Settings:setScriptDimension(true, 1280)
local dir = scriptPath()
setImagePath(dir .. "image_EN")

-- consts
local SpinClick = Location(417, 476)
local FinishedLotteryBoxRegion = Region(177, 411, 258, 151)
local ResetClick = Location(1100, 240)
local ResetConfirmationClick = Location(837, 561)
local ResetCloseClick = Location(635, 560)

-- script
local function spin()
	for i = 1, 10 do
		click(SpinClick)
	end
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
	if FinishedLotteryBoxRegion:exists("lottery.png", 0) then
		reset()
	else
		spin()
	end
end