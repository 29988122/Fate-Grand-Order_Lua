# Fate-Grand-Order_Lua

As of 2017.11.20, this script is working WITHOUT ROOT / BEING BLOCKED, I DO NOT take responsibility for your banned account! 
```
(Alghough I highly doubt it, 
they really should not add extra detection method as it will only drag the game EVEN slower, 
let alone this script runs at human speed.)
```
This script supported TW, JP and USA server.

<p align="center">
  <a href="https://imgur.com/a/c6vKI">
    <img alt="Chaldea" src="https://camo.githubusercontent.com/19a9a5e1023613c01ba79aa1d03cae17d201f610/68747470733a2f2f7669676e65747465312e77696b69612e6e6f636f6f6b69652e6e65742f666174656772616e646f726465722f696d616765732f322f32642f4368616c6465615f53656375726974795f4f7267616e697a6174696f6e5f4c6f676f2e706e672f7265766973696f6e2f6c61746573742f7363616c652d746f2d77696474682d646f776e2f323030303f63623d3230313631313139303833333437" width="400"/>
  </a>
</p>

Screw those farming events - I only wanna enjoy the (kinoko) story!
Therefore I proudly brought you this: FGO automation script.

# Table of Contents:
[Install](#install)

[Use](#use)

[Behavior details](#behavior-details)
  [Auto refill](#auto-refill)
  [How to capture screen for recognition](#




## Install
1. https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial
Download the latest version of sikuli framework here.

2. Enable usb debugging, connect your PC to android and execute run.bat inside ama\_daemon folder. After daemon has been installed, you can disable usb debugging and unplug. DAEMON NEEDS TO BE REINSTALLED UPON PHONE REBOOT.

3. Open ankulua to check if daemon is properly installed - and you're done.



## Use
Please choice the corresponding lua file in AnkuLua accroding to your:
- FGO server (supported Japan / Taiwan / USA currently).
- Used in event or regular stages. 
Because sometimes events have extra window options to click, hence different version of scripts.
If there's no extra options for the current event during battle sequence, please use the regular one.

Then, put your game in either:
- menu, put your desired quest as the 1st item on the screen(upper-right corner).
- battle screen.

and click the transprent arrow. You're good to go.

I only update events in JP server, unless requested.




## Behavior details
- It is custoimized for events that I'm playing, hence some minor adjustments will be done frequently. **Remember to update!**
- Stamina does NOT automatically refilled, if you need to refill them automatically, please check [Auto refill](#auto-refill)
- Script sometimes stucked at certain screen - that's because FGO and delightworks SUCKED. If loading took too long, script will think it already finished loading and click when game's in fact not ready. Restart the script manually should suffice, or adjust all the wait() function in the .lua yourself. 3-5 seconds more would be enough. 
- Script automatically chooses weak cards, until "boss" fight.
- It will switch target to any "servant" or "danger" enemy, cast Noble Phantasm immediately and after until battle ended.
- Choose your party member wisely. Because this script does not do B/A/Q or brave chains, you have to observe the behavior of the script, and arrange your party accordingly in order to gain max clear efficiency / prevent party wipe from highest level event stage. 


## Auto refill
If you really want to refill automatically, please modify the lua file you are executing(TW, EN or JP). 

There are 3 variables - Refill_or_Not = 0, Use_Stone = 0, How_Many = 0. 

You should change Refill_or_Not to 1 to enable the auto refill feature, Use_Stone to 1 if you don't have enough apple (default Use_Stone = 0 will use apple), and How_Many to your planned refill rounds.

For example, Refill_or_Not = 1 Use_Stone = 1 How_Many = 3 will enable the auto refill feature, use stone 3 times, and stop at the "not enough stamina" screen, without useing 4th stone.


Extra:
You can manually replace target_servant.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920*1080->1280*720, 2560*1440->1280*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.
---
Any feature request or bugreport are welcomed. Please create a new issue and I'll do my best!

有功能需要加入，腳本有問題，請去上面的issue討論版發新的討論文章，我會盡力做到。

バグとか機能要望とかは大歓迎。issue掲示板で新たなスレを立ち上げてください。

Enjoy the game!
