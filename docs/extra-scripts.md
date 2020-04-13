# Extra scripts

Other than FGO_Regular.lua, this repository contains a few other helpful scripts.

## `_auto_friendgacha.lua`

This script will continue to do summons until your inventory is full.

I would suggest using it for FP summons only, but it can also be used for SQ summons.

## `_auto_gift_exchange.lua`

Used for Nero or Christmas events to automatically open lottery boxes. The script will continually open boxes until the present box is full.

You need to set your server region at
```
GameRegion = "EN"
```

The possible values are:
- CN for China
- JP for Japan
- TW for Taiwan
- EN for USA

## `_auto_gift_box.lua`

Also used for Nero or Christmas events. This script automatically retrieves EXP cards from your gift box.

The configuration parameters are:

| Variable        | Description                                                                                                                                                                                            |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Gold_Threshold  | If 4* EXP cards are detected, the script will only retrieve stacks with a size < Gold_Threshold.<br><br>For example, if the threshold is 3, all 4* EXP stacks with a size of 1 or 2 will be collected. |
| Count_Region_X  | Must either be set to NACountRegionX or JPCountRegionX, depending on the server region.                                                                                                                |
| Max_Click_Count | The maximum number of presents to collect.<br><br>If your inventory space is very limited, you should choose a low number.                                                                             |

You will probably have to optimize the Y positions in the `touchActions` part of the script yourself, since scrolling behaves differently dependening on your device and Ankulua settings.