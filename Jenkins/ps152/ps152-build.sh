#!/bin/bash -xe

MODEL_NAME=JT-C52
CERT_SRC_DIR=/qnap/PS152-1/keystore/release
CERT_DST_DIR=device/panasonic/$MODEL_NAME

# sharing .repo directory
SHARED_REPO=/home2/ps152-share-repo/.repo

branch_arg=$1
case $branch_arg in
    cobra-cts)          BRANCH=ps152-cobra-cts;      CUSTOM=002;;
    cobra-beta)         BRANCH=ps152-cobra-dev-beta; CUSTOM=002;;
    platform)           BRANCH=ps152-platform-dev;   CUSTOM=001;;
    cobra)              BRANCH=ps152-cobra-dev;      CUSTOM=C02;;
    cobra-rel)          BRANCH=ps152-cobra-release;  CUSTOM=C14;;
    pingu)              BRANCH=ps152-pingu-dev;      CUSTOM=D21;;
    pingu-rel)          BRANCH=ps152-pingu-release;  CUSTOM=D33;;
    pell)               BRANCH=ps152-pell-dev;       CUSTOM=002;;
    cobra-advance-dev)  BRANCH=ps152-cobra-advance-dev; CUSTOM=C03;;
    cobra-contact-rel)  BRANCH=ps152-cobra-contact-release;  CUSTOM=C12;;
    arch-cl-rel)        BRANCH=ps152-arch-cl-release; CUSTOM=D32;;
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
MERGE_TAG=$6

echo "gitosis" | sudo -S rm -rf  nightly
mkdir nightly
cd nightly/
echo "auto build start"

### init build dirctry ##############################################
function retryable() {
    for i in {1..50}; do
        "$@" && break
    done
    return $?
}
function mkdirSymlink() {
    mkdir -p $1
    ln -s $1
}
function repoSymlink() {
    # it have to called in .repo directory.
    echo "make symbolic links $(pwd)/... -> $SHARED_REPO/..."
    mkdirSymlink $SHARED_REPO/projects
    mkdirSymlink $SHARED_REPO/project-objects
    # TODO : if these directory are not exists, prepare by repo init on $SHARED_REPO/..
    # mkdirSymlink $SHARED_REPO/manifests.git
    # mkdirSymlink $SHARED_REPO/repo
}
function preRepoInit() {
    if [ -e .repo ]; then
	echo 'Restruct .repo'
	rm -rf ./.repo
    fi
    mkdir -p .repo
    # execute sub-shell at .repo.
    (set -e; cd .repo && repoSymlink)
}

MANIFEST_GIT_URL=ssh://ps152-android@rhea.psn.jp.panasonic.com/platform/manifest.git
REPO_GIT_URL=ssh://ps152-android@rhea.psn.jp.panasonic.com/tools/panasonic/repo.git
initCobra(){
    preRepoInit

    set +e
    echo "repo init start" > time.txt
    date >> time.txt
    repo init -u $MANIFEST_GIT_URL -b $BRANCH -m ${BRANCH}.xml --repo-url $REPO_GIT_URL --no-repo-verify

    echo "repo sync start" >> time.txt
    date >> time.txt
    retryable repo sync -j8
    set -e

    echo "repo forall start" >> time.txt
    date >> time.txt
    repo forall -c git checkout -B $BRANCH rhea/$BRANCH
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
    repo forall -c git merge rhea/ps152-platform-dev

    # ignore setenv.sh
    cd device/panasonic/$MODEL_NAME
    git checkout --ours COBRA_BUILD.sh
    git add COBRA_BUILD.sh
    cd ../../../

    # ignore unified
    cd hardware/panasonic/proprietary
    git checkout --ours firmware/firmware2.img.ext4
    git checkout --ours firmware/firmware2/unified
    git add firmware
    git commit -m "Merge remote-tracking branch 'rhea/ps152-platform-dev' into ps152-cobra-dev"
    cd ../../../

    set -e
    echo "merge platform end" >> time.txt
    date >> time.txt
}

