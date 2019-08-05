local game = {}

game.MENU_SCREEN_REGION = Region(2100,1200,1000,1000)
game.MENU_SELECT_QUEST_CLICK = Location(1900,400)
game.MENU_START_QUEST_CLICK = Location(2400,1350)

-- see docs/menu_boost_item_click_array.png
game.MENU_BOOST_ITEM_1_CLICK = Location(1280,418)
game.MENU_BOOST_ITEM_2_CLICK = Location(1280,726)
game.MENU_BOOST_ITEM_3_CLICK = Location(1280,1000)
game.MENU_BOOST_ITEM_SKIP_CLICK = Location(1652,1304)
game.MENU_BOOST_ITEM_CLICK_ARRAY = {
	["1"] = game.MENU_BOOST_ITEM_1_CLICK,
	["2"] = game.MENU_BOOST_ITEM_2_CLICK,
	["3"] = game.MENU_BOOST_ITEM_3_CLICK,
	["disabled"] = game.MENU_BOOST_ITEM_SKIP_CLICK
}

game.STAMINA_SCREEN_REGION = Region(600,200,300,300)
game.STAMINA_OK_CLICK = Location(1650,1120)
game.STAMINA_SQ_CLICK = Location(1270,345)
game.STAMINA_GOLD_CLICK = Location(1270,634)
game.STAMINA_SILVER_CLICK = Location(1270,922)
game.STAMINA_BRONZE_CLICK = Location(1270,1140)

game.SUPPORT_SCREEN_REGION = Region(0,0,110,332)
game.SUPPORT_LIST_REGION = Region(70,332,378,1091) -- see docs/support_list_region.png
game.SUPPORT_SWIPE_START_CLICK = Location(35,1190)
game.SUPPORT_SWIPE_END_CLICK = Location(35,390)

game.SUPPORT_LIST_ITEM_REGION_ARRAY = {
	-- see docs/support_list_item_regions_top.png
	Region(76,338,2356,428),
	Region(76,778,2356,390),

	-- see docs/support_list_item_regions_bottom.png
	Region(76,558,2356,390),
	Region(76,991,2356,428)
}

game.SUPPORT_LIMIT_BREAK_REGION = Region(376,0,16,90)
game.SUPPORT_FRIEND_REGION = Region(2234,game.SUPPORT_LIST_REGION:getY(),120,game.SUPPORT_LIST_REGION:getH()) -- see docs/friend_region.png
game.SUPPORT_UPDATE_CLICK = Location(1670,250)
game.SUPPORT_UPDATE_YES_CLICK = Location(1480,1110)
game.SUPPORT_LIST_TOP_CLICK = Location(2480,360)
game.SUPPORT_FIRST_SUPPORT_CLICK = Location(1900,500)
game.CONTINUE_CLICK = Location(1650,1120)

game.BATTLE_SCREEN_REGION = Region(2105,1259,336,116) -- see docs/battle_region.png
game.BATTLE_STAGE_COUNT_REGION = StageCountRegion -- this is provided by the config file
game.BATTLE_EXTRAINFO_WINDOW_CLOSE_CLICK = Location(2550,0)
game.BATTLE_ATTACK_CLICK = Location(2300,1200)
game.BATTLE_SKIP_DEATH_ANIMATION_CLICK = Location(1700, 100) -- see docs/skip_death_animation_click.png

-- see docs/target_regions.png
game.BATTLE_TARGET_REGION_ARRAY = {
	Region(0,0,485,220),
	Region(485,0,482,220),
	Region(967,0,476,220)
}

game.BATTLE_TARGET_CLICK_ARRAY = {
	Location(90,80),
	Location(570,80),
	Location(1050,80)
}

game.BATTLE_SKILL_1_CLICK = Location(140,1160)
game.BATTLE_SKILL_2_CLICK = Location(340,1160)
game.BATTLE_SKILL_3_CLICK = Location(540,1160)
game.BATTLE_SKILL_4_CLICK = Location(770,1160)
game.BATTLE_SKILL_5_CLICK = Location(970,1160)
game.BATTLE_SKILL_6_CLICK = Location(1140,1160)
game.BATTLE_SKILL_7_CLICK = Location(1400,1160)
game.BATTLE_SKILL_8_CLICK = Location(1600,1160)
game.BATTLE_SKILL_9_CLICK = Location(1800,1160)
game.BATTLE_SKILL_OK_CLICK = Location(1680,850)

game.BATTLE_SERVANT_1_CLICK = Location(700,880)
game.BATTLE_SERVANT_2_CLICK = Location(1280,880)
game.BATTLE_SERVANT_3_CLICK = Location(1940,880)

game.BATTLE_MASTER_SKILL_OPEN_CLICK = Location(2380,640)
game.BATTLE_MASTER_SKILL_1_CLICK = Location(1820,620)
game.BATTLE_MASTER_SKILL_2_CLICK = Location(2000,620)
game.BATTLE_MASTER_SKILL_3_CLICK = Location(2160,620)

game.BATTLE_STARTING_MEMBER_1_CLICK = Location(280,700)
game.BATTLE_STARTING_MEMBER_2_CLICK = Location(680,700)
game.BATTLE_STARTING_MEMBER_3_CLICK = Location(1080,700)
game.BATTLE_SUB_MEMBER_1_CLICK = Location(1480,700)
game.BATTLE_SUB_MEMBER_2_CLICK = Location(1880,700)
game.BATTLE_SUB_MEMBER_3_CLICK = Location(2280,700)
game.BATTLE_ORDER_CHANGE_OK_CLICK = Location(1280,1260)

game.BATTLE_CARD_AFFINITY_REGION_ARRAY = {
	-- see docs/card_affinity_regions.png
	Region(295,650,250,200),
	Region(810,650,250,200),
	Region(1321,650,250,200),
	Region(1834,650,250,200),
	Region(2348,650,250,200)
}

game.BATTLE_CARD_TYPE_REGION_ARRAY = {
	-- see docs/card_type_regions.png
	Region(0,1060,512,200),
	Region(512,1060,512,200),
	Region(1024,1060,512,200),
	Region(1536,1060,512,200),
	Region(2048,1060,512,200)
}

game.BATTLE_COMMAND_CARD_CLICK_ARRAY = {
	Location(300,1000),
	Location(750,1000),
	Location(1300,1000),
	Location(1800,1000),
	Location(2350,1000),
}

game.BATTLE_NP_CARD_CLICK_ARRAY = {
	Location(1000,220),
	Location(1300,400),
	Location(1740,400)
}

game.RESULT_SCREEN_REGION = Region(100,300,700,200)
game.RESULT_BOND_REGION = Region(2000,820,120,120)
game.RESULT_CE_REWARD_REGION = Region(1050,1216,33,28)
game.RESULT_CE_REWARD_CLOSE_CLICK = Location(80,60)
game.RESULT_FRIEND_REQUEST_REGION = Region(660,120,140,160)
game.RESULT_FRIEND_REQUEST_REJECT_CLICK = Location(600,1200)
game.RESULT_QUEST_REWARD_REGION = Region(1630,140,370,250)
game.RESULT_NEXT_CLICK = Location(2200,1350) -- see docs/quest_result_next_click.png

return game
