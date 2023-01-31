@echo off
REM Rust Server Installer (v2.4.0) by lilciv#2944
mode 130,25 & color 02

:intro
title Rust Server Installer - lilciv#2944
echo This script will install a Rust Server on your computer.
echo.
pause
cls

:steamcmd
title Installing SteamCMD...
set steamcmd=C:\SteamCMD
echo Enter the location you want SteamCMD installed (Default: C:\SteamCMD)
echo.
set /p steamcmd="Location: "
echo.
md "%steamcmd%"
curl -SL -A "Mozilla/5.0" https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip --output "%steamcmd%"\SteamCMD.zip
cd /d "%steamcmd%"
powershell -command "Expand-Archive -Force SteamCMD.zip ./"
del SteamCMD.zip
cls
echo SteamCMD installed!
echo -------------------

:branch
title Setting Up Your Server
echo.
echo Pick Your Server Branch
echo.
echo 1: Main Branch Server
echo 2: Staging Branch Server
echo.
echo Note: There is no direct Oxide support for the Staging Branch. You will have to manually install it.
echo.
set /p choice="Enter 1 or 2: "
if not '%choice%'=='' set choice=%choice:~0,1%
cls
if '%choice%' == '1' goto rustmain
if '%choice%' == '2' goto ruststaging
echo Please Enter 1 or 2.
goto branch

:rustmain
set forceinstall=C:\RustServer
echo WARNING: Be sure there is not an existing Rust Server installation in this directory.
echo The folder should either be empty or non-existent.
echo.
echo Enter the location you want the Rust Server installed (Default: C:\RustServer)
echo.
set /p forceinstall="Location: "
md "%forceinstall%"
cd /d "%forceinstall%"
title Installing Rust Server...
"%steamcmd%"\steamcmd.exe +force_install_dir "%forceinstall%" +login anonymous +app_update 258550 +quit
REM Creating Update File (Release Server)
(
	echo @echo off
	echo REM UpdateServer.bat by lilciv#2944
	echo mode 110,20
	echo color 02
	echo title Updating Server...
	echo "%steamcmd%"\steamcmd.exe +force_install_dir "%forceinstall%" +login anonymous +app_update 258550 +quit
	echo echo.
	echo echo Rust Updated!
	echo echo.
	echo choice /c yn /m "Do you want to run your server now?: "
	echo IF ERRORLEVEL 2 exit
	echo IF ERRORLEVEL 1 goto serverstart
	echo :serverstart
	echo mode 120,30
	echo title %comspec%
	echo StartServer.bat
)>UpdateServer.bat
cls
echo Rust Server Installed!
echo ----------------------
echo.
goto oxidechoice

:ruststaging
set forceinstall=C:\RustStagingServer
echo WARNING: Be sure there is not an existing Rust Server installation in this directory.
echo The folder should either be empty or non-existent.
echo.
echo Enter the location you want the Rust Staging Branch Server installed (Default: C:\RustStagingServer)
echo.
set /p forceinstall="Location: "
echo.
md "%forceinstall%"
cd /d "%forceinstall%"
title Installing Rust Staging Server...
"%steamcmd%"\steamcmd.exe +force_install_dir "%forceinstall%" +login anonymous +app_update 258550 -beta staging +quit
REM Creating Update File (Staging Server)
(
	echo @echo off
	echo REM UpdateServer.bat by lilciv#2944
	echo mode 110,20
	echo color 02
	echo title Updating Server...
	echo "%steamcmd%"\steamcmd.exe +force_install_dir "%forceinstall%" +login anonymous +app_update 258550 -beta staging +quit
	echo echo.
	echo echo Rust Staging Updated!
	echo echo.
	echo choice /c yn /m "Do you want to run your server now?: "
	echo IF ERRORLEVEL 2 exit
	echo IF ERRORLEVEL 1 goto serverstart
	echo :serverstart
	echo mode 120,30
	echo title %comspec%
	echo StartServer.bat
)>UpdateServer.bat
cls
echo Rust Staging Server Installed!
echo ------------------------------
echo.
goto mapchoice

