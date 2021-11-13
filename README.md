# Rust Server Installer Script

## Features
SteamCMD Installation

Release and Staging Branch Support

Custom Map Support - With the choice of adding the RustEdit DLL during install.

Oxide Support (Release Branch Only)

Creation of StartServer.bat, UpdateServer.bat, and WipeServer.bat files based on user values.

## How To Use
Launch the RustServerInstaller.bat file.

Follow the listed prompts.

**Note:** If you do not specify a value for something, the default value will be chosen.

YouTube Overview Video by SRTBull: https://www.youtube.com/watch?v=9tG0xH8LNn4

Codefling: https://codefling.com/tools/rust-server-installer-script

For assistance, please message me on Discord: lilciv#2944

Tested on Windows 10, Windows 11, and Windows Server 2019.

This script is not supported on Windows 7 in any way. It will not run.

## Custom Maps
One thing to note about using Custom Maps:

Custom Maps **MUST** be a direct downloadable link, meaning the link must immediately start the map download.

For example, https://www.dropbox.com/s/ig1ds1m3q5hnflj/proc_install_1.0.map?dl=1 is a direct download link.

For Dropbox links, ensure that the end of the link has "dl=1" and not "dl=0"

## How To Join Your Server
To join your new server, you'll need to type one of the following commands into the Rust F1 console:

If your server is hosted on the machine that you are running Rust from: ```client.connect localhost:ServerPort``` Ex: ```client.connect localhost:28015```

If your server is hosted on another machine in your local network: ```client.connect MachineIP:ServerPort``` Ex: ```client.connect 192.168.1.10:28015```

## How To Let Others Outside Your Network Join
To let others outside your local network join your server, you will need to forward the UDP Server Port to your server machine.

Along with this, in many cases you will need to allow the required ports through the Windows Defender Firewall.

While every Router/Firewall is different, here is an explanation video by SRTBull explaining the process: https://www.youtube.com/watch?v=PYfpOUNVKoM
