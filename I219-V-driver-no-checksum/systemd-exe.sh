#!/bin/bash

abs_path="$(dirname $(readlink -f "$0"))/"
echo "abs_path = $abs_path"
date

if ! ifconfig | grep 70:85:c2:2b:f6:7f &>/dev/null; then
    $abs_path/execute.sh
else
    echo "ethernet driver already installed, skip ..."
fi

