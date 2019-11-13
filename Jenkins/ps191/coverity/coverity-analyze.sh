#!/bin/bash -x

## Coverity Usage
## this script is for running coverity-build

source /media/m2/galileo/env/env.rc

# check script usage and base env
echo "======== init"
ROOT="/media/m2/galileo/src/coverity/"
WORK=$ROOT$1
POKY_BUILD="$WORK/src/poky/build"
COV_INTER_DIR="$WORK/cov-inter-dir"
echo "[INFO]: init finished successfully"

# analyze
echo "======== coverity analyze"
set -e
cov-analyze --dir $COV_INTER_DIR --all --rule --strip-path $POKY_BUILD -j auto
set +e
echo "[INFO]: analyze finished successfully"
