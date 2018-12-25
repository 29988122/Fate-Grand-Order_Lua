--デフォルト、触らない方がいい設定です
dir = scriptPath()
setImagePath(dir)

xOffset = 150
yOffset = 0

GameRegion = "JP"
StageCountRegion = Region(1722 + xOffset,25 + yOffset,46,53)

--Temp solution, https://github.com/29988122/Fate-Grand-Order_Lua/issues/21#issuecomment-357257089 
NotJPserverForStaminaRefillExtraClick = 1

--[[Experimental https://github.com/29988122/Fate-Grand-Order_Lua/issues/55 
    UnstableFastSkipDeadAnimation = 1
--]]

--Initalize for user input listnames
Autoskill_List = {}
for i = 1, 10 do
    Autoskill_List[i] = {}
    for j = 1, 2 do
        Autoskill_List[i][j] = 0
    end
end

--スタミナ自動補充
Refill_Enabled = 0

--[[ Can be set to any of the following:
    "SQ"         Use Saint Quartz for refills
    "All Apples"    Use all available Apples for refills
    "Gold"          Use only Gold Apples for refills
    "Silver"        Use only Silver Apples for refills
    "Bronze"        Use only Bronze Apples for refills
]]
Refill_Resource = "All Apples"

-- Represents the amount of times a refill will happen.
-- Is NOT a counter for number of Apples used when Bronze apples are included
Refill_Repetitions = 0

--サポートサーヴァント自動選択
--説明書に参照してください https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#autosupportselection
Support_SelectionMode = "first"
Support_SwipesPerUpdate = 10
Support_MaxUpdates = 3
Support_FallbackTo = "manual"
Support_FriendsOnly = 0
Support_PreferredServants = "waver4.png, waver3.png, waver2.png, waver1.png"
Support_PreferredCEs = "*chaldea_lunchtime.png"

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
--]]
Enable_Autoskill = 0
Skill_Confirmation = 0
Skill_Command = "abc,#,def,#,ghi"

--Enable_Autoskill_List = 1の場合は、スクリプトが起動する際、複数のオートスキル設定から一つを選択することができます
Enable_Autoskill_List = 0
--以下はユーザーが予め設定したオートスキルリストです
Autoskill_List[1][1] = "Settings No.1"
Autoskill_List[1][2] = "abc,#,def,#,ghi"

Autoskill_List[2][1] = "Settings No.2"
Autoskill_List[2][2] = ""

Autoskill_List[3][1] = "Settings No.3"
Autoskill_List[3][2] = ""

Autoskill_List[4][1] = "Settings No.4"
Autoskill_List[4][2] = ""

Autoskill_List[5][1] = "Settings No.5"
Autoskill_List[5][2] = ""

Autoskill_List[6][1] = "Settings No.6"
Autoskill_List[6][2] = ""

Autoskill_List[7][1] = "Settings No.7"
Autoskill_List[7][2] = ""

Autoskill_List[8][1] = "Settings No.8"
Autoskill_List[8][2] = ""

Autoskill_List[9][1] = "Settings No.9"
Autoskill_List[9][2] = ""

Autoskill_List[10][1] = "Settings No.10"
Autoskill_List[10][2] = ""

--[[
カード選択の優先順位。
モードは二つがあります。
簡単モード:
例: "BAQ"の場合はweak buster->buster->resist buster->weak arts->arts->resist arts->weak quick->quick->resist quick
Battle_CardPriority = "BAQ"

詳細モード:
例:"WA, WB, WQ, A, B, Q, RA, RQ, RB"の場合はweak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick
Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"

（詳細はこちらを） https://github.com/29988122/Fate-Grand-Order_Lua#card-priority-customization
--]]
Battle_CardPriority = "BAQ"

--[[
宝具の使用パターン：
• disabled: 宝具は使わない。Autoskill設定したらこのオプションを使いましょう。
• danger: DANGERとSERVANT敵が現したら自動的に毎回使います。Autoskillの順番が乱れる可能性があります。
• spam: 宝具が溜まったら直ちに使います。
Check https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/README.md#noble-phantasm-behavior for further detail.
--]]
Battle_NoblePhantasm = "disabled" 

--イベントステージ終了時にて別枠がある場合（もう一つのポイント報酬ウィンドウとか、詳細はウェブのreadmeで）
isEvent = 0

dofile(dir .. "regular.lua")
