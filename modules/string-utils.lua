-- remove trailing and leading whitespace from string.
-- source: http://lua-users.org/wiki/CommonFunctions
local function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- check if string X starts with string Y
-- source: http://lua-users.org/wiki/StringRecipes
local function starts_with(str, start)
   return str:sub(1, #start) == start
end

return {
	trim = trim,
	starts_with = starts_with
}