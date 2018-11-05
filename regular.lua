--Other import such as ankulua-utils or string-utils are defined in support.lua.
package.path = package.path .. ";" .. dir .. 'modules/?.lua'
local support = require "support"

--[[このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
	私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
	お願いします。このプログラムを禁止しないでください。
--]]

--Main loop, pattern detection regions.
--Click pos are hard-coded into code, unlikely to change in the future.
MenuRegion = Region(2100,1200,1000,1000)
BattleRegion = Region(2200,200,1000,600)
ResultRegion = Region(100,300,700,200)
BondRegion = Region(2000,820,120,120)
QuestrewardRegion = Region(1630,140,370,250)
FriendrequestRegion = Region(660, 120, 140, 160)
StaminaRegion = Region(600,200,300,300)

StoneClick = (Location(1270,340))
AppleClick = (Location(1270,640))

StartQuestClick = Location(2400,1350)
StartQuestWithoutItemClick = Location(1652,1304) -- see docs/start_quest_without_item_click.png

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
	Ultcard3Region = Region(1800,100,200,200)
--]]

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

--File paths
GeneralImagePath = "image_" .. GameRegion .. "/"

--Autoskill and Autoskill exception handling related, waiting for cleanup.
decodeSkill_NPCasting = 0
AutoskillPopupStageCounter = 1
stageTurnArray = {0, 0, 0, 0, 0}
turnCounter = {0, 0, 0, 0, 0}
MysticCode_OrderChange = 0

--Wait for cleanup variables and its respective functions, my messed up code^TM.
atkround = 1

--TBD:Autoskill execution optimization, switch target during Autoskill, Do not let Targetchoose().ultcard() interfere with Autoskill, battle()execution order cleanup. 
--TBD:Screenshot function refactoring: https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-428015815
	
--[[recognize speed realated functions:
	1.setScanInterval(1)
	2.Settings:set("MinSimilarity", 0.5)
	3.Settings:set("AutoWaitTimeout", 1)
	4.usePreviousSnap(true)
	5.resolution 1280
	6.exists(var ,0)
--]]

function initCardPriorityArray()
	--[[Considering:
	Battle_CardPriority = "BAQ"
	then:
	CardPriorityArray = {"WB", "B", "RB", "WA", "A", "RA", "WQ", "Q", "RQ"}
	--]]
	
	for card in Battle_CardPriority:gmatch(".") do
		table.insert(CardPriorityArray, "W" .. card)
		table.insert(CardPriorityArray, card)
		table.insert(CardPriorityArray, "R" .. card)
	end
end

function menu()
	CleartoSpamNP = 0
    atkround = 1
    decodeSkill_NPCasting = 0
	turnCounter = {0, 0, 0, 0, 0}
	
	--Click uppermost quest.
    click(Location(1900,400))
	wait(1.5)
	
	--Auto refill.
    if StaminaRegion:exists(GeneralImagePath .. "stamina.png", 0) then
        RefillStamina()
    end
	
	--Friend selection.
	local hasSelectedSupport = support.selectSupport(Support_SelectionMode)
	if hasSelectedSupport then
		wait(1.5)
		startQuest()
	end
end

function RefillStamina()
    if Refill_or_Not == 1 and StoneUsed < How_Many then
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
    else
        scriptExit("AP ran out!")
    end
end

function startQuest()
	click(StartQuestClick)

	if isEvent == 1 then
		wait(2)
		click(StartQuestWithoutItemClick)
	end
end

function battle()
	wait(1.5)
	InitForUpdateStageCounter()

	--TBD: counter not used, will replace atkround.
	local RoundCounter = 1
    
	UpdateStageCounter(StageCountRegion)
    
	if TargetChoosen ~= 1 then
		--Choose priority target for NP spam and focus fire.
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
	
    ultcard()

    wait(0.5)
	doBattleLogic()
	--From checkCardAffin(region) to checkCardType(region), the same snapshot is used.
    usePreviousSnap(false)
    
	atkround = atkround + 1

	if UnstableFastSkipDeadAnimation == 1 then
		--https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 Experimental
		for i = 1, 3 do
			click(Location(1700,100))
			wait(1)
		end
	end
    wait(2)
end

