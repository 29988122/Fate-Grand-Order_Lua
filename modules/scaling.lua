local scaling = {}

local ankuluaUtils = require("ankulua-utils")
local mathUtils = require("math-utils")

local function DecideScaleMethod(originalWidth, originalHeight, desiredWidth, desiredHeight)
	local rateToScaleByWidth = desiredWidth / originalWidth
	local rateToScaleByHeight = desiredHeight / originalHeight

	if rateToScaleByWidth >= rateToScaleByHeight then
		return { ByWidth = true, Rate = rateToScaleByWidth }
	else
		return { ByWidth = false, Rate = rateToScaleByHeight }
	end
end

local function Scale(originalWidth, originalHeight, rate)
	return {
		Width = mathUtils.Truncate(originalWidth * rate),
		Height = mathUtils.Truncate(originalHeight * rate)
	}
end

local function CalculateBorderThickness(outer, inner)
	local size = math.abs(outer - inner)
	return mathUtils.Truncate(size / 2)
end

local function CalculateOffsets(gameWidth, gameHeight, scriptWidth, scriptHeight)
	local scaleMethod = DecideScaleMethod(gameWidth, gameHeight, scriptWidth, scriptHeight)
	local gameScaledToScript = Scale(gameWidth, gameHeight, scaleMethod.Rate)

	return {
		ByWidth = scaleMethod.ByWidth,
		X = CalculateBorderThickness(scriptWidth, gameScaledToScript.Width),
		Y = CalculateBorderThickness(scriptHeight, gameScaledToScript.Height),
	}
end

local function ApplyOffsetsToLocationOrRegion(lr, offsets)
	lr = ankuluaUtils.AddX(lr, offsets.X)
	lr = ankuluaUtils.AddY(lr, offsets.Y)

	return lr
end

local function ApplyOffsetsToTable(table, offsets)
	for key, value in pairs(table) do
		local type = ankuluaUtils.TypeOf(value)

		if type == "Location" or type == "Region" then
			table[key] = ApplyOffsetsToLocationOrRegion(value, offsets)
		elseif type == "table" then
			ApplyOffsetsToTable(value, offsets)
		end
	end
end

function scaling.ApplyAspectRatioFix(gameTable, scriptWidth, scriptHeight, imageWidth, imageHeight)
	local gameResolution = getRealScreenSize()
	local offsets = CalculateOffsets(gameResolution:getX(), gameResolution:getY(), scriptWidth, scriptHeight)

	if offsets.ByWidth then
		Settings:setCompareDimension(true, imageWidth)
		Settings:setScriptDimension(true, scriptWidth)
	else
		Settings:setCompareDimension(false, imageHeight)
		Settings:setScriptDimension(false, scriptHeight)
	end

    ApplyOffsetsToTable(gameTable, offsets)
    return gameTable
end

return scaling