:oxidechoice
title Setting Up Your Server
choice /c yn /m "Would you like to install Oxide?: "
cls
IF ERRORLEVEL 2 goto mapchoice
IF ERRORLEVEL 1 goto oxideinstall

:oxideinstall
title Installing Oxide...
curl -SL -A "Mozilla/5.0" "https://umod.org/games/rust/download" --output "%forceinstall%"\OxideMod.zip
cd /d "%forceinstall%"
powershell -command "Expand-Archive -Force OxideMod.zip ./"
del OxideMod.zip
REM Creating Update File (Oxide)
(
	echo @echo off
	echo REM UpdateServer.bat by lilciv#2944
	echo mode 110,20
	echo color 02
	echo title Updating Server...
	echo "%steamcmd%"\steamcmd.exe +force_install_dir "%forceinstall%" +login anonymous +app_update 258550 +quit
	echo echo.
	echo echo Rust Updated!
	echo pause
	echo curl -SL -A "Mozilla/5.0" "https://umod.org/games/rust/download" --output "%forceinstall%"\OxideMod.zip
	echo cd /d "%forceinstall%"
	echo powershell -command "Expand-Archive -Force OxideMod.zip ./"
	echo del OxideMod.zip
	echo echo.
	echo echo Oxide Updated!
	echo echo.
	echo choice /c yn /m "Do you want to run your server now?: "
	echo IF ERRORLEVEL 2 exit
	echo IF ERRORLEVEL 1 goto serverstart
	echo :serverstart
	echo mode 120,30
	echo title %comspec%
	echo StartServer.bat
)>UpdateServer.bat
cls
echo Oxide installed!
echo ----------------
echo.
goto mapchoice

:mapchoice
title Setting Up Your Server
choice /c yn /m "Are you using a custom map file? (For normal/first time installs, you likely aren't): "
cls
IF ERRORLEVEL 2 goto startproc
IF ERRORLEVEL 1 goto rusteditchoice

:rusteditchoice
choice /c yn /m "Do you want to install the RustEdit DLL? (You usually need this for custom maps): "
echo.
IF ERRORLEVEL 2 goto startcustom
IF ERRORLEVEL 1 goto rusteditinstall

:rusteditinstall
title Installing RustEdit DLL...
powershell -Command "Invoke-WebRequest https://github.com/k1lly0u/Oxide.Ext.RustEdit/raw/master/Oxide.Ext.RustEdit.dll -OutFile '"%forceinstall%"\RustDedicated_Data\Managed\Oxide.Ext.RustEdit.dll'
cls
echo RustEdit DLL installed!
echo -----------------------
echo.
goto startcustom

:startproc
cd /d "%forceinstall%"
title Creating Your Startup File...
set serverport=28015
set /p serverport="Enter your server port (Default: 28015): "
echo.
set rconport=28016
set /p rconport="Enter your RCON port (Default: 28016): "
echo.
set queryport=28017
set /p queryport="Enter your server query port (Default: 28017): "
echo.
set identity=RustServer
echo Don't have any spaces in the identity name!
set /p identity="Enter your server identity (Default: RustServer): "
echo.
set seed=1337
set /p seed="Enter your map seed (Default: 1337): "
echo.
set worldsize=4500
set /p worldsize="Enter your world size (Default: 4500): "
echo.
set maxplayers=150
set /p maxplayers="Enter the max players (Default: 150): "
echo.
set hostname=A Simple Rust Server
set /p hostname="Enter your server's hostname (How it appears on the server browser): "
echo.
set description=An unconfigured Rust server.
set /p description="Enter your server's description: "
echo.
set rconpw=ChangeThisPlease
set /p rconpw="Enter your RCON password (make it secure!): "
echo.
set /p serverurl="Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one): "
echo.
echo Reminder: Your Header Image link MUST contain ONLY the picture, at 1024x512 size
set /p headerimage="Enter your Server Header Image (Can be blank if you don't have one): "

