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
COV_INTER_DIR="$WORK/cov-inter-dir"
echo "---- SUCCEED"

# check jenkins input
echo "======== user input check"
if [ -z $TARGET_BRANCH ]; then
    echo "[ERROR]: TARGET_BRANCH not set"
    exit 1
fi
echo "---- SUCCEED"

# commit
echo "======== coverity commit"
set -e
cov-commit-defects --dir $COV_INTER_DIR --host 10.68.23.32 --user qian.hao --password qian.hao --stream fujisawa.yoshiharu_1 --description "$TARGET_BRANCH"
set +e
echo "---- SUCCEED"
