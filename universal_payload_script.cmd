@echo off
title Universal payload.bin Flasher - by Hikari Calyx Tech
echo.
echo Initializing...
echo.

if exist prcsd.hikaricalyx goto otaflashinginitd
if not exist payload.bin goto nopayload
echo.
echo payload.bin detected.
echo.
echo You'll need to use Payload Dumper to dump the payload file.
echo.
echo.To use payload dumper, you must have Python 3 installed.
echo.
echo Please type lowercase "yes" to confirm, then press Enter Key to proceed. 
echo.
echo Otherwise press Enter Key with nothing typed will end this script.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto startdump
goto eof
:startdump
set econfirm=
if exist payload_dumper.exe goto pdumperexe
pip3 install protobuf
if %errorlevel% equ 9009 goto nopython
if not exist payload_dumper.py goto errornoscript
if not exist update_metadata_pb2.py goto errornoscript
python payload_dumper.py payload.bin
if %errorlevel% neq 0 goto errorscript2
goto otaflashinginit

:nopayload
echo.
echo ERROR: payload.bin doesn't exist.
echo.
pause
goto eof

:errornopython
echo.
echo ERROR: Your PC doesn't have Python 3 installed. 
echo.
pause
goto eof

:pdumperexe
echo.
payload_dumper payload.bin
if %errorlevel% neq 0 goto errorscript2
goto otaflashinginit

:errornoscript
echo.
echo ERROR: You didn't put both scripts to the same directory of this script.
echo.
pause
goto eof

:errorscript2
echo.
echo ERROR: The script didn't process the payload.bin well.
echo.
pause
goto eof

:otaflashinginitd
if exist flashit.cmd del /q flashit.cmd
echo.
echo Processed files found.
echo.
:otaflashinginit
echo.
echo Please choose a slot you wish to flash. ( a / b )
echo.
:reselectslot
set /p cslot=
if %cslot%==A set wslot=a&goto chosenx
if %cslot%==B set wslot=b&goto chosenx
if %cslot%==a set wslot=a&goto chosenx
if %cslot%==b set wslot=b&goto chosenx
echo.
echo Incorrect slot, please type again. ( a / b )
echo.
goto reselectslot
:chosenx
echo.
echo Generating flashing script...
echo.
dir /b *.img > list.txt
for /f "delims=." %%i in (list.txt) do set "%%i=%%i.img"&echo fastboot flash %%i_%wslot% %%i.img>>flashit.cmd
del list.txt
if not exist vendor.img.ext4 ren system.img system.img.ext4
if not exist vendor.img.ext4 ren vendor.img vendor.img.ext4
if not exist system.img echo Converting system image to sparse, please wait...
if not exist system.img img2simg system.img.ext4 system.img
if not exist vendor.img echo Converting vendor image to sparse, please wait...
if not exist vendor.img img2simg vendor.img.ext4 vendor.img
echo DO NOT DELETE ME > prcsd.hikaricalyx

:reflash
cls
echo.
echo The payload.bin is already processed.
echo.
echo Do you want to flash your phone right now?
echo.
echo Please type lowercase "yes" to confirm, then press Enter Key to proceed. 
echo.
echo Otherwise press Enter Key with nothing typed will end this script.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto startflashing
goto eof

:startflashing
set econfirm=
echo Please connect your powered off phone or phone that entered Fastboot mode
fastboot reboot-bootloader
fastboot oem
cls
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
del tmp.txt
echo.
echo Your Phone's serial number is %devsn:~0,16%.
echo.
echo Do you wish to erase userdata while flashing?
echo.
echo.Userdata erasing will not erase FRP lock.
echo.
echo.Please type lowercase "yes" to confirm erasing, then press Enter Key to proceed. 
echo.
echo.Otherwise, press Enter Key will skip userdata erasing.
echo.
set /p econfirm=
cls
echo.
fastboot getvar unlocked
echo.
echo.
fastboot oem device-info
echo.
echo.
echo Please check information above.
echo If your phone is unlocked, press any key to proceed.
pause>nul
echo.
echo Flashing, please wait...
echo.
call flashit.cmd
if "%econfirm%"=="yes" goto erasing
:flashdone
set econfirm=
echo.
echo.Flashing done. 
echo.
echo Do you want to switch to slot %cslot% right now?
echo.
echo.Please type lowercase "yes" to confirm erasing, then press Enter Key to proceed. 
echo.
echo.Otherwise, press Enter Key will only reboot your phone.
echo.
set /p econfirm=
if "%econfirm%"=="yes" fastboot --set-active=%wslot%
if "%econfirm%"=="yes" fastboot --set-active=_%wslot%
fastboot reboot
echo.
echo All done. Press any key to exit.
echo.
pause>nul
goto eof

:erasing
echo.
echo Erasing userdata...
echo.
fastboot format userdata
fastboot erase ssd
fastboot erase misc
fastboot erase sti
fastboot erase ddr
goto flashdone

:eof