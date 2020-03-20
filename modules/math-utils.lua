local mathUtils = {}

--  source: https://stackoverflow.com/a/36798347/4276186
function mathUtils.Truncate(number)
	local decimalPlaces = number % 1
	return number - decimalPlaces
end

-- source: http://lua-users.org/wiki/SimpleRound
function mathUtils.Round(number)
	local roundedAsString = string.format("%.0f", number)
	return tonumber(roundedAsString)
end

return mathUtils