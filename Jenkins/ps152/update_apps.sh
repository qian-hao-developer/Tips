#!/bin/bash -xe

TARGET_PINGU=/qnap/PS152-1/apps/20170919/pingu-release
APK_PINGU=$TARGET_PINGU/apk/browsertool-sumisei_jtc52-release-unsigned.apk

TARGET_ARCH=/qnap/PS152-1/apps/20170919/arch-cl-release
APK_ARCH=$TARGET_ARCH/apk/browsertool-sumisei_jtc52-release-unsigned.apk


APPS=/home2/apps
KEYSTORE=/qnap/PS152-1/keystore

PEM_DEV=$KEYSTORE/develop/3rdparty/ref/3rdparty.x509.pem
PK8_DEV=$KEYSTORE/develop/3rdparty/ref/3rdparty.pk8
PEM_REL=$KEYSTORE/release/3rdparty/ref/3rdparty.x509.pem
PK8_REL=$KEYSTORE/release/3rdparty/ref/3rdparty.pk8

cd $APPS/ps152-pingu-release/CAFISArch/
git pull
cp $TARGET_PINGU/so/*.so lib/armeabi/.
java -jar $KEYSTORE/signapk.jar $PEM_DEV $PK8_DEV $APK_PINGU base/CAFISArch.apk
java -jar $KEYSTORE/signapk.jar $PEM_REL $PK8_REL $APK_PINGU release/CAFISArch.apk

cd $APPS/ps152-arch-cl-release/CAFISArch/
git pull
cp $TARGET_ARCH/so/*.so lib/armeabi/.
java -jar $KEYSTORE/signapk.jar $PEM_DEV $PK8_DEV $APK_ARCH base/CAFISArch.apk
java -jar $KEYSTORE/signapk.jar $PEM_REL $PK8_REL $APK_ARCH release/CAFISArch.apk

