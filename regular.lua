--[[このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
	私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
	お願いします。このプログラムを禁止しないでください。]]

--Main loop, pattern detection regions.
--Click pos are hard-coded into code, unlikely to change in the future.
MenuRegion = Region(2100,1200,1000,1000)
BattleRegion = Region(2200,200,1000,600)
ResultRegion = Region(100,300,700,200)
BondRegion = Region(2000,820,120,120)
QuestrewardRegion = Region(1630,140,370,250)
StaminaRegion = Region(600,200,300,300)

SupportScreenRegion = Region(0,0,110,332)
SupportListRegion = Region(0,334,2443,1107)
SupportListTopClick = Location(2480,360)
SupportUpdateClick = Location(1670, 250)
SupportUpdateYesClick = Location(1660, 1110)

StoneClick = (Location(1270,340))
AppleClick = (Location(1270,640))

--Weak, resist, etc. Compatiable for most server, but tricky, frequently fail.
Card1AffinRegion = Region( 295,650,250,200)
Card2AffinRegion = Region( 810,650,250,200)
Card3AffinRegion = Region(1321,650,250,200)
Card4AffinRegion = Region(1834,650,250,200)
Card5AffinRegion = Region(2348,650,250,200)

CardAffinRegionArray = {Card1AffinRegion, Card2AffinRegion, Card3AffinRegion, Card4AffinRegion, Card5AffinRegion}

--Buster, Art, Quick, etc.
Card1TypeRegion = Region(200,1060,200,200)
Card2TypeRegion = Region(730,1060,200,200)
Card3TypeRegion = Region(1240,1060,200,200)
Card4TypeRegion = Region(1750,1060,200,200)
Card5TypeRegion = Region(2280,1060,200,200)

CardTypeRegionArray = {Card1TypeRegion, Card2TypeRegion, Card3TypeRegion, Card4TypeRegion, Card5TypeRegion}

--*Rough* damage calculation by formula, you may tinker these to change card selection priority.
--https://pbs.twimg.com/media/C2nSYxcUoAAy_F2.jpg
WeakMulti = 2.0
NormalMulti = 1.0
ResistMulti = 0.5

BCard = 150
ACard = 100
QCard = 80

ResistBuster =  BCard * ResistMulti
ResistArt = ACard * ResistMulti
ResistQuick = QCard * ResistMulti

WeakBuster = BCard * WeakMulti
WeakArt = ACard * WeakMulti
WeakQuick = QCard * WeakMulti

--User customizable BAQ selection priority.
CardPriorityArray = {}

--Card selection pos for click, and array for AutoSkill.
Card1Click = (Location(300,1000))
Card2Click = (Location(750,1000))
Card3Click = (Location(1300,1000))
Card4Click = (Location(1800,1000))
Card5Click = (Location(2350,1000))

CardClickArray = {Card1Click, Card2Click, Card3Click, Card4Click, Card5Click}

--*Primitive* ways to spam NPs after priority target appeared in battle. IT WILL override autoskill NP skill. Check function ultcard()
Ultcard1Click = (Location(1000,220))
Ultcard2Click = (Location(1300,400))
Ultcard3Click = (Location(1740,400))

--Priority target detection region and selection region.
Target1Type = Region(0,0,485,220)
Target2Type = Region(485,0,482,220)
Target3Type = Region(967,0,476,220)
Target1Click = (Location(90,80))
Target2Click = (Location(570,80))
Target3Click = (Location(1050,80))

--[[For future use:
	NpbarRegion = Region(280,1330,1620,50)
	Ultcard1Region = Region(900,100,200,200)
	Ultcard2Region = Region(1350,100,200,200)
	Ultcard3Region = Region(1800,100,200,200)]]

--Autoskill click regions.
Skill1Click = (Location(140,1160))
Skill2Click = (Location(340,1160))
Skill3Click = (Location(540,1160))

Skill4Click = (Location(770,1160))
Skill5Click = (Location(970,1160))
Skill6Click = (Location(1140,1160))

Skill7Click = (Location(1400,1160))
Skill8Click = (Location(1600,1160))
Skill9Click = (Location(1800,1160))

Master1Click = (Location(1820,620))
Master2Click = (Location(2000,620))
Master3Click = (Location(2160,620))

