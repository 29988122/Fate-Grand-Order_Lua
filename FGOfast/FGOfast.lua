rMenu = Region(2100,1200,1000,1000)
rBattle = Region(2200,200,1000,600)
rResult = Region(100,300,700,200)
sCard1 = Region(330,650,200,200)
sCard2 = Region(840,650,200,200)
sCard3 = Region(1340,650,200,200)
sCard4 = Region(1850,650,200,200)
sCard5 = Region(2370,650,200,200)
card1 = (Location(300,1000))
card2 = (Location(750,1000))
card3 = (Location(1300,1000))
card4 = (Location(1800,1000))
card5 = (Location(2350,1000))
Settings:setCompareDimension(true, 1280)
atkround = 1
--Settings:set("MinSimilarity", 0.6)
Settings:set("AutoWaitTimeout", 1)

--ultcard1 = Region(900,100,200,200)
--ultcard2 = Region(1350,100,200,200)
--ultcard3 = Region(1800,100,200,200)
--setScanInterval(1)
--usePreviousSnap(true)
--[[1.weak改顏色
2.寶具判斷

speed:
1.setScanInterval(1)
2.Settings:set("MinSimilarity", 0.5)
3.Settings:set("AutoWaitTimeout", 1)
4.usePreviousSnap(false)
5.resolution 1280
6.exists(var ,0)]]
function menu()
    atkround = 1
    wait (1)
    click(Location(1900,400))
    wait (1)
    click(Location(1900,500))
    wait (1)
    click(Location(2400,1350))
    wait(5)
end

function battle()
    click(Location(2300,1200))
    if atkround > 4 then
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
    f1 = sCard1:exists("weakdelta.png")
    if f1 ~= nil then
        click(card1)
        toast("card1")
        i = i + 1
    end

    f2 = sCard2:exists("weakdelta.png")
    if f2 ~= nil then
        click(card2)
        toast("card2")
        i = i + 1
    end

    f3 = sCard3:exists("weakdelta.png")
    if f3 ~= nil then
        click(card3)
        toast("card3")
        i = i + 1
    end

    f4 = sCard4:exists("weakdelta.png")
    if f4 ~= nil then
        click(card4)
        toast("card4")
        i = i + 1
    end

    f5 = sCard5:exists("weakdelta.png")
    if f5 ~= nil then
        click(card5)
        toast("card5")
        i = i + 1
    end
end

function ultcard()
    click(Location(860,400))
    click(Location(1300,400))
    click(Location(1740,400))
end

function result()
    wait(2)
    click(Location(1000, 1000))
    wait(3)
    click(Location(1000, 1000))
    wait(3)
    click(Location(2200, 1350))
    wait(3)
end

function berserkerbattle()
    click(Location(2300,1200))
    if atkround >= 6 then
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

while(1) do
    if rMenu:exists("menu.png", 0) then
        menu()
    end
    if rBattle:exists("battle.png", 0) then
        berserkerbattle()
    end
    if rResult:exists("result.png", 0) then
        result()
    end
end