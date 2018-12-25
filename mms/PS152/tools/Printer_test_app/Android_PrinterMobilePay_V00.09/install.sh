#!/bin/bash

echo "RAW転送用ビットマップをコピーします。"
echo "ビットマップファイルを消す"
adb shell rm /mnt/sdcard/pictures/RAW_PATTERN1.bmp
adb shell rm /mnt/sdcard/pictures/RAW_PATTERN2.bmp
adb shell rm /mnt/sdcard/pictures/RAW_PATTERN3.bmp
adb shell rm /mnt/sdcard/pictures/RAW_PATTERN4.bmp
adb shell rm /mnt/sdcard/pictures/RAW_PATTERN5.bmp
echo "ビットマップファイルをコピーする"
adb push RAW_PATTERN1.bmp /mnt/sdcard/Pictures/
adb push RAW_PATTERN2.bmp /mnt/sdcard/Pictures/
adb push RAW_PATTERN3.bmp /mnt/sdcard/Pictures/
adb push RAW_PATTERN4.bmp /mnt/sdcard/Pictures/
adb push RAW_PATTERN5.bmp /mnt/sdcard/Pictures/

echo "イメージ転送用ビットマップをコピーします。"
echo "ビットマップファイルを消す"
adb shell rm /mnt/sdcard/pictures/PATTERN1.bmp
adb shell rm /mnt/sdcard/pictures/PATTERN2.bmp
adb shell rm /mnt/sdcard/pictures/PATTERN3.bmp
adb shell rm /mnt/sdcard/pictures/PATTERN4.bmp
adb shell rm /mnt/sdcard/pictures/PATTERN5.bmp
echo "ビットマップファイルをコピーする"
adb push PATTERN1.bmp /mnt/sdcard/Pictures/
adb push PATTERN2.bmp /mnt/sdcard/Pictures/
adb push PATTERN3.bmp /mnt/sdcard/Pictures/
adb push PATTERN4.bmp /mnt/sdcard/Pictures/
adb push PATTERN5.bmp /mnt/sdcard/Pictures/

echo "日本語フォントファイルをコピーします。"
adb shell rm /mnt/sdcard/pictures/PRN_FT01.bin
adb push PRN_FT01.bin /mnt/sdcard/Pictures/

echo "ファームウェアデータ転送用ファイルをコピーします"
adb shell rm /mnt/sdcard/pictures/MobilePay.bin
adb push MobilePay.bin /mnt/sdcard/Pictures/

echo "iowrite.txtデータをコピーします"
adb shell rm /mnt/sdcard/pictures/iowrite.txt
adb push iowrite.txt /mnt/sdcard/Pictures/

echo "spiwrite.txtデータをコピーします"
adb shell rm /mnt/sdcard/pictures/spiwrite.txt
adb push spiwrite.txt /mnt/sdcard/Pictures/

echo "TEXT1.txt TEXT2.txt TEXT3.txtデータをコピーします"
adb shell rm /mnt/sdcard/pictures/TEXT1.txt
adb shell rm /mnt/sdcard/pictures/TEXT2.txt
adb shell rm /mnt/sdcard/pictures/TEXT3.txt
adb push TEXT1.txt /mnt/sdcard/Pictures/
adb push TEXT2.txt /mnt/sdcard/Pictures/
adb push TEXT3.txt /mnt/sdcard/Pictures/

echo "Printerアプリケーションをコピーします。"
adb shell rm /mnt/sdcard/pictures/PrinterMobilePay.apk
adb push PrinterMobilePay.apk /mnt/sdcard/Pictures/

echo "リリースノートもコピー転送しておきます。"
adb shell rm /mnt/sdcard/pictures/ReleaseNote.txt
adb push ReleaseNote.txt /mnt/sdcard/Pictures/

echo "PrinterMobilePay.apkをインストールします"
adb uninstall com.example.printer
adb install PrinterMobilePay.apk

echo "インストールは、正常に終了しました"