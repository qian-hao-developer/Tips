#!/bin/bash

# -C : avoid file overwite. if you intend to overwite, use '>|'.
# -e : abort script when error occured.
# -u : report the error when used undefined variable.
# -o pipefail : report the error when error occurs in the middle of pipe subprocess.
set -Ceuo pipefail

# export LC_ALL=C     # change locale for script performance.
# export LANG=C       # change locale for script performance.

usage_exit() {
    cmd=${0##*/}
    cat <<EOF
USAGE : $cmd STAGE NEW_TAG
    STAGE      :
	1 : clean & build
	2 : tagging & create manifest
	3 : push
	You can select multiple. eg. when specifying 1 and 2, put 12.
    NEW_TAG    : name of new tag

    To run in the directory where .repo is present
EOF
    exit 1
}

clean() {
    [[ -d .repo ]] || usage_exit
    rm -rf poky
}

no_merge_commits() {
    local oldtag=$(cd .repo/manifests ; git fetch --all; git describe --tags --abbrev=0)
    [[ ! $(repo forall -pc git log --merges ${oldtag}..HEAD) ]]
}

build() {
    repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev
    repo sync
    repo forall -pc git checkout galileo/galileo-pf-dev -B galileo-pf-dev
    no_merge_commits
    cd poky
    bash -c '\
	source oe-init-build-env &&\
	bitbake brcm-pos-image &&\
	(tm=/tftpboot/$(date +'%m%d'); cd $BUILDDIR && mkdir -p $tm; bash ../meta-brcm/scripts/brcm-copy-images.sh -d $tm && rm -vf /tftpboot/bin.* && yes | cp -vf $tm/* /tftpboot/)'
}

stage1() {
    clean
    build
}

tagging() {
    # tagging
    repo forall -pc "git tag ${1}"

    # report
    echo "repo forall -pc ""git log -1 --pretty='%H %s' tags/${1}" >| $report
    repo forall -pc "git log -1 --pretty='%H %s' tags/${1}" | tee -a $report
}

manifest() {
    cd .repo/manifests
    sed -e "s@heads/galileo-pf-dev@tags/$1@g" default.xml > $1.xml
    git add $1.xml
    git checkout -B galileo-pf-dev
    git commit -m "galileo-brb:Environment::$1"
    git tag $1
}

cleantag() {
    repo forall -pc 'git tag -d $(git tag) && git fetch galileo --tags' | cat
}



stage2() {
    cleantag
    # local oldtag=$(cd .repo/manifests ; git fetch --all; git describe --tags --abbrev=0)
    local newtag=$1

    tagging $newtag
    (manifest $newtag)
}

push_tag() {
    # push tag
    local bef=$(repo forall -pc "git log -1 tags/$1")
    repo forall -pc "git push galileo $1"

    # tag verify
    cleantag
    local aft=$(repo forall -pc "git log -1 tags/$1")

    diff -u <(echo $bef) <(echo $aft)
}

push_manifest() {
    cd .repo/manifests
    git push origin galileo-pf-dev
    git push origin $1

    echo
    echo
    echo repository: $(git remote -v | head -1 | perl -pe 's/.*://g' | perl -pe 's/ .*//g')
    echo branch: $(git branch | grep '*' | perl -pe 's/^[^ ]* //g')
    echo "<pre>"
    git log -1 | cat
    echo "</pre>"
}


stage3() {
    push_tag $1
    (push_manifest $1)
}

main() {
    local report=$(date +'%m%d')_report.txt
    rm -f $report; touch $report
    report=$(realpath $report)


    if [[ $1 =~ .*1.* ]]; then
	# clean build
	stage1
    fi
    if [[ $1 =~ .*2.* ]]; then
	tagging
	stage2 $2
    fi
    if [[ $1 =~ .*3.* ]]; then
	push
	stage3 $2
    fi
}

[[ $# -ge 2 ]] || usage_exit 1
stage=$1
newtag=$2

main $stage $newtag