mergeCobra(){
    if [ "$BRANCH" != "ps152-cobra-advance-dev" ]; then
	return
    fi
	if [ "$MERGE_TAG" = "" ]; then
	return
	fi

    echo "merge cobra start" >> time.txt
    set +e
    date >> time.txt
    repo forall -c git merge $MERGE_TAG

    # ignore setenv.sh
    cd device/panasonic/$MODEL_NAME
    git checkout --ours COBRA_BUILD.sh
    git add COBRA_BUILD.sh
    cd ../../../

    # ignore unified
    cd hardware/panasonic/proprietary
    git checkout --ours firmware/firmware2.img.ext4
    git checkout --ours firmware/firmware2/unified
    git add firmware
    git commit -m "Merge tag $MERGE_TAG into ps152-cobra-advance-dev"
    cd ../../../

    set -e
    echo "merge cobra end" >> time.txt
    date >> time.txt
}

mergeCobraRelease(){
    if [ "$BRANCH" != "ps152-pingu-release" ]; then
	return
    fi
    echo "merge cobra start" >> time.txt
    set +e
    date >> time.txt
    repo forall -c git merge rhea/ps152-cobra-release

    # ignore setenv.sh
    cd device/panasonic/$MODEL_NAME
    git checkout --ours COBRA_BUILD.sh
    git add COBRA_BUILD.sh
    cd ../../../

    # ignore unified
    cd hardware/panasonic/proprietary
    git checkout --ours firmware/firmware2.img.ext4
    git checkout --ours firmware/firmware2/unified
    git add firmware
    git commit -m "Merge remote-tracking branch 'rhea/ps152-cobra-release' into ps152-pingu-release"
    cd ../../../

    set -e
    echo "merge cobra end" >> time.txt
    date >> time.txt
}
### update unified ##################################################

### BUILD DEFINE ####################################################
TAG=ps152-12-$CUSTOM-$SI-$REGION

### BUILD DEFINE ####################################################

DATE='date +%Y/%m/%d-%H:%M:%S'
$DATE
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
    cd ../../../
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
    git add COBRA_BUILD.sh
    git commit -m "P152HWR:SI::Change PSN_SI_VERSION $SI"
    cd ../../../
}
updateBuildIDNonSecure(){
    cd device/panasonic/$MODEL_NAME/
    cat COBRA_BUILD.sh | sed \
	-e 's/BUILD_SECURE=.*/BUILD_SECURE="-no"/' > tmp.sh
    mv tmp.sh COBRA_BUILD.sh
    chmod ugo+x COBRA_BUILD.sh
    cd ../../../
    rm out/target/product/$MODEL_NAME/system/build.prop
    rm out/target/product/$MODEL_NAME/system/build.prop.bakforspec
}
### update Build_ID #################################################

### replace Certification files #####################################
replaceCertFiles(){
    if [ "$RELEASE" != "release" ]; then
	return
    fi
    cp $CERT_SRC_DIR/platform/platform.pk8			$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/platform.x509.pem		$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/releasekey.pk8		$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/releasekey.x509.pem	$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/media.pk8				$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/media.x509.pem		$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/shared.pk8			$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/shared.x509.pem		$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/platform/apk_sign.xml			$CERT_DST_DIR/.
    cp $CERT_SRC_DIR/fw/private-key.pem				$CERT_DST_DIR/security/.
    cp $CERT_SRC_DIR/fw/public-key.der.crt			$CERT_DST_DIR/.
    if [ "$BRANCH" == "ps152-pingu-release" ]; then
	cp $CERT_SRC_DIR/platform/apk_sign_pingu.xml	$CERT_DST_DIR/apk_sign.xml
    fi
    if [ "$BRANCH" == "ps152-arch-cl-release" ]; then
	cp $CERT_SRC_DIR/platform/apk_sign_pingu.xml	$CERT_DST_DIR/apk_sign.xml
    fi
}
### replace Certification files #####################################

### Push & TAG ######################################################
gitPushTagging(){
    repo forall -c git push rhea $BRANCH
    repo forall -c git tag $TAG
    repo forall -c git push rhea $TAG
}
### Push & TAG ######################################################

