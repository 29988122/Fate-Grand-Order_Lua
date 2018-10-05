-- see http://ankulua.boards.net/thread/7/settings#snapshot
local function useSameSnapIn(func)
	snapshot()
	local value = func()
	usePreviousSnap(false)
	
	return value
end

return {
	useSameSnapIn = useSameSnapIn
}