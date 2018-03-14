#!/bin/bash -xe

### Initialize #################################################################

# sharing .repo directory
SHARED_REPO=/home2/ps152-share-repo/.repo

# uri settings
MANIFEST_GIT_URL=ssh://ps152-android@rhea.psn.jp.panasonic.com/platform/manifest.git
REPO_GIT_URL=ssh://ps152-android@rhea.psn.jp.panasonic.com/tools/panasonic/repo.git

# argument check
branch_arg=$1
case $branch_arg in
    cobra-cts)          BRANCH=ps152-cobra-cts;    CUSTOM=002;;
    cobra-beta)         BRANCH=ps152-cobra-dev-beta; CUSTOM=002;;
    platform)           BRANCH=ps152-platform-dev; CUSTOM=001;;
    cobra)              BRANCH=ps152-cobra-dev;    CUSTOM=C02;;
    cobra-advance-dev)  BRANCH=ps152-cobra-advance-dev; CUSTOM=C03;;
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

# Set arguments variable
DATE='date +%Y/%m/%d-%H:%M:%S'
### BUILD DEFINE #######################
TAG=ps152-12-$CUSTOM-$SI-$REGION
$DATE
echo "build TAG=$TAG"


### Functions ##################################################################
function retryable() {
    for i in {1..5}; do
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


initWorkingRepositories(){
    preRepoInit

    set +e
    echo "repo init start" > time.txt
    date >> time.txt
    repo init -u $MANIFEST_GIT_URL -b $BRANCH -m ${BRANCH}.xml --repo-url $REPO_GIT_URL --no-repo-verify

    echo "repo sync start" >> time.txt
    date >> time.txt
    retryable repo sync -j8

    echo "repo end" >> time.txt
    date >> time.txt
    set -e
}

################################################################################

OpenGrokDir=/var/opengrok/src/$TAG
echo "gitosis" | sudo -S mkdir -p $OpenGrokDir
echo "gitosis" | sudo -S chmod go+w $OpenGrokDir

cd $OpenGrokDir
echo "OpenGrok start"
initWorkingRepositories
rm -rf .repo
find . -name '.git' | xargs rm -rf
echo "gitosis" | sudo -S chown -R root:root $OpenGrokDir
echo "gitosis" | sudo -S chmod go-w $OpenGrokDir

cd /usr/opengrok/bin
#echo "gitosis" | sudo -S ./OpenGrok index
echo "gitosis" | sudo -S ./OpenGrok update

$DATE
echo "OpenGrok end"