### update Manifest #################################################
updateManifest(){
    cd .repo/manifests
    git checkout -B $BRANCH origin/$BRANCH
    cat $BRANCH.xml | sed "s/heads\/$BRANCH/tags\/$TAG/" > $TAG.xml
    git add $TAG.xml
    git commit -m "P152HWR:SI::Add new manifest for $TAG"
    git push origin $BRANCH
    cd ../
    unlink manifest.xml
    ln -s manifests/$TAG.xml manifest.xml
    cd ../
}
### update Manifest #################################################


### build ###########################################################
build(){
    cp -af device/panasonic/$MODEL_NAME/COBRA_BUILD.sh .
    ./COBRA_BUILD.sh
}
### build ###########################################################

### makeDP ###########################################################
makeDP(){
    cd build/tools/create_dp/
    cp /qnap/PS152-1/keystore/license/license.lic .
    cp -r ../../../out/PS152-12-${CUSTOM}-${SI}-${REGION}_EWriter ./PS152-12-${CUSTOM}-${SI}-${REGION}
    echo "gitosis" | sudo -S ./create_test_dp_full.sh PS152-12-${CUSTOM}-${SI}-${REGION}
    cd ../../../
}
### makeDP ###########################################################

### makeROM ##########################################################
makeROM(){
    EMMC16GB=false
    DSTDIR=develop
    if [ "$BRANCH" == "ps152-cobra-dev" ]; then
	EMMC16GB=true
    fi
    if [ "$BRANCH" == "ps152-cobra-release" ]; then
	EMMC16GB=true
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-cobra-contact-release" ]; then
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-pingu-release" ]; then
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-arch-cl-release" ]; then
	DSTDIR=release
    fi

    ./COBRA_BUILD.sh -r PS152-12-${CUSTOM}-${SI}-${REGION}
    zip -rm /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/ROM_BINARY_PS152-12-${CUSTOM}-${SI}-${REGION}_0xE90000.zip \
	out/ROM_BINARY_PS152-12-${CUSTOM}-${SI}-${REGION}_0xE90000

    if [ "$EMMC16GB" == "true" ]; then
	./COBRA_BUILD.sh -r PS152-12-${CUSTOM}-${SI}-${REGION} -n 0x1D5A000
	zip -rm /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/ROM_BINARY_PS152-12-${CUSTOM}-${SI}-${REGION}_0x1D5A000.zip \
	    out/ROM_BINARY_PS152-12-${CUSTOM}-${SI}-${REGION}_0x1D5A000
    fi

    zip -rm /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/PS152-12-${CUSTOM}-${SI}-${REGION}_checksum_result.zip \
	out/PS152-12-${CUSTOM}-${SI}-${REGION}/checksum_result
}
### makeROM ##########################################################

### createZip ###########################################################
createZip(){
    DSTDIR=develop
    if [ "$BRANCH" == "ps152-cobra-release" ]; then
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-cobra-contact-release" ]; then
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-pingu-release" ]; then
	DSTDIR=release
    fi
    if [ "$BRANCH" == "ps152-arch-cl-release" ]; then
	DSTDIR=release
    fi
    # Copy to confirm later
    cp $CERT_DST_DIR/apk_sign.xml out/PS152-12-${CUSTOM}-${SI}-${REGION}/.
    cp $CERT_DST_DIR/apk_sign.xml out/PS152-12-${CUSTOM}-${SI}-${REGION}_EWriter/.

    cd ./out/
    for f in PS152-12* ; do
	zip -rm /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/$f.zip $f
    done
    cd ../

    zip /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/PS152-12-${CUSTOM}-${SI}-${REGION}-full.zip \
	build/tools/create_dp/PS152-12-${CUSTOM}-${SI}-${REGION}-full.dat
}
### createZip ###########################################################

initCobra
mergePlatform
mergeCobra
#mergeCobraRelease
updateUnified
updateBuildID
replaceCertFiles
build
gitPushTagging
updateManifest
#updateBuildIDNonSecure
#build
makeDP
makeROM
createZip

$DATE
echo "auto build end"
