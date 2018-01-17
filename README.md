# Fate-Grand-Order_Lua

As of 2018.01.14, this script is working WITHOUT ROOT / BEING BLOCKED, I DO NOT take responsibility for your banned account! 
```
(Alghough I highly doubt it, 
they really should not add extra detection method as it will only drag the game EVEN slower, 
let alone this script runs at human speed.)
```
This script supported CN, EN, JP and TW server. KR server support can be added if user - you - can help us! Check issue forum for further info.

<p align="center">
  <a href="https://imgur.com/a/c6vKI">
    <img alt="Chaldea" src="https://camo.githubusercontent.com/19a9a5e1023613c01ba79aa1d03cae17d201f610/68747470733a2f2f7669676e65747465312e77696b69612e6e6f636f6f6b69652e6e65742f666174656772616e646f726465722f696d616765732f322f32642f4368616c6465615f53656375726974795f4f7267616e697a6174696f6e5f4c6f676f2e706e672f7265766973696f6e2f6c61746573742f7363616c652d746f2d77696474682d646f776e2f323030303f63623d3230313631313139303833333437" width="400"/>
  </a>
</p>

![Lua-Sikuli](https://img.shields.io/badge/Lua--Sikuli-5.1-blue.svg) [![GitHub license](https://img.shields.io/github/license/29988122/Fate-Grand-Order_Lua.svg)](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/LICENSE)


Screw those farming events - I only wanna enjoy the (kinoko) story!
Therefore I proudly brought you this: FGO automation script.

# Table of Contents:
* [Install](#install)
* [Use](#use)
* [Extra scripts](#extra-scripts)
* [Behavior details](#behavior-details)
  * [Auto refill](#auto-refill)
  * [Autoskill](#autoskill)
    * [Chaldea Combat Uniform: Order Change](#chaldea-combat-uniform-order-change)
  * [Events](#events)
  * [How to capture screen for recognition](#how-to-capture-screen-for-recognition)
* [Feature requests, 說明, 要望](#feature-requests)




## Install:
1. https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial
On Android, install the latest version of sikuli framework here.

2. Download the latest release version of Fate-Grand-Order_Lua, extract it.

3. Copy the whole extracted folder into your phone.

4. On Android, enable developer options->usb debugging, connect your PC to android and execute run.bat inside Fate-Grand-Order_Lua
\ama\_daemon folder **ON PC**. After daemon has been installed, you can disable usb debugging and unplug. DAEMON NEEDS TO BE REINSTALLED UPON PHONE REBOOT.

5. If daemon installation was not successful / driver not properly installed, please install this: https://forum.xda-developers.com/showthread.php?t=2317790

6. Open ankulua to check if daemon is properly installed - and load the script inside your phone - you're done.

7. Remember to update Fate-Grand-Order_Lua, just download the latest version from here, replace the old version in you phone.


## Use:
Please choice the corresponding lua file in AnkuLua according to your:
- FGO server (supported China / Japan / Taiwan / USA currently).
- Used in event or regular stages. 
Because sometimes events have extra window options to click, hence different version of scripts is required.
If there's no extra options for the current event during battle sequence, please use the regular one.
Refer to [Events](#events) for more details.

Then, put your game in either:
- menu, put your desired quest as the 1st item on the screen(upper-right corner).
- battle screen.

and click the transparent arrow. You're good to go.

I only update events in JP server, unless requested.

## Extra scripts:
* \_auto\_friendgacha.lua

As title. It will keep gacha until your bag's full.

* \_auto\_gift\_exchange

Use for Nero matsuri or Christmas events. Their UI really sucked.

## Behavior details:
- It is customized for events that I'm playing, hence some minor adjustments will be done frequently. **Remember to update!**

- Stamina does NOT automatically refilled, if you need to refill them automatically, please check [Auto refill](#auto-refill)

- Script sometimes stucked at certain screen - that's because FGO and delightworks SUCKED. If loading took too long, script will think it already finished loading and click when game's in fact not ready. Restart the script manually should suffice, or adjust all the wait() function in the .lua yourself. 3-5 seconds more would be enough. 

- Script automatically chooses weak cards, until "boss" fight.

- It will switch target to any "servant" or "danger" enemy, cast Noble Phantasm immediately and after until battle ended.

- Choose your party member wisely. Because this script does not do B/A/Q or brave chains, you have to observe the behavior of the script, and arrange your party accordingly in order to gain max clear efficiency / prevent party wipe from highest level event stage. 

- Customized skill command is supported, though the command execution is still highly depends on runtime conditions. Please check [Autoskill](#autoskill)

## Auto refill:
If you really want to refill automatically, please modify the lua file you are executing(TW, EN or JP). 

There are 3 variables - Refill\_or\_Not = 0, Use\_Stone = 0, How\_Many = 0. 

You should change Refill\_or\_Not to 1 to enable the auto refill feature, Use\_Stone to 1 if you don't have enough apple (default Use\_Stone = 0 will use apple), and How\_Many to your planned refill rounds.

For example, Refill\_or\_Not = 1 Use\_Stone = 1 How\_Many = 3 will enable the auto refill feature, use stone 3 times, and stop at the "not enough stamina" screen, without using 4th stone.

## Autoskill:
Autoskill allows you to execute customized skill command according to your team using a string. To enable, please modify the lua file you are executing(CN, EN, JP or TW).

Change Enable_Autoskill to 1 if you wish to enable it, 0 to disable. 

Skill_Confirmation allows you to skip the Confirm Skill Use window. Modify it according to your Battle Menu setting: 
```
OFF = 0
ON = 1
```
That is, if you need to click through confirmation window to use a skill, make this option Enable_Autoskill = 1. 
Otherwise, leave it Enable_Autoskill = 0.

Skill_Command is the command string which follows the rules below:
```
',' = Turn counter
',#,' = Battle counter
'0' = Skip 1 turn

Servant skill = a b c	d e f	g h i
Master skill = j k l
Target Servant = 1 2 3
Activate Servant NP = 4 5 6

Please insert your command in between the "".

eg:
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
### Chaldea Combat Uniform: Order Change
To use the Master Skill Order Change for servant exchange, insert the following Skill_Command:
```
x - activates Order Change
Starting Member Position - 1  2  3
Sub-member position - 1  2  3

eg:
Skill_Command = "x13"
Exchange starting member 1 with sub-member 3
```
You are able to mix the Order Change command with normal autoskill command:
```
Skill_Command = "bce,0,f3hi,#,j2d,#,4,x13a1g3"
```

## Events:
If there are events which includes point reward system gained through quests, please set isEvent variable to 1.

This will allow the use of this script for the particular events.
If there are other additional windows, a custom script is required. 

## How to capture screen for recognition:
You can manually replace target\_servant.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920\*1080->1280\*720, 2560\*1440->1280\*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.

## Feature requests:
Any feature request or bugreport are welcomed. Please create a new issue and I'll do my best!

有功能需要加入，腳本有問題，請去上面的issue討論版發新的討論文章，我會盡力做到。

バグとか機能要望とかは大歓迎。issue掲示板で新たなスレを立ち上げてください。

Enjoy the game!
