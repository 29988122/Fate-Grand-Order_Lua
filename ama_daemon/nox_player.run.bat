@echo off
.\tools\nox_adb.exe connect 127.0.0.1:62001
.\tools\nox_adb.exe connect 127.0.0.1:62025
.\tools\nox_adb.exe connect 127.0.0.1:62026
.\tools\nox_adb.exe connect 127.0.0.1:62027
.\tools\nox_adb.exe connect 127.0.0.1:62028
.\tools\nox_adb.exe connect 127.0.0.1:62029
.\tools\nox_adb.exe connect 127.0.0.1:62030
.\tools\nox_adb.exe connect 127.0.0.1:62031
.\tools\nox_adb.exe connect 127.0.0.1:62032

.\tools\lua5.1.exe .\tools\install.nox.luac
set /p temp=""
