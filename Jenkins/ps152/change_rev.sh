#!/bin/sh

REGION=$1
if [ "$REGION" = "" ]; then
	echo "Please enter the REGION" 1>&2
	exit 1
fi

pushd device/panasonic/JT-C52/
cat COBRA_BUILD.sh | sed \
	-e "s/PSN_REGION_VERSION=.*/PSN_REGION_VERSION=$REGION/" > tmp.sh
mv tmp.sh COBRA_BUILD.sh
chmod ugo+x COBRA_BUILD.sh
popd

pushd hardware/panasonic/proprietary/firmware/firmware2/
cat unified | sed \
	-e "s/\\.00\$/\\.$REGION/" > tmp
mv tmp unified
popd

hardware/panasonic/proprietary/firmware/generate_image.sh 
