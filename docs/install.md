# Install
1. **On Android**, install the latest version of AnkuLua(Sikuli) framework. https://ankulua.boards.net/thread/1395/free-ankulua-trial-apk-download

2. Download the latest [release](https://github.com/29988122/Fate-Grand-Order_Lua/archive/master.zip) of script, extract it **on PC**.

3. Copy the whole extracted folder into your Android phone or emulator.

4. **On Android**, enter settings->enable developer options->enable usb debugging.

5. Connect your PC to Android with USB cable, and execute run.bat **on PC** inside```Fate-Grand-Order_Lua\ama_daemon```folder. 

6. After daemon has been installed, you can disable usb debugging and unplug. **Daemon needs to be reinstalled upon phone reboot**.
  * If daemon installation was not successful / driver not properly installed, please install this: https://forum.xda-developers.com/showthread.php?t=2317790

7. Open Ankulua to check if daemon is properly installed - and load the correct script inside your phone - enjoy the game your way!

## Android 8.1 and above
As the security level on Android rises, it's getting increasingly harder to apply tweaks, daemons on Android without root.
You can still use the ```Media Projection``` and ```Android Accessibility``` methods to run FGO automation script **without installing daemon**.
Adjust them in the settings section inside Ankulua.

Not really recommended, as you'll *probably* need to refer to [here](http://ankulua.boards.net/board/1/general-discussion) for troubleshooting - we're not able to debug it most of the time, since the scope of the issue is out of our hand. The alternative methods's not really matured yet, unfortunately :(