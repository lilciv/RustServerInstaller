# Rust Server Installer (Powershell Edition) (v2.4.0) by lilciv#2944

#----------------------------------------------

#Title + Intro
$host.UI.RawUI.WindowTitle = "Rust Server Installer - lilciv#2944"
Write-Host "This script will install a Rust Server on your computer."
Write-Host "`n"
Pause
Clear-Host

#----------------------------------------------

# SteamCMD Installation
function SteamCMD {
    $host.UI.RawUI.WindowTitle = "Installing SteamCMD..."
    Write-host "Enter the location you want SteamCMD installed (Default: C:\SteamCMD)"
    Write-Host "`n"
    $SteamCMD = Read-Host "Location"
    if ($SteamCMD -eq [string]::empty) {
        $SteamCMD = "C:\SteamCMD"
    }

    if (!(Test-Path $SteamCMD)) {
        New-Item $SteamCMD -ItemType Directory
        Write-Host "SteamCMD Folder Created"
    }
    Set-Location "$SteamCMD"
    Write-Host "`n"
    Invoke-WebRequest https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -OutFile 'SteamCMD.zip'
    Expand-Archive -Force SteamCMD.zip ./
    Remove-Item SteamCMD.zip
    Clear-Host
    Write-Host "SteamCMD installed!"
    Write-Host "`n"
    BranchChoice
}

#----------------------------------------------

# Branch Choice
function BranchChoice {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    Write-Host "Note: There is no direct Oxide support for the Staging Branch. You will have to manually install it."

    do {
        Write-Host "`nPick Your Server Branch"
        Write-Host "`t1. Main Branch"
        Write-Host "`t2. Staging Branch"
        
        $Choice = Read-Host "`nEnter 1 or 2"
        } until (($Choice -eq '1') -or ($Choice -eq '2'))
        switch ($Choice) {
        '1'{
                MainBranch
        }
        '2'{
                StagingBranch
        }
    }
}

#----------------------------------------------

# Rust Main Branch
function MainBranch {
    Clear-Host
    Write-Host "WARNING: Be sure there is not an existing Rust Server installation in this directory."
    Write-Host "The folder should either be empty or non-existent."
    Write-Host "`n"
    Write-Host "Enter the location you want the Rust Server installed (Default: C:\RustServer)"
    $ForceInstall = Read-Host "Location"
    if ($ForceInstall -eq [string]::empty) {
        $ForceInstall = "C:\RustServer"
    }
    
    if (!(Test-Path $ForceInstall)) {
        New-Item $ForceInstall -ItemType Directory
        Write-Host "Rust Server Folder Created"
    }
    $host.UI.RawUI.WindowTitle = "Installing Rust Server..."
    Set-Location "$SteamCMD"
    .\steamcmd.exe +force_install_dir $ForceInstall +login anonymous +app_update 258550 +quit
    Set-Location "$ForceInstall"
    $UpdateServer = "UpdateServer.bat"
    New-Item $ForceInstall\$UpdateServer
# Creating Update File (Main Branch)
$UpdateMain = @"
@echo off
REM UpdateServer.bat by lilciv#2944
mode 110,20
color 02
title Updating Server...
"$SteamCMD"\steamcmd.exe +force_install_dir "$ForceInstall" +login anonymous +app_update 258550 +quit
echo.
echo Rust Updated!
echo.
choice /c yn /m "Do you want to run your server now?: "
IF ERRORLEVEL 2 exit
IF ERRORLEVEL 1 goto serverstart
:serverstart
mode 120,30
title %comspec%
StartServer.bat
"@

    Set-Content $UpdateServer $UpdateMain
    Clear-Host
    Write-Host "Rust Server Installed!"
    Write-Host "`n"
    OxideChoice
}

#----------------------------------------------

