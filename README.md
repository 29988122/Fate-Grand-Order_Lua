# Fate-Grand-Order_Lua
This script supported CN, EN, JP and TW servers on Android devices < Oreo 8.0 and emulators.

[(What if I have > Android 8.1 phone?)](#android-81-and-above)

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

As of 2018.12.30, this script is **working without root** / without being blocked or banned, although I DO NOT take responsibility for your banned account! 

[Disclaimer and concern about your account](ACCOUNT%20SAFETY.md)

***

# Table of Contents:
* [中文說明 マニュアル](#中文說明-マニュアル)
* [Install](#install)
  * [Android 8.1 and above](#android-81-and-above)
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
* [Events](#events)  
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

### Android 8.1 and above:
As the security level on Android rises, it's getting increasingly harder to apply tweaks, daemons on Android without root.
You can still use the ```Media Projection``` and ```Android Accessibility``` methods to run FGO automation script **without installing daemon**.
Adjust them in the settings section inside Ankulua.

Not really recommended, as you'll need to refer to [here](http://ankulua.boards.net/board/1/general-discussion) for troubleshooting - we're not able to debug it as the alternative methods's not matured yet.

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
You need to change this line in the file ```setImagePath(dir .. "image_JP")``` to either ```image_JP``` ```image_EN``` ```image_TW``` ```image_CN``` to your server.

***

## Advanced features:
By adjust settings inside your lua file, you can achieve the following things:
* [AutoSkill](#autoskill) Cast skills in battle via user-predefined skill lists.
* [AutoRefill](#autorefill) Refill stamina as you wish. 
* [AutoSupportSelection](#autosupportselection) Select certain support servant+CE combination. 
* [Card Priority Customization](#card-priority-customization) Customize your card selection priority. 
* [Noble Phantasm Behavior](#noble-phantasm-behavior) When to cast NP in order to face dangerous servants. 

### AutoSkill:
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

#### Chaldea Combat Uniform: Order Change
Order Change from Chaldea Combat Uniform allows you to exchange servants during battle.
By inserting ```x``` into user-predefined strings, you can make your ```Skill_Command``` more flexible:
```
x - activates Order Change
Starting Member Position - 1  2  3
Sub-member position - 1  2  3

e.g. 
Skill_Command = "x13"
Exchange starting member 1 with sub-member 3
```
Of course, you can mix the Order Change command with normal Autoskill commands:
```
e.g.
Skill_Command = "bce,0,f3hi,#,j2d,#,4,x13a1g3"
```

#### AutoSkill List
Set ```Enable_Autoskill_List = 1``` to enable this feature.
You can setup a predefined autoskill list from 1~10, and the script whould let you choose from it when it starts running.
This especially helps if you need to farm different stages during events.

### AutoRefill:
Set `Refill_Enabled = 1` to enable AutoRefill.

There are five options available for `Refill_Resource`:
1. **SQ**: will consume Saint Quartz
2. **Gold**: will consume Gold Apples
3. **Silver**: will consume Silver Apples
4. **Bronze**: will consume Bronze Apples
5. **All Apples**: will consume all available apples in the following order: Bronze, Silver, Gold. This option is used when you need to do a full throttle farming.

`Refill_Repetitions` controls how many apples you want to use to refill your AP.

However, this option is only accurate when you're using SQ or Gold Apples.

On average, it will consume 3x the amount from `Refill_Repetitions` when using Bronze Apples, 1.2x the amount when using Silver Apples.

### AutoSupportSelection
```Support_SelectionMode``` has 3 options: first, preferred, and manual.
The default setting ```first``` will select the first visible servant on the selection screen. Fastest one.

```manual``` is used when you can monitor your script running - you need to select the support servant yourself, and the script will continue running after selection.

```preferred``` is our desired option here. By putting screenshots of your pre-defined servant or CE into image_SUPPORT folder, that servant or CE can then be chosen automatically by the script. 

[Follow this guide](https://github.com/29988122/Fate-Grand-Order_Lua/wiki/AutoSupportSelection) if you need to customize your desire servants and CEs. You can also use the the common servants and CEs we provided inside image_SUPPORT folder.

This selection function will search every combination of preferred servants and preferred CEs that you put in the above settings.

Thanks @potchy for implementing this function!

### Card Priority Customization:
By changing the ```Battle_CardPriority``` option, you can have your card selection behavior change. There are two modes available, simple and detailed mode. 

For example:
```
Simple Mode:
Battle_CardPriority = "BAQ" 
It will select Weak Buster->Buster->Resist Buster->Weak Arts->Arts->Resist Arts->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected.

Battle_CardPriority = "ABQ"
It will select Weak Arts->Arts->Resist Arts->Weak Buster->Buster->Resist Buster->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected. 
```
```
Detailed Mode:
Append W to BAQ to turn them into weak cards, append R to BAQ to turn them into resist cards.
You can create any priority order that will result in the most output you prefer.
You must make sure that you've listed all 9 distinct cards in the input string.

Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"
It will select weak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick until all three cards included CPs are selected. 
```

### Noble Phantasm Behavior:

```Battle_NoblePhantasm = "disabled"```
The script will never cast NPs automatically.

```Battle_NoblePhantasm = "danger"```
The script will cast NPs only when there are DANGER or SERVANT enemies on the screen. This option will probably mess up your Autoskill orders.

```Battle_NoblePhantasm = "spam"```
The script will cast NPs as soon as they are available.

If you have ```Enable_Autoskill = 1```, the above options applied after all of your predefined skills/NPs finished casting. 

## Events:
If there are events which includes:
* Power-up items before battle
* Extra button to be clicked from reward system window after battle  

Please set ```isEvent``` variable to 1.

This will allow the use of this script for certain events.

A custom script is required for summer racing events and Oni island events. 
Please ask in issue forum if you need this feature.

## How to capture screen for recognition:
You can manually replace target\_servant.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920\*1080->1280\*720, 2560\*1440->1280\*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.

## Troubleshooting
Known issues are listed here.

### Syntax error: unexpected symbol near '燎:
This error shows up when you save FGO_XX_REGULAR.lua using UTF-8-BOM encoding.

Download [Notepad++](https://notepad-plus-plus.org/) or a similar editor and save it using UTF-8 encoding instead.

![notepad-utf8](https://user-images.githubusercontent.com/4316326/48924293-944ab400-ee9d-11e8-869e-37a0a3456ff9.png)


## Feature requests:
Any feature request or bugreport are welcomed. Please create a new issue and I'll do my best!

有功能需要加入，腳本有問題，請去上面的issue討論版發新的討論文章，我會盡力做到。

バグとか機能要望とかは大歓迎。issue掲示板で新たなスレを立ち上げてください。

Enjoy the game!
