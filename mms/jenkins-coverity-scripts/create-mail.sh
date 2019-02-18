#!/bin/bash

# this script is for creating mail contents of result notifications
if [ $# -ne 2 ]; then
    echo "Usage: create-mail.sh <WORK> <RESULT>"
    exit 1
fi

ROOT="/mnt/hdd2/"
SCRIPTS_ROOT="/mnt/hdd2/coverity/scripts"
WORK=$ROOT$1
OUT="$WORK/mail.txt"
TEMPLATE="$SCRIPTS_ROOT/data/notification.txt"
RESULT=$2
COMMIT_LOG="$WORK/commit-log.txt"
ADDITIONAL_SUCCESS="http://10.68.23.32:8080/\nにてご確認んください。"
ADDITIONAL_FAILURE="ログ結果をご確認いただくか、メインテナーにご連絡をお願いいたします。"

echo "======== create result mail"
rm -rf $OUT
cp $TEMPLATE $OUT

sed -i "s@\(.*\)\(<REPO_VER_FIXME>\)@\1$REPO_VER@g" $OUT
sed -i "s@\(.*\)\(<LAYER_PATH_FIXME>\)@\1$LAYER_PATH@g" $OUT
sed -i "s@\(.*\)\(<TARGET_BRANCH_FIXME>\)@\1$TARGET_BRANCH@g" $OUT
sed -i "s@\(.*\)\(<TARGET_RECIPE_FIXME>\)@\1$TARGET_RECIPE@g" $OUT

if [ $RESULT = "SUCCESS" ]; then
    if [ ! -e $COMMIT_LOG ]; then
        echo "[ERROR]: $COMMIT_LOG not exist"
        exit 1
    fi
    snap=`grep "snapshot" $COMMIT_LOG`

    sed -i "s@\(.*\)\(<RESULT_FIXME>\)@\1SUCCEED@g" $OUT
    sed -i "s@\(.*\)\(<SNAPSHOT_FIXME>\)@\1$snap@g" $OUT
    sed -i "s@\(.*\)\(<ADDITIONAL_FIXME>\)@\1$ADDITIONAL_SUCCESS@g" $OUT
else
    sed -i "s@\(.*\)\(<RESULT_FIXME>\)@\1FAILED@g" $OUT
    sed -i "s@\(.*\)\(<SNAPSHOT_FIXME>\)@\1---@g" $OUT
    sed -i "s@\(.*\)\(<ADDITIONAL_FIXME>\)@\1$ADDITIONAL_FAILURE@g" $OUT
fi

if [ ! -e $OUT ]; then
    echo "[ERROR]: create mail failed"
    exit 1
fi
echo "---- SUCCEED"
