#!/bin/bash -xe

SCRIPT_DIR=/home/jenkins/ps152/doxygen
OUTPUT_DIR=/qnap/PS152-1/develop/doxygen
WORK_DIR=/home2/doxygen

branch_arg=$1
case $branch_arg in
    cobra)              BRANCH=ps152-cobra-dev;;
    cobra-rel)          BRANCH=ps152-cobra-release;;
    pingu-rel)          BRANCH=ps152-pingu-release;;
    cobra-advance-dev)  BRANCH=ps152-cobra-advance-dev;;
    arch-cl-rel)        BRANCH=ps152-arch-cl-release;;
    *)                  usage ; exit 1;;
esac

# prepare #######################################
cd $WORK_DIR

# for lk ########################################
git clone ssh://ps152-android@rhea.psn.jp.panasonic.com/kernel/lk lk -b ps152-cobra-advance-dev

## cleanup unnecessary files
find lk/platform -mindepth 1 -maxdepth 1 -type d -name "*" | grep -v "msm_shared" | grep -v "msm8909" | xargs rm -rf 
find lk/target -mindepth 1 -maxdepth 1 -type d -name "*" | grep -v "msm8909" | xargs rm -rf
rm -rf lk/lib/openssl

## run doxygen 
doxygen $SCRIPT_DIR/Doxyfile_lk
zip -rm $OUTPUT_DIR/ps152_lk_doc.zip ps152_lk_doc
rm -rf lk

# for kernel/driver/video/mdss ##################
git clone ssh://ps152-android@rhea.psn.jp.panasonic.com/kernel/msm-3.10 kernel -b ps152-cobra-advance-dev

## run doxygen 
doxygen $SCRIPT_DIR/Doxyfile_mdss
zip -rm $OUTPUT_DIR/ps152_mdss_doc.zip ps152_mdss_doc
rm -rf kernel