# Rust Staging Branch
function StagingBranch {
    Clear-Host
    Write-Host "WARNING: Be sure there is not an existing Rust Server installation in this directory."
    Write-Host "The folder should either be empty or non-existent."
    Write-Host "`n"
    Write-Host "Enter the location you want the Rust Staging Branch Server installed (Default: C:\RustStagingServer)"
    $ForceInstall = Read-Host "Location"
    if ($ForceInstall -eq [string]::empty) {
        $ForceInstall = "C:\RustStagingServer"
    }
    
    if (!(Test-Path $ForceInstall)) {
        New-Item $ForceInstall -ItemType Directory
        Write-Host "Rust Staging Server Folder Created"
    }
    $host.UI.RawUI.WindowTitle = "Installing Rust Staging Server..."
    Set-Location "$SteamCMD"
    .\steamcmd.exe +force_install_dir $ForceInstall +login anonymous +app_update 258550 -beta staging +quit
    Set-Location "$ForceInstall"
    $UpdateServer = "UpdateServer.bat"
    # Creating Update File (Staging Branch)
$UpdateStaging = @"
@echo off
REM UpdateServer.bat by lilciv#2944
mode 110,20
color 02
title Updating Server...
"$SteamCMD"\steamcmd.exe +force_install_dir "$ForceInstall" +login anonymous +app_update 258550 -beta staging +quit
echo.
echo Rust Staging Updated!
echo.
choice /c yn /m "Do you want to run your server now?: "
IF ERRORLEVEL 2 exit
IF ERRORLEVEL 1 goto serverstart
:serverstart
mode 120,30
title %comspec%
StartServer.bat
"@

    Set-Content $UpdateServer $UpdateStaging
    Clear-Host
    Write-Host "Rust Staging Server Installed!"
    MapChoice
}

#----------------------------------------------

# Oxide Choice
function OxideChoice {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    do {
        Write-Host "`nWould you like to install Oxide?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                OxideInstall
        }
        'N'{
                MapChoice
        }
    }
}

#----------------------------------------------

# Oxide Install
function OxideInstall {
    $host.UI.RawUI.WindowTitle = "Installing Oxide..."
    Set-Location $ForceInstall
    Invoke-WebRequest https://umod.org/games/rust/download -OutFile 'OxideMod.zip'
    Expand-Archive -Force OxideMod.zip ./
    Remove-Item OxideMod.zip
    # Creating Update File (Oxide)
$UpdateMainOxide = @"
@echo off
REM UpdateServer.bat by lilciv#2944
mode 110,20
color 02
title Updating Server...
"$SteamCMD"\steamcmd.exe +force_install_dir "$ForceInstall" +login anonymous +app_update 258550 +quit
echo.
echo Rust Updated!
pause
curl -SL -A "Mozilla/5.0" "https://umod.org/games/rust/download" --output "$ForceInstall"\OxideMod.zip
cd /d $ForceInstall
powershell -command "Expand-Archive -Force OxideMod.zip ./"
del OxideMod.zip
echo.
echo Oxide Updated!
echo.
choice /c yn /m "Do you want to run your server now?: "
IF ERRORLEVEL 2 exit
IF ERRORLEVEL 1 goto serverstart
:serverstart
mode 120,30
title %comspec%
StartServer.bat
"@
    Set-Content $UpdateServer $UpdateMainOxide
    Clear-Host
    Write-Host "Oxide installed!"
    Write-Host "`n"
    MapChoice
}

#----------------------------------------------

# Map Choice
function MapChoice {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    do {
        Write-Host "`nWhich kind of map are you using?"
        Write-Host "`t1. Procedural Map"
        Write-Host "`t2. Custom Map"
        
        $Choice = Read-Host "`nEnter 1 or 2"
        } until (($Choice -eq '1') -or ($Choice -eq '2'))
        switch ($Choice) {
        '1'{
                StartProc
        }
        '2'{
                RustEditChoice
        }
    }
}

#----------------------------------------------

# RustEdit Choice
function RustEditChoice {
    Clear-Host
    do {
        Write-Host "`nWould you like to install the RustEdit DLL?"
        Write-Host "nYou usually need this for custom maps."
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                RustEditInstall
        }
        'N'{
                StartCustom
        }
    }
}

