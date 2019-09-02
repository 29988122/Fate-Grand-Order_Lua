# Project Avalon
Project Avalon is an extension of [Fate-Grand-Order_Lua](https://github.com/29988122/Fate-Grand-Order_Lua), with the aim of using the processing power of PC to perform complex algorithm for the script, which cannot be handled by currently widely posessed mobile devices.

Note: This project is currently WIP and hence be aware of messy codes and bugs.
***

# Table of Contents:
* [Concept](#concept)
* [Installation](#installation)
* [Usage](#usage)
* [Features](#features)
* [Credits](#credits)

***
## Concept
<img src="https://i.imgur.com/C4Zcmh4.png" width="400">

The main aim of using Avalon wrapper is to reduce the coupling of FGO_Lua and Project Avalon. By using this method, FGO_Lua can be developed independently from Project Avalon. Besides, users could use the standalone FGO_Lua scripts when the Avalon server isn't available.

The FGO_Lua folder holds the Lua codes factored out from the original FGO_Lua scripts. Pendragon folder holds the lua functions for REST API(in /pendragon/api.lua), as well as FGO module algorithms modifed to handle REST API.

## Installation
To run the Avalon features, Python 3.6 is required in your PC. Personally, I use [Anaconda](https://www.anaconda.com/) to manage my Python environments.

Next, install [Tesseract library for OCR](https://github.com/tesseract-ocr/tesseract/wiki).

Then, in Anaconda, create a Python 3.6 envirionment and install all the required packages in the /api/requirements.txt

Note: Put everything into your mobile device except the api folder which will stay in your PC.

## Usage:
Please choose the corresponding lua file in AnkuLua according to your:
* FGO server (supported China / Japan / Taiwan / USA currently)
    * FGO_CN_REGULAR.lua
    * FGO_JP_REGULAR.lua
    * FGO_TW_REGULAR.lua
    * FGO_EN_REGULAR.lua

In the lua file above, set ```Use_Avalon = 1``` to enable the Avalon features.

In the lua file /avalon/pendragon/config.lua, change the IP Address of ```Config.API_URL``` to your PC's local network IP. You can check you local network IP using [Fing App](https://www.fing.com/products/fing-app).

In /api/source, change the Tesseract related file settings ```pytesseract.pytesseract.tesseract_cmd``` and ```tessdata_dir_config``` to your Tesseract installation folder.

Then, run the Python script called ```index.py``` in /api/source, using terminal/comand prompt or Python IDE such as [Liclipse](https://www.liclipse.com/).

## Features/Proof Of Concept:
Currently, the only Avalon feature available is the detection of Stage, which enables Fate-Grand-Order_Lua to execute AutoSkills in any stages in battle. Instead of the need to start Fate-Grand-Order_Lua at Stage 1/3, you can run it at any stage such as 2/3 or 3/3 and have AutoSkills for that stage to be executed. [Demo](https://streamable.com/v58lv)

Currently, there are other features that are being planned such as Context Aware AutoSkill and Reinforced Learning Card Chaining. If you have additional idea implementations to contribute, please submit a pull request.

## Credits:
[PokeGuys](https://github.com/PokeGuys/fgo-script) for the API between Ankulua and PC.

[Sugi-chan](https://github.com/sugi-chan/pendragon) for his Reinforced Learning FGO card chaining algorithm.
