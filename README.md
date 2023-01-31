# Rust Server Installer Script

This script will install a Rust Server on your Windows machine all within one file. The following things are supported and handled by the script:

## Features
SteamCMD Installation

Release and Staging Branch Support

Custom Map Support - With the choice of adding the RustEdit DLL during install.

Oxide Support (Release Branch Only)

Defining an admin post install

Creation of StartServer.bat, UpdateServer.bat, and WipeServer.bat files based on user values.

## How To Use
Launch the RustServerInstaller.bat file.  
Follow the listed prompts.  

**Note:** If you do not specify a value for something, the default value will be chosen.  

YouTube Overview Video by SRTBull: https://www.youtube.com/watch?v=9tG0xH8LNn4  
Codefling: https://codefling.com/tools/rust-server-installer-script  

For assistance, please message me on Discord: lilciv#2944  

Tested on Windows 10, Windows 11, and Windows Server 2019.  
For Windows Server 2016, 2012R2 and Windows 8/8.1 support, you need to install cURL. (see https://curl.se/download.html)  
Alternatively, you can use my Powershell edition for older operating systems found on this GitHub - this will work on all of the operating systems listed above.

**FYI:** If you use any sort of Antivirus program that manages SSL certificates, you will need to disable it for this script to run properly. Kaspersky and Bitdefender seem to be two common ones causing issues.

</br>

**Note:** If you change your Server Identity name after running the script (the default is "RustServer") - you will need to adjust two lines in the WipeServer.bat file:  
Line 17 (**cd /d server/identity**) - change the **identity** name to your new one.  
Line 30 (**cd /d server/identity**) - change the **identity** name to your new one.

</br>

**Note:** It is not recommended to move the install directory of your server after the script has run, as the UpdateServer.bat file will no longer function as expected. While you can manually update the file to reference the new directory, it is generally easier and recommended to run the script from scratch to complete a fresh Rust Server install, and then copy over your **server** and **oxide** folders, ensuring your identity name remains the same.


## Custom Maps
One thing to note about using Custom Maps:  

Custom Maps **MUST** be a direct downloadable link, meaning the link must immediately start the map download.  
For example, https://www.dropbox.com/s/ig1ds1m3q5hnflj/proc_install_1.0.map?dl=1 is a direct download link.  
For Dropbox links, ensure that the end of the link has "dl=1" and not "dl=0"

## How To Join Your Server
To join your new server, you'll need to type one of the following commands into the Rust F1 console:

If your server is hosted on the machine that you are running Rust from:  
```client.connect localhost:ServerPort```  
An example of what you would type when using the default Server Port of 28015:  
```client.connect localhost:28015```

If your server is hosted on another machine in your local network:  
```client.connect MachineIP:ServerPort```  
An example of what you would type when using the default Server Port of 28015:  
```client.connect 192.168.1.10:28015```

## How To Let Others Outside Your Network Join
To let others outside your local network join your server, you will need to forward the UDP Server Port and UDP Query Port to your server machine.  
Along with this, in many cases you will need to allow the required ports through the Windows Defender Firewall.  

While every Router/Firewall is different, here is an explanation video by SRTBull explaining the process: https://www.youtube.com/watch?v=PYfpOUNVKoM