#----------------------------------------------

# RustEdit Install
function RustEditInstall {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    Set-Location $ForceInstall\RustDedicated_Data\Managed\
    Invoke-WebRequest https://github.com/k1lly0u/Oxide.Ext.RustEdit/raw/master/Oxide.Ext.RustEdit.dll -OutFile 'Oxide.Ext.RustEdit.dll'
    Clear-Host
    Write-Host "RustEdit DLL installed!"
    StartCustom
}

#----------------------------------------------

# Start Procedural
function StartProc {
    Clear-Host
    $host.UI.RawUI.WindowTitle = "Creating Your Startup File..."
    Set-Location "$ForceInstall"
    $ServerPort = Read-Host "Enter your server port (Default: 28015)"
    if ($ServerPort -eq [string]::empty) {
        $ServerPort = "28015"
    }
    Write-Host "`n"
    $RCONPort =  Read-Host "Enter your RCON port (Default: 28016)"
    if ($RCONPort -eq [string]::empty) {
        $RCONPort = "28016"
    }
    Write-Host "`n"
    $QueryPort =  Read-Host "Enter your server query port (Default: 28017)"
    if ($QueryPort -eq [string]::empty) {
        $QueryPort = "28017"
    }
    Write-Host "`n"
    Write-Host "Don't have any spaces in the identity name!"
    $Identity = Read-Host "Enter your server identity (Default: RustServer)"
    if ($Identity -eq [string]::empty) {
        $Identity = "RustServer"
    }
    Write-Host "`n"
    $Seed = Read-Host "Enter your map seed (Default: 1337)"
    if ($Seed -eq [string]::empty) {
        $Seed = "1337"
    }
    Write-Host "`n"
    $WorldSize = Read-Host "Enter your world size (Default: 4500)"
    if ($WorldSize -eq [string]::empty) {
        $WorldSize = "4500"
    }
    Write-Host "`n"
    $MaxPlayers = Read-Host "Enter the max players (Default: 150)"
    if ($MaxPlayers -eq [string]::empty) {
        $MaxPlayers = "150"
    }
    Write-Host "`n"
    $Hostname = Read-Host "Enter your server's hostname (How it appears on the server browser)"
    if ($Hostname -eq [string]::empty) {
        $Hostname = "A Simple Rust Server"
    }
    Write-Host "`n"
    $Description = Read-Host "Enter your server's description"
    if ($Description -eq [string]::empty) {
        $Description = "An unconfigured Rust server."
    }
    Write-Host "`n"
    $RCONPW = Read-Host "Enter your RCON password (make it secure!)"
    if ($RCONPW -eq [string]::empty) {
        $RCONPW = "ChangeThisPlease"
    }
    Write-Host "`n"
    $ServerURL = Read-Host "Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one)"
    Write-Host "`n"
    $HeaderImage = Read-Host "Enter your Server Header Image (Can be blank if you don't have one)"
    $StartServer = "StartServer.bat"
    # Creating Start File (Procedural Map)
$StartProc = @"
@echo off
:start
RustDedicated.exe -batchmode ^
-logFile "$Identity-logs.txt" ^
+server.queryport $QueryPort ^
+server.port $ServerPort ^
+server.level "Procedural Map" ^
+server.seed $Seed ^
+server.worldsize $WorldSize ^
+server.maxplayers $MaxPlayers ^
+server.hostname "$Hostname" ^
+server.description "$Description" ^
+server.headerimage "$HeaderImage" ^
+server.url "$ServerURL" ^
+server.identity "$Identity" ^
+rcon.port $RCONPort ^
+rcon.password $RCONPW ^
+rcon.web 1
goto start
"@
    # Creating server.cfg (Procedural Map)
    Set-Content $StartServer $StartProc
    $CFGLocation = "$ForceInstall\server\$Identity\cfg"
    if (!(Test-Path $CFGLocation)) {
        New-Item $CFGLocation -ItemType Directory
    }
    $ServerCFG = "server.cfg"
$ServerCFGContent = @"
fps.limit "60"
"@
    # Creating Wipe File (Procedural Map)
    Set-Location $CFGLocation
    Set-Content $ServerCFG $ServerCFGContent
    Set-Location $ForceInstall
    $WipeServer = "WipeServer.bat"
$WipeServerContent = @"
@echo off
:start
REM WipeServer.bat by lilciv#2944
mode 110,20
color 02
echo This file will allow you to wipe your server. Be sure you want to continue.
echo.
pause
echo.
choice /c yn /m "Do you want to wipe Blueprints?: "
IF ERRORLEVEL 2 goto wipemap
IF ERRORLEVEL 1 goto wipebp
:wipebp
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del *.db
del *.db-journal
del *.db-wal
goto finishbp
:wipemap
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del player.deaths.*
del player.identities.*
del player.states.*
del player.tokens.*
del sv.files.*
goto finishmap
:finishbp
echo.
echo Server has been Map and BP Wiped!
echo.
echo Be sure to change your map seed in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
exit
:finishmap
echo.
echo Server has been Map Wiped!
echo.
echo Be sure to change your map seed in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
"@
    Set-Content $WipeServer $WipeServerContent
    # Admin Check
    Clear-Host
    do {
        Write-Host "`nDo you want to add yourself as an admin on the server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                Admin
        }
        'N'{
                Finish
        }
    }
}

