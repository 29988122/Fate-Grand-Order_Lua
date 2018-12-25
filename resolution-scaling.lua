local xOffset = 0
local yOffset = 0

local function createOffsets()
        xDifferential = getAppUsableScreenSize():getX() / 2560
        yDifferential = getAppUsableScreenSize():getY() / 1440

        if yDifferential > xDifferential then
                yOffset = xDifferential * 1440 / 2
        elseif yDifferential < xDifferential then
                xOffset = yDifferential * 2560 / 2
        end
end

local function getYOffset()
        return yOffset
end

local function getXOffset()
        return xOffset
end

return
{
        createOffsets = createOffsets,
        getYOffset = getYOffset,
        getXOffset = getXOffset
}
