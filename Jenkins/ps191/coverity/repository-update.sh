#!/bin/bash -x

## Coverity Usage
## this script is for updating repository of all and heading target repository to branch

source /media/m2/galileo/env/env.rc

echo "BASE_VERSION = $BASE_VERSION"
echo "SPEC_BRANCH = $SPEC_BRANCH"
echo "SPEC_BRANCH_PATH = $SPEC_BRANCH_PATH"

echo "======== init"
ROOT="/media/m2/galileo/src/coverity/"

if [ $# -ne 1 ]; then
    echo "Usage: repository-update.sh <work_folder_number>"
    exit 1
fi
if [ ! -d $ROOT$1 ]; then
    echo "[ERROR]: work directory [$1] not exist"
    exit 1
fi

WORK=$ROOT$1
REPO_ROOT="$WORK/src"

[ ! -d $REPO_ROOT ] && echo "[WARNING]: source folder not exist, creating" && mkdir $REPO_ROOT
rm -rf $REPO_ROOT/*

# BASE_VERSION
[ -z $BASE_VERSION ] && BASE_VERSION="galileo-pf-dev"
if [ "$BASE_VERSION" = "galileo-pf-dev" ]; then
    init_cmd="repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev --no-repo-verify"
else
    init_cmd="repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev -m ${BASE_VERSION}.xml --no-repo-verify"
fi
cd $REPO_ROOT
set -e
eval "$init_cmd"
repo sync
set +e
repo forall -pc git fetch galileo

# SPEC_BRANCH && SPEC_BRANCH_PATH
[ -z $SPEC_BRANCH ] && SPEC_BRANCH="none"
if [ -z $SPEC_BRANCH_PATH ] || [ "$SPEC_BRANCH" = "none" ]; then
    SPEC_BRANCH_PATH="none"
fi
if [ "$SPEC_BRANCH_PATH" != "none" ]; then
    cd $REPO_ROOT/$SPEC_BRANCH_PATH
    git branch -a | grep $SPEC_BRANCH
    if [ $? -ne 0 ]; then
        echo "[ERROR]: $SPEC_BRANCH not exist for $SPEC_BRANCH_PATH"
        exit 1
    fi
    git checkout -B $SPEC_BRANCH galileo/$SPEC_BRANCH
    cd $REPO_ROOT
fi

echo "[INFO]: init finished sucessfully"
