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

mergePlatform(){
if [ "$BRANCH" != "ps152-cobra-dev" ]; then
    return
fi
echo $BRANCH
}

mergePlatform

TAG=ps152-12-$CUSTOM-$SI-$REGION
echo date
echo "build TAG=$TAG"

