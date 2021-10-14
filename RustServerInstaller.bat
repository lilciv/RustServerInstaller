@echo off
REM Rust Server Installer (v1.0.7) by lilciv#2944
color 02
mode 110,20
:steamcmd
title Installing SteamCMD...
set steamcmd=C:\SteamCMD
set /p steamcmd="Enter the location you want SteamCMD installed (Default: C:\SteamCMD): "
echo.
md %steamcmd%
curl -SL -A "Mozilla/5.0" https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip --output %steamcmd%\SteamCMD.zip
cd /d %steamcmd%
powershell -command "Expand-Archive -Force SteamCMD.zip ./"
del SteamCMD.zip
echo.
echo SteamCMD installed!
echo.

:branch
title Setting Up Your Server
echo.
echo.
echo Note: There is direct Oxide support for the Staging Branch. You will have to manually install it.
echo.
choice /c yn /m "Do you want to install a Staging Branch server? (Usually, you DO NOT want to do this): "
echo.
If ERRORLEVEL 2 goto rustmain
IF ERRORLEVEL 1 goto ruststaging

:rustmain
echo.
set forceinstall=C:\RustServer
echo WARNING: Be sure there is not an existing Rust installation in this directory.
echo The folder should either be empty or non-existent.
echo.
set /p forceinstall="Enter the location you want Rust installed (Default: C:\RustServer): "
echo.
md %forceinstall%
cd /d %forceinstall%
title Installing Rust...
%steamcmd%\steamcmd.exe +login anonymous +force_install_dir %forceinstall% +app_update 258550 +quit
REM Creating Update File
echo @echo off> UpdateServer.bat
echo color 02>> UpdateServer.bat
echo mode 110,20>> UpdateServer.bat
echo title Updating Server...>> UpdateServer.bat
echo %steamcmd%\steamcmd.exe +login anonymous +force_install_dir %forceinstall% +app_update 258550 +quit>> UpdateServer.bat
echo echo.>> UpdateServer.bat
echo echo Rust Updated! >> UpdateServer.bat
echo pause>> UpdateServer.bat
echo Rust installed!
echo.
goto choice

:ruststaging
echo.
set forceinstall=C:\RustStagingServer
echo WARNING: Be sure there is not an existing Rust installation in this directory.
echo The folder should either be empty or non-existent.
echo.
set /p forceinstall="Enter the location you want Rust Staging installed (Default: C:\RustStagingServer): "
echo.
md %forceinstall%
cd /d %forceinstall%
title Installing Rust Staging...
%steamcmd%\steamcmd.exe +login anonymous +force_install_dir %forceinstall% +app_update 258550 -beta staging +quit
REM Creating Update File
echo @echo off> UpdateServer.bat
echo color 02>> UpdateServer.bat
echo mode 110,20>> UpdateServer.bat
echo title Updating Server...>> UpdateServer.bat
echo %steamcmd%\steamcmd.exe +login anonymous +force_install_dir %forceinstall% +app_update 258550 -beta staging +quit>> UpdateServer.bat
echo echo.>> UpdateServer.bat
echo echo Rust Staging Updated! >> UpdateServer.bat
echo pause>> UpdateServer.bat
echo Rust Staging installed!
echo.
goto map

:choice
title Setting Up Your Server
choice /c yn /m "Would you like to install Oxide?: "
echo.
IF ERRORLEVEL 2 goto map
IF ERRORLEVEL 1 goto oxide

:oxide
title Installing Oxide...
curl -SL -A "Mozilla/5.0" "https://umod.org/games/rust/download" --output %forceinstall%\OxideMod.zip
cd /d %forceinstall%
powershell -command "Expand-Archive -Force OxideMod.zip ./"
del OxideMod.zip
REM Creating Update File
echo curl -SL -A "Mozilla/5.0" "https://umod.org/games/rust/download" --output %forceinstall%\OxideMod.zip>> UpdateServer.bat
echo powershell -command "Expand-Archive -Force OxideMod.zip ./">> UpdateServer.bat
echo del OxideMod.zip>> UpdateServer.bat
echo echo.>> UpdateServer.bat
echo echo Oxide Updated! >> UpdateServer.bat
echo pause>> UpdateServer.bat
echo.
echo Oxide installed!
echo.
echo.
goto map

