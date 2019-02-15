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
POKY="$WORK/galileo/poky"
COV_INTER_DIR="$WORK/cov-inter-dir"

if [ ! -d $POKY ]; then
    echo "[ERROR]: poky directory not exist"
    exit 1
fi
echo "---- SUCCEED"

# jenkins input check
echo "======== user input check"
if [ -z $TARGET_RECIPE ]; then
    echo "[ERROR]: TARGET_RECIPE not set"
    exit 1
fi
echo "---- SUCCEED"

# remove coverity build cache of last time
rm -rf $COV_INTER_DIR

# build
echo "======== build with coverity"
cd $POKY
set -e
echo "[INFO]: COV_INTER_DIR = $COV_INTER_DIR"
echo "[INFO]: TARGET_RECIPE = $TARGET_RECIPE"
if [ "$TARGET_RECIPE" = "all" ]; then
    SSTATE="$WORK/yocto-cache/sstate-cache"
    if [ -d $SSTATE ]; then
        rm -rf $SSTATE
    fi
    bash -c "\
        source oe-init-build-env && \
        cov-build --dir $COV_INTER_DIR --encoding UTF-8 --emit-complementary-info --add-arg --no_emit_referenced_types --add-arg --no_use_stage_emit --add-arg -D_Fract=int bitbake brcm-pos-image"
else
    bash -c "\
        source oe-init-build-env && \
        bitbake $TARGET_RECIPE -c cleansstate && \
        cov-build --dir $COV_INTER_DIR --encoding UTF-8 --emit-complementary-info --add-arg --no_emit_referenced_types --add-arg --no_use_stage_emit --add-arg -D_Fract=int bitbake $TARGET_RECIPE"
fi
set +e
echo "---- SUCCEED"
