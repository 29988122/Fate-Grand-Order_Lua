@echo off
.\tools\adb connect 127.0.0.1:6555

rem itools simulator
.\tools\adb connect 127.0.0.1:54001

rem BS multiple instances
.\tools\adb connect 127.0.0.1:5555
.\tools\adb connect 127.0.0.1:6666
.\tools\adb connect 127.0.0.1:7777
.\tools\adb connect 127.0.0.1:9999


