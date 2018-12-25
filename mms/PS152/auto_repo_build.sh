#!/bin/bash -e

####### function ######
function retry() {
	for var in {1..50}; do
		"$@" && break
	done
	return $?
}


###### start ######
echo "[start]"
if [ $# -ne 2 ]; then
	echo "./sh <folder_name> <request_type(0-local,1-rhea)>"
	exit 1
fi

echo "[init directory]"
if [ -d "$1" ]; then
	echo "directory $1 exists, recreate"
	rm -rf $1
else
	echo "directory $1 not exists, create"
fi
mkdir $1
cd $1

echo "[init repo]"
if [ $2 -eq 0 ]; then
	echo "[init from cobra_local]"
	repo init -u gitosis@cobra:ps152/platform/manifest -b ps152-cobra-advance-dev -m ps152-cobra-advance-dev.xml --repo-url gitosis@cobra:ps152/tools/repo --no-repo-verify
elif [ $2 -eq 1 ]; then
	echo "[init from rhea]"
	repo init -u ssh://ps152-android@rhea.psn.jp.panasonic.com/platform/manifest.git -b ps152-cobra-advance-dev -m ps152-cobra-advance-dev.xml --repo-url ssh://ps152-android@rhea.psn.jp.panasonic.com/tools/panasonic/repo.git --no-repo-verify
else
	echo "[init parameter error: input $2]"
	exit 1
fi

set +e

echo "[repo sync]"
retry repo sync -j8

set -e
$? && echo "[repo sync succeed]"

set +e
echo "[git checkout]"
if [ $2 -eq 0 ]; then
	repo forall -c git checkout -b ps152-cobra-advance-dev cobra/ps152-cobra-advance-dev
elif [ $2 -eq 1 ]; then
	repo forall -c git checkout -b ps152-cobra-advance-dev rhea/ps152-cobra-advance-dev
else
	echo "[request_type illegal: $2]"
	exit 1
fi
set -e

echo "[source & lunch]"
source build/envsetup.sh
lunch JT_C52-userdebug
source ~/.bashrc

set +e
echo "[check JAVA_HOME]"
env | grep -Fq "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64"
if [ $? -eq 1 ]; then
	echo "JAVA_HOME error"
	exit 1
fi
echo "[JAVA_HOME OK]"
set -e

echo "[check ubuntu version]"
if [[ $(lsb_release -rs) == "16.04" ]]; then
	echo "16.04"

	echo "[cp ld]"
	cp -a /usr/bin/x86_64-linux-gnu-ld.gold prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6/x86_64-linux/bin/ld
	echo "[cp succees]"

	echo "[HOST_x86_common.mk start]"
	set +e
	cat build/core/clang/HOST_x86_common.mk | grep "\-B\$(\$(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/x86_64-linux/bin" -n | sed 's/:.*//g' | grep -Fq "11"
	catResult=$?
	set -e
	if [ $catResult -eq 1 ]; then
		echo "[patch HOST_86_common.mk]"
		cd build/
		patch -p1 < ../../HOST_x86_common_diff.patch
		cd ..
		echo "[patch finished]"
	fi
	echo "[HOST_x86_common.mk finished]"

	echo "[make update-api]"
	make update-api
	echo "[make update-api finished]"
fi

echo "[start build]"
./COBRA_BUILD.sh && echo "[build finished]"
