setImagePath(dir)

local function ApplyDefaults()
	local Defaults =
	{
		BoostItem_SelectionMode = "disabled",
		Story_Skip = 0,
		Debug_Mode = false,
		StopAfterBond10 = 0,
		UnstableFastSkipDeadAnimation = 0,
		Withdraw_Enabled = false,

		GameRegion = "EN",

		Refill_Enabled = 0,
		Refill_Resource = "All Apples",
		Refill_Repetitions = 0,

		Party_Number = nil,
		Support_SelectionMode = "first",
		Support_SwipesPerUpdate = 10,
		Support_MaxUpdates = 3,
		Support_FallbackTo = "manual",
		Support_FriendsOnly = 0,
		Support_FriendNames = "",
		Support_PreferredServants = "",
		Support_PreferredCEs = "",

		Enable_Autoskill = 0,
		Skill_Confirmation = 0,
		Autoskill_List = { },

		Battle_CardPriority = "BAQ",
		Battle_AutoChooseTarget = 1,
		Battle_NoblePhantasm = "disabled"
	}

	for key, defaultValue in pairs(Defaults) do
		globalValue = _G[key]
		
		if globalValue == nil then
			_G[key] = defaultValue
		end
	end
end

-- Writes autoskill options into global variables
local function ExtractAutoskillOptions(selected_autoskill)
	for key, value in pairs(selected_autoskill) do
		-- We don't want to make Name a global variable
		if key ~= "Name" then
			-- _G is global variable table
			_G[key] = value
		end
	end
end

local function AddRefillInfoToDialog()
	if Refill_Enabled == 1 then
		if Refill_Resource == "SQ" then
			RefillType = "sq"
		elseif Refill_Resource == "All Apples" then
			RefillType = "all apples"
		elseif Refill_Resource == "Gold" then
			RefillType = "gold apples"
		elseif Refill_Resource == "Silver" then
			RefillType = "silver apples"
		else
			RefillType = "bronze apples"
		end
		addTextView("Auto Refill Enabled:")
		newRow()
		addTextView("You are going to use")
		newRow()
		addTextView(Refill_Repetitions .. " " .. RefillType .. ", ")
		newRow()
		addTextView("remember to check those values everytime you execute the script!")
		addSeparator()
	end
end

local function AddAutoskillListToDialog()
	-- Autoskill list dialogue content generation.
	if Enable_Autoskill == 1 then
		addTextView("Please select your predefined Autoskill setting:")
		newRow()
		addRadioGroup("AutoSkillIndex", 1)

		for key, value in ipairs(Autoskill_List) 
		do
			addRadioButton(value["Name"], key)
		end
	end
end

--User option PSA dialogue. Also choosable list of perdefined skill.
function PSADialogue()
	dialogInit()

	AddRefillInfoToDialog()
	AddAutoskillListToDialog()  

	--Show the generated dialogue.
	dialogShow("CAUTION")

	if Enable_Autoskill == 1 then
		--Put user selection into variables
		local selected_autoskill = Autoskill_List[AutoSkillIndex]

		ExtractAutoskillOptions(selected_autoskill)
	else
		addTextView("AutoSkill is disabled, the script will battle automatically.")
	end
end

ApplyDefaults()
PSADialogue()

dofile(dir .. "regular.lua")
