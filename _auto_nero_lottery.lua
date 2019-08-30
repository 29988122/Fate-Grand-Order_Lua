xOffset = 0
yOffset = 0

xDifferential = getAppUsableScreenSize():getX() / 2560
yDifferential = getAppUsableScreenSize():getY() / 1440

if yDifferential > xDifferential then
    yOffset = ( getAppUsableScreenSize():getY() - ( xDifferential * 1440 ) ) / xDifferential / 2
    Settings:setCompareDimension(true,1280)
    Settings:setScriptDimension(true,2560)
elseif yDifferential < xDifferential then
    xOffset = ( getAppUsableScreenSize():getX() - ( yDifferential * 2560 ) ) / yDifferential / 2
    Settings:setCompareDimension(false,720)
    Settings:setScriptDimension(false,1440)
else
    Settings:setCompareDimension(true,1280)
    Settings:setScriptDimension(true,2560)
end

setImmersiveMode(true)
while(1) do
    click(Location(830 + xOffset,830 + yOffset))
end
