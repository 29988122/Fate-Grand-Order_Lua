@echo off
.\tools\adb.exe connect 127.0.0.1:62001
.\tools\lua5.1.exe .\tools\install.luac -k
set /p temp=""

