#!/bin/sh

java -Djava.util.logging.config.file=/mnt/hdd2/opengrok/logging.properties \
-jar /mnt/hdd2/opengrok/opengrok-1.1.2/lib/opengrok.jar \
-c /mnt/hdd2/opengrok/tools/universal-ctags/bin/ctags \
-s /mnt/hdd2/opengrok/src \
-d /mnt/hdd2/opengrok/data \
-H -P -S -G \
-W /mnt/hdd2/opengrok/etc/configuration.xml \
-U http://localhost:8081/opengrok
