@ECHO OFF
ECHO RAW転送用ビットマップをコピーします。
rem ビットマップファイルを消す
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN1.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN2.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN3.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN4.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN5.bmp
rem ビットマップファイルをコピーする
..\adb push RAW_PATTERN1.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN2.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN3.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN4.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN5.bmp /mnt/sdcard/Pictures/

ECHO イメージ転送用ビットマップをコピーします。
rem ビットマップファイルを消す
..\adb shell rm /sdcard/pictures/PATTERN1.bmp
..\adb shell rm /sdcard/pictures/PATTERN2.bmp
..\adb shell rm /sdcard/pictures/PATTERN3.bmp
..\adb shell rm /sdcard/pictures/PATTERN4.bmp
..\adb shell rm /sdcard/pictures/PATTERN5.bmp
rem ビットマップファイルをコピーする
..\adb push PATTERN1.bmp /sdcard/Pictures/
..\adb push PATTERN2.bmp /sdcard/Pictures/
..\adb push PATTERN3.bmp /sdcard/Pictures/
..\adb push PATTERN4.bmp /sdcard/Pictures/
..\adb push PATTERN5.bmp /sdcard/Pictures/

ECHO 日本語フォントファイルをコピーします。
..\adb shell rm /sdcard/pictures/PRN_FT01.bin
..\adb push PRN_FT01.bin /sdcard/Pictures/

ECHO ファームウェアデータ転送用ファイルをコピーします
..\adb shell rm /sdcard/pictures/MobilePay.bin
..\adb push MobilePay.bin /sdcard/Pictures/

ECHO iowrite.txtデータをコピーします
..\adb shell rm /sdcard/pictures/iowrite.txt
..\adb push iowrite.txt /sdcard/Pictures/

ECHO spiwrite.txtデータをコピーします
..\adb shell rm /sdcard/pictures/spiwrite.txt
..\adb push spiwrite.txt /sdcard/Pictures/

ECHO TEXT1.txt TEXT2.txt TEXT3.txtデータをコピーします
..\adb shell rm /sdcard/pictures/TEXT1.txt
..\adb shell rm /sdcard/pictures/TEXT2.txt
..\adb shell rm /sdcard/pictures/TEXT3.txt
..\adb push TEXT1.txt /sdcard/Pictures/
..\adb push TEXT2.txt /sdcard/Pictures/
..\adb push TEXT3.txt /sdcard/Pictures/

rem /* +++ JMups Addition Start by 2014/06/05 f.ono +++ */
rem ECHO Printerアプリケーションをコピーします。
rem ..\adb shell rm /sdcard/pictures/Printer.apk
rem ..\adb push Printer.apk /sdcard/Pictures/

rem ECHO リリースノートもコピー転送しておきます。
rem ..\adb shell rm /sdcard/pictures/ReleaseNote.txt
rem ..\adb push ReleaseNote.txt /sdcard/Pictures/

rem ECHO Printer.apkをインストールします
rem ..\adb uninstall com.example.printer
rem ..\adb install Printer.apk
rem /* +++ JMups Addition End   by 2014/06/05 f.ono +++ */

ECHO インストールは、正常に終了しました

pause