Servant1Click = (Location(700,880))
Servant2Click = (Location(1280,880))
Servant3Click = (Location(1940,880))

--Autoskill related variables, check function decodeSkill(str, isFirstSkill).
SkillClickArray = {Skill1Click, Skill2Click, Skill3Click, Skill4Click, Skill5Click, Skill6Click, Skill7Click, Skill8Click, Skill9Click, Master1Click, Master2Click, Master3Click}
SkillClickArray[-47] = Servant1Click
SkillClickArray[-46] = Servant2Click
SkillClickArray[-45] = Servant3Click
SkillClickArray[-44] = Ultcard1Click
SkillClickArray[-43] = Ultcard2Click
SkillClickArray[-42] = Ultcard3Click

StageSkillArray = {}
StageSkillArray[1] = {}
StageSkillArray[2] = {}
StageSkillArray[3] = {}
StageSkillArray[4] = {}
StageSkillArray[5] = {}

StartingMember1Click = (Location(280,700))
StartingMember2Click = (Location(680,700))
StartingMember3Click = (Location(1080,700))
StartingMemberClickArray = {}
StartingMemberClickArray[-47] = StartingMember1Click
StartingMemberClickArray[-46] = StartingMember2Click
StartingMemberClickArray[-45] = StartingMember3Click

SubMember1Click = (Location(1480,700))
SubMember2Click = (Location(1880,700))
SubMember3Click = (Location(2280,700))
SubMemberClickArray = {}
SubMemberClickArray[-47] = SubMember1Click
SubMemberClickArray[-46] = SubMember2Click
SubMemberClickArray[-45] = SubMember3Click

--Autoskill and Autoskill exception handling related, waiting for cleanup.
decodeSkill_NPCasting = 0
stageCount = 1
stageTurnArray = {0, 0, 0, 0, 0}
turnCounter = {0, 0, 0, 0, 0}
MysticCode_OrderChange = 0

--Wait for cleanup variables and its respective functions, my messed up code^TM.
atkround = 1

--TBD:Autoskill execution optimization, switch target during Autoskill, Do not let Targetchoose().ultcard() interfere with Autoskill. 

--[[recognize speed realated functions:
	1.setScanInterval(1)
	2.Settings:set("MinSimilarity", 0.5)
	3.Settings:set("AutoWaitTimeout", 1)
	4.usePreviousSnap(true)
	5.resolution 1280
	6.exists(var ,0)]]

function initCardPriorityArray()
	--[[Considering:
	Battle_CardPriority = "BAQ"
	then:
	CardPriorityArray = {"WB", "B", "RB", "WA", "A", "RA", "WQ", "Q", "RQ"}]]
	local count = 0
	for card in Battle_CardPriority:gmatch(".") do
		table.insert(CardPriorityArray, "W" .. card)
		table.insert(CardPriorityArray, card)
		table.insert(CardPriorityArray, "R" .. card)
		
		count = count + 1
	end
end

function init()
	setImmersiveMode(true)			   
	Settings:setCompareDimension(true,1280)
	Settings:setScriptDimension(true,2560)
	
	--Set only ONCE for every separated script run.
	initCardPriorityArray()
	StoneUsed = 0
	PSADialogueShown = 0
	
	--Check function CheckCurrentStage(region)
	StageCounter = 1
end

init()

function menu()
    atkround = 1
    decodeSkill_NPCasting = 0
	turnCounter = {0, 0, 0, 0, 0}
	
	--Click uppermost quest.
    click(Location(1900,400))
	wait(1.5)
	
	--Auto refill.
    if Refill_or_Not == 1 and StoneUsed < How_Many then
        RefillStamina()
	end
	
	--Friend selection.
	local hasSelectedSupport = selectSupport(Support_SelectionMode)
	if hasSelectedSupport then
		wait(1.5)
		startQuest()
	end
end

