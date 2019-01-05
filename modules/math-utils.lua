local mathUtils = {}

function mathUtils.Truncate(number)
    local decimal_places = number % 1
    return number - decimal_places
end

return mathUtils