--[[
このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
お願いします。このプログラムを禁止しないでください。
]]
MenuRegion = Region(2100,1200,1000,1000)
BattleRegion = Region(2200,200,1000,600)
ResultRegion = Region(100,300,700,200)
QuestrewardRegion = Region(1630,140,370,250)
StaminaRegion = Region(600,200,300,300)

StoneClick = (Location(1270,340))
AppleClick = (Location(1270,640))

Card1AffinRegion = Region(330,650,200,200)
Card2AffinRegion = Region(840,650,200,200)
Card3AffinRegion = Region(1340,650,200,200)
Card4AffinRegion = Region(1850,650,200,200)
Card5AffinRegion = Region(2370,650,200,200)

CardAffinRegionArray = {Card1AffinRegion, Card2AffinRegion, Card3AffinRegion, Card4AffinRegion, Card5AffinRegion}

Card1TypeRegion = Region(200,1060,200,200)
Card2TypeRegion = Region(730,1060,200,200)
Card3TypeRegion = Region(1240,1060,200,200)
Card4TypeRegion = Region(1750,1060,200,200)
Card5TypeRegion = Region(2280,1060,200,200)

CardTypeRegionArray = {Card1TypeRegion, Card2TypeRegion, Card3TypeRegion, Card4TypeRegion, Card5TypeRegion}

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

Card1Click = (Location(300,1000))
Card2Click = (Location(750,1000))
Card3Click = (Location(1300,1000))
Card4Click = (Location(1800,1000))
Card5Click = (Location(2350,1000))

CardClickArray = {Card1Click, Card2Click, Card3Click, Card4Click, Card5Click}
CardPriorityArray = {}

Ultcard1Click = (Location(1000,220))
Ultcard2Click = (Location(1300,400))
Ultcard3Click = (Location(1740,400))

Target1Type = Region(0,0,485,220)
Target2Type = Region(485,0,482,220)
Target3Type = Region(967,0,476,220)
Target1Choose = (Location(90,80))
Target2Choose = (Location(570,80))
Target3Choose = (Location(1050,80))

--NpbarRegion = Region(280,1330,1620,50)
--Ultcard1Region = Region(900,100,200,200)
--Ultcard2Region = Region(1350,100,200,200)
--Ultcard3Region = Region(1800,100,200,200)

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

SkillClickArray = {Skill1Click, Skill2Click, Skill3Click, Skill4Click, Skill5Click, Skill6Click, Skill7Click, Skill8Click, Skill9Click, Master1Click, Master2Click, Master3Click}
SkillClickArray[-47] = Servant1Click
SkillClickArray[-46] = Servant2Click
SkillClickArray[-45] = Servant3Click
SkillClickArray[-44] = Ultcard1Click
SkillClickArray[-43] = Ultcard2Click
SkillClickArray[-42] = Ultcard3Click

stageSkillArray = {}
stageSkillArray[1] = {}
stageSkillArray[2] = {}
stageSkillArray[3] = {}
stageSkillArray[4] = {}
stageSkillArray[5] = {}

startingMember1Click = (Location(280,700))
startingMember2Click = (Location(680,700))
startingMember3Click = (Location(1080,700))
startingMemberClickArray = {}
startingMemberClickArray[-47] = startingMember1Click
startingMemberClickArray[-46] = startingMember2Click
startingMemberClickArray[-45] = startingMember3Click

subMember1Click = (Location(1480,700))
subMember2Click = (Location(1880,700))
subMember3Click = (Location(2280,700))
subMemberClickArray = {}
subMemberClickArray[-47] = subMember1Click
subMemberClickArray[-46] = subMember2Click
subMemberClickArray[-45] = subMember3Click

exchangeMode = 0
npClicked = 0
stageCount = 1
stageTurnArray = {0, 0, 0, 0, 0}
turnCounter = {0, 0, 0, 0, 0}

GeneratedStagecountSnapshot = 0
checkStageCountStage = 1
--Alternative fix for different font of stage count number among regions



atkround = 1
stoneused = 0
refillshown = 0
skillshown = 0
--[[
recognize speed realated functions:
1.setScanInterval(1)
2.Settings:set("MinSimilarity", 0.5)
3.Settings:set("AutoWaitTimeout", 1)
4.usePreviousSnap(true)
5.resolution 1280
6.exists(var ,0)]]

function initCardPriorityArray()
	--[[
	considering:
	Battle_CardPriority = "BAQ"
	
	then:
	CardPriorityArray = {"WB", "B", "RB", "WA", "A", "RA", "WQ", "Q", "RQ"}
	--]]

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
	
	initCardPriorityArray()
