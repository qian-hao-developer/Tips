# git settings
* proxy
```Shell
$ git config --global http.proxy "http://proxy.mei.co.jp:8080/"
$ git config --global https.proxy "https://proxy.mei.co.jp:8080/"
```

# git clone repositories
* 対象の Yocto ver. が sumo の場合
```Shell
$ mkdir -p ~/_git/yocto/sumo && cd $_/
$ git clone -b sumo https://git.yoctoproject.org/git/poky
$ git clone -b sumo https://git.yoctoproject.org/git/meta-raspberrypi
$ cd poky/
$ git checkout -b sumo-19.0.1 refs/tags/sumo-19.0.1
``` 
* poky の branch は更新が激しいので、
  release tag（キリの良い所）を利用するのが無難です。

# bitbake settings
```Shell
$ cd ~/_git/yocto/sumo/poky/
$ ln -s ../meta-raspberrypi
$ source oe-init-build-env build_pi3
$ vi conf/bblayers.conf
$ vi conf/local.conf
```
* modify point of conf/bblayers.conf
```diff
 BBLAYERS ?= " \
   ${HOME}/_git/yocto/sumo/poky/meta \
   ${HOME}/_git/yocto/sumo/poky/meta-yocto \
   ${HOME}/_git/yocto/sumo/poky/meta-yocto-bsp \
+  ${HOME}/_git/yocto/sumo/poky/meta-raspberrypi \
   "
```
* modify point of conf/bblayers.conf
```diff
-MACHINE ??= "qemux86"
+MACHINE ??= "raspberrypi3-64"
```
```diff
-#DL_DIR ?= "${TOPDIR}/downloads"
+DL_DIR ?= "${TOPDIR}/../downloads"
+ENABLE_UART = "1"
```
* ENABLE_UART について
    * ssh で通信するのも良いですが、Raspberry Pi では
      こういうの[https://www.switch-science.com/catalog/1196/]で UART 通信で制御するのが手軽です。

    * ENABLE_UART を 1 にしておくと、/boot/cmdline.txt に
      “console=serial0,115200″ を付けてくれます。

    * UART を利用する場合は /boot/config.txt に
      dtoverlay=pi3-miniuart-bt も付けるようにします。
      file: meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb

        ```diff
        @@ -194,6 +194,9 @@ do_deploy_append_raspberrypi3-64() {
         
           echo "# Enable audio (loads snd_bcm2835)" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
           echo "dtparam=audio=on" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
        +
        +    echo "" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
        +    echo "dtoverlay=pi3-miniuart-bt" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
        }
         
        addtask deploy before do_build after do_install
        ```

# bitbake test
* まず bitbake がきちんと通ることを確認します。
```Shell
$ bitbake -g core-image-minimal-dev && cat pn-buildlist | sort > pn-buildlist_core-image-minimal-dev.sort
```

* bitbake が成功すると、image target の core-image-minimal-dev
  に含まれる packages name list file が出力されます。

# fetch packages
* Yocto の build 時間の大半は fetch であるのはあまりにも有名なため、
  まずなるべく fetch を終わらせます。
```Shell
$ bitbake -c fetch core-image-minimal-dev
$ bitbake -c compile core-image-minimal-dev; ringbell.sh
```

* ringbell.sh については こちら[ringbell.md] をご参照ください。

* なお、社内ネットワークは git プロトコル経由での git リポジトリの pull を許可していないため、
  SRC_URI が git になっている pkg は “protocol=http” を指定してやる必要があります。
    * ex.1) meta/recipes-core/glibc/glibc_2.27.bb
        ```diff
        -SRC_URI = "${GLIBC_GIT_URI};branch=${SRCBRANCH};name=glibc \
        +SRC_URI = "${GLIBC_GIT_URI};branch=${SRCBRANCH};protocol=http;name=glibc \
        ```

    * ex.2) meta/recipes-devtools/binutils/binutils-2.30.inc
        ```diff
        -BINUTILS_GIT_URI ?= "git://sourceware.org/git/binutils-gdb.git;branch=binutils-${BINUPV}-branch;protocol=git"
        +BINUTILS_GIT_URI ?= "git://sourceware.org/git/binutils-gdb.git;branch=binutils-${BINUPV}-branch;protocol=http"
        ```

* ほかにも、bitbake のログで「fetch がいつまで経っても始まらないなー」というやつは、
  当該 pkg の SRC_URI を確認してみてください。

# bitbake
```Shell
$ bitbake -k core-image-minimal-dev; ringbell.sh
```

* ここでも fetch が始まらないやつを check します。
    * 1 日かけても終わらない pkg もあるので、そういうのは諦めて
      連続通電 PC で一晩かけて落とします。
        ```
        $ nohup bitbake -c fetch linux-raspberrypi &
        ```

# burn image to SD
* change following “/dev/sdX” to appropriate path of SD card device.
```Shell
$ export SDIMG="tmp/deploy/images/raspberrypi3-64/core-image-minimal-dev-raspberrypi3-64.rpi-sdimg"
$ sudo dd if=${SDIMG} of=/dev/sdX bs=512M; sync; ringbell.sh
```

* then, enjoy ! 