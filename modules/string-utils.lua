local stringUtils = {}

-- remove trailing and leading whitespace from string.
-- source: http://lua-users.org/wiki/CommonFunctions
function stringUtils.Trim(s)
  -- from PiL2 20.4
  return s:gsub("^%s*(.-)%s*$", "%1")
end

-- check if string X starts with string Y
-- source: http://lua-users.org/wiki/StringRecipes
function stringUtils.StartsWith(str, start)
   return str:sub(1, #start) == start
end

return stringUtils