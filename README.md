# Fate-Grand-Order_Lua
AS OF 2017.05.01 CCC EVENT, THIS SCRIPT IS WORKING WITHOUT ROOT / BEING BLOCKED, I DO NOT TAKE RESPONSIBILITY FOR YOUR BANNED ACCOUNT! (Alghough I highly doubt it, they are terrible coders, let alone this script run at human speed.)

Screw those farming events - I only wanna enjoy the (kinoko) story!
Therefore I brought you this: FGO automation script.

Install:
1. https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial
Download the latest version of sikuli framework here.

2. Enable usb debugging, connect your PC to android and execute run.bat inside ama_daemon folder. After daemon has been installed, you can disable usb debugging and unplug. DAEMON NEEDS TO BE REINSTALLED UPON REBOOT.

3. Open ankulua to check if daemon is properly installed - and you're done.
Put your game in
- menu, put your desired quest on the 1st item.
- battle screen.
and click the transprent arrow. You're good to go.


Behavior details:
- It is custoimized for events that I'm playing, hence some minor adjustments.
Most of the time it can run any quest without problem.

- Stamina does NOT automatically refilled, you have to eat those precious apples manually.

- Script automatically chooses weak cards, until "boss" fight.
It will switch target to any "servant", cast Noble Phantasm immediately and after until battle ended.
You can manually replace target.png inside image folder to customize your priority target.
1. screenshot your phone
2. convert it to png format
3. resize it to 1280 WIDTH (1920*1080->1280*720, 2560*1440->1280*720, etc.)
4. crop the desired pattern(ex: danger, servant, or particular enemy name) for the script to recognize.
5. replace target.png and test.

Enjoy the game!
