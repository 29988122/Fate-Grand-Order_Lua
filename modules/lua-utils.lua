local luaUtils = {}

-- algorithm taken from https://stackoverflow.com/a/41350070/4276186
local function ReverseIterator(table, i)
	i = i - 1
	
	if i > 0 then
		return i, table[i]
	end
end

function luaUtils.Reverse(table)
	return ReverseIterator, table, #table + 1
end

return luaUtils