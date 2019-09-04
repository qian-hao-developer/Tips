#!/bin/bash

PATH_OPENGROK="/mnt/hdd2/opengrok"
PATH_SCRIPT_ROOT="$PATH_OPENGROK/sh"
PATH_DATA="$PATH_OPENGROK/data"
PATH_HISTORYCACHE="$PATH_DATA/historycache"
REMOVE_FOLDER=("historycache" "index" "suggester" "xref")
PATH_INDEX_DIR="$PATH_OPENGROK/index_links"

######################## common

reindex() {
    echo "===== reindex ====="
    set -e
    cd $PATH_OPENGROK
    $PATH_SCRIPT_ROOT/opengrok-index-run.sh
    set +e
    echo "----- SUCCEED -----"
}

link_resource() {
	echo "===== link resource ====="
	if [ -z $TARGET ]; then
		echo "[ERROR]: target $TARGET not set"
		exit 1
	fi
	if [ ! -d "$PATH_SRC/$TARGET" ]; then
		echo "[ERROR]: target $PATH_SRC/$TARGET not exist"
		exit 1
	fi

	if [ -L "$PATH_INDEX_DIR/$TARGET" ]; then
		echo "link $PATH_INDEX_DIR/$TARGET already exist, remove and recreate"
		rm -rf $PATH_INDEX_DIR/$TARGET
	fi
	echo "start link: $TARGET ==> $PATH_INDEX_DIR/$TARGET"
	ln -s $PATH_SRC/$TARGET $PATH_INDEX_DIR/$TARGET
}

######################## option: create

create_repository() {
    echo "===== create repository ====="
    if [ ! -d $PATH_SRC ]; then
        echo "[ERROR]: top directory which manages src folders ($PATH_SRC) not exist"
        exit 1
    fi
    cd $PATH_SRC
    if [ -d $TARGET ]; then
        echo "[ERROR]: target folder $TARGET already existed, use -u instead of -c"
		exit 1
	fi

    echo "create resource in $TARGET"
	mkdir $TARGET
    cd $TARGET

    echo "repo init & sync"
    set -ex
    repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b $MAIN_BRANCH -m "$TARGET.xml" --no-repo-verify
    repo sync -j8
    set +ex

    echo "----- SUCCEED -----"
}

do_create_resource() {
	create_repository
	link_resource
}

opt_create_resource() {
	# check sub opts exist
	if [ $# -ne 3 ]; then
		echo "update.sh -c <main_branch> <src>"
		echo "i.e:"
		echo "update -c galileo-pf-dev bart_1"
	    exit 1
	fi
	
	MAIN_BRANCH=$2
	TARGET=$3
	
	PATH_SRC="$PATH_OPENGROK/src/$MAIN_BRANCH"

	do_create_resource
}

######################## option: update

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

delete_link() {
	echo "===== delete link ====="
	if [ -z $REPLACE ]; then
		echo "[ERROR]: replace $REPLACE not set"
		exit 1
	fi
	if [ ! -L "$PATH_INDEX_DIR/$REPLACE" ]; then
		echo "old link $PATH_INDEX_DIR/$REPLACE not exist, skip"
		return
	fi
	rm -rf $PATH_INDEX_DIR/$REPLACE
}

update_repository() {
    echo "===== update repository ====="
    if [ ! -d $PATH_SRC ]; then
        echo "[ERROR]: top directory which manages src folders ($PATH_SRC) not exist"
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
    set -e
    repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev -m "$TARGET.xml" --no-repo-verify
    repo sync -j8
    set +e

    echo "----- SUCCEED -----"
}

do_update_resource() {
	update_repository
	delete_link
	delete_cache
	link_resource
}

opt_update_resource() {
	# check sub opts exist
	if [ $# -ne 4 ]; then
	    echo "update.sh -u <main_branch> <replace> <create>"
		echo "i.e:"
		echo "update.sh -u galileo-pf-dev abu_r2 abu_r3"
	    exit 1
	fi
	
	MAIN_BRANCH=$2
	REPLACE=$3
	TARGET=$4
	
	PATH_SRC="$PATH_OPENGROK/src/$MAIN_BRANCH"

	do_update_resource
}

######################## option: help

do_link_resource() {
	link_resource
}

opt_link_resource() {
	# check sub opts exist
	if [ $# -ne 3 ]; then
	    echo "update.sh -l <main_branch> <target>"
		echo "i.e:"
		echo "update.sh -l galileo-pf-dev abu_r2"
	    exit 1
	fi
	
	MAIN_BRANCH=$2
	TARGET=$3
	
	PATH_SRC="$PATH_OPENGROK/src/$MAIN_BRANCH"

	do_link_resource
}

######################## option: help

opt_index_resource() {
	reindex
}

######################## option: help

opt_help() {
	echo "Usage: update.sh [-c] [-u] -o"
	echo "		 -c: create new resource"
	echo "			 update -c <main_branch> <src>"
	echo "			 i.e"
	echo "			 update -c galileo-pf-dev bart_1"
	echo "		 -u: update existed resource"
	echo "			 update -u <main_branch> <old_src> <new_src>"
	echo "			 i.e"
	echo "			 update -u galileo-pf-dev abu_r2 abu_r3"
	echo "		 -h: print this help"
}

######################## main

main() {
	# check option exists
	if [ $# -lt 1 ]; then
		echo "[ERROR]: at least 1 option needed, num_opt = $#"
		exit 1
	fi

	# run opt
	while getopts "c:u:l:ih" opt; do
		case $opt in
			c)
				opt_create_resource $@
				;;
			u)
				opt_update_resource $@
				;;
			i)
				opt_index_resource $@
				;;
			l)
				opt_link_resource $@
				;;
			h)
				opt_help $@
				;;
		esac
	done
}

main $@
