#!/bin/sh

adb push busybox /data
adb shell chmod +x /data/busybox
echo Read Start
#echo --- SERIAL_NUMBER
#adb shell /data/busybox devmem 0x5C008 32
#echo --- JTAG_ID
#adb shell /data/busybox devmem 0x5E07C 32
#echo --- SOC_HW_VERSION
#adb shell /data/busybox devmem 0x0194D000 32
#echo --- OEM_ID, PRODUCT_ID
#adb shell /data/busybox devmem 0x5E080 32
#echo --------------------------------
#echo === QFPROM ===
#echo --- FEATURE_ID,JTAG_ID ---
#adb shell /data/busybox devmem 0x58000 32
#echo --- READ Permission ---
#adb shell /data/busybox devmem 0x58010 32
#echo --- WRITE Permission ---
#adb shell /data/busybox devmem 0x58014 32
#echo --- Anti rollback ---
#adb shell /data/busybox devmem 0x58018 32
#adb shell /data/busybox devmem 0x5801C 32
#adb shell /data/busybox devmem 0x58020 32
#echo --- OEM CONFIG ---
#adb shell /data/busybox devmem 0x58030 32
#adb shell /data/busybox devmem 0x58034 32
#adb shell /data/busybox devmem 0x58038 32
#adb shell /data/busybox devmem 0x5803C 32
echo --- OEM secure boot ---
adb shell /data/busybox devmem 0x58098 32
adb shell /data/busybox devmem 0x5809C 32
#echo --- OEM PK Hash ---
#adb shell /data/busybox devmem 0x580A8 32
#adb shell /data/busybox devmem 0x580AC 32
#adb shell /data/busybox devmem 0x580B0 32
#adb shell /data/busybox devmem 0x580B4 32
#adb shell /data/busybox devmem 0x580B8 32
#adb shell /data/busybox devmem 0x580BC 32
#adb shell /data/busybox devmem 0x580C0 32
#adb shell /data/busybox devmem 0x580C4 32
#adb shell /data/busybox devmem 0x580C8 32
#adb shell /data/busybox devmem 0x580CC 32
echo Finish.
