Settings:setCompareDimension(true,1280)
Settings:setScriptDimension(true,2560)
dir = scriptPath()

--You can change this to either "image_EN" or "image_JP" for Japan and US server to support auto gift exchange AND auto reset.
setImagePath(dir .. "image_JP")

finishedLotteryBoxRegion = Region(540, 840, 120, 220)

while(1) do
    if finishedLotteryBoxRegion:exists("lottery.png", 0) then
		click(Location(2200, 500))
		wait(0.2)
		click(Location(1600, 1150))
		wait(1.5)
		click(Location(1200, 1150))
		wait(0.2)	
	end
    click(Location(900,900))
end