--[[
このスクリプトは人の動きを真似してるだけなので、サーバーには余計な負担を掛からないはず。
私の国では仕事時間は異常に長いので、もう満足プレイする時間すらできない。休日を使ってシナリオを読むことがもう精一杯…
お願いします。このプログラムを禁止しないでください。
]]
MenuRegion = Region(2100,1200,1000,1000)
BattleRegion = Region(2200,200,1000,600)
ResultRegion = Region(100,300,700,200)
StaminaRegion = Region(600,200,300,300)

StoneClick = (Location(1270,340))
AppleClick = (Location(1270,640))

Card1Region = Region(330,650,200,200)
Card2Region = Region(840,650,200,200)
Card3Region = Region(1340,650,200,200)
Card4Region = Region(1850,650,200,200)
Card5Region = Region(2370,650,200,200)

CardAffinRegion = {Card1Region, Card2Region, Card3Region, Card4Region, Card5Region}

Card1Click = (Location(300,1000))
Card2Click = (Location(750,1000))
Card3Click = (Location(1300,1000))
Card4Click = (Location(1800,1000))
Card5Click = (Location(2350,1000))

CardClickArray = {Card1Click, Card2Click, Card3Click, Card4Click, Card5Click}

Target1Type = Region(0,0,485,220)
Target2Type = Region(485,0,482,220)
Target3Type = Region(967,0,476,220)

Target1Choose = (Location(90,80))
Target2Choose = (Location(570,80))
Target3Choose = (Location(1050,80))

QuestrewardRegion = Region(1630,140,370,250)
--NpbarRegion = Region(280,1330,1620,50)
--Ultcard1Region = Region(900,100,200,200)
--Ultcard2Region = Region(1350,100,200,200)
--Ultcard3Region = Region(1800,100,200,200)
Ultcard1Click = (Location(1000,220))
Ultcard2Click = (Location(1300,400))
Ultcard3Click = (Location(1740,400))

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
WeakBuster = BCard * WeakMulti
WeakArt = ACard * WeakMulti
WeakQuick = QCard * WeakMulti

setImmersiveMode(true)			   
Settings:setCompareDimension(true,1280)
Settings:setScriptDimension(true,2560)

atkround = 1
stoneused = 0
refillshown = 0
--[[
recognize speed realated functions:
1.setScanInterval(1)
2.Settings:set("MinSimilarity", 0.5)
3.Settings:set("AutoWaitTimeout", 1)
4.usePreviousSnap(true)
5.resolution 1280
6.exists(var ,0)]]

function menu()
    atkround = 1
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
            click(Location(1650,1120))
            stoneused = stoneused + 1
        else
            click(AppleClick)
            click(Location(1650,1120))
            stoneused = stoneused + 1
        end
    end
    wait(2)
end

function battle()
	if targetchoosen ~= 1 then
		targetchoose()
	end

    wait(0.5)
    click(Location(2300,1200))
    wait(1)
    
    if targetchoosen == 1 then
        ultcard()
    end

    wait(0.5)
    doBattleLogic()
    
    usePreviousSnap(false)
    
    atkround = atkround + 1
    wait(3)
end

function checkCardAffin(region)
	weakAvail = region:exists("weak.png")
	usePreviousSnap(true)
	if weakAvail ~= nil then
		return WeakMulti
	end
	
	resistAvail = region:exists("resist.png")
	if  resistAvail ~= nil then
		return ResistMulti
	else
		return NormalMulti
	end	
end

function checkCardType(region)
	b = region:exists("buster.png")
	if b ~= nil then
		return BCard
	end
	
	a = region:exists("art.png")
	if  a ~= nil then
		return ACard
	end
	
	q = region:exists("quick.png")
	if q ~= nil then
		return QCard
	else
		return BCard
	end		
end

function doBattleLogic()
	affinArray = 0
	typeArray = 0
	cardScore = 0
	cardCount = 0
	storage = {}
	
	WBLocation = {}
	BLocation = {}
	RBLocation = {}
	WALocation = {}
	WQLocation = {}
	ALocation = {}
	QLocation = {}
	
	for cardSlot = 1, 5 do
		affinArray = checkCardAffin(CardAffinRegion[cardSlot])
		typeArray = checkCardType(CardTypeRegionArray[cardSlot])
		cardScore = affinArray * typeArray
		
		if cardScore >= ResistBuster then
			if cardScore == WeakBuster then
				table.insert(WBLocation, cardSlot)
			
			elseif cardScore == BCard then
				table.insert(BLocation, cardSlot)
			
			elseif cardScore == ResistBuster then
				table.insert(RBLocation, cardSlot)
				
			elseif cardScore == WeakQuick then
				table.insert(WQLocation, cardSlot)
			
			elseif cardScore == WeakArt then
				table.insert(WALocation, cardSlot)
			
			elseif cardScore == QCard then
				table.insert(QLocation, cardSlot)
			
			elseif cardScore == ACard then
				table.insert(ALocation, cardSlot)
			end		
		end
	end
	
	storage[1] = WBLocation
	storage[2] = BLocation
	storage[3] = WALocation
	storage[4] = WQLocation
	storage[5] = RBLocation
	storage[6] = ALocation
	storage[7] = QLocation
	
	
	for i, storageNum in ipairs(storage) do
		for j, nCard in pairs(storageNum) do
			click(CardClickArray[nCard])
			cardCount = cardCount + 1
			if cardCount == 3 then
				break
			end
		end
	end	
end

function norcard()
    i = 0
    
    w1 = Card1Region:exists("weak.png")
	usePreviousSnap(true)   
    if w1 ~= nil then
        click(Card1Click)
        Card1Clicked = 1
        i = i + 1
    end

    w2 = Card2Region:exists("weak.png")
    if w2 ~= nil then
        click(Card2Click)
        Card2Clicked = 1
        i = i + 1
    end

    w3 = Card3Region:exists("weak.png")
    if w3 ~= nil then
        click(Card3Click)
        Card3Clicked = 1
        i = i + 1
    end

    w4 = Card4Region:exists("weak.png")
    if w4 ~= nil then
        click(Card4Click)
        Card4Clicked = 1
        i = i + 1
    end

    w5 = Card5Region:exists("weak.png")
    if w5 ~= nil then
        click(Card5Click)
        Card5Clicked = 1
        i = i + 1
    end
end

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
    wait(15)
	rw1 = QuestrewardRegion:exists("questreward.png")
	if rw1 ~= nil then
		click(Location(100,100))
	end
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
		dialogShow("Auto Refilling Stamina")
		refillshown = 1
	end
    if MenuRegion:exists("menu.png", 0) then
		toast("Will only select servant/danger enemy as noble phantasm target, please check github for further detail")
        menu()
		targetchoosen = 0
    end
    if BattleRegion:exists("battle.png", 0) then
        battle()
    end
    if ResultRegion:exists("result.png", 0) then
        result()
    end
end