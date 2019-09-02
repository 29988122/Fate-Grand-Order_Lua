local scaling = {}

local ankuluaUtils = require("ankulua-utils")
local mathUtils = require("math-utils")

local function DecideScaleMethod(originalWidth, originalHeight, desiredWidth, desiredHeight)
	local rateToScaleByWidth = desiredWidth / originalWidth
	local rateToScaleByHeight = desiredHeight / originalHeight

	if rateToScaleByWidth <= rateToScaleByHeight then
		return { ByWidth = true, Rate = rateToScaleByWidth }
	else
		return { ByWidth = false, Rate = rateToScaleByHeight }
	end
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

local function CalculateGameAreaWithoutBorders(scriptWidth, scriptHeight, screenWidth, screenHeight, scaleRate)
	local scriptScaledToScreen = Scale(scriptWidth, scriptHeight, scaleRate)

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

function scaling.ApplyAspectRatioFix(scriptWidth, scriptHeight, imageWidth, imageHeight)
	setImmersiveMode(true)
	autoGameArea(true)

	local gameWithBorders = getGameArea()
	local scaleMethod = DecideScaleMethod(scriptWidth, scriptHeight, gameWithBorders:getW(), gameWithBorders:getH())	
	local gameWithoutBorders = CalculateGameAreaWithoutBorders(scriptWidth, scriptHeight, gameWithBorders:getW(), gameWithBorders:getH(), scaleMethod.Rate)
	local gameWithoutBordersAndNotch = ApplyNotchOffset(gameWithoutBorders, gameWithBorders:getX())
	setGameArea(gameWithoutBordersAndNotch)

	if scaleMethod.ByWidth then
		Settings:setScriptDimension(true, scriptWidth)
		Settings:setCompareDimension(true, imageWidth)
	else
		Settings:setScriptDimension(false, scriptHeight)
		Settings:setCompareDimension(false, imageHeight)
	end
end

return scaling