#!/bin/bash -xe

## How To Setup #####################################################################################################
# 1. Download from official website
#   http://www.coverity.com/services/customer-portal/
#   $ tar -xzf /qnap/PS152-1/coverity/cov-analysis-linux64-8.7.1.tar.gz 
#
# 2. Update license
#   $ unzip /qnap/PS152-1/coverity/license.zip
#   $ cp license.dat ~/cov-analysis-linux64-8.7.1/bin/license.dat
#
# 3. Run configure script
#   $ ~/cov-analysis-linux64-8.7.1/bin/cov-configure --gcc
#   $ ~/cov-analysis-linux64-8.7.1/bin/cov-configure --java
#   $ ~/cov-analysis-linux64-8.7.1/bin/cov-configure --comptype gcc --compiler arm-linux-androideabi-gcc --template
#
#####################################################################################################################

# env
COV_PATH=/home/gitosis/cov-analysis-linux64-8.7.1/bin
SRC_ROOT=/home2/ps152-cobra-advance-dev/nightly
VERSION=C03.218.04
COV_RESULT=/home/gitosis/cov_result/PS152-12-C03-218-04

# run coverity tools
cd $SRC_ROOT
$COV_PATH/cov-build --dir $COV_RESULT --encoding UTF8 ./COBRA_BUILD.sh

$COV_PATH/cov-analyze --include-java --dir $COV_RESULT --all --disable SIZEOF_MISMATCH --disable-parse-warnings --strip-path $SRC_ROOT --disable-fb -j auto

$COV_PATH/cov-commit-defects --version $VERSION --description "csa8.0.0" --dir $COV_RESULT --host 10.68.33.131 --stream PS152 --user committer --password committer
