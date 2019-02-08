#!/bin/sh -e

if [ $# -ne 2 ]; then
    echo "update.sh <replace> <create>"
    return
fi

REPLACE=$1
TARGET=$2

PATH_OPENGROK="/mnt/hdd2/opengrok"
PATH_DATA="$PATH_OPENGROK/data"
PATH_SRC="$PATH_OPENGROK/src"

PATH_HISTORYCACHE="$PATH_DATA/historycache"
REMOVE_FOLDER=("historycache" "index" "suggester" "xref")

delete_cache() {
    echo "====== delete cache ====="
    for i in "${REMOVE_FOLDER[@]}"
    do
        target_path=$PATH_DATA/$i
        if [ ! -d $target_path ]; then
            echo "$target_path not exist"
            continue
        fi

        target_folder=$target_path/$REPLACE
        if [ ! -d $target_folder ]; then
            echo "$target_folder for delete not exist"
            continue
        else
            echo "delete $target_folder"
            rm -rf $target_folder
        fi
    done
    echo "----- SUCCEED -----"
}

update_repository() {
    echo "===== update repository ====="
    if [ ! -d $PATH_SRC ]; then
        echo "src directory not exist"
        exit 1
    fi
    cd $PATH_SRC
    if [ ! -d $REPLACE ]; then
        echo "replace src $REPLACE not exist, create fresh folder"
        mkdir $TARGET
    else
        echo "replace src folder $REPLACE ==> $TARGET"
        mv $REPLACE $TARGET
    fi
    cd $TARGET
    rm -rf *

    echo "repo init & sync"
    set +e
    repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev -m "$TARGET.xml" --no-repo-verify
    repo sync -j8
    set -e

    echo "----- SUCCEED -----"
}

reindex() {
    echo "===== reindex ====="
    set +e
    cd $PATH_OPENGROK
    ./opengrok-index-run.sh
    set -e
    echo "----- SUCCEED -----"
}


update_repository
reindex
delete_cache
