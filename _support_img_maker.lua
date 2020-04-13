dir = scriptPath()
package.path = package.path .. ";" .. dir .. 'modules/?.lua'
setImagePath(dir)

local ankuluaUtils = require("ankulua-utils")
local scaling = require("scaling")

GameRegion = "EN"
GeneralImagePath = "image_" .. GameRegion .. "/"

local IMAGE_WIDTH = 1280
local IMAGE_HEIGHT = 720
local SCRIPT_WIDTH = 2560
local SCRIPT_HEIGHT = 1440

scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

-- Single screenshot is enough
snapshot()

local supportBound = Region(106,0,286,220)
local regionAnchor = Pattern(GeneralImagePath .. "support_region_tool.png")
local regionArray = regionFindAllNoFindException(Region(2100,0,300,1440), regionAnchor)
local screenBounds = Region(0,0,SCRIPT_WIDTH,SCRIPT_HEIGHT)

local i = 0

for _, testRegion in ipairs(regionArray) do
  -- At max two Servant+CE are completely on screen
  if i > 1 then
    break
  end

  supportBound:setY(testRegion:getY() - 70 + 68 * 2)

  if ankuluaUtils.DoesRegionContain(screenBounds, supportBound) then
    local servantBound = Region(supportBound:getX(), supportBound:getY(), 250, 88)
    servantBound:save('servant_' .. i .. '.png')

    local ceBound = Region(supportBound:getX(), supportBound:getY() + 160, supportBound:getW(), 60)
    ceBound:save('ce_' .. i .. '.png')

    i = i + 1
  end
end