#----------------------------------------------

# Start Custom
function StartCustom {
    $host.UI.RawUI.WindowTitle = "Creating Your Startup File (Custom Map)..."
    Set-Location "$ForceInstall"
    $ServerPort = Read-Host "Enter your server port (Default: 28015)"
    if ($ServerPort -eq [string]::empty) {
        $ServerPort = "28015"
    }
    Write-Host "`n"
    $RCONPort =  Read-Host "Enter your RCON port (Default: 28016)"
    if ($RCONPort -eq [string]::empty) {
        $RCONPort = "28016"
    }
    Write-Host "`n"
    $QueryPort =  Read-Host "Enter your server query port (Default: 28017)"
    if ($QueryPort -eq [string]::empty) {
        $QueryPort = "28017"
    }
    Write-Host "`n"
    Write-Host "Don't have any spaces in the identity name!"
    $Identity = Read-Host "Enter your server identity (Default: RustServer)"
    if ($Identity -eq [string]::empty) {
        $Identity = "RustServer"
    }
    Write-Host "`n"
    $LevelURL = Read-Host "Enter your custom map URL (Must be a direct download link!)"
    if ($LevelURL -eq [string]::empty) {
        $LevelURL = "https://www.dropbox.com/s/ig1ds1m3q5hnflj/proc_install_1.0.map?dl=1"
    }
    Write-Host "`n"
    $MaxPlayers = Read-Host "Enter the max players (Default: 150)"
    if ($MaxPlayers -eq [string]::empty) {
        $MaxPlayers = "150"
    }
    Write-Host "`n"
    $Hostname = Read-Host "Enter your server's hostname (How it appears on the server browser)"
    if ($Hostname -eq [string]::empty) {
        $Hostname = "A Simple Rust Server"
    }
    Write-Host "`n"
    $Description = Read-Host "Enter your server's description"
    if ($Description -eq [string]::empty) {
        $Description = "An unconfigured Rust server."
    }
    Write-Host "`n"
    $RCONPW = Read-Host "Enter your RCON password (make it secure!)"
    if ($RCONPW -eq [string]::empty) {
        $RCONPW = "ChangeThisPlease"
    }
    Write-Host "`n"
    $ServerURL = Read-Host "Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one)"
    Write-Host "`n"
    $HeaderImage = Read-Host "Enter your Server Header Image (Can be blank if you don't have one)"
    # Creating Start File (Custom Map)
    $StartServer = "StartServer.bat"
$StartCustom = @"
@echo off
:start
RustDedicated.exe -batchmode ^
-logFile "$Identity-logs.txt" ^
-levelurl "$LevelURL" ^
+server.queryport $QueryPort ^
+server.port $ServerPort ^
+server.maxplayers $MaxPlayers ^
+server.hostname "$Hostname" ^
+server.description "$Description" ^
+server.headerimage "$HeaderImage" ^
+server.url "$ServerURL" ^
+server.identity "$Identity" ^
+rcon.port $RCONPort ^
+rcon.password $RCONPW ^
+rcon.web 1
goto start
"@
    # Creating server.cfg (Custom Map)
    Set-Content $StartServer $StartCustom
    $CFGLocation = "$ForceInstall\server\$Identity\cfg"
    if (!(Test-Path $CFGLocation)) {
        New-Item $CFGLocation -ItemType Directory
    }
    $ServerCFG = "server.cfg"
$ServerCFGContent = @"
fps.limit "60"
"@
    # Creating Wipe File (Custom Map)
    Set-Location $CFGLocation
    Set-Content $ServerCFG $ServerCFGContent
    Set-Location $ForceInstall
    $WipeServer = "WipeServer.bat"
$WipeServerContent = @"
@echo off
:start
REM WipeServer.bat by lilciv#2944
mode 110,20
color 02
echo This file will allow you to wipe your server. Be sure you want to continue.
echo.
pause
echo.
choice /c yn /m "Do you want to wipe Blueprints?: "
IF ERRORLEVEL 2 goto wipemap
IF ERRORLEVEL 1 goto wipebp
:wipebp
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del *.db
del *.db-journal
del *.db-wal
goto finishbp
:wipemap
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del player.deaths.*
del player.identities.*
del player.states.*
del player.tokens.*
del sv.files.*
goto finishmap
:finishbp
echo.
echo Server has been Map and BP Wiped!
echo.
echo Be sure to check your custom map link in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
exit
:finishmap
echo.
echo Server has been Map Wiped!
echo.
echo Be sure to check your custom map link in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
"@
    Set-Content $WipeServer $WipeServerContent
    # Admin Check
    Clear-Host
    do {
        Write-Host "`nDo you want to add yourself as an admin on the server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                Admin
        }
        'N'{
                Finish
        }
    }
}

