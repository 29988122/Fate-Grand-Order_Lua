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
Card1Click = (Location(300,1000))
Card2Click = (Location(750,1000))
Card3Click = (Location(1300,1000))
Card4Click = (Location(1800,1000))
Card5Click = (Location(2350,1000))
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
saberstage2ndwave = Region(0,0,600,200)

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
    wait(1.5)
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
    norcard()

    if i < 3 then
        if f1 == nil then
            click(Card1Click)
        end
        if f2 == nil then
            click(Card2Click)
        end
        if f3 == nil then
            click(Card3Click)
        end
        if f4 == nil then
            click(Card4Click)
        end
        if f5 == nil then
            click(Card5Click)
        end
    end

    i = 0
    atkround = atkround + 1
    wait(3)
end

function norcard()
    i = 0
    f1 = Card1Region:exists("weak.png")
	usePreviousSnap(true)
    if f1 ~= nil then
        click(Card1Click)
        i = i + 1
    end

    f2 = Card2Region:exists("weak.png")
    if f2 ~= nil then
        click(Card2Click)
        i = i + 1
    end

    f3 = Card3Region:exists("weak.png")
    if f3 ~= nil then
        click(Card3Click)
        i = i + 1
    end

    f4 = Card4Region:exists("weak.png")
    if f4 ~= nil then
        click(Card4Click)
        i = i + 1
    end

    f5 = Card5Region:exists("weak.png")
    if f5 ~= nil then
        click(Card5Click)
        i = i + 1
    end
	usePreviousSnap(false)
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
	t1a = saberstage2ndwave:exists("201712jpevent_saber_stage.png")
	t2a = saberstage2ndwave:exists("201712jpevent_saber_stage.png")
	t3a = saberstage2ndwave:exists("201712jpevent_saber_stage.png")
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
	r1 = QuestrewardRegion:exists("questreward.png")
	if r1 ~= nil then
		click(Location(100,100))
	end
end

--[[
function berserkeBattleRegion()
    click(Location(2300,1200))
    if atkround >= 4 then
        ultcard()
    end
    click(card1)
    click(card2)
    click(card3)
    click(card4)
    click(card5)
    atkround = atkround + 1
    wait (3)
end
]]

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