REM Creating Start File (Procedural Map)
(
	echo @echo off
	echo :start
	echo RustDedicated.exe -batchmode ^^
	echo -logFile "%identity%_logs.txt" ^^
	echo +server.queryport %queryport% ^^
	echo +server.port %serverport% ^^
	echo +server.level "Procedural Map" ^^
	echo +server.seed %seed% ^^
	echo +server.worldsize %worldsize% ^^
	echo +server.maxplayers %maxplayers% ^^
	echo +server.hostname "%hostname%" ^^
	echo +server.description "%description%" ^^
	echo +server.headerimage "%headerimage%" ^^
	echo +server.url "%serverurl%" ^^
	echo +server.identity "%identity%" ^^
	echo +rcon.port %rconport% ^^
	echo +rcon.password %rconpw% ^^
	echo +rcon.web 1
	echo goto start
)>StartServer.bat

REM Creating server.cfg (Procedural Map)
md "%forceinstall%"\server\%identity%\cfg
cd /d "%forceinstall%"\server\%identity%\cfg
(
	echo fps.limit "60"
)>server.cfg

REM Creating Wipe File (Procedural Map)
cd /d "%forceinstall%"
(
	echo @echo off
	echo REM WipeServer.bat by lilciv#2944
	echo mode 110,20
	echo color 02
	echo echo This file will allow you to wipe your server. Be sure you want to continue.
	echo echo.
	echo pause
	echo echo.
	echo choice /c yn /m "Do you want to wipe Blueprints?: "
	echo IF ERRORLEVEL 2 goto wipemap
	echo IF ERRORLEVEL 1 goto wipebp
	echo :wipebp
	echo echo.
	echo echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
	echo pause
	echo echo.
	echo cd /d server/%identity%
	echo del *.sav
	echo del *.sav.*
	echo del *.map
	echo del *.db
	echo del *.db-journal
	echo del *.db-wal
	echo goto finishbp
	echo :wipemap
	echo echo.
	echo echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
	echo pause
	echo echo.
	echo cd /d server/%identity%
	echo del *.sav
	echo del *.sav.*
	echo del *.map
	echo del player.deaths.*
	echo del player.identities.*
	echo del player.states.*
	echo del player.tokens.*
	echo del sv.files.*
	echo goto finishmap
	echo :finishbp
	echo echo.
	echo echo Server has been Map and BP Wiped!
	echo echo.
	echo echo Be sure to change your map seed in your startup batch file!
	echo echo Don't forget to delete any necessary plugin data!
	echo echo.
	echo pause
	echo exit
	echo :finishmap
	echo echo.
	echo echo Server has been Map Wiped!
	echo echo.
	echo echo Be sure to change your map seed in your startup batch file!
	echo echo Don't forget to delete any necessary plugin data!
	echo echo.
	echo pause
)>WipeServer.bat

REM Admin Check
cls
choice /c yn /m "Do you want to add yourself as an admin on the server now?: "
cls
IF ERRORLEVEL 2 goto finish
IF ERRORLEVEL 1 goto admin

:startcustom
cd /d "%forceinstall%"
title Creating Your Startup File (Custom Map)...
set serverport=28015
set /p serverport="Enter your server port (Default: 28015): "
echo.
set rconport=28016
set /p rconport="Enter your RCON port (Default: 28016): "
echo.
set queryport=28017
set /p queryport="Enter your server query port (Default: 28017): "
echo.
set identity=RustServer
echo Don't have any spaces in the identity name!
set /p identity="Enter your server identity (Default: RustServer): "
echo.
set levelurl=https://www.dropbox.com/s/ig1ds1m3q5hnflj/proc_install_1.0.map?dl=1
set /p levelurl="Enter your custom map URL (Must be a direct download link!): "
echo.
set maxplayers=150
set /p maxplayers="Enter the max players (Default: 150): "
echo.
set hostname=A Simple Rust Server
set /p hostname="Enter your server's hostname (How it appears on the server browser): "
echo.
set description=An unconfigured Rust server.
set /p description="Enter your server's description: "
echo.
set rconpw=ChangeThisPlease
set /p rconpw="Enter your RCON password (make it secure!): "
echo.
set /p serverurl="Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one): "
echo.
echo Reminder: Your Header Image link MUST contain ONLY the picture, at 1024x512 size
set /p headerimage="Enter your Server Header Image (Can be blank if you don't have one): "

