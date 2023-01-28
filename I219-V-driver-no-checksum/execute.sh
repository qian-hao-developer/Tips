#!/bin/sh

abs_path="$(dirname $(readlink -f "$0"))/"
echo "abs_path = $abs_path"

if [ ! -d $abs_path/e1000e-3.4.2.1 ]; then
    echo "src folder not exist"
    return 0
fi

cd $abs_path/e1000e-3.4.2.1/src/
make
make install
rmmod e1000e
modprobe e1000e
/etc/init.d/networking restart
update-initramfs -u

echo [finished]