:map
title Setting Up Your Server
choice /c yn /m "Are you using a custom map file? (For normal/first time installs, you likely aren't): "
echo.
IF ERRORLEVEL 2 goto startproc
IF ERRORLEVEL 1 goto startcustom

:startproc
cd /d %forceinstall%
title Creating Your Startup File...
set serverport=28015
set /p serverport="Enter your server port (Default: 28015): "
echo.
set rconport=28016
set /p rconport="Enter your RCON port (Default: 28016): "
echo.
set seed=21474
set /p seed="Enter your map seed (Default: 21474): "
echo.
set worldsize=3500
set /p worldsize="Enter your world size (Default: 3500): "
echo.
set maxplayers=150
set /p maxplayers="Enter the max players (Default: 150): "
echo.
set hostname=Dedicated Rust Server
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
echo Reminder: Your Header Image MUST contain ONLY the picture, at 1024x512 size (Ex: https://i.imgur.com/5CFzQHl.png)
set /p headerimage="Enter your Server Header Image (If you don't have one, leave this blank): "

echo @echo off> StartServer.bat
echo :start>> StartServer.bat
echo RustDedicated.exe -batchmode ^^>> StartServer.bat
echo -logFile "ServerLogs.txt" ^^>>StartServer.bat
echo -silent-crashes ^^>>StartServer.bat
echo +server.port %serverport% ^^>> StartServer.bat
echo +server.level "Procedural Map" ^^>> StartServer.bat
echo +server.seed %seed% ^^>> StartServer.bat
echo +server.worldsize %worldsize% ^^>> StartServer.bat
echo +server.maxplayers %maxplayers% ^^>> StartServer.bat
echo +server.hostname "%hostname%" ^^>> StartServer.bat
echo +server.description "%description%" ^^>> StartServer.bat
echo +server.headerimage "%headerimage%" ^^>>StartServer.bat
echo +server.url "%serverurl%" ^^>>StartServer.bat
echo +server.identity "RustServer" ^^>> StartServer.bat
echo +rcon.port %rconport% ^^>> StartServer.bat
echo +rcon.password %rconpw% ^^>> StartServer.bat
echo +rcon.web 1 ^^>> StartServer.bat
echo goto start>> StartServer.bat
goto finish

:startcustom
cd /d %forceinstall%
title Creating Your Startup File (Custom Map)...
set serverport=28015
set /p serverport="Enter your server port (Default: 28015): "
echo.
set rconport=28016
set /p rconport="Enter your RCON port (Default: 28016): "
echo.
set levelurl=https://www.dropbox.com/s/xyprhdhq5l8tmsf/procrustedit.map?dl=1
set /p levelurl="Enter your custom map map URL (must be a direct download link!): "
echo.
set maxplayers=150
set /p maxplayers="Enter the max players (Default: 150): "
echo.
set hostname=Dedicated Rust Server
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
echo Reminder: Your Header Image MUST contain ONLY the picture, at 1024x512 size (Ex: https://i.imgur.com/5CFzQHl.png)
set /p headerimage="Enter your Server Header Image (If you don't have one, leave this blank): "

echo @echo off> StartServer.bat
echo :start>> StartServer.bat
echo RustDedicated.exe -batchmode ^^>> StartServer.bat
echo -logFile "ServerLogs.txt" ^^>>StartServer.bat
echo -silent-crashes ^^>>StartServer.bat
echo -levelurl "%levelurl%" ^^>> StartServer.bat
echo +server.port %serverport% ^^>> StartServer.bat
echo +server.maxplayers %maxplayers% ^^>> StartServer.bat
echo +server.hostname "%hostname%" ^^>> StartServer.bat
echo +server.description "%description%" ^^>> StartServer.bat
echo +server.headerimage "%headerimage%" ^^>>StartServer.bat
echo +server.url "%serverurl%" ^^>>StartServer.bat
echo +server.identity "RustServer" ^^>> StartServer.bat
echo +rcon.port %rconport% ^^>> StartServer.bat
echo +rcon.password %rconpw% ^^>> StartServer.bat
echo +rcon.web 1 ^^>> StartServer.bat
echo goto start>> StartServer.bat
goto finish

:finish
echo.
echo.
echo.
echo All finished! You will see two batch files in your Rust Server Folder:
echo.
echo StartServer.bat is to launch your server.
echo UpdateServer.bat is to update your server (and Oxide if you installed it) come force wipe.
echo.
pause
