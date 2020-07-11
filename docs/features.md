# Features

By adjusting the settings inside your FGO_REGULAR.lua file, you can achieve the following things:
* [AutoSkill](#autoskill) Cast skills in battle via user-predefined skill lists.
* [AutoRefill](#autorefill) Refill stamina as you wish. 
* [AutoSupportSelection](#autosupportselection) Select certain support servant+CE combination. 
* [Card Priority Customization](#card-priority-customization) Customize your card selection priority. 
* [Noble Phantasm Behavior](#noble-phantasm-behavior) When to cast NP in order to face dangerous servants.
* [Party Selection](#party-selection) Select one of your parties when starting a quest.

## AutoSkill
AutoSkill allows you to execute a series of turn-based skill commands, via user-predefined strings.
Change ```Enable_Autoskill``` to 1 to enable it, 0 to disable. 

```Skill_Confirmation``` allows you to skip the Confirm Skill Use window. Modify it according to your Battle Menu setting: 
```lua
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

`Skill_Command` strings should be composed by the following rules:
```lua
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

### Chaldea Combat Uniform: Order Change
Order Change from Chaldea Combat Uniform allows you to exchange servants during battle.
By inserting `x` into user-predefined strings, you can make your `Skill_Command` more flexible:
```lua
x - activates Order Change
Starting Member Position - 1  2  3
Sub-member position - 1  2  3

e.g. 
Skill_Command = "x13"
Exchange starting member 1 with sub-member 3
```
Of course, you can mix the Order Change command with normal Autoskill commands:
```lua
e.g.
Skill_Command = "bce,0,f3hi,#,j2d,#,4,x13a1g3"
```

### Targeting Enemies
You can target specific enemies you wish to target with your skills or NP.
By inserting ```t``` into user-predefined strings, you can make use of this for more complex fights:
```lua
t - informs script of targeting
Position of enemy - 1 2 3

e.g.
Skill_Command = "t1at35"
Target far left enemy for using Servant 1 skill 1, then target far right enemy for using Servant 1 NP
```
Lastly, the ```Battle_AutoChooseTarget``` variable in the config file is set to on by default. Using the autoskill functionality to target specific enemies is redundant with the auto selection, so it is recommended that you turn auto selection off if you plan to use this Target feature.

### Attack with Command Cards before NPs
You can attack using 1 or 2 Command Cards before attacking with NPs.

To use it, insert either ```n1``` or ```n2``` to use 1 or 2 Command Cards before launching the configured NPs.

Here are some examples:
```lua
Skill_Command = "n145"
Use 1 regular Command Card according to the priority from Battle_CardPriority, then use the NPs of the first and second Servants

Skill_Command = "n26"
Use 2 regular Command Cards, then use the NP of the third Servant
```

## AutoRefill
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

## AutoSupportSelection
`Support_SelectionMode` has 3 options: first, preferred, and manual.
The default setting `first` will select the first visible servant on the selection screen. Fastest one.

`manual` is used when you can monitor your script running - you need to select the support servant yourself, and the script will continue running after selection.

`preferred` is our desired option here. By putting screenshots of your pre-defined servant or CE into image_SUPPORT folder, that servant or CE can then be chosen automatically by the script.

### Support_PreferredServants and Support_PreferredCEs

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

And select it **immediately** once the script found any of them. The script searches from the top to the bottom of the friend list. The reverse of the above example also stands true, i.e., waver.png with "Any" CE.

Consider another example:
```
Support_PreferredServants = "waver.png, tamamo.png"
Support_PreferredCEs = "*lunchtime.png, maid_in_halloween.png"
(Prepend a * if you want to make sure it is MLB (Max Level Break, hence the star sign)).
```
And the script will search for:

• Waver + *Max Level Break* Lunchtime

• Waver + Maid in Halloween

• Tamamo + *Max Level Break* Lunchtime

• Tamamo + Maid in Halloween

And select it **immediately** once the script found any of them.

### Support_SelectionMode, Support_MaxUpdates, and Support_FallbackTo

If the servant/CE is not found in the support list, the script will click refresh as many times as defined in ```Support_MaxUpdates```.

If this limit is reached, the script will use the ```Support_FallbackTo``` option to decide what do next. The options are the same as in ```Support_SelectionMode```. So, for instance, if the script is set up like this:

```lua
Support_SelectionMode = "preferred"
Support_PreferredServants = "waver4.png"
Support_PreferredCEs = "*maid_in_halloween.png"
Support_MaxUpdates = 3
Support_FallbackTo = "first"
```

| waver4.png | maid_in_halloween.png |
| :---:      | :---:                 |
| ![waver4.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/waver4.png?raw=true)  | ![maid_in_halloween.png](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/image_SUPPORT/maid_in_halloween.png?raw=true)  |

.... it will try to find Waver + a MLB Maid in Halloween CE in your support list. If it is not found in 3 refreshes maximum, the script will scroll back to top and pick the first visible servant.

The last option, ```Support_SwipesPerUpdate``` controls the number of swipes/servants before refreshing the screen.
If you have like 6 friend support servants, make it 6.

### Using Your Own Images

[Follow this guide](support-image-maker.md) if you need to customize your desire servants and CEs. You can also use the the common servants and CEs we provided inside image_SUPPORT folder.

## Card Priority Customization
By changing the `Battle_CardPriority` option, you can have your card selection behavior change. There are two modes available, simple and detailed mode. 

For example:
```lua
Simple Mode:
Battle_CardPriority = "BAQ" 
It will select Weak Buster->Buster->Resist Buster->Weak Arts->Arts->Resist Arts->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected.

Battle_CardPriority = "ABQ"
It will select Weak Arts->Arts->Resist Arts->Weak Buster->Buster->Resist Buster->Weak Quick->Quick->Resist Quick cards until all three cards included CPs are selected. 
```
```lua
Detailed Mode:
Append W to BAQ to turn them into weak cards, append R to BAQ to turn them into resist cards.
You can create any priority order that will result in the most output you prefer.
You must make sure that you've listed all 9 distinct cards in the input string.

Battle_CardPriority = "WA, WB, WQ, A, B, Q, RA, RQ, RB"
It will select weak arts->weak buster->weak buster->arts->buster->quick->resist arts->resist buster->resist quick until all three cards included CPs are selected. 
```

## Auto Target Choosing

By default, ```Battle_AutoChooseTarget = 1``` will choose "servant" or "danger" enemy as target every turn.

Change it to ```Battle_AutoChooseTarget = 0``` to disable this behavior.

## Noble Phantasm Behavior

```Battle_NoblePhantasm = "disabled"```
The script will never cast NPs automatically.

```Battle_NoblePhantasm = "danger"```
The script will cast NPs only when there are DANGER or SERVANT enemies on the screen. This option will probably mess up your Autoskill orders.

```Battle_NoblePhantasm = "spam"```
The script will cast NPs as soon as they are available.

If you have ```Enable_Autoskill = 1```, the above options applied after all of your predefined skills/NPs finished casting.

## Party Selection
If you set `Party_Number` to a number between 1 and 10, the script will automatically switch to that party after selecting the support Servant.

You can either set this value globally or as part of the ```Autoskill_List``` entries.

## More script options
These are some optional features you can use in your scripts

### Events
If there are events which includes:
* Power-up items before battle
* Extra button to be clicked from reward system window after battle  

Please set ```isEvent``` variable to 1.

This will allow the use of this script for certain events.

A custom script is required for summer racing events and Oni island events. 
Please ask in issue forum if you need this feature.

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