#----------------------------------------------

# Admin
function Admin {
    Clear-Host
    Write-Host "If you do not know your SteamID, please go here: https://www.businessinsider.com/how-to-find-steam-id"
    Write-Host "`n"
    Write-Host "Admin and Moderator users are stored in the users.cfg file located here: $ForceInstall\server\$Identity\cfg"
    Write-Host "`n"
    # This is not a valid SteamID, don't worry!
    $SteamID = Read-Host "Enter your Steam64 ID"
    if ($SteamID -eq [string]::empty) {
        $SteamID = "12345678901234567"
    }
    Set-Location $CFGLocation
    $UsersCFG = "users.cfg"
$UsersCFGContent = @"
ownerid $SteamID "unknown" "no reason"
"@
    Set-Content $UsersCFG $UsersCFGContent
    Finish
}

#----------------------------------------------

# Finish
function Finish {
    Clear-Host
    Write-Host "All finished! You will see these three batch files in $ForceInstall"
    Write-Host "`n"
    Write-Host "StartServer.bat is to launch your server."
    Write-Host "UpdateServer.bat is to update your server (and Oxide if it was installed) come force wipe."
    Write-Host "WipeServer.bat is to wipe your server. You will be given the choice of just a map or a full blueprint wipe."
    Write-Host "`n"
    do {
        Write-Host "`nDo you want to run your new server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                ServerStart
        }
        'N'{
                Exit
        }
    }
}

#----------------------------------------------

# Server Start
function ServerStart {
    Set-Location $ForceInstall
    Start-Process StartServer.bat
}

#----------------------------------------------

# Main Function
function Main {
    SteamCMD
}

Main
