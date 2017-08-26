rMenu = Region(2100,1200,1000,1000)
rBattle = Region(2200,200,1000,600)
rResult = Region(100,300,700,200)
sCard1 = Region(330,650,200,200)
sCard2 = Region(840,650,200,200)
sCard3 = Region(1340,650,200,200)
sCard4 = Region(1850,650,200,200)
sCard5 = Region(2370,650,200,200)
sNpbar = Region(280,1330,1620,50)
sTarget1 = Region(0,0,485,220)
sTarget2 = Region(485,0,482,220)
sTarget3 = Region(967,0,476,220)
sQuestreward = Region(1630,140,370,250)
questreward = (Location(100,100))
card1 = (Location(300,1000))
card2 = (Location(750,1000))
card3 = (Location(1300,1000))
card4 = (Location(1800,1000))
card5 = (Location(2350,1000))
target1 = (Location(90,80))
target2 = (Location(570,80))
target3 = (Location(1050,80))

--ultcard1 = Region(900,100,200,200)
--ultcard2 = Region(1350,100,200,200)
--ultcard3 = Region(1800,100,200,200)
setImmersiveMode(true)
dir = scriptPath()
setImagePath(dir .. "image_TW")
Settings:setCompareDimension(true, 1280)
Settings:setScriptDimension(true, 2560)
atkround = 1
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
    wait (2)
    click(Location(1900,400))
    wait (2)
    click(Location(1900,500))
    wait (2)
    click(Location(2400,1350))
	wait (8)
end

function battle()
	wait (1)
	if targetchoosen ~= 1 then
		targetchoose()
	end

    click(Location(2300,1200))

    if targetchoosen == 1 then
        ultcard()
    end

    norcard()

    if i < 3 then
        if f1 == nil then
            click(card1)
        end
        if f2 == nil then
            click(card2)
        end
        if f3 == nil then
            click(card3)
        end
        if f4 == nil then
            click(card4)
        end
        if f5 == nil then
            click(card5)
        end
    end

    i = 0
    atkround = atkround + 1
    wait (3)
end

function norcard()
    i = 0
    f1 = sCard1:exists("weak.png")
	usePreviousSnap(true)
    if f1 ~= nil then
        click(card1)
        --toast("card1")
        i = i + 1
    end

    f2 = sCard2:exists("weak.png")
    if f2 ~= nil then
        click(card2)
        --toast("card2")
        i = i + 1
    end

    f3 = sCard3:exists("weak.png")
    if f3 ~= nil then
        click(card3)
        --toast("card3")
        i = i + 1
    end

    f4 = sCard4:exists("weak.png")
    if f4 ~= nil then
        click(card4)
        --toast("card4")
        i = i + 1
    end

    f5 = sCard5:exists("weak.png")
    if f5 ~= nil then
        click(card5)
        --toast("card5")
        i = i + 1
    end
	usePreviousSnap(false)
end

function ultcard()
	wait(1)
	click(Location(1000,220))
	click(Location(1300,400))
	click(Location(1740,400))
end

function targetchoose()
    t1 = sTarget1:exists("target_servant.png")
	usePreviousSnap(true)
	t2 = sTarget2:exists("target_servant.png")
	t3 = sTarget3:exists("target_servant.png")
	t1a = sTarget1:exists("target_danger.png")
	t2a = sTarget2:exists("target_danger.png")
	t3a = sTarget3:exists("target_danger.png")
    if t1 ~= nil or t1a ~= nil then
        click(target1)
		toast("Switched to priority target")
		targetchoosen = 1
	elseif t2 ~= nil or t2a ~= nil then
		click(target2)
		toast("Switched to priority target")
		targetchoosen = 1
	elseif t3 ~= nil or t3a ~= nil then
		click(target3)
		toast("Switched to priority target")
		targetchoosen = 1
	else
		toast("No priority target selected")
    end
	usePreviousSnap(false)
end

function result()
    wait(3)
    click(Location(1000, 1000))
    wait(3)
    click(Location(1000, 1000))
    wait(3)
    click(Location(2200, 1350))
    wait(16)
	r1 = sQuestreward:exists("questreward.png")
	if r1 ~= nil then
		click(questreward)
	end
end

--[[
function berserkerbattle()
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
	
    if rMenu:exists("menu.png", 0) then
		toast("Will only select servant/danger enemy as noble phantasm target, please check github for further detail")
        menu()
		targetchoosen = 0		
    end
	
    if rBattle:exists("battle.png", 0) then
        battle()
    end
    if rResult:exists("result.png", 0) then
        result()
    end
end