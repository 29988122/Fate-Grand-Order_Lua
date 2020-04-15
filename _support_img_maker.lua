dir = scriptPath()
package.path = package.path .. ";" .. dir .. 'modules/?.lua'
setImagePath(dir)

local ankuluaUtils = require("ankulua-utils")
local scaling = require("scaling")
local game = require("game")

GameRegion = "EN"
GeneralImagePath = "image_" .. GameRegion .. "/"

local IMAGE_WIDTH = 1280
local IMAGE_HEIGHT = 720
local SCRIPT_WIDTH = 2560
local SCRIPT_HEIGHT = 1440

scaling.ApplyAspectRatioFix(SCRIPT_WIDTH, SCRIPT_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT)

-- Single screenshot is enough
snapshot()

--Checks if Support Selection menu is up
local isSupportScreen =	game.SUPPORT_SCREEN_REGION:exists(Pattern(GeneralImagePath .. "support_screen.png"):similar(.85))

local supportBound = Region(106,0,286,220)
local regionAnchor = Pattern(GeneralImagePath .. "support_region_tool.png")
local regionArray = regionFindAllNoFindException(Region(2100,0,300,1440), regionAnchor)
local screenBounds = Region(0,0,SCRIPT_WIDTH,SCRIPT_HEIGHT)

local datetime = os.date('%Y%m%d-%H%M%S')
local folder = 'support_' .. datetime .. '/'
os.execute('mkdir ' .. dir .. '/' .. folder)

local i = 0

for _, testRegion in ipairs(regionArray) do
  -- At max two Servant+CE are completely on screen
  if i > 1 then
    break
  end

  if isSupportScreen then
    supportBound:setY(testRegion:getY() - 70 + 68 * 2)
  else -- Assume we are on Friend List
    supportBound:setY(testRegion:getY() + 82)
    supportBound = ankuluaUtils.AddX(supportBound, 10)
  end

  if ankuluaUtils.DoesRegionContain(screenBounds, supportBound) then
    local servantBound = Region(supportBound:getX(), supportBound:getY(), 250, 88)
    servantBound:save(folder .. 'servant_' .. i .. '.png')

    local ceBound = Region(supportBound:getX(), supportBound:getY() + 160, supportBound:getW(), 50)
    ceBound:save(folder .. 'ce_' .. i .. '.png')

    i = i + 1
  end
end

if i == 0 then
  scriptExit("No support images were found on the current screen")
else
  scriptExit(i .. " Servant and CE images have been stored in the  folder '" .. folder .. "'")
end
