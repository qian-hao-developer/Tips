#!/bin/sh

if [ ! -d ./e1000e-3.4.2.1 ]; then
    echo "src folder not exist"
    return 0
fi

cd e1000e-3.4.2.1/src/
make
make install
rmmod e1000e
modprobe e1000e
/etc/init.d/networking restart
update-initramfs -u

echo [finished]
