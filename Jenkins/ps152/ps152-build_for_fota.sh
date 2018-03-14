#!/bin/bash -xe

MODEL_NAME=JT-C52
CERT_SRC_DIR=/qnap/PS152-1/keystore/release
CERT_DST_DIR=device/panasonic/$MODEL_NAME

branch_arg=$1
case $branch_arg in
    cobra-cts)          BRANCH=ps152-cobra-cts;    CUSTOM=002;;
    cobra-beta)         BRANCH=ps152-cobra-dev-beta; CUSTOM=002;;
    platform)           BRANCH=ps152-platform-dev; CUSTOM=001;;
    cobra)              BRANCH=ps152-cobra-dev;    CUSTOM=C02;;
    pingu)              BRANCH=ps152-pingu-dev;    CUSTOM=A21;;
    pell)               BRANCH=ps152-pell-dev;     CUSTOM=002;;
    *)                  usage ; exit 1;;
esac

SI=$2
if [ "$SI" = "" ]; then
  exit 1
fi

REGION=$3
if [ "$REGION" = "" ]; then
  exit 1
fi

cd /home/gitosis/android/$BRANCH/
SSD=$4
if [ "$SSD" = "ssd" ]; then
  cd /home2/$BRANCH/
fi

RELEASE=$5

cd nightly/
echo "auto build start"

### BUILD DEFINE ####################################################
TAG=ps152-12-$CUSTOM-$SI-$REGION

### BUILD DEFINE ####################################################

echo date
echo "build TAG=$TAG"

### update unified ##################################################
updateUnified(){
    echo "update unified"
    cd hardware/panasonic/proprietary/firmware/firmware2/
    echo -e "$CUSTOM.$SI.$REGION\n" > unified
    cat unified
    
    cd ../../../../../
    ./hardware/panasonic/proprietary/firmware/generate_image.sh 
}
### update unified ##################################################

### update Build_ID #################################################
updateBuildID(){
    cd device/panasonic/$MODEL_NAME/
    cat COBRA_BUILD.sh | sed \
	-e "s/PSN_SI_VERSION=.*/PSN_SI_VERSION=$SI/" \
	-e "s/PSN_REGION_VERSION=.*/PSN_REGION_VERSION=$REGION/" \
	-e "s/PSN_CUSTOM_VERSION=.*/PSN_CUSTOM_VERSION=$CUSTOM/" \
	-e 's/BUILD_SECURE=.*/BUILD_SECURE=""/' > tmp.sh
    mv tmp.sh COBRA_BUILD.sh
    chmod ugo+x COBRA_BUILD.sh
    cd ../../../
}
updateBuildIDNonSecure(){
    set +e
    rm out/target/product/$MODEL_NAME/system/build.prop
    rm out/target/product/$MODEL_NAME/system/build.prop.bakforspec
    set -e
}
### update Build_ID #################################################

### build ###########################################################
build(){
	cp -af device/panasonic/$MODEL_NAME/COBRA_BUILD.sh .
	./COBRA_BUILD.sh
}
### build ###########################################################

### makeDP ###########################################################
makeDP(){
	cd build/tools/create_dp/
	cp -r ../../../out/PS152-12-${CUSTOM}-${SI}-${REGION}_EWriter ./PS152-12-${CUSTOM}-${SI}-${REGION}
	echo "gitosis" | sudo -S ./create_test_dp_full.sh PS152-12-${CUSTOM}-${SI}-${REGION}
	cd ../../../
}
### makeDP ###########################################################

### createZip ###########################################################
createZip(){
    cd ./out/
    for f in PS152-12* ; do
	zip -r /qnap/PS152-1/develop/nightly/$BRANCH/$f.zip $f
    done
    cd ../

	zip /qnap/PS152-1/develop/nightly/$BRANCH/PS152-12-${CUSTOM}-${SI}-${REGION}-full.zip \
		build/tools/create_dp/PS152-12-${CUSTOM}-${SI}-${REGION}-full.dat

}
### createZip ###########################################################
cleanup(){
    cd ./out/
    echo "gitosis" | sudo -S rm -rf PS152-12-${CUSTOM}-${SI}-${REGION}
    echo "gitosis" | sudo -S rm -rf PS152-12-${CUSTOM}-${SI}-${REGION}_EWriter
    cd ../

    cd build/tools/create_dp/
    set +e
    git checkout -f
    git clean -d -f
    set -e
    echo "gitosis" | sudo -S rm -rf NEW
    echo "gitosis" | sudo -S rm -rf OLD
}

updateUnified
updateBuildID
updateBuildIDNonSecure
build
makeDP
createZip
cleanup

echo date
echo "auto build end"
