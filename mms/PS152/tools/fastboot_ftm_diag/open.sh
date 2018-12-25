#!/bin/sh

if [ $# -ne 1 ]; then
    echo "option 1 for reading, option 2 for opening"
fi

if [ $1 -eq 1 ]; then
    echo read fastboot
    adb shell nvm_test2 1 2556
    echo read mode
    adb shell nvm_test2 1 2557
    echo read diag
    adb shell nvm_test2 1 2558
else
    echo enable fastboot
    adb shell nvm_test2 2 2556 01
    echo enable ftm
    adb shell nvm_test2 2 2557 00
    echo enable diag
    adb shell nvm_test2 2 2558 00
fi

