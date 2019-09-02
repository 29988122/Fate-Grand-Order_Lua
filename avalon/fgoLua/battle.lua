local onStageChange

onStageChange = function(currentStage)
	return currentStage + 1
end

return {
	onStageChange = onStageChange
}