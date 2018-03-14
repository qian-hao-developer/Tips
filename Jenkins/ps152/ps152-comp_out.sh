#!/bin/bash -xe

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

cd nightly/
echo "to compress the out directory"

### BUILD DEFINE ####################################################
TAG=ps152-12-$CUSTOM-$SI-$REGION
### BUILD DEFINE ####################################################

echo date

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

	zip -r /qnap/PS152-1/$DSTDIR/nightly/$BRANCH/out_PS152-12-${CUSTOM}-${SI}-${REGION}.zip out/

}
### createZip ###########################################################

createZip

echo date
echo "compress end"
