#!/bin/bash -x

## Coverity Usage
## this script is for running coverity-build

source /media/m2/galileo/env/env.rc

# check script usage and base env
echo "======== init"
ROOT="/media/m2/galileo/src/coverity/"
WORK=$ROOT$1
POKY="$WORK/src/poky"
COV_INTER_DIR="$WORK/cov-inter-dir"

echo "BUILD_RECIPE = $BUILD_RECIPE"
echo "MANUFACTURE = $MANUFACTURE"
echo "HARDWARE = $HARDWARE"
echo "NAND = $NAND"

# check inputs from jenkins server
BUILD=""
if [ "$MANUFACTURE" == "galileo" ] && [ "$HARDWARE" == "brb" ] && [ "$NAND" == "256" ]; then
	BUILD="build.pf256m"
fi
if [ "$MANUFACTURE" == "ps191" ] && [ "$HARDWARE" == "brb" ] && [ "$NAND" == "256" ]; then
	BUILD="build.brb256m"
fi
if [ "$MANUFACTURE" == "ps191" ] && [ "$HARDWARE" == "evt" ] && [ "$NAND" == "256" ]; then
	BUILD="build.evt256m"
fi
if [ "$MANUFACTURE" == "ps191" ] && [ "$HARDWARE" == "evt" ] && [ "$NAND" == "512" ]; then
	BUILD="build.evt512m"
fi

if [ -z $BUILD ]; then
	echo "[ERROR]: $MANUFACTURE-$HARDWARE-$NAND not supported"
	exit 1
fi

cd $POKY
if [ ! -d $BUILD ]; then
	echo "[ERROR]: build folder $BUILD not exist"
	exit 1
fi

# remove coverity build cache of last time
rm -rf $COV_INTER_DIR

echo "[INFO]: init finished successfully"

# build
echo "======== build with coverity"
cd $POKY
set -e
if [ "$BUILD_RECIPE" = "all" ]; then
    SSTATE="$WORK/yocto-cache/sstate-cache"
    if [ -d $SSTATE ]; then
        rm -rf $SSTATE
    fi
    bash -c "\
        source oe-init-build-env $BUILD && \
        bitbake softfp-brcm-boot1 -c cleanall && bitbake brcm-u-boot -c cleanall && bitbake brcm-linux -c cleanall && bitbake galileo-pos-image -c cleanall && rm -rf tmp cache && \
        cov-build --dir $COV_INTER_DIR --encoding UTF-8 --emit-complementary-info --add-arg --no_emit_referenced_types --add-arg --no_use_stage_emit --add-arg -D_Fract=int bitbake galileo-pos-image"
else
    bash -c "\
        source oe-init-build-env $BUILD && \
        bitbake $BUILD_RECIPE -c cleanall && \
        cov-build --dir $COV_INTER_DIR --encoding UTF-8 --emit-complementary-info --add-arg --no_emit_referenced_types --add-arg --no_use_stage_emit --add-arg -D_Fract=int bitbake $BUILD_RECIPE"
fi
set +e
echo "[INFO]: build finished successfully"
