dir = scriptPath()
setImagePath(dir .. "image_JP")

--スタミナ回復
Refill_or_Not = 0
Use_Stone = 1
How_Many = 10

--[[
オートスキル:

',' = ターン数
'#' = BATTLE 数
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
第3回 - サーヴァント 3 にサーヴァント 2 のスキル f を使う, サーヴァント 3 のスキル h, i

BATTLE 2:
第1回 - サーヴァント 2 にマスタースキル j を使う, サーヴァント 2 のスキル d

BATTLE 3:
第1回 - サーヴァント 1 の宝具を使う
第2回 - サーヴァント 1 自分にスキル a を使う, サーヴァント 3 自分にスキル g を使う
]]
Enable_Autoskill = 0
Skill_Command = ""

--イベントポイント報酬
isEvent = 0

dofile(dir .. "regular.lua")