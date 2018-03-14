#!/bin/bash -xe

branch_arg=$1
case $branch_arg in
    platform)           BRANCH=ps152-platform-dev; CUSTOM=001;;
    cobra)              BRANCH=ps152-cobra-dev;    CUSTOM=002;;
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

rm -rf  nightly
mkdir nightly
cd nightly/
echo "auto build start"

### init build dirctry ##############################################
function retryable() {
    for i in {1..20}; do
        "$@" && break
    done
    return $?
}

initCobra(){
set +e
echo "repo init start" > time.txt
date >> time.txt
repo init -u gitosis@cobra:ps152/platform/manifest -b $BRANCH -m $BRANCH.xml --repo-url gitosis@cobra:ps152/tools/repo --no-repo-verify

echo "repo sync start" >> time.txt
date >> time.txt
retryable repo sync
set -e

echo "repo forall start" >> time.txt
date >> time.txt
repo forall -c git checkout -b $BRANCH cobra/$BRANCH
echo "repo forall end" >> time.txt
date >> time.txt
}
### init build dirctry ##############################################

### update unified ##################################################
mergePlatform(){
if [ "$BRANCH" != "ps152-cobra-dev" ]; then
    return
fi
echo "merge platform start" >> time.txt
set +e
date >> time.txt
repo forall -c git merge cobra/ps152-platform-dev

# ignore setenv.sh
cd device/panasonic/si_version
git checkout --ours setenv.sh
git add setenv.sh
cd ../../../

# ignore unified
cd hardware/panasonic/proprietary
git checkout --ours firmware/firmware2.img.ext4
git checkout --ours firmware/firmware2/unified
git add firmware
git commit -m "Merge remote-tracking branch 'cobra/ps152-platform-dev' into ps152-cobra-dev"
cd ../../../

repo forall -c git push cobra $BRANCH

set -e
echo "merge platform end" >> time.txt
date >> time.txt
}

### update unified ##################################################

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
    cd hardware/panasonic/proprietary
    git add firmware
    git commit -m "Change unified version"
    git push
    cd ../../../
}
### update unified ##################################################

### update Build_ID #################################################
updateBuildID(){
    cd device/panasonic/si_version/
    cat setenv.sh | sed \
	-e "s/PSN_SI_VERSION=.*/PSN_SI_VERSION=$SI/" \
	-e "s/PSN_REGION_VERSION=.*/PSN_REGION_VERSION=$REGION/" \
	-e "s/PSN_CUSTOM_VERSION=.*/PSN_CUSTOM_VERSION=$CUSTOM/" \
	-e 's/BUILD_SECURE=.*/BUILD_SECURE=""/' > tmp.sh
    mv tmp.sh setenv.sh
    chmod ugo+x setenv.sh
    git add setenv.sh
    git commit -m "P152HWR:SI::Change PSN_SI_VERSION $SI"
    git push
    cd ../../../
}
### update Build_ID #################################################

### update TAG ######################################################
updateTAG(){
    repo forall -c git tag $TAG
    repo forall -c git push cobra $TAG
}
### update TAG ######################################################

### update Manifest #################################################
updateManifest(){
    cd .repo/manifests
    git checkout -b $BRANCH
    cat $BRANCH.xml | sed "s/heads\/$BRANCH/tags\/$TAG/" > $TAG.xml
    git add $TAG.xml
    git commit -m "P152HWR:SI::Add new manifest for $TAG"
    git push
    cd ../
    unlink manifest.xml
    ln -s manifests/$TAG.xml manifest.xml
    cd ../
}
### update Manifest #################################################


### build ###########################################################
build(){
./TCD_BUILD.sh
}
createZip(){
    cd ./out/
    for f in PS152-12* ; do
	zip -r /qnap/PS152-1/develop/nightly/$BRANCH/$f.zip $f
    done
    cd ../
}
### build ###########################################################

initCobra
mergePlatform
updateUnified
updateBuildID
updateTAG
updateManifest
build
createZip

echo date
echo "auto build end"
