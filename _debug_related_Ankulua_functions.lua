Settings:snapSet("OutputCaptureImg", true)
Settings:snapSet("OutputCropImg", true)
Settings:snapSet("OutputResizeImg", true)
Settings:snapSet("OutputRegImg", true)

test = getAppUsableScreenSize()
aaa = test:getX()
toast(aaa)
wait(3)
aaa = test:getY()
toast(aaa)
wait(3)

test = getRealScreenSize()
aaa = test:getX()
toast(aaa)
wait(3)
aaa = test:getY()
toast(aaa)
wait(3)

setImmersiveMode(true)
dir = scriptPath()
setImagePath(dir .. "image_JP")							   
Settings:setCompareDimension(true, 1280)
Settings:setScriptDimension(true, 2560)
--[[
recognize speed realated functions:
1.setScanInterval(1)
2.Settings:set("MinSimilarity", 0.5)
3.Settings:set("AutoWaitTimeout", 1)
4.usePreviousSnap(true)
5.resolution 1280
6.exists(var ,0)]]