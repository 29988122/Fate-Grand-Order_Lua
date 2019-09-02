local ankuluaUtils = {}

-- determines if a match is completely contained in a region
-- algorithm taken from https://referencesource.microsoft.com/#System.Drawing/commonui/System/Drawing/Rectangle.cs,366
function ankuluaUtils.DoesRegionContain(region, match)
	return region:getX() <= match:getX()
		and match:getX() + match:getW() <= region:getX() + region:getW()

		and region:getY() <= match:getY()
		and match:getY() + match:getH() <= region:getY() + region:getH()
end

-- see http://ankulua.boards.net/thread/7/settings#snapshot
function ankuluaUtils.UseSameSnapIn(func)
	snapshot()
	local value = func()
	usePreviousSnap(false)

	return value
end

-- an improved version of AnkuLua's original typeOf()
-- this one also works on normal Lua objects, like tables
-- Lua's built-in type() function is not available in AnkuLua
function ankuluaUtils.TypeOf(object)
    local type = typeOf(object)
    if type == "userdata" then
        type = object:typeOf()
    end
	
    return type
end

-- AnkuLua unfortunately doesn't provide Sikuli's setX() and setY() as of 2019-01-04
-- these can be replaced later on if they are added to the official framework
local function ThrowUnsupportedObjectTypeError(type)
	error("Unsupported object type: " .. type)
end

function ankuluaUtils.SetX(original, x)
	local type = ankuluaUtils.TypeOf(original)

	if type == "Location" then
		return Location(x, original:getY())
	elseif type == "Region" then
		return Region(x, original:getY(), original:getW(), original:getH())
	else
		ThrowUnsupportedObjectTypeError(type)
	end
end

function ankuluaUtils.AddX(original, x)
	return ankuluaUtils.SetX(original, original:getX() + x)
end

function ankuluaUtils.SetY(original, y)
	local type = ankuluaUtils.TypeOf(original)

	if type == "Location" then
		return Location(original:getX(), y)
	elseif type == "Region" then
		return Region(original:getX(), y, original:getW(), original:getH())
	else
		ThrowUnsupportedObjectTypeError(type)
	end
end

function ankuluaUtils.AddY(original, y)
	return ankuluaUtils.SetY(original, original:getY() + y)
end

return ankuluaUtils