end

init()

function menu()
    atkround = 1
    npClicked = 0
    turnCounter = {0, 0, 0, 0, 0}
    click(Location(1900,400))
    wait(1.5)
    if Refill_or_Not == 1 and stoneused < How_Many then
        refillstamina()
    end
    click(Location(1900,500))
    wait(1.5)
    click(Location(2400,1350))
	wait(8)
end

function refillstamina()
    if StaminaRegion:exists("stamina.png", 0) then
        if Use_Stone == 1 then
            click(StoneClick)
	    wait(1.5)
            click(Location(1650,1120))
            stoneused = stoneused + 1
        else
            click(AppleClick)
	    wait(1.5)
            click(Location(1650,1120))
            stoneused = stoneused + 1
        end
		wait(3)
		if NotJPserverForStaminaRefillExtraClick == nil then
			--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
			click(Location(1900,400))
			wait(1.5)
		end
    end
end

function checkStageCount(region)
	--Alternative fix for different font of stage count number among regions
	--local s = region:exists("_GeneratedStagecountSnapshot.png")
	local s = region:exists(Pattern("_GeneratedStagecountSnapshot.png"):similar(0.9))

	if s ~= nil then
		toast("Battle "..checkStageCountStage.."/3")
		return checkStageCountStage
	end
	
	if s == nil then
		StageCountRegion:save("_GeneratedStagecountSnapshot.png")
		checkStageCountStage = checkStageCountStage + 1
		toast("Battle "..checkStageCountStage.."/3")
		return checkStageCountStage
	end
end

function executeSkill()
	npClicked = 0
	local currentStage = 1
	local currentTurn = atkround
	if stageCount ~= 1 then
    		currentStage = checkStageCount(StageCountRegion)
    		turnCounter[currentStage] = turnCounter[currentStage] + 1
    		currentTurn = turnCounter[currentStage]
    end
    	
    if currentTurn	<= stageTurnArray[currentStage] then 		
    	local currentSkill = stageSkillArray[currentStage][currentTurn]
    	local firstSkill = 1
    	if currentSkill ~= '0' and currentSkill ~= '#' then
    		for command in string.gmatch(currentSkill, ".") do
        		decodeSkill(command, firstSkill)
        		firstSkill = 0	
        	end
    	end
    	usePreviousSnap(false)
		if npClicked == 0 then
			--wait for last iterated skill animation
    		wait(3)
    	end	
    end
    usePreviousSnap(false)
end
   

function battle()
	if GeneratedStagecountSnapshot ~= 1 then
		wait(2)
		StageCountRegion:save("_GeneratedStagecountSnapshot.png")		
		GeneratedStagecountSnapshot = 1
		checkStageCountStage = 1
	end

	local roundCounter = 0
	
	if targetchoosen ~= 1 then
		targetchoose()
	end
	
    wait(0.5)
    if Enable_Autoskill == 1 then
		executeSkill()
    end
    
    wait(0.5)
	if npClicked == 0 then
		--enter card selection screen
    	click(Location(2300,1200))
    	wait(1)
    end
    
    if targetchoosen == 1 and npClicked == 0 then
        ultcard()
    end

    wait(0.5)
    doBattleLogic()
    
    usePreviousSnap(false)
    
    atkround = atkround + 1
    wait(3)
end
	
function decodeSkill(str, isFirstSkill)
	--magic number - check ascii code, a == 97
	local index = string.byte(str) - 96
	if isFirstSkill == 0 and npClicked == 0 and index >= -44 and exchangeMode == 0 then
		--wait for skill animation
		wait(3)
	end
	--enter Order Change Mode
	if index == 24 then
		exchangeMode = 1
	end
	if index >= 10 then
		--cast master skill
		 click(Location(2380, 640))
		 wait(0.3)
	end
	if index >= -44 and index <= -42 and npClicked == 0 then
		---cast NP
		click(Location(2300,1200))
		npClicked = 1
		wait(1)
	end
	--iterate, cast skills/NPs, also select target for it(if needed)
	if exchangeMode == 1 then
		click(SkillClickArray[12])
		exchangeMode = 2
	elseif exchangeMode == 2 then
		click(startingMemberClickArray[index])
		exchangeMode = 3
	elseif exchangeMode == 3 then
		click(subMemberClickArray[index])
		wait(0.3)
		click(Location(1280,1260))
		exchangeMode = 0
		wait(4)
	else
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

--[[function norcard()
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

function ultcard()
	click(Ultcard1Click)
	click(Ultcard2Click)
	click(Ultcard3Click)
end

function targetchoose()
    t1 = Target1Type:exists("target_servant.png")
	usePreviousSnap(true)
	t2 = Target2Type:exists("target_servant.png")
	t3 = Target3Type:exists("target_servant.png")
	t1a = Target1Type:exists("target_danger.png")
	t2a = Target2Type:exists("target_danger.png")
	t3a = Target3Type:exists("target_danger.png")
    if t1 ~= nil or t1a ~= nil then
        click(Target1Choose)
		toast("Switched to priority target")
		targetchoosen = 1
	elseif t2 ~= nil or t2a ~= nil then
		click(Target2Choose)
		toast("Switched to priority target")
		targetchoosen = 1
	elseif t3 ~= nil or t3a ~= nil then
		click(Target3Choose)
		toast("Switched to priority target")
		targetchoosen = 1
	else
		toast("No priority target selected")
    end
    usePreviousSnap(false)
end

function result()
    wait(2.5)
    click(Location(1000, 1000))
    wait(3.5)
    click(Location(1000, 1000))
    wait(3.5)
    click(Location(2200, 1350))
    if isEvent == 1 then
    	wait(2)
    	click(Location(2200, 1350))
    end
    wait(15)
	if QuestrewardRegion:exists("questreward.png") ~= nil then
		click(Location(100,100))
	end
end

function summermenu()
    atkround = 1
    npClicked = 0
    turnCounter = {0, 0, 0, 0, 0}
 	click(OuenCar)
    wait(1.5)
    click(Location(1900,400))
    wait(2.5)
    if Refill_or_Not == 1 and stoneused < How_Many then
		refillstamina()
	end
	--summer avoid misclick(script clicked oil but in fact accidently used stone to fill stamina)	
	if Refill_or_Not == 0 and StaminaRegion:exists("stamina.png", 0) then
		wait(99999999999)
	end
	wait(1.5)
    click(Location(1900,500))
    wait(1.5)
    click(Location(2400,1350))
	wait(1.5)		
	if OIL == 1 then
		click(Location(1600,1300))
		wait(1.5)
		click(Location(1600,1100))
	end
	if OIL == 2 then
		click(Location(1200,400))
		wait(1.5)
		click(Location(1600,1100))
	end
	if OIL == 3 then
		click(Location(1200,700))
		wait(1.5)
		click(Location(1600,1100))
	end
	if OIL == 4 then
		click(Location(1200,1000))
		wait(1.5)
		click(Location(1600,1100))
	end
	if OIL == nil then
		toast("Please start the event script from battle stage!")
		wait(100)
	end
	wait (8)
end


while(1) do
	if Refill_or_Not == 1 and refillshown == 0 then
		if Use_Stone == 1 then
			temp = "stones"
		else
			temp = "apples"
		end
		dialogInit()
		addTextView("You are going to use "..How_Many.." "..temp..", remember to check those values everytime you execute the script!")
		if Enable_Autoskill == 0 then
			dialogShow("Auto Refilling Stamina")
		end
		refillshown = 1
	end
	
	if Enable_Autoskill == 1 and skillshown == 0 then
		if Refill_or_Not == 0 then
			dialogInit()
		else
			newRow()
		end
		addTextView("AutoSkill Enabled! Start the script from memu or Battle 1/3 to make it work properly. Make sure that your Skill Command is correct before you execute the script!")
		if Refill_or_Not == 0 then
			dialogShow("AutoSkill")
		else
			dialogShow("Warning!")
		end
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
    			table.insert(stageSkillArray[stageCount], word)
    			stageTurnArray[stageCount] = stageTurnArray[stageCount] + 1
    		end
  		end
		skillshown = 1
	end
    
    if OIL == 99 then
		toast("Summer Racing Special: Please start this script IN THE TARGET FARMING BATTLE STAGE.")
	end

    if SummerRacingRegion:exists("_TEMP_JP_EVENT_2018_07_summer_racing.png", 3) then
		OuenCar = SummerRacingRegion:getLastMatch()
		summermenu()
        targetchoosen = 0
        
        GeneratedStagecountSnapshot = 0
		--Alternative fix for different font of stage count number among regions
	end

    if BattleRegion:exists("battle.png", 0) then
        if OIL == nil then
			dialogInit()
			addTextView("Please select desired oil:")
			newRow()
			addRadioGroup("rgIndex", 1)
			addRadioButton("Don't use oil", 1)
			addRadioButton("Quick Oil", 2)
			addRadioButton("Arts Oil", 3)
			addRadioButton("Buster Oil", 4)
			dialogShow("Oil Select")
			OIL = rgIndex
		end
        battle()
    end
    
    if ResultRegion:exists("result.png", 0) then
        result()
    end
end

