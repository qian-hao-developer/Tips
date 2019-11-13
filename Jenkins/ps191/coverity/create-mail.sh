#!/bin/bash -x

# this script is for creating mail contents of result notifications
if [ $# -ne 2 ]; then
    echo "Usage: create-mail.sh <WORK> <RESULT>"
    exit 1
fi

echo "BASE_VERSION = $BASE_VERSION"
echo "SPEC_BRANCH = $SPEC_BRANCH"
echo "SPEC_BRANCH_PATH = $SPEC_BRANCH_PATH"
echo "BUILD_RECIPE = $BUILD_RECIPE"
echo "MANUFACTURE = $MANUFACTURE"
echo "HARDWARE = $HARDWARE"
echo "NAND = $NAND"

echo "PROJECT_NAME = $PROJECT_NAME"
echo "BUILD_NUMBER = $BUILD_NUMBER"
echo "BUILD_STATUS = $BUILD_STATUS"
echo "BUILD_URL = $BUILD_URL"

ROOT="/media/m2/galileo/src/coverity/"
SCRIPTS_ROOT="/media/m2/galileo/sh/coverity/"
WORK=$ROOT$1
OUT="$WORK/mail.txt"
TEMPLATE="$SCRIPTS_ROOT/data/notification.txt"
RESULT=$2
COMMIT_LOG="$WORK/commit-log.txt"
ADDITIONAL_SUCCESS="http://10.68.23.32:8080/ にてご確認ください。\n\n\
1. ブラウザで上記アドレス(Coverity Connectサーバー)にアクセス\n\
2. 画面左上(Sマークの右)をクリックし、「Developer Streams」を選択\n\
3. 画面左上(Sマークの下)の三本線マークをクリックし、フィルターを選択・作成\n\
4. フィルターの設定画面にて、「スナップショットスコープ」シートの「表示」欄に、上記「snapshot」番号を記入\n\
5. フィルターの設定画面にて、「フィルター」シートの「ストリーム」欄に、「fujisawa.yoshiharu_1」を記入\n\
6. 「OK」をクリックし、結果を参照\n\
"
ADDITIONAL_FAILURE="ログ結果をご確認いただくか、メインテナーにご相談ください。\n\n\
ログの確認方法は以下：\n\
1. Jenkinsサーバー(http://10.73.174.111:8080)にアクセス\n\
2. 本メールに記載されているパイプラインをクリック\n\
3. 本メールに記載されているビルド番号を、左側にある「ビルド履歴」から参照し、クリック\n\
4. 画面左側にある「Console Output」をクリック\n\
5. 表示されるログを確認\n\
※タイトル構成：[Coverity通知] <パイプライン> <ビルド番号> (ビルド結果)\n\
"

echo "======== create result mail"
rm -rf $OUT
cp $TEMPLATE $OUT

sed -i "s@\(.*\)\(<BUILD_URL>\)@\1$BUILD_URL@g" $OUT
sed -i "s@\(.*\)\(<BASE_VERSION>\)@\1$BASE_VERSION@g" $OUT
sed -i "s@\(.*\)\(<SPEC_BRANCH>\)@\1$SPEC_BRANCH@g" $OUT
sed -i "s@\(.*\)\(<SPEC_BRANCH_PATH>\)@\1$SPEC_BRANCH_PATH@g" $OUT
sed -i "s@\(.*\)\(<BUILD_RECIPE>\)@\1$BUILD_RECIPE@g" $OUT
sed -i "s@\(.*\)\(<MANUFACTURE>\)@\1$MANUFACTURE@g" $OUT
sed -i "s@\(.*\)\(<HARDWARE>\)@\1$HARDWARE@g" $OUT
sed -i "s@\(.*\)\(<NAND>\)@\1$NAND@g" $OUT

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
    sed -i "s@\(.*\)\(<RESULT_FIXME>\)@\1$RESULT@g" $OUT
    sed -i "s@\(.*\)\(<SNAPSHOT_FIXME>\)@\1---@g" $OUT
    sed -i "s@\(.*\)\(<ADDITIONAL_FIXME>\)@\1$ADDITIONAL_FAILURE@g" $OUT
fi

if [ ! -e $OUT ]; then
    echo "[ERROR]: create mail failed"
    exit 1
fi
echo "[INFO]: create finished successfully"
