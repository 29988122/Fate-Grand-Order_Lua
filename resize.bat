@echo off 
rem set size=%1%%
rem echo %size%
IF "%3"=="" GOTO :usage

if not exist %3 (
mkdir %3
)

cd %2
for %%x in (*.png) do ..\convertPng.exe %%x -resize %1%% ..\%3\%%x
cd ..
goto :eof
rem ..\convert.exe %%x -resize %size% 640\%%x

:usage
echo Usage: resize percent "from directory" "to directory
echo for example, resize 50 image.2560 image.1280

:eof