function InitForUpdateStageCounter()
	--Generate a snapshot ONCE in the beginning of battle(). Will re-run itself after entered memu().
	if SnapshotGeneratedForStagecounter ~= 1 then
		toast("Taking snapshot for stage recognition")
		StageCountRegion:save(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png")		
		SnapshotGeneratedForStagecounter = 1
		StageCounter = 1
	end
end

function TargetChoose()
    t1 = Target1Type:exists(GeneralImagePath .. "target_servant.png")
	usePreviousSnap(true)
	t2 = Target2Type:exists(GeneralImagePath .. "target_servant.png")
	t3 = Target3Type:exists(GeneralImagePath .. "target_servant.png")
	t1a = Target1Type:exists(GeneralImagePath .. "target_danger.png")
	t2a = Target2Type:exists(GeneralImagePath .. "target_danger.png")
	t3a = Target3Type:exists(GeneralImagePath .. "target_danger.png")
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

	--Will ALWAYS enter this clause. Check for current stage.
	if AutoskillPopupStageCounter ~= 1 then
    		currentStage = StageCounter
    		turnCounter[currentStage] = turnCounter[currentStage] + 1
    		currentTurn = turnCounter[currentStage]
    end
    	
	if currentTurn	<= stageTurnArray[currentStage] then
		--currentSkill is a two-dimensional array with something like abc1jkl4.
		local currentSkill = StageSkillArray[currentStage][currentTurn]
		
		--[[Prevent exessive delay between skill clickings. 
			firstSkill = 1 means more delay, cause one has to wait for battle animation. 
			firstSkill = 0 means less delay.
		--]]
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

	--NP spam AFTER all of the autoskill commands finished.
	if currentStage >= AutoskillPopupStageCounter and StageSkillArray[AutoskillPopupStageCounter][currentTurn] == nil then
		CleartoSpamNP = 1
	end
end

function UpdateStageCounter(region)
	--Alternative fix for different font of stagecount number among different regions, worked pretty damn well tho.
	--This will compare last screenshot with current screen, effectively get to know if stage changed or not.
	local s = region:exists(Pattern(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png"):similar(0.8))

	--Pattern found, stage did not change.
	if s ~= nil then
		toast("Battle "..StageCounter.."/3")
		return
	end
	
	--Pattern not found, which means that stage changed. Generate another snapshot te be used next time.
	if s == nil then
		toast("Taking snapshot for stage recognition")
		StageCountRegion:save(GeneralImagePath .. "_GeneratedStageCounterSnapshot.png")
		StageCounter = StageCounter + 1
        TargetChoosen = 0
		toast("Battle "..StageCounter.."/3")
		return
	end
end
	
function decodeSkill(str, isFirstSkill)
	--magic number - check ascii code, a == 97. http://www.asciitable.com/
	local index = string.byte(str) - 96

	--[[isFirstSkill == 0: Not yet proceeded to next turn.
		decodeSkill_NPCasting == 0: Not currently casting NP(not in card selection screen).
		index >= -44 and MysticCode_OrderChange == 0: Not currently doing Order Change.
		
		Therefore, script is casting regular servant skills.
	--]]
	if isFirstSkill == 0 and decodeSkill_NPCasting == 0 and index >= -44 and MysticCode_OrderChange == 0 then
		--Wait for regular servant skill animation executed last time.
		--Do not make it shorter, at least 2.9s. Napoleon's skill animation is ridiculously long.
		wait(3.3)
	end

	--[[In ascii, char(4, 5, 6) command for servant NP456 = decimal(52, 53, 54) respectively.
		Hence: 
		52 - 96 = -44 
		53 - 96 = -43 
		54 - 96 = -42
	--]]	
	if index >= -44 and index <= -42 and decodeSkill_NPCasting == 0 then
		---Enter card selection screen, ready to cast NP.
		click(Location(2300,1200))
		decodeSkill_NPCasting = 1
		wait(1)
		--Although it seems slow, make it no shorter than 1 sec to protect user with less processing power devices.
	end

	--[[In ascii, char(j, k, l) and char(x) command for master skill = decimal(106, 107, 108) and decimal(120) respectively.
		Hence:
		106 - 96 = 10
		107 - 96 = 11
		108 - 96 = 12
		120 - 96 = 24
	--]]
	if index >= 10 then
		--Click master skill menu icon, ready to cast master skill.
		click(Location(2380, 640))
		wait(0.3)
	end

	--[[Enter Order Change Mode.
		In ascii, char(x) = decimal(120)
		120 - 96 = 24
	--]]
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
	weakAvail = region:exists(GeneralImagePath .. "weak.png")
	usePreviousSnap(true)
	if weakAvail ~= nil then
		return WeakMulti
	end
	
	if region:exists(GeneralImagePath .. "resist.png") ~= nil then
		return ResistMulti
	else
		return NormalMulti
	end	
end

function checkCardType(region)
	if region:exists(GeneralImagePath .. "buster.png") ~= nil then
		return BCard
	end
	
	if region:exists(GeneralImagePath .. "art.png") ~= nil then
		return ACard
	end
	
	if region:exists(GeneralImagePath .. "quick.png") ~= nil then
		return QCard
	else
		return BCard
	end		
end

function ultcard()
	local weCanSpam = Battle_NoblePhantasm == "spam"
	local weAreInDanger = Battle_NoblePhantasm == "danger" and TargetChoosen == 1
	local isAutoskillFinished = Enable_Autoskill == 0 or CleartoSpamNP == 1

	if (weCanSpam or weAreInDanger) and isAutoskillFinished then
		click(Ultcard1Click)
		click(Ultcard2Click)
		click(Ultcard3Click)
	end
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
end
--]]

function result()
	--Bond exp screen.
    wait(2)
	click(Location(2200, 1350))
	
	--Bond level up screen.
	if BondRegion:exists(GeneralImagePath .. "bond.png") then
		wait(1)
		click(Location(2200, 1350))
	end

	--Master exp screen.
    wait(2)
	click(Location(2200, 1350))
	
	--Obtained item screen.
    wait(1.5)
	click(Location(2200, 1350))
	
	--Extra event item screen.
    if isEvent == 1 then
    	wait(1.5)
    	click(Location(2200, 1350))
	end

	--Friend request screen. Non-friend support was selected this battle.  Ofc it's defaulted not sending request.
	wait(1.5)
	if FriendrequestRegion:exists(GeneralImagePath .. "friendrequest.png") ~= nil then
		click(Location(600,1200))
	end

	wait(15)
	
	--1st time quest reward screen.
	if QuestrewardRegion:exists(GeneralImagePath .. "questreward.png") ~= nil then
		click(Location(100,100))
	end


end

--User option PSA dialogue. Also choosble list of perdefined skill.
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
		addRadioButton(Autoskill_List[1][1] .. ": " .. Autoskill_List[1][2], 1)
		addRadioButton(Autoskill_List[2][1] .. ": " .. Autoskill_List[2][2], 2)
		addRadioButton(Autoskill_List[3][1] .. ": " .. Autoskill_List[3][2], 3)
		addRadioButton(Autoskill_List[4][1] .. ": " .. Autoskill_List[4][2], 4)
		addRadioButton(Autoskill_List[5][1] .. ": " .. Autoskill_List[5][2], 5)
		addRadioButton(Autoskill_List[6][1] .. ": " .. Autoskill_List[6][2], 6)
		addRadioButton(Autoskill_List[7][1] .. ": " .. Autoskill_List[7][2], 7)
		addRadioButton(Autoskill_List[8][1] .. ": " .. Autoskill_List[8][2], 8)
		addRadioButton(Autoskill_List[9][1] .. ": " .. Autoskill_List[9][2], 9)
		addRadioButton(Autoskill_List[10][1] .. ": " .. Autoskill_List[10][2], 10)
	end

	--Show the generated dialogue.
	dialogShow("CAUTION")
	PSADialogueShown = 1

	--Put user selection into list for later exception handling.
	if Enable_Autoskill_List == 1 then
		Skill_Command = Autoskill_List[AutoskillListIndex][2]
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
				AutoskillPopupStageCounter = AutoskillPopupStageCounter + 1
				if AutoskillPopupStageCounter > 5 then
					scriptExit("Error: Detected commands for more than 5 stages")
			  	end
			end
			--Autoskill table popup.
		  	if word ~= '#' then
				table.insert(StageSkillArray[AutoskillPopupStageCounter], word)
			  	stageTurnArray[AutoskillPopupStageCounter] = stageTurnArray[AutoskillPopupStageCounter] + 1
		  	end
		end
	end
end

function init()
	setImmersiveMode(true)			   
	Settings:setCompareDimension(true,1280)
	Settings:setScriptDimension(true,2560)
	
	--Set only ONCE for every separated script run.
	support.init()
	initCardPriorityArray()
	StoneUsed = 0
	PSADialogueShown = 0
	
	--Check function CheckCurrentStage(region)
	StageCounter = 1
end

init()
while(1) do
	--Execute only once
	PSADialogue()

    if MenuRegion:exists(GeneralImagePath .. "menu.png", 0) then
		toast("Will only select servant/danger enemy as noble phantasm target, unless specified using Skill Command. Please check github for further detail.")
        menu()
		TargetChoosen = 0

		SnapshotGeneratedForStagecounter = 0
    end
    if BattleRegion:exists(GeneralImagePath .. "battle.png", 0) then
        battle()
    end
    if ResultRegion:exists(GeneralImagePath .. "result.png", 0) then
        result()
    end
end
