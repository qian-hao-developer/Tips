#!/bin/bash

## Coverity Usage
## this script is for running coverity-build

# check script usage and base env
echo "======== init"
ROOT="/mnt/hdd2/"

if [ $# -ne 1 ]; then
    echo "Usage: repository-update.sh <work_folder_number>"
    exit 1
fi
if [ ! -d $ROOT$1 ]; then
    echo "[ERROR]: work directory [$1] not exist"
    exit 1
fi

WORK=$ROOT$1
POKY_BUILD="$WORK/galileo/poky/build"
COV_INTER_DIR="$WORK/cov-inter-dir"

if [ ! -d $POKY_BUILD ]; then
    echo "[ERROR]: build directory not exist"
    exit 1
fi
echo "---- SUCCEED"

# analyze
echo "======== coverity analyze"
set -e
cov-analyze --dir $COV_INTER_DIR --all --rule --strip-path $POKY_BUILD -j auto
set +e
echo "---- SUCCEED"
