xOffset = 0
yOffset = 0

xDifferential = getAppUsableScreenSize():getX() / 2560
yDifferential = getAppUsableScreenSize():getY() / 1440

if yDifferential > xDifferential then
        yOffset = xDifferential * 1440 / 2
elseif yDifferential < xDifferential then
        xOffset = yDifferential * 2560 / 2
end

function getYOffset()
        return yOffset
end

function getXOffset()
        return xOffset
end
