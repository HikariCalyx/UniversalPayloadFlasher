# UniversalPayloadFlasher
A script that will allow you flash payload.bin for A/B Android devices like fastboot images.

## What you need
1. Google Platform Tools

Which can be downloaded from

https://developer.android.com/studio/releases/platform-tools


Or this website for Chinese users

https://developer.android.google.cn/studio/releases/platform-tools

2. Python 3

You must add Python 3 into your environment variable when installing.

https://www.python.org/downloads/

3. Payload dumper

If you want to use Payload dumper python script, this can be downloaded from

https://gist.github.com/ius/42bd02a5df2226633a342ab7a9c60f15

If you have precompiled payload_dumper.exe, you can use it instead, without Python 3 installed. 

4. img2simg for Windows

This is a bit difficult to find, so I'll provide in the release section directly.

5. dd for Windows

Thanks to John Newbigin for such tool!

http://www.chrysocome.net/dd

Search "dd-0.6beta3.zip" in page above to download it.

## How to use, if you decided to use the source script only
1. Install Python 3 with Environment Variable added.

2. Put the script with following files (If you decided to use payload_dumper.exe, then you needn't to put payload_dumper.py and update_metadata_pb2.py altogether):

payload_dumper.py

update_metadata_pb2.py

fastboot.exe

AdbWinApi.dll

AdbWinUsbApi.dll

mke2fs.exe

mke2fs.conf

make_f2fs.exe

cyggcc_s-1.dll

cygwin1.dll

cygz.dll

img2simg.exe

dd.exe

3. Place payload.bin altogether, which can be extracted from your Full OTA package. The payload.bin from Append OTA will not be accepted.

4. Open the script and follow the steps that script told you.

## What about the release?
This is meant for saving efforts. Since it's packaged with Bat2Exe, it may marked as Trojan, this is expected.
Please add it to whitelist before using, otherwise please use the source script instead.
