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

[![Lua-5.1-Sikuli](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Lua--Sikuli-5.1-blue.svg)](http://www.sikuli.org/)[![GitHub license](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Fate-Grand-Order_Lua.svg)](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/LICENSE)

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
* [Events](#events)
* [Advanced features](#advanced-features)
	* [AutoSkill](#autoskill)
		* [Chaldea Combat Uniform: Order Change](#chaldea-combat-uniform-order-change)
		* [Targeting Enemies](#targeting-enemies)
		* [Attack with Command Cards before NPs](#attack-with-command-cards-before-nps)
	* [AutoRefill](#autorefill)
	* [AutoSupportSelection](#autosupportselection)
	* [Card Priority Customization](#card-priority-customization)
	* [Auto Target Choosing](#auto-target-choosing)
	* [Noble Phantasm Behavior](#noble-phantasm-behavior)
* [More script options](#more-script-options)
* [Troubleshooting](#troubleshooting)
	* [Syntax error: unexpected symbol near '燎](#syntax-error-unexpected-symbol-near-燎)
* [Feature requests, 說明, 要望](#feature-requests)

***

## 中文說明 マニュアル
[中文說明](https://github.com/29988122/Fate-Grand-Order_Lua/wiki/readme.md-%E6%AD%A3%E9%AB%94%E4%B8%AD%E6%96%87)

[マニュアル](https://github.com/29988122/Fate-Grand-Order_Lua/wiki/readme.md-%E6%97%A5%E6%9C%AC%E8%AA%9E)

## Install:
1. **On Android**, install the latest version of AnkuLua(Sikuli) framework. https://ankulua.boards.net/thread/1395/free-ankulua-trial-apk-download

2. Download the latest [release](https://github.com/29988122/Fate-Grand-Order_Lua/archive/master.zip) of script, extract it **on PC**.

3. Copy the whole extracted folder into your Android phone or emulator.

4. **On Android**, enter settings->enable developer options->enable usb debugging.

5. Connect your PC to Android with USB cable, and execute run.bat **on PC** inside```Fate-Grand-Order_Lua\ama_daemon```folder. 

6. After daemon has been installed, you can disable usb debugging and unplug. **Daemon needs to be reinstalled upon phone reboot**.
* If daemon installation was not successful / driver not properly installed, please install this: https://forum.xda-developers.com/showthread.php?t=2317790

7. Open Ankulua to check if daemon is properly installed - and load the correct script inside your phone - enjoy the game your way!

### Android 8.1 and above:
As the security level on Android rises, it's getting increasingly harder to apply tweaks, daemons on Android without root.
You can still use the ```Media Projection``` and ```Android Accessibility``` methods to run FGO automation script **without installing daemon**.
Adjust them in the settings section inside Ankulua.

Not really recommended, as you'll *probably* need to refer to [here](http://ankulua.boards.net/board/1/general-discussion) for troubleshooting - we're not able to debug it most of the time, since the scope of the issue is out of our hand. The alternative methods's not really matured yet, unfortunately :( 

## Usage:
Please set your server region in `FGO_REGULAR.lua`:
```
GameRegion = "EN"
```

- CN for China
- JP for Japan
- TW for Taiwan
- EN for USA

Put your game in either:
* Menu screen, make the quest you wanna farm as the 1st item on the screen (upper-right corner)
* Battle screen
* Results screen (first menu with or without bond level up)
* Support Selection screen

And start the script (`FGO_REGULAR.lua`).

The script will automatically enter battle, choose cards for you, again and again until AP depleted.

## Extra scripts:
```_auto_friendgacha.lua```

As title. It will keep gacha until your bag's full. I suggest using it for friend gacha only, despite it can also be used for stone gacha.

```_auto_gift_exchange.lua```

Used for Nero matsuri or Christmas events. Their UX really sucked, so a script for gacha is a nice QoL improvement.
You need to change this line in the file ```setImagePath(dir .. "image_JP")``` to either ```image_JP``` ```image_EN``` ```image_TW``` ```image_CN``` to your server.

## Events:
If there are events which includes:
* Power-up items before battle
* Extra button to be clicked from reward system window after battle  

Please set ```isEvent``` variable to 1.

This will allow the use of this script for certain events.

A custom script is required for summer racing events and Oni island events. 
Please ask in issue forum if you need this feature.

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

```Autoskill_List``` is where you setup predefined autoskill settings.
The script would let you choose one from it when it starts running.
This especially helps if you need to farm different stages during events.

Every entry in ```Autoskill_List``` should have a ```Name``` and ```Skill_Command```. You can have any number of entries in ```Autoskill_List```.  
Optionally, you can also override any globally defined option.

e.g.
```lua
Autoskill_List =
{
	-- Setting 1 does not override global options
	{
		Name = "Party 1",
		Skill_Command = "4,#,f5,#,i6"
	},
	-- Setting 2 overrides support selection method to preferred, Preferred Support servant to Any and CE to mona lisa.
	{
		Name = "QP",
		Skill_Command = "4,#,f5,#,i6",
		Support_SelectionMode = "preferred",
		Support_PreferredServants = "",
		Support_PreferredCEs = "*mona_lisa.png"
	},
	-- Setting 3 overrides Card Priority
	{
		Name = "Quick",
		Skill_Command = "d1g14,#,e14,#,h1fi4",
		Battle_CardPriority = "QBA"
	}
}
```

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

#### Targeting Enemies
You can target specific enemies you wish to target with your skills or NP.
By inserting ```t``` into user-predefined strings, you can make use of this for more complex fights:
```
t - informs script of targeting
Position of enemy - 1 2 3

e.g.
Skill_Command = "t1at35"
Target far left enemy for using Servant 1 skill 1, then target far right enemy for using Servant 1 NP
```
Lastly, the ```Battle_AutoChooseTarget``` variable in the config file is set to on by default. Using the autoskill functionality to target specific enemies is redundant with the auto selection, so it is recommended that you turn auto selection off if you plan to use this Target feature.

#### Attack with Command Cards before NPs
You can attack using 1 or 2 Command Cards before attacking with NPs.

To use it, insert either ```n1``` or ```n2``` to use 1 or 2 Command Cards before launching the configured NPs.

Here are some examples:
```
Skill_Command = "n145"
Use 1 regular Command Card according to the priority from Battle_CardPriority, then use the NPs of the first and second Servants

Skill_Command = "n26"
Use 2 regular Command Cards, then use the NP of the third Servant
```

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

### Auto Target Choosing:

By default, ```Battle_AutoChooseTarget = 1``` will choose "servant" or "danger" enemy as target every turn.

Change it to ```Battle_AutoChooseTarget = 0``` to disable this behavior.

### Noble Phantasm Behavior:

```Battle_NoblePhantasm = "disabled"```
The script will never cast NPs automatically.

```Battle_NoblePhantasm = "danger"```
The script will cast NPs only when there are DANGER or SERVANT enemies on the screen. This option will probably mess up your Autoskill orders.

```Battle_NoblePhantasm = "spam"```
The script will cast NPs as soon as they are available.

If you have ```Enable_Autoskill = 1```, the above options applied after all of your predefined skills/NPs finished casting.

## More script options
These are some optional features you can use in your scripts

### Debug_Mode
Debug mode highlights the region of the game recognized by the script on your screen instead of actually running the script. To enable, set:
```lua
Debug_Mode = true
```

### StopAfterBond10
If you want to stop the script after retreiving a Bond 10 CE card, set:
```lua
StopAfterBond10 = 1
```

### BoostItem_SelectionMode
Enables the use of event boost items.

Possible values: `disabled` (default), `1`, `2` or `3`.

If you want to use this, make sure **Confirm Use of Boost Item** is off.

### StorySkip
If you want the script to automatically skip story scenes, set:
```lua
StorySkip = 1
```

### Withdraw_Enabled
If you want to automatically withdraw and try the quest again when all your Servants have been defeated, set:
```lua
Withdraw_Enabled = true
```

### UnstableFastSkipDeadAnimation
If you want to skip the death animations, set:
```lua
UnstableFastSkipDeadAnimation = 1
```

This feature is unstable, so its use is not recommended.

## Troubleshooting
Known issues are listed here.

### Syntax error: unexpected symbol near '燎:
This error shows up when you save FGO_REGULAR.lua using UTF-8-BOM encoding.

Download [Notepad++](https://notepad-plus-plus.org/) or a similar editor and save it using UTF-8 encoding **without BOM** instead.

![notepad-utf8](https://user-images.githubusercontent.com/4316326/48924293-944ab400-ee9d-11e8-869e-37a0a3456ff9.png)

## Feature requests:
Any feature request or bug report is welcome. Please create a new issue and I'll do my best.

Enjoy the game!
