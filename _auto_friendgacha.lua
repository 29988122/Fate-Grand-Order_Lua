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

setContinueClickTiming(50, 100)
setImmersiveMode(true)
click(Location(1400 + xOffset,1120 + yOffset))
click(Location(1600 + xOffset,1120 + yOffset))
while(1) do
    click(Location(1600 + xOffset,1120 + yOffset))
    wait(0.3)
    click(Location(1600 + xOffset,1120 + yOffset))
    wait(3)
    continueClick(Location(1660 + xOffset,1300 + yOffset), 20)
    wait(0.5)
end
