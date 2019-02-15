#!/bin/bash

## Coverity Usage
## this script is for updating repository of all and heading target repository to branch

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
REPO_ROOT="$WORK/galileo"

if [ ! -d $REPO_ROOT ]; then
    echo "[ERROR]: repo folder in work directroy not exist"
    exit 1
fi
echo "---- SUCCEED"

# check jenkins param
echo "======== user input check"
if [ -z $REPO_VER ]; then
    echo "[ERROR]: REPO_VER not set"
    exit 1
fi
if [ -z $LAYER_PATH ]; then
    echo "[ERROR]: LAYER_PATH not set"
    exit 1
fi
if [ -z $TARGET_BRANCH ]; then
    echo "[ERROR]: TARGET_BRANCH not set"
    exit 1
fi

RECIPE_PATH="$REPO_ROOT/$LAYER_PATH"

if [ ! -d $RECIPE_PATH ]; then
    echo "[ERROR]: LAYER_PATH not exist"
    exit 1
fi
cd $RECIPE_PATH
git fetch galileo

if [ "$REPO_VER" != "galileo-pf-dev" ]; then
    git tag | grep $REPO_VER
    if [ $? -ne 0 ]; then
        echo "[ERROR]: REPO_VER not exist"
        exit 1
    fi
fi

git branch -a | grep $TARGET_BRANCH
if [ $? -ne 0 ]; then
    echo "[ERROR]: TARGET_BRANCH not exist"
    exit 1
fi
echo "---- SUCCEED"

# repo base pull
echo "======== base all repositories pull work"
cd $REPO_ROOT
set -e
repo forall -pc git fetch galileo
repo forall -pc git checkout -B galileo-pf-dev galileo/galileo-pf-dev
set +e
echo "---- SUCCEED"

# head to target branch
echo "======== head target branch work"
cd $RECIPE_PATH

if [ "$TARGET_BRANCH" != "galileo-pf-dev" ]; then
    set -e
    git fetch galileo
    git checkout $TARGET_BRANCH
    set +e
fi
echo "---- SUCCEED"
