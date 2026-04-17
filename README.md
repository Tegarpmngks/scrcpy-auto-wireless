# scrcpy-auto-wireless
(Put inside scrcpy folder!) Just a random Windows batch script to automatically open wireless adb &amp; grab ip address from wired device through ADB, intended for usage of Android version under 11.0

You can download the latest scrcpy version from it's official repository (I suggest you to download it here since it's the only official source)
https://github.com/genymobile/scrcpy

This batch script I wrote out of boredom is just for automating scrcpy connection on older devices (Oppo A3s with Android 8 to be exact)

# How does it works??
1. Older android devices didn't support wireless debugging from the Developer Settings, so we must open it through wired adb
2. After opening the wireless adb port, now we grab the device's ipv4 through adb shell command, then we store it as %Device_IP% in that instance (don't worry it will get deleted as soon as you close the cmd)
3. Then we run "scrcpy --tcpip=%Device_IP%", you can add any scrycpy argument as you see fit on this line

# Code Explanation 
```
setlocal enabledelayedexpansion
	for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
```
- This is used to set color inside the cmd, per word, color command can only do it to all the text inside the cmd window
  (You can delete it, but make sure to delete any text with ```%ESC%[0m``` and the like from the batch file 

```
set DEVICE_IP=
	FOR /F "tokens=2 delims=/ " %%a IN ('adb shell ip addr show wlan0 ^| findstr "inet" ^| findstr /v "inet6"') DO set DEVICE_IP=%%a
```
- This is used to grab device ipv4 address through adb shell, most android devices (or linux in general with singular wifi dongle/receiver) will use ```wlan0``` as it's wifi hardware name, and we find for ```"inet"``` string, but ignoring ```"inet6"``` string, so we only grab the ipv4, not ipv6 (idk how, but without it adb tends to grab ipv6 instead)

```
:start
scrcpy --tcpip=%DEVICE_IP% 

goto start
```
- I added this for reconnection capabilities, but it will only works if the said device didn't restart, you may move ```:start``` to right after the ```title Scrcpy Wi-Fi Auto Connect``` line

**Other command have either ::notes on it or just a basic adb & scrcpy command**

You may modify the code as wanted (as it's not encrypted in any way and it's on plain .bat file)

