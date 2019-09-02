local api = require("pendragon/api")

local onStageChange

onStageChange = function()
 	local response = api.fetchCurrentStage("_GeneratedStageCounterSnapshot.png")
 	if (response.success) then
       return tonumber(response.message.stage)
    else
        scriptExit(string.format('[onStageChange] Fetch Current Stage API failed. (%s)', response.message))
    end
end


return {
	onStageChange = onStageChange
}