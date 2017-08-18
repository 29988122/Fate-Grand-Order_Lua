# Fate-Grand-Order_Lua
AS OF 2017.08.18, THIS SCRIPT IS WORKING WITHOUT ROOT / BEING BLOCKED, I DO NOT TAKE RESPONSIBILITY FOR YOUR BANNED ACCOUNT! (Alghough I highly doubt it, they are terrible coders, let alone this script runs at human speed.)

Screw those farming events - I only wanna enjoy the (kinoko) story!
Therefore I brought you this: FGO automation script.

Install:
1. https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial
Download the latest version of sikuli framework here.

2. Enable usb debugging, connect your PC to android and execute run.bat inside ama_daemon folder. After daemon has been installed, you can disable usb debugging and unplug. DAEMON NEEDS TO BE REINSTALLED UPON PHONE REBOOT.

3. Open ankulua to check if daemon is properly installed - and you're done.

Put your game in either:
- menu, put your desired quest as the 1st item on the screen(upper-right corner).
- battle screen.
and click the transprent arrow. You're good to go.

Please choice the corresponding lua file accroding to your:
- FGO server (supported Japan / Taiwan currently).
- Used in event or regular stages. 
Because events have extra window options to click, hence different version of scripts.
I only update events in JP server, unless requested.

Behavior details:
- It is custoimized for events that I'm playing, hence some minor adjustments will be done frequently. Remember to update!
- Stamina does NOT automatically refilled, you have to eat those precious apples manually.
- Script automatically chooses weak cards, until "boss" fight.
- It will switch target to any "servant" or "danger" enemy, cast Noble Phantasm immediately and after until battle ended.


Extra:
You can manually replace target_servant.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920*1080->1280*720, 2560*1440->1280*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.

Enjoy the game!
