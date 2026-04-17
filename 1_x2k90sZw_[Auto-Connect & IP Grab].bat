@echo off
	setlocal enabledelayedexpansion
	for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

	title Scrcpy Wi-Fi Auto Connect
echo %ESC%[91m[Killing all running adb server...] %ESC%[0m
	adb kill-server

echo %ESC%[94m[1/3] %ESC%[92m[Opening ADB TCP/IP on port 5555...] %ESC%[0m
	adb tcpip 5555

:: Delay for opening adb connection (you may add or cut time based on your phone specs and/or connection speed)
	timeout /t 3 >nul

echo. 

echo %ESC%[94m[2/3] %ESC%[92m[Querying ipv4 address from adb device...]
	set DEVICE_IP=
	FOR /F "tokens=2 delims=/ " %%a IN ('adb shell ip addr show wlan0 ^| findstr "inet" ^| findstr /v "inet6"') DO set DEVICE_IP=%%a
	if "%DEVICE_IP%"=="" (
    	echo %ESC%[92m Failed to get ipv4 address! %ESC%[0m
    	echo %ESC%[93m Make sure your device are active and connected to same Wi-Fi network %ESC%[0m
    	pause
    exit /b
)

echo Device's IPv4 Found : %DEVICE_IP%
echo.

echo %ESC%[94m[3/3] %ESC%[92m[Running scrcpy through Wi-Fi...]
echo %ESC%[93m You may disconnect the cable now. %ESC%[0m
:start
scrcpy --tcpip=%DEVICE_IP% 

goto start
pause