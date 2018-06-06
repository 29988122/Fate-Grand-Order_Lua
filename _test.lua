dir = scriptPath()
setImagePath(dir .. "image_JP")
setImmersiveMode(true)			   
Settings:setCompareDimension(true,1280)
Settings:setScriptDimension(true,2560)

test = Region(1720,25,110,55)
-- test:save("_testround.png")

if  test:exists("_testround.png") ~= nil then
    toast("hi")
end

obj = test:find("_testround.png")
splash = obj:getScore()
toast(splash)
-- s = Region(1240,1060,200,200)
-- if s Region:exists("") == nil then
--     toast("hi I'm ok")
-- else
--     toast("not nil")
-- end