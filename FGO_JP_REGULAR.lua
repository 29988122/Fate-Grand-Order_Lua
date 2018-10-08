--デフォルト、触らない方がいい設定です
dir = scriptPath()
setImagePath(dir)

GameRegion = "JP"
StageCountRegion = Region(1722,25,46,53)

--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
NotJPserverForStaminaRefillExtraClick = 1

--[[Experimental https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 
    UnstableFastSkipDeadAnimation = 1]]

--スタミナ自動補充
Refill_or_Not = 0
Use_Stone = 0
How_Many = 0

--サポートサーヴァント自動選択
--説明書に参照してください https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#autosupportselection
Support_SelectionMode = "first"
Support_SwapsPerRefresh = 10
Support_MaxRefreshes = 3
Support_FallbackTo = "manual"
Support_PreferredServants = "waver1.png, waver2.png, waver4.png" --Any number of images separated by commas, if set to "Any" will pick any servant
Support_PreferredCEs = "*chaldea_lunchtime.png" --Any number of images separated by commas, if set to "Any" will pick any craft essence


--[[
オートスキル:
',' = ターン数
',#,' = BATTLE 数
'0' = 1回ターンスキップする

サーヴァントスキル = a b c	d e f	g h i
マスタースキル = j k l
スキルの使用対象 = 1 2 3
宝具使用 = 4 5 6

コマンドは "" の間に入力してください。

例:
Skill_Command = "bce,0,f3hi,#,j2d,#,4,a1g3"

BATTLE 1:
第1回 - サーヴァント 1 のスキル b, c, サーヴァント 2 のスキル e
第2回 - スキップする
第3回 - サーヴァント 2 のスキル f を使ってサーヴァント 3 を対象とする, サーヴァント 3 のスキル h, i

BATTLE 2:
第1回 - マスタースキル j を使ってサーヴァント 2 を対象とする, サーヴァント 2 のスキル d

BATTLE 3:
第1回 - サーヴァント 1 の宝具を使う
第2回 - サーヴァント 1 のスキル a を使って自分を対象とする, サーヴァント 3 のスキル g を使って自分を対象とする

Skill_Confirmation: OFF = 0
(ゲーム中はスキル使用確認ウィンドウがある場合) ON = 1
]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = "abc,#,def,#,ghi"

--Enable_Autoskill_List = 1の場合は、スクリプトが起動する際、複数のオートスキル設定から一つを選択することができます
Enable_Autoskill_List = 0
Autoskill_List = {}
--以下はユーザーが予め設定したオートスキルリストです
Autoskill_List[1] = "abc,#,def,#,ghi"
Autoskill_List[2] = ""
Autoskill_List[3] = ""
Autoskill_List[4] = ""
Autoskill_List[5] = ""
Autoskill_List[6] = ""
Autoskill_List[7] = ""
Autoskill_List[8] = ""
Autoskill_List[9] = ""
Autoskill_List[10] = ""

--カード選択の優先順位。BAQの場合はweak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

--[[
Options:
• disabled: will never cast NPs automatically, except for Autoskill commands
• danger: will cast NPs only when there are DANGER or SERVANT enemies on screen
• spam: will cast NPs as soon as they are available
--]]
Battle_NoblePhantasm = "disabled" 

--イベントステージ終了時にて別枠がある場合（もう一つのポイント報酬ウィンドウとか、詳細はウェブのreadmeで）
isEvent = 0

dofile(dir .. "regular.lua")