function RefillStamina()
    if StaminaRegion:exists("stamina.png", 0) then
        if Use_Stone == 1 then
			click(StoneClick)
			toast("Auto Refilling Stamina")
	    	wait(1.5)
            click(Location(1650,1120))
            StoneUsed = StoneUsed + 1
        else
			click(AppleClick)
			toast("Auto Refilling Stamina")
	    	wait(1.5)
            click(Location(1650,1120))
            StoneUsed = StoneUsed + 1
        end
		wait(3)
		if NotJPserverForStaminaRefillExtraClick == nil then
			--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
			click(Location(1900,400))
			wait(1.5)
		end
    end
end

function selectSupport(selectionMode)
	if SupportScreenRegion:exists("support_screen.png") then
		if selectionMode == "first" then
			return selectFirstSupport()
		elseif selectionMode == "preferred" then
			return selectPreferredSupport()
		elseif selectionMode == "manual" then
			scriptExit("Support selection mode set to \"manual\".")
		else
			scriptExit("Invalid support selection mode: \"" + selectionMode + "\".")
		end
	end

	return false
end

function selectFirstSupport()
	click(Location(1900,500))
	return true
end

function selectPreferredSupport()
	local numberOfSwipes = 0
	local numberOfUpdates = 0
	
	while (true)
	do
		local supports = regionFindAllNoFindException(SupportListRegion, Support_PreferredImage)
		for i, support in ipairs(supports) do
			click(support)
			return true -- found
		end

		if numberOfSwipes < Support_SwapsPerRefresh then
			swipe(Location(1200, 1150), Location(1200, 800))			
			numberOfSwipes = numberOfSwipes + 1
		elseif numberOfUpdates < Support_MaxRefreshes then		
			click(SupportUpdateClick)
			wait(1)
			click(SupportUpdateYesClick)
			wait(3)

			numberOfUpdates = numberOfUpdates + 1
			numberOfSwipes = 0
		else -- not found :(
			click(SupportListTopClick)
			return selectSupport(Support_FallbackTo)
		end
	end
end

function startQuest()
	click(Location(2400,1350))
end

function battle()
	wait(2.5)
	InitForCheckCurrentStage()

	--TBD: counter not used, will replace atkround.
	local RoundCounter = 1
	
	if TargetChoosen ~= 1 then
		--Choose priority target for NP spam and focuse fire.
		TargetChoose()
	end
	
    wait(0.5)
    if Enable_Autoskill == 1 then
		executeSkill()
    end
	
	--From TargetChoose() to executeSKill().CheckCurrentStage(), the same snapshot is used.
	usePreviousSnap(false)
	
    wait(0.5)
	if decodeSkill_NPCasting == 0 then
		--enter card selection screen
    	click(Location(2300,1200))
    	wait(1)
	end
    
    if TargetChoosen == 1 and decodeSkill_NPCasting == 0 then
        ultcard()
    end

    wait(0.5)
	doBattleLogic()
	--From checkCardAffin(region) to checkCardType(region), the same snapshot is used.
    usePreviousSnap(false)
    
	atkround = atkround + 1

	if UnstableFastSkipDeadAnimation == 1 then
		--https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 Experimental
		for i = 1, 6 do
			click(Location(1500,500))
			wait(2)
		end
	end
    wait(3)
end

function InitForCheckCurrentStage()
	--Generate a snapshot ONCE in the beginning of battle(). Will re-run itself after entered memu().
	if SnapshotGeneratedForStagecounter ~= 1 then
		toast("Taking snapshot for stage recognition")
		StageCountRegion:save("_GeneratedStageCounterSnapshot.png")		
		SnapshotGeneratedForStagecounter = 1
		StageCounter = 1
	end
end

function TargetChoose()
    t1 = Target1Type:exists("target_servant.png")
	usePreviousSnap(true)
	t2 = Target2Type:exists("target_servant.png")
	t3 = Target3Type:exists("target_servant.png")
	t1a = Target1Type:exists("target_danger.png")
	t2a = Target2Type:exists("target_danger.png")
	t3a = Target3Type:exists("target_danger.png")
    if t1 ~= nil or t1a ~= nil then
        click(Target1Click)
		toast("Switched to priority target")
		TargetChoosen = 1
	elseif t2 ~= nil or t2a ~= nil then
		click(Target2Click)
		toast("Switched to priority target")
		TargetChoosen = 1
	elseif t3 ~= nil or t3a ~= nil then
		click(Target3Click)
		toast("Switched to priority target")
		TargetChoosen = 1
	else
		toast("No priority target selected")
	end
end

function executeSkill()
	decodeSkill_NPCasting = 0
	local currentStage = 1
	local currentTurn = atkround
	if stageCount ~= 1 then
    		currentStage = CheckCurrentStage(StageCountRegion)
    		turnCounter[currentStage] = turnCounter[currentStage] + 1
    		currentTurn = turnCounter[currentStage]
    end
    	
	if currentTurn	<= stageTurnArray[currentStage] then
		--currentSkill is a two-dimensional array with something like abc1jkl4.
		local currentSkill = StageSkillArray[currentStage][currentTurn]
		
		--[[Prevent exessive delay between skill clickings. 
			firstSkill = 1 means more delay, cause one has to wait for battle animation. 
			firstSkill = 0 means less delay.]]
    	local firstSkill = 1
    	if currentSkill ~= '0' and currentSkill ~= '#' then
    		for command in string.gmatch(currentSkill, ".") do
        		decodeSkill(command, firstSkill)
        		firstSkill = 0	
        	end
    	end
		if decodeSkill_NPCasting == 0 then
			--Wait for regular servant skill animation executed last time. Then proceed to next turn.
    		wait(2.7)
    	end	
    end
end

function CheckCurrentStage(region)
	--Alternative fix for different font of stagecount number among different regions, worked pretty damn well tho.
	--This will compare last screenshot with current screen, effectively get to know if stage changed or not.
	local s = region:exists(Pattern("_GeneratedStageCounterSnapshot.png"):similar(0.8))

	--Pattern found, stage did not change.
	if s ~= nil then
		toast("Battle "..StageCounter.."/3")
		return StageCounter
	end
	
	--Pattern not found, which means that stage changed. Generate another snapshot te be used next time.
	if s == nil then
		toast("Taking snapshot for stage recognition")
		StageCountRegion:save("_GeneratedStageCounterSnapshot.png")
		StageCounter = StageCounter + 1
		toast("Battle "..StageCounter.."/3")
		return StageCounter
	end
end
	
function decodeSkill(str, isFirstSkill)
	--magic number - check ascii code, a == 97. http://www.asciitable.com/
	local index = string.byte(str) - 96

	--[[isFirstSkill == 0: Not yet proceeded to next turn.
		decodeSkill_NPCasting == 0: Not currently casting NP(not in card selection screen).
		index >= -44 and MysticCode_OrderChange == 0: Not currently doing Order Change.
		
		Therefore, script is casting regular servant skills.]]
	if isFirstSkill == 0 and decodeSkill_NPCasting == 0 and index >= -44 and MysticCode_OrderChange == 0 then
		--Wait for regular servant skill animation executed last time.
		--Do not make it shorter, at least 2.9s. Napoleon's skill animation is ridiculously long.
		wait(3.1)
	end

	--[[In ascii, char(4, 5, 6) command for servant NP456 = decimal(52, 53, 54) respectively.
		Hence: 
		52 - 96 = -44 
		53 - 96 = -43 
		54 - 96 = -42]]	
	if index >= -44 and index <= -42 and decodeSkill_NPCasting == 0 then
		---Enter card selection screen, ready to cast NP.
		click(Location(2300,1200))
		decodeSkill_NPCasting = 1
		wait(0.8)
	end

	--[[In ascii, char(j, k, l) and char(x) command for master skill = decimal(106, 107, 108) and decimal(120) respectively.
		Hence:
		106 - 96 = 10
		107 - 96 = 11
		108 - 96 = 12
		120 - 96 = 24]]
	if index >= 10 then
		--Click master skill menu icon, ready to cast master skill.
		click(Location(2380, 640))
		wait(0.3)
	end

	--[[Enter Order Change Mode.
		In ascii, char(x) = decimal(120)
		120 - 96 = 24]]
	if index == 24 then
		MysticCode_OrderChange = 1
	end

	--MysticCode-OrderChange master skill implementation.
	--Actual clicking is done by the default case here.
	if MysticCode_OrderChange == 1 then
		--Click Order Change icon.
		click(SkillClickArray[12])
		MysticCode_OrderChange = 2
	elseif MysticCode_OrderChange == 2 then
		click(StartingMemberClickArray[index])
		MysticCode_OrderChange = 3
	elseif MysticCode_OrderChange == 3 then
		click(SubMemberClickArray[index])
		wait(0.3)
		click(Location(1280,1260))
		MysticCode_OrderChange = 0
		wait(5)
	else
		--Cast skills, NPs, or select target.
		click(SkillClickArray[index])
	end
	if index > 0 and Skill_Confirmation == 1 then
		click(Location(1680,850))
	end
end	

function checkCardAffin(region)
	weakAvail = region:exists("weak.png")
	usePreviousSnap(true)
	if weakAvail ~= nil then
		return WeakMulti
	end
	
	if region:exists("resist.png") ~= nil then
		return ResistMulti
	else
		return NormalMulti
	end	
end

function checkCardType(region)
	if region:exists("buster.png") ~= nil then
		return BCard
	end
	
	if region:exists("art.png") ~= nil then
		return ACard
	end
	
	if region:exists("quick.png") ~= nil then
		return QCard
	else
		return BCard
	end		
end

function ultcard()
	click(Ultcard1Click)
	click(Ultcard2Click)
	click(Ultcard3Click)
end

function doBattleLogic()	
	local cardStorage =
	{
		WB = {}, B = {}, RB = {},
		WA = {}, A = {}, RA = {},
		WQ = {}, Q = {}, RQ = {}
	}
	
	for cardSlot = 1, 5 do
		local cardAffinity = checkCardAffin(CardAffinRegionArray[cardSlot])
		local cardType = checkCardType(CardTypeRegionArray[cardSlot])
		local cardScore = cardAffinity * cardType
		
		if cardScore == WeakBuster then
			table.insert(cardStorage.WB, cardSlot)
		elseif cardScore == BCard then
			table.insert(cardStorage.B, cardSlot)
		elseif cardScore == ResistBuster then
			table.insert(cardStorage.RB, cardSlot)
			
		elseif cardScore == WeakArt then
			table.insert(cardStorage.WA, cardSlot)
		elseif cardScore == ACard then
			table.insert(cardStorage.A, cardSlot)
		elseif cardScore == ResistArt then
			table.insert(cardStorage.RA, cardSlot)	
			
		elseif cardScore == WeakQuick then
			table.insert(cardStorage.WQ, cardSlot)
		elseif cardScore == QCard then
			table.insert(cardStorage.Q, cardSlot)
		else
			table.insert(cardStorage.RQ, cardSlot)		
		end
	end
	
	local clickCount = 0
	for p, cardPriority in ipairs(CardPriorityArray) do
		local currentStorage = cardStorage[cardPriority]
	
		for s, cardSlot in pairs(currentStorage) do
			click(CardClickArray[cardSlot])
			clickCount = clickCount + 1
			
			if clickCount == 3 then
				break
			end
		end
		
		if clickCount == 3 then
			break
		end
	end
end

--[[Deprecated
function norcard()
    i = 0
    
    w1 = CardAffinRegionArray[1]:exists("weak.png")
	usePreviousSnap(true)   
    if w1 ~= nil then
        click(Card1Click)
        Card1Clicked = 1
        i = i + 1
    end

    w2 = CardAffinRegionArray[2]:exists("weak.png")
    if w2 ~= nil then
        click(Card2Click)
        Card2Clicked = 1
        i = i + 1
    end

    w3 = CardAffinRegionArray[3]:exists("weak.png")
    if w3 ~= nil then
        click(Card3Click)
        Card3Clicked = 1
        i = i + 1
    end

    w4 = CardAffinRegionArray[4]:exists("weak.png")
    if w4 ~= nil then
        click(Card4Click)
        Card4Clicked = 1
        i = i + 1
    end

    w5 = CardAffinRegionArray[5]:exists("weak.png")
    if w5 ~= nil then
        click(Card5Click)
        Card5Clicked = 1
        i = i + 1
    end
end]]

function result()
	--Bond exp screen.
    wait(2)
	click(Location(1000, 1000))
	
	--Bond level up screen.
	if BondRegion:exists("bond.png") then
		wait(1)
		click(Location(1000, 1000))
	end

	--Master exp screen.
    wait(2)
	click(Location(1000, 1000))
	
	--Obtained item screen.
    wait(1.5)
	click(Location(2200, 1350))
	
	--Extra event item screen.
    if isEvent == 1 then
    	wait(1.5)
    	click(Location(2200, 1350))
    end
	wait(15)
	
	--1st time quest reward screen.
	if QuestrewardRegion:exists("questreward.png") ~= nil then
		click(Location(100,100))
	end
end

--Nested if...Will modify it when I know more.
function PSADialogue()
	if PSADialogueShown ~= 0 then
		return
	end
	dialogInit()
	--Auto Refill dialogue content generation.
	if Refill_or_Not == 1 then
		if Use_Stone == 1 then
			RefillType = "stones"
		else
			RefillType = "apples"
		end
		addTextView("Auto Refill Enabled:")
		newRow()
		addTextView("You are going to use")
		newRow()
		addTextView(How_Many .. " " .. RefillType .. ", ")
		newRow()
		addTextView("remember to check those values everytime you execute the script!")
		addSeparator()
	end

	--Autoskill dialogue content generation.
	if Enable_Autoskill == 1 then
		addTextView("AutoSkill Enabled:")
		newRow()
		addTextView("Start the script from memu or Battle 1/3 to make it work properly.")
		addSeparator()
	end

	--Autoskill list dialogue content generation.
	if Enable_Autoskill_List == 1 then
		addTextView("Please select your predefined Autoskill setting:")
		newRow()
		addRadioGroup("AutoskillListIndex", 1)
		addRadioButton("Setting 01 " .. Autoskill_List[1], 1)
		addRadioButton("Setting 02 " .. Autoskill_List[2], 2)
		addRadioButton("Setting 03 " .. Autoskill_List[3], 3)
		addRadioButton("Setting 04 " .. Autoskill_List[4], 4)
		addRadioButton("Setting 05 " .. Autoskill_List[5], 5)
		addRadioButton("Setting 06 " .. Autoskill_List[6], 6)
		addRadioButton("Setting 07 " .. Autoskill_List[7], 7)
		addRadioButton("Setting 08 " .. Autoskill_List[8], 8)
		addRadioButton("Setting 09 " .. Autoskill_List[9], 9)
		addRadioButton("Setting 10 " .. Autoskill_List[10], 10)
	end

	--Show the generated dialogue.
	dialogShow("CAUTION")
	PSADialogueShown = 1

	--Put user selection into list for later exception handling.
	if Enable_Autoskill_List == 1 then
		Skill_Command = Autoskill_List[AutoskillListIndex]
	end

	--Autoskill exception handling.
	if Enable_Autoskill == 1 then
		for word in string.gmatch(Skill_Command, "[^,]+") do
			if string.match(word, "[^0]") ~= nil then
				if string.match(word, "^[1-3]") ~= nil then
					scriptExit("Error at '" ..word.. "': Skill Command cannot start with number '1', '2' and '3'!")
				elseif string.match(word, "[%w+][#]") ~= nil or string.match(word, "[#][%w+]") ~= nil then
					scriptExit("Error at '" ..word.. "': '#' must be preceded and followed by ','! Correct: ',#,' ")
			  	elseif string.match(word, "[^a-l^1-6^#^x]") ~= nil then
					scriptExit("Error at '" ..word.. "': Skill Command exceeded alphanumeric range! Expected 'x' or range 'a' to 'l' for alphabets and '0' to '6' for numbers.")
			  	end
		  	end
			if word == '#' then
				stageCount = stageCount + 1
				if stageCount > 5 then
					scriptExit("Error: Detected commands for more than 5 stages")
			  	end
		  	end
		  	if word ~= '#' then
				table.insert(StageSkillArray[stageCount], word)
			  	stageTurnArray[stageCount] = stageTurnArray[stageCount] + 1
		  	end
		end
	end
end

while(1) do
	--Execute only once
	PSADialogue()

    if MenuRegion:exists("menu.png", 0) then
		toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
        menu()
		TargetChoosen = 0

		SnapshotGeneratedForStagecounter = 0
    end
    if BattleRegion:exists("battle.png", 0) then
        battle()
    end
    if ResultRegion:exists("result.png", 0) then
        result()
    end
end
