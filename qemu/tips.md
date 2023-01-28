# in yocto
See more details in yocto-mega-manual [8.10. runqemu Command-Line Options]
## start qemu
runqemu
## not use gui window
runqemu nographic
## quit
Ctrl-A X

# more about runqemu
## use runqemu in docker container
runqemu can be executed in docker container, but container need to be run with option:
    --cap-add=NET_ADMIN --device=/dev/net/tun
and container needs sudo permission, so crop can not use runqemu as it's default user pokyuser has no password.
## use normal qemu command
run normal qemu command in docker is not tested yet,
but it can be used in host OS (not docker) with image even it's built by yocto.
## runqemu options
runqemu [machine name] [image name] [additional qemu options]
i.e. for qemuarm and core-image-base
    runqemu qemuarm
    runqemu core-image-base
if more than one machine or image exists, it's better to specify the target name of machine and image
    runqemu qemuarm core-image-base
machine can be qemuarm, qemux86, qemux86-64 ...
it's the arch of board system to mock (not the build pc's system)
## qemu command info from runqemu execution result
normal qemu needs option to set environments like machine, memory, kernel image path ...
runqemu will show the full command in boot log, like:
===============================================================
runqemu - INFO - Running /media/ssd/raspberry/yocto/server-1/build/tmp/work/x86_64-linux/qemu-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/qemu-system-arm -device virtio-net-device,netdev=net0,mac=52:54:00:12:34:02 -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -drive id=disk0,file=/media/ssd/raspberry/yocto/server-1/build/tmp/deploy/images/qemuarm/core-image-base-qemuarm-20230128080635.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor -device VGA,edid=on -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -machine virt -cpu cortex-a15 -m 256 -serial mon:stdio -serial null -kernel /media/ssd/raspberry/yocto/server-1/build/tmp/deploy/images/qemuarm/zImage--5.2.32+git0+bb2776d6be_fdb7cd1bb5-r0-qemuarm-20230128080635.bin -append 'root=/dev/vda rw  console=ttyS0 mem=256M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 '
===============================================================
## sample of normal qemu usage
example when use normal qemu command (i.e. build for qemuarm machine):
===============================================================
qemu-system-arm -M virt -m 1024 -kernel qemuarm/zImage -drive if=none,file=qemuarm/core-image-base-qemuarm.ext4,format=raw,id=hd1 -device virtio-blk-device,drive=hd1 -netdev user,id=usernet -device virtio-net-device,netdev=usernet -append "root=/dev/vda rw console=ttyAMA0" -nographic -no-reboot
===============================================================
- if use console=ttyS0, boot log will output to S0 and will need another serial capture to catch it
- console=ttyAMA0 will output log in current terminal
- try to use hd0 first, and use hd1 ... if hd0 is already in use
- set kernel image to option -kernel
- set rootfs image to option file=
- the sample is built with machine qemuarm, if machine is qemux86-64, use qemu-system-aarch64

# installation in ubuntu:
apt install qemu qemu-system qemu-system-common qemu-utils