REM Creating Start File (Custom Map)
(
	echo @echo off
	echo :start
	echo RustDedicated.exe -batchmode ^^
	echo -logFile "%identity%_logs.txt" ^^
	echo -levelurl "%levelurl%" ^^
	echo +server.queryport %queryport% ^^
	echo +server.port %serverport% ^^
	echo +server.maxplayers %maxplayers% ^^
	echo +server.hostname "%hostname%" ^^
	echo +server.description "%description%" ^^
	echo +server.headerimage "%headerimage%" ^^
	echo +server.url "%serverurl%" ^^
	echo +server.identity "%identity%" ^^
	echo +rcon.port %rconport% ^^
	echo +rcon.password %rconpw% ^^
	echo +rcon.web 1
	echo goto start
)>StartServer.bat

REM Creating server.cfg (Custom Map)
md "%forceinstall%"\server\%identity%\cfg
cd /d "%forceinstall%"\server\%identity%\cfg
(
	echo fps.limit "60"
)>server.cfg

REM Creating Wipe File (Custom Map)
cd /d "%forceinstall%"
(
	echo @echo off
	echo REM WipeServer.bat by lilciv#2944
	echo mode 110,20
	echo color 02
	echo echo This file will allow you to wipe your server. Be sure you want to continue.
	echo echo.
	echo pause
	echo echo.
	echo choice /c yn /m "Do you want to wipe Blueprints?: "
	echo IF ERRORLEVEL 2 goto wipemap
	echo IF ERRORLEVEL 1 goto wipebp
	echo :wipebp
	echo echo.
	echo echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
	echo pause
	echo echo.
	echo cd /d server/%identity%
	echo del *.sav
	echo del *.sav.*
	echo del *.map
	echo del *.db
	echo del *.db-journal
	echo del *.db-wal
	echo goto finishbp
	echo :wipemap
	echo echo.
	echo echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
	echo pause
	echo echo.
	echo cd /d server/%identity%
	echo del *.sav
	echo del *.sav.*
	echo del *.map
	echo del player.deaths.*
	echo del player.identities.*
	echo del player.states.*
	echo del player.tokens.*
	echo del sv.files.*
	echo goto finishmap
	echo :finishbp
	echo echo.
	echo echo Server has been Map and BP Wiped!
	echo echo.
	echo echo Be sure to check your custom map link in your startup batch file!
	echo echo Don't forget to delete any necessary plugin data!
	echo echo.
	echo pause
	echo exit
	echo :finishmap
	echo echo.
	echo echo Server has been Map Wiped!
	echo echo.
	echo echo Be sure to check your custom map link in your startup batch file!
	echo echo Don't forget to delete any necessary plugin data!
	echo echo.
	echo pause
)>WipeServer.bat

REM Admin Check
cls
choice /c yn /m "Do you want to add yourself as an admin on the server now?: "
cls
IF ERRORLEVEL 2 goto finish
IF ERRORLEVEL 1 goto admin

:admin
REM This is not a valid SteamID, don't worry!
set steamid=12345678901234567
echo If you do not know your SteamID, please go here: https://www.businessinsider.com/how-to-find-steam-id
echo.
echo Admin and Moderator users are stored in the users.cfg file located here: %forceinstall%\server\%identity%\cfg
echo.
set /p steamid="Enter your Steam64 ID: "

cd /d "%forceinstall%"\server\%identity%\cfg
(
	echo ownerid %steamid% "unknown" "no reason"
)>users.cfg
cls
goto finish

:finish
echo All finished! You will see three batch files in %forceinstall%:
echo.
echo StartServer.bat is to launch your server.
echo UpdateServer.bat is to update your server (and Oxide if it was installed) come force wipe.
echo WipeServer.bat is to wipe your server. You will be given the choice of just a map or a full blueprint wipe.
echo.
choice /c yn /m "Do you want to run your new server now?: "
echo.
IF ERRORLEVEL 2 exit
IF ERRORLEVEL 1 goto serverstart

:serverstart
cd /d "%forceinstall%"
mode 120,30
title %comspec%
StartServer.bat
