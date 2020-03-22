setImagePath(dir)

local function SetSupportOptions(selected_autoskill)
  if selected_autoskill["Support_SelectionMode"] ~= nil then
    Support_SelectionMode = selected_autoskill["Support_SelectionMode"]
  end

  if selected_autoskill["Support_SwipesPerUpdate"] ~= nil then
    Support_SwipesPerUpdate = selected_autoskill["Support_SwipesPerUpdate"]
  end

  if selected_autoskill["Support_MaxUpdates"] ~= nil then
    Support_MaxUpdates = selected_autoskill["Support_MaxUpdates"]
  end

  if selected_autoskill["Support_FallbackTo"] ~= nil then
    Support_FallbackTo = selected_autoskill["Support_FallbackTo"]
  end

  if selected_autoskill["Support_FriendsOnly"] ~= nil then
    Support_FriendsOnly = selected_autoskill["Support_FriendsOnly"]
  end

  if selected_autoskill["Support_FriendNames"] ~= nil then
    Support_FriendNames = selected_autoskill["Support_FriendNames"]
  end

  if selected_autoskill["Support_PreferredServants"] ~= nil then
    Support_PreferredServants = selected_autoskill["Support_PreferredServants"]
  end

  if selected_autoskill["Support_PreferredCEs"] ~= nil then
    Support_PreferredCEs = selected_autoskill["Support_PreferredCEs"]
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
    Skill_Command = selected_autoskill["Skill_Command"]

    SetSupportOptions(selected_autoskill)
  end
end

PSADialogue()

dofile(dir .. "regular.lua")