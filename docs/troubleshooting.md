# Troubleshooting
Known issues are listed here.

## Syntax error: unexpected symbol near '燎
This error shows up when you save FGO_REGULAR.lua using UTF-8-BOM encoding.

Download [Notepad++](https://notepad-plus-plus.org/) or a similar editor and save it using UTF-8 encoding **without BOM** instead.

![notepad-utf8](https://user-images.githubusercontent.com/4316326/48924293-944ab400-ee9d-11e8-869e-37a0a3456ff9.png)

## The script clicks in the wrong locations or does nothing at all
First of all, make sure that you are using the current Ankulua version.

If the script still misbehaves, it's most likely because it doesn't detect the game area correctly.

There are 2 Ankulua settings in [scaling.lua](https://github.com/29988122/Fate-Grand-Order_Lua/blob/master/modules/scaling.lua), which may need to be modified on your device:
```lua
setImmersiveMode(true)
autoGameArea(true)
```

`setImmersiveMode` tells Ankulua to assume that no Android navigation bar is present while playing FGO. If there is one, on your device, set this to `false`.

`autoGameArea` removes black areas created by notches. In most cases leaving this on `true` will create no problems, even if you don't have a notch.

For the official documentation, see the [Ankulua forum post](https://ankulua.boards.net/thread/7/settings).

If you need to debug whether your settings are correct or not, add this right before the `end` of `scaling.ApplyAspectRatioFix`:

```lua
	Region(0, 0, SCRIPT_WIDTH, SCRIPT_HEIGHT):highlight(10)
```

This will show a red border around the detected game region, excluding the blue bars. If it doesn't look correct, try different `autoGameArea` and `setImmersiveMode` combinations.