#!/bin/sh

echo "[start]"
if [ $# -ne 2 ]; then
    echo "./install.sh <.apk> <IP Adress>"
    exit 1
fi

echo "[adb connect]"
adb connect $2
echo "[adb root]"
adb root
echo "[adb connect]"
adb connect $2
echo "[push]"
adb push $1 /sdcard/Download/app-debug.apk
echo "[mount]"
adb shell mount -w -o remount /dev/block/by-name/system /system
echo "[mkdir]"
adb shell mkdir /system/priv-app/com.kddi.catv.neo.uiapp-1
echo "[rm apk]"
adb shell rm /system/priv-app/com.kddi.catv.neo.uiapp-1/TV.apk
echo "[cp apk]"
adb shell cp /sdcard/Download/app-debug.apk /system/priv-app/com.kddi.catv.neo.uiapp-1/TV.apk
echo "[chmod folder]"
adb shell chmod 777 /system/priv-app/com.kddi.catv.neo.uiapp-1
echo "[chmod apk]"
adb shell chmod 644 /system/priv-app/com.kddi.catv.neo.uiapp-1/TV.apk
echo "[done]"
