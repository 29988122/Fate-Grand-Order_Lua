local scaling = {}

local ankuluaUtils = require("ankulua-utils")
local mathUtils = require("math-utils")

local function DecideScaleToFitRate(originalWidth, originalHeight, desiredWidth, desiredHeight)
	local rateToScaleByWidth = desiredWidth / originalWidth
	local rateToScaleByHeight = desiredHeight / originalHeight

	return math.min(rateToScaleByWidth, rateToScaleByHeight)
end

local function Scale(originalWidth, originalHeight, rate)
	return {
		Width = mathUtils.Round(originalWidth * rate),
		Height = mathUtils.Round(originalHeight * rate)
	}
end

local function CalculateBorderThickness(outer, inner)
	local size = math.abs(outer - inner)
	return mathUtils.Round(size / 2)
end

local function CalculateGameRegionWithoutBorders(scriptWidth, scriptHeight, screenWidth, screenHeight)
	local rate = DecideScaleToFitRate(scriptWidth, scriptHeight, screenWidth, screenHeight)
	local scriptScaledToScreen = Scale(scriptWidth, scriptHeight, rate)

	return Region(
		CalculateBorderThickness(screenWidth, scriptScaledToScreen.Width), -- Offset (X)
		CalculateBorderThickness(screenHeight, scriptScaledToScreen.Height), -- Offset (Y)
		scriptScaledToScreen.Width, -- Game width (without borders)
		scriptScaledToScreen.Height -- Game height (without borders)
	)
end

local function ApplyNotchOffset(region, notchOffset)
	return ankuluaUtils.AddX(region, notchOffset)
end

function scaling.ApplyAspectRatioFix(scriptWidth, scriptHeight)
	setImmersiveMode(true)
	autoGameArea(true)
	
	local gameWithBorders = getGameArea()
	local gameWithoutBorders = CalculateGameRegionWithoutBorders(scriptWidth, scriptHeight, gameWithBorders:getW(), gameWithBorders:getH())
	local gameWithoutBordersAndNotch = ApplyNotchOffset(gameWithoutBorders, gameWithBorders:getX())

    setGameArea(gameWithoutBordersAndNotch)
end

return scaling