#!/bin/bash -x

## Coverity Usage
## this script is for running coverity-build

source /media/m2/galileo/env/env.rc

# check script usage and base env
echo "======== init"
ROOT="/media/m2/galileo/src/coverity/"
WORK=$ROOT$1
COV_INTER_DIR="$WORK/cov-inter-dir"
COMMIT_LOG="$WORK/commit-log.txt"
echo "[INFO]: init finished sucessfully"

# commit
echo "======== coverity commit"
rm -rf $COMMIT_LOG
set -e
cov-commit-defects --dir $COV_INTER_DIR --host 10.68.23.32 --user qian.hao --password qian.hao --stream fujisawa.yoshiharu_1 --description "$BUILD_RECIPE" | tee $COMMIT_LOG
set +e
echo "[INFO]: commit finished successfully"
