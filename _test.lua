dir = scriptPath()
setImagePath(dir .. "image_CN")

s = Region(1240,1060,200,200)
if s Region:exists("") == nil then
    toast("hi I'm ok")
else
    toast("not nil")
end