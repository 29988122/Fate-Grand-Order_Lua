# Fate-Grand-Order_Lua
This script supported CN, EN, JP and TW server. KR server support can be added if user - you - can help us! Check issue forum for further info. 

Any of the questions can be asked in the "Issues" section, you don't really have to find my mail address or DM me on reddit, I'm always here. Don't be shy xD

Please consider Star our repo to encourage us if this script is useful to you : )

<p align="center">
  <a href="https://imgur.com/a/c6vKI">
    <img alt="Chaldea" src="https://camo.githubusercontent.com/19a9a5e1023613c01ba79aa1d03cae17d201f610/68747470733a2f2f7669676e65747465312e77696b69612e6e6f636f6f6b69652e6e65742f666174656772616e646f726465722f696d616765732f322f32642f4368616c6465615f53656375726974795f4f7267616e697a6174696f6e5f4c6f676f2e706e672f7265766973696f6e2f6c61746573742f7363616c652d746f2d77696474682d646f776e2f323030303f63623d3230313631313139303833333437" width="400"/>
  </a>
</p>

[![Lua-5.1-Sikuli](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Lua--Sikuli-5.1-blue.svg)](http://http://www.sikuli.org/)[![GitHub license](https://cdn.rawgit.com/29988122/Fate-Grand-Order_Lua/ffdafd04/docs/Fate-Grand-Order_Lua.svg)](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/LICENSE)

Screw those farming events - I only wanna enjoy the (kinoko) story!

Therefore I proudly brought you this: FGO automation script.

As of 2018.08.26, this script is working WITHOUT ROOT / BEING BLOCKED, although I DO NOT take responsibility for your banned account! 

PSA: DO NOT update to Android 8.0 and above, or you'll have to use Emulator for the script.

[Disclaimer and concern about your account](ACCOUNT%20SAFETY.md)

# Table of Contents:
* [Install](#install)
* [Usage](#usage)
* [Extra scripts](#extra-scripts)
* [Behavior details](#behavior-details)
  * [AutoRefill](#autorefill)
  * [AutoSkill](#autoskill)
    * [Chaldea Combat Uniform: Order Change](#chaldea-combat-uniform-order-change)
    * [AutoSkill List](#autoskill-list)
  * [AutoSupportSelection](#autosupportselection)
  * [Events](#events)
  * [Card Priority Customization](#card-priority-customization)
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


## Usage:
Please choose the corresponding lua file in AnkuLua according to your:
- FGO server (supported China / Japan / Taiwan / USA currently).
Modify the lua file, change settings and add functions such as AutoSkill or AutoRefill to suit your needs.
(Sometimes, events have extra window options to click. Refer to [Events](#events) for more details.)

Then, put your game in either:
- menu, put your desired quest as the 1st item on the screen(upper-right corner).
- battle screen.

and click the transparent arrow. You're good to go.

## Extra scripts:
* \_auto\_friendgacha.lua

As title. It will keep gacha until your bag's full.

* \_auto\_gift\_exchange

Use for Nero matsuri or Christmas events. Their UI really sucked.

## Behavior details:
- Major and minor adjustments will be done frequently as FGO updates. **Remember to update!**

- Stamina does NOT automatically refilled, if you need to refill them automatically, please check [AutoRefill](#autorefill)

- Script sometimes stucked at certain screen - that's because FGO and delightworks SUCKED. If loading took too long, script will think it already finished loading and click when game's in fact not ready. Restart the script manually should suffice, or adjust all the wait() function in the .lua yourself. 3-5 seconds more would be enough. 

- Script automatically chooses weak cards, until "boss" fight.

- It will switch target to any "servant" or "danger" enemy, cast Noble Phantasm immediately and after until battle ended.

- Choose your party member wisely. Because this script does not do B/A/Q or brave chains, you have to observe the behavior of the script, and arrange your party accordingly in order to gain max clear efficiency / prevent party wipe from highest level event stage. 

- Customized skill command is supported, though the command execution is still highly depends on runtime conditions. Please check [AutoSkill](#autoskill).

- User-defined support selection is supported, though it could be slow at times, please consider your farming efficiency. Please check [AutoSupportSelection](#autosupportselection).

## AutoRefill:
If you really want to refill automatically, please modify the lua file you are executing(TW, EN or JP). 

There are 3 variables - Refill\_or\_Not = 0, Use\_Stone = 0, How\_Many = 0. 

You should change Refill\_or\_Not to 1 to enable the auto refill feature, Use\_Stone to 1 if you don't have enough apple (default Use\_Stone = 0 will use apple), and How\_Many to your planned refill rounds.

For example, Refill\_or\_Not = 1 Use\_Stone = 1 How\_Many = 3 will enable the auto refill feature, use stone 3 times, and stop at the "not enough stamina" screen, without using 4th stone.

## AutoSkill:
AutoSkill allows you to execute customized skill command according to your team using a string. To enable, please modify the lua file you are executing(CN, EN, JP or TW).

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
We did not implement skill cooldown check yet. 

However by planning ahead, wrote commands for many rounds(putting a lot of zeros), you can prevent the script accidently clicked the skills that were still on cooldown.

Also, you can have a band-aid fix by casting skills only on the 1st servant(a1,d1,f1, etc). By doing so, the script will click cancel when the skill's on cooldown, preventing stuck.

Thanks @ryuga93 for implementing this function!

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

```preferred``` is our desired option here. By putting screenshots of your pre-defined servant friend into image_SUPPORT folder, that servant can be choosed automatically by the script. The pic must be a png file, cropped from 1280\*720 game screenshot. Name the file yourself and put it in ```Support_PreferredServants```, if it is a Servant, or in ```Support_PreferredCEs``` it is a Craft Essence.

Your screenshot can be anything as long as it is inside the area outlined in red:
![screenshot_20180920-223126 1](https://user-images.githubusercontent.com/4316326/46427814-ba16d080-c718-11e8-893c-51c26ec02c22.png)

---

If the servant/CE is not found in the support list, the script will click refresh as many times as defined in ```Support_MaxRefreshes```.

If this limit is reached, the script will use the ```Support_FallbackTo``` option to decide what do next. The options are the same as in ```Support_SelectionMode```. So, for instance, if the script is setup like this:

```
Support_SelectionMode = "preferred"
Support_PreferredServants = "waver4.png"
Support_PreferredCEs = "*maid_in_halloween.png" -- prepend a * if you want to make sure it is MLB
Support_MaxRefreshes = 3
Support_FallbackTo = "first"
```

| waver4.png | maid_in_halloween.png |
| :---:      | :---:                 |
| ![waver4.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/waver4.png?raw=true)  | ![maid_in_halloween.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/maid_in_halloween.png?raw=true)  |

.... it will try to find Waver + a MLB Maid in Halloween CE in your support list. If it is not found in 3 refreshes maximum, the script will scroll back to top and pick the first visible servant.

The last option, ```Support_SwapsPerRefresh``` controls the number of swipes/servants before refreshing the screen.
If you have like 6 friend support servants, make it 6.

Check here for further info: 
https://github.com/29988122/Fate-Grand-Order_Lua/pull/42#issuecomment-415980728

Thanks @potchy for implementing this function!

## Events:
If there are events which includes point reward system gained through quests, please set isEvent variable to 1.

This will allow the use of this script for the particular events.
If there are other additional windows, a custom script is required. 

## Card Priority Customization:
By changing the Battle_CardPriority option in the lua file you are executing(CN, EN, JP or TW), you can have your card selection behavior change. For example:
```
Battle_CardPriority = "BAQ" 
It will select Weak Buster->Buster->Resist Buster->Weak Arts->Arts->Resist Arts->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected.

Battle_CardPriority = "ABQ"
It will select Weak Arts->Arts->Resist Arts->Weak Buster->Buster->Resist Buster->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected. 

Currently we don't support more detailed card selection parameters, sorry!
However, you can join us, write your code, and make a Pull Request to help other FGO players around the world. Thank you.
```

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
