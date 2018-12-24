# Fate-Grand-Order_Lua
This script supported CN, EN, JP and TW server on Android devices and emulators.

Any of the questions can be asked in the "Issues" section. Don't be shy xD

Please consider Star our repo to encourage us if this script is useful to you : )

<p align="center">
  <a href="https://imgur.com/a/c6vKI">
    <img alt="Chaldea" src="https://camo.githubusercontent.com/19a9a5e1023613c01ba79aa1d03cae17d201f610/68747470733a2f2f7669676e65747465312e77696b69612e6e6f636f6f6b69652e6e65742f666174656772616e646f726465722f696d616765732f322f32642f4368616c6465615f53656375726974795f4f7267616e697a6174696f6e5f4c6f676f2e706e672f7265766973696f6e2f6c61746573742f7363616c652d746f2d77696474682d646f776e2f323030303f63623d3230313631313139303833333437" width="400"/>
  </a>
</p>

[![Lua-5.1-Sikuli](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Lua--Sikuli-5.1-blue.svg)](http://http://www.sikuli.org/)[![GitHub license](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Fate-Grand-Order_Lua.svg)](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/LICENSE)

Screw those farming events - I only wanna enjoy the (kinoko) story!

Therefore I proudly brought you this: FGO automation script.

As of 2018.12.24, this script is **working without root** / without being blocked or banned, although I DO NOT take responsibility for your banned account! 

[Disclaimer and concern about your account](ACCOUNT%20SAFETY.md)

***

# Table of Contents:
* [中文說明 マニュアル](#中文說明-マニュアル)
* [Install](#install)
* [Usage](#usage)
* [Extra scripts](#extra-scripts)
* [Advanced features](#advanced-features)
  * [AutoSkill](#autoskill)
    * [Chaldea Combat Uniform: Order Change](#chaldea-combat-uniform-order-change)
    * [AutoSkill List](#autoskill-list)
  * [AutoRefill](#autorefill)
  * [AutoSupportSelection](#autosupportselection)
  * [Card Priority Customization](#card-priority-customization)
  * [Noble Phantasm Behavior](#noble-phantasm-behavior)
  
  * [How to capture screen for recognition](#how-to-capture-screen-for-recognition)
* [Troubleshooting](#troubleshooting)
  * [Syntax error: unexpected symbol near '燎](#syntax-error-unexpected-symbol-near-燎)
* [Feature requests, 說明, 要望](#feature-requests)

***

## 中文說明 マニュアル
[中文說明](https://github.com/29988122/Fate-Grand-Order_Lua/wiki/readme.md-%E6%AD%A3%E9%AB%94%E4%B8%AD%E6%96%87)

[マニュアル](https://github.com/29988122/Fate-Grand-Order_Lua/wiki/readme.md-%E6%97%A5%E6%9C%AC%E8%AA%9E)

## Install:
1. **On Android**, install the latest version of AnkuLua(Sikuli) framework. https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial

2. Download the latest [release](https://github.com/29988122/Fate-Grand-Order_Lua/releases) of script, extract it **on PC**.

3. Copy the whole extracted folder into your Android phone or emulator.

4. **On Android**, enter settings->enable developer options->enable usb debugging.

5. Connect your PC to Android with USB cable, and execute run.bat **on PC** inside```Fate-Grand-Order_Lua\ama_daemon```folder. 

6. After daemon has been installed, you can disable usb debugging and unplug. **Daemon needs to be reinstalled upon phone reboot**.
* If daemon installation was not successful / driver not properly installed, please install this: https://forum.xda-developers.com/showthread.php?t=2317790

6. Open Ankulua to check if daemon is properly installed - and load the correct script inside your phone - enjoy the game your way!

## Usage:
Please choose the corresponding lua file in AnkuLua according to your:
* FGO server (supported China / Japan / Taiwan / USA currently)
    * FGO_CN_REGULAR.lua
    * FGO_JP_REGULAR.lua
    * FGO_TW_REGULAR.lua
    * FGO_EN_REGULAR.lua

Put your game in either:
* Menu screen, make the quest you wanna farm as the 1st item on the screen (upper-right corner)
* Battle screen

And start the script.

The script will automatically enter battle, choose cards for you, again and again until stamina depleted.

## Extra scripts:
```_auto_friendgacha.lua```

As title. It will keep gacha until your bag's full. I suggest using it for friend gacha only, despite it can also be used for stone gacha.

```_auto_gift_exchange.lua```

Used for Nero matsuri or Christmas events. Their UX really sucked, so a script for gacha is a nice QoL improvement.

***

## Advanced features:
By adjust settings inside your lua file, you can achieve the following things:
* [AutoSkill](#autoskill) Cast skills in battle via user-predefined skill lists.
* [AutoRefill](#autorefill) Refill stamina as you wish. 
* [AutoSupportSelection](#autosupportselection) Select certain support servant+CE combination. 
* [Card Priority Customization](#card-priority-customization) Customize your card selection priority. 
* [Noble Phantasm Behavior](#noble-phantasm-behavior) When to cast NP in order to face dangerous servants. 

## AutoSkill:
AutoSkill allows you to execute a series of turn-based skill commands, via user-predefined strings.
Change ```Enable_Autoskill``` to 1 to enable it, 0 to disable. 

```Skill_Confirmation``` allows you to skip the Confirm Skill Use window. Modify it according to your Battle Menu setting: 
```
OFF = 0
ON = 1
```
That is, if you need to click through confirmation window to use a skill, make this option ```Skill_Confirmation = 1```. 
Otherwise, leave it as ```Skill_Confirmation = 0```.

```Skill_Command``` strings should be composed by the following rules:
```
',' = Turn counter
',#,' = Battle counter
'0' = Skip 1 turn

Servant skill = a b c	d e f	g h i
Master skill = j k l
Target Servant = 1 2 3
Activate Servant NP = 4 5 6

Please insert your command in between the "".

e.g.
Skill_Command = "bce,0,f3hi,#,j2d,#,4,a1g3"

Battle 1:
Turn 1 - Servant 1 skill b, c, Servant 2 skill e
Turn 2 - No skill
Turn 3 - Servant 2 skill f on servant 3, Servant 3 skill h, i

Battle 2:
Turn 1 - Master skill j on servant 2, Servant 2 skill d

Battle 3:
Turn 1 - Activate NP servant 1
Turn 2 - Servant 1 skill a on self, Servant 3 skill g on self
```
We did not implement skill cooldown check yet. 

However by planning ahead, wrote commands for many rounds(putting a lot of zeros), you can prevent the script accidently clicked the skills that were still on cooldown.

Also, you can have a band-aid fix by casting skills only on the 1st servant(a1,d1,f1, etc). By doing so, the script will click cancel when the skill's on cooldown, preventing stuck.

## AutoRefill:
Set `Refill_Enabled = 1` to enable AutoRefill.

`Refill_Repetitions` controls how many apples you want to use to refill your AP.

There are five options available for `Refill_Resource`:
1. **SQ**: will consume Saint Quartz
2. **Bronze**: will consume Bronze Apples
3. **Silver**: will consume Silver Apples
4. **Gold**: will consume Gold Apples
5. **All Apples**: will consume all available apples in the following order: Bronze, Silver, Gold.

It does **not** reflect the amount of resources consumed, unless you're using SQ or Gold Apples.

### Chaldea Combat Uniform: Order Change
To use the Master Skill Order Change for servant exchange, insert the following Skill_Command:
```
x - activates Order Change
Starting Member Position - 1  2  3
Sub-member position - 1  2  3

e.g. 
Skill_Command = "x13"
Exchange starting member 1 with sub-member 3
```
You are able to mix the Order Change command with normal autoskill command:
```
Skill_Command = "bce,0,f3hi,#,j2d,#,4,x13a1g3"
```

### AutoSkill List
You can set Enable_Autoskill_List = 1 to enable this feature.
You can setup a predefined autoskill list from 1~10, and the script let you choose whenever it ran.
This especially helps if you need to farm few different stages during event.

### AutoSupportSelection
```Support_SelectionMode``` has 3 options: first, preferred, and manual.
The default settings ```first``` will select the first visible servant on the selection screen. Fastest one.

```manual``` is used when you can monitor your script running - you need to select the support servant yourself, and the script will continue running after selection.

```preferred``` is our desired option here. By putting screenshots of your pre-defined servant or CE into image_SUPPORT folder, that servant or CE can then be chosen automatically by the script. The pic must be a png file, cropped from 1280\*720 game screenshot. Name the file yourself and put the filename(s) in the options ```Support_PreferredServants``` or ```Support_PreferredCEs```, accordingly.

This selection function will try every combination that you put in the above settings.

Consider the following example:
```
Support_PreferredServants = "Any"
Support_PreferredServants = ""
(Putting "any" or leave it blank means that you don't care which servant it is.)

Support_PreferredCEs = "lunchtime.png, maid_in_halloween.png"
```
Then the script will search for:

• Any servant with CE Chaldea Lunchtime

• Any servant with CE Maid in Halloween

And select it **immediately** once the script found it. The script searches from the top to the bottom of the friend list. The reverse of the above example also stands true, i.e., waver.png with "Any" CE.

Consider another example:
```
Support_PreferredServants = "waver.png, tamamo.png"
Support_PreferredCEs = "lunchtime.png, maid_in_halloween.png"
```
And the script will search for:
• Waver + Lunchtime

• Waver + Maid in Halloween

• Tamamo + Lunchtime

• Tamamo + Maid in Halloween

And select it **immediately** once the script found it.

Your screenshot can be anything as long as it is inside the area outlined in red:
![support_list_region](https://raw.githubusercontent.com/29988122/Fate-Grand-Order_Lua/master/docs/support_list_region.png)

---

If the servant/CE is not found in the support list, the script will click refresh as many times as defined in ```Support_MaxUpdates```.

If this limit is reached, the script will use the ```Support_FallbackTo``` option to decide what do next. The options are the same as in ```Support_SelectionMode```. So, for instance, if the script is setup like this:

```
Support_SelectionMode = "preferred"
Support_PreferredServants = "waver4.png"
Support_PreferredCEs = "*maid_in_halloween.png" -- prepend a * if you want to make sure it is MLB(Max Level Break, hence the star sign.)
Support_MaxUpdates = 3
Support_FallbackTo = "first"
```

| waver4.png | maid_in_halloween.png |
| :---:      | :---:                 |
| ![waver4.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/waver4.png?raw=true)  | ![maid_in_halloween.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/maid_in_halloween.png?raw=true)  |

.... it will try to find Waver + a MLB Maid in Halloween CE in your support list. If it is not found in 3 refreshes maximum, the script will scroll back to top and pick the first visible servant.

The last option, ```Support_SwipesPerUpdate``` controls the number of swipes/servants before refreshing the screen.
If you have like 6 friend support servants, make it 6.

Thanks @potchy for implementing this function!

## Events:
If there are events which includes point reward system gained through quests, please set isEvent variable to 1.

This will allow the use of this script for the particular events.
If there are other additional windows, a custom script is required. 

## Card Priority Customization:
By changing the Battle_CardPriority option in the lua file you are executing(CN, EN, JP or TW), you can have your card selection behavior change. There are two modes available, simple and detailed mode. For example:
```
Simple Mode:
Battle_CardPriority = "BAQ" 
It will select Weak Buster->Buster->Resist Buster->Weak Arts->Arts->Resist Arts->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected.

Battle_CardPriority = "ABQ"
It will select Weak Arts->Arts->Resist Arts->Weak Buster->Buster->Resist Buster->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected. 

Detailed Mode:
Append W to BAQ to turn them into weak cards, append R to BAQ to turn them into resist cards.
You can create any priority order that will result in the most output you prefer.
Note that you must make sure that there are 9 distinct cards in your input.

Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"
It will select weak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick until all three cards included CPs are selected. 
```
## Noble Phantasm Behavior:
• disabled: Will never cast NPs automatically. If you have Autoskill enabled, please use this option.

• danger: Will cast NPs only when there are DANGER or SERVANT enemies on the screen. This option will probably mess up your Autoskill orders.

• spam: Will cast NPs as soon as they are available.

Currently, ```danger``` option will only start working, spamming NPs after you've finished all your pre-defined Autoskill commands.
Still in alpha state. If your Autoskill order got messed up, please use ```disabled``` option instead.

## How to capture screen for recognition:
You can manually replace target\_servant.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920\*1080->1280\*720, 2560\*1440->1280\*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.

## Troubleshooting
Known issues are listed here.

## Syntax error: unexpected symbol near '燎:
This error shows up when you save FGO_XX_REGULAR.lua using UTF-8-BOM encoding.

Download [Notepad++](https://notepad-plus-plus.org/) or a similar editor and save it using UTF-8 encoding instead.

![notepad-utf8](https://user-images.githubusercontent.com/4316326/48924293-944ab400-ee9d-11e8-869e-37a0a3456ff9.png)


## Feature requests:
Any feature request or bugreport are welcomed. Please create a new issue and I'll do my best!

有功能需要加入，腳本有問題，請去上面的issue討論版發新的討論文章，我會盡力做到。

バグとか機能要望とかは大歓迎。issue掲示板で新たなスレを立ち上げてください。

Enjoy the game!
