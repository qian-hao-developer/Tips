#!/bin/sh
#  Calcurate checksums of tough device
#  2015/12/18 Toshimi Hamada modified for PS152
#  2015/4/16 Hidenori Ishii(PSN TSBU) 
#    - based on DOS batch files written by Kimura-san ( and other members? )

mydate=`date +%m%d-%H%M%S`
LOGDIR=LOG/result_${mydate}
RESULTDIR=RESULT
mkdir -p ${LOGDIR} ${RESULTDIR}
DEVLISTFILE=${LOGDIR}/devices.log

TOOLSRC=./tool
TOOLDST=/data

# $1: device id
push_checksum_tool()
{
    echo Preparing tools in device $1...
    for toolbin in `ls -1d tool/*| grep -v '^  *$'`
    do
	echo pushing ${toolbin}
	adb -s $1 push ${toolbin} ${TOOLDST}
	adb -s $1 shell chmod 777 ${TOOLDST}/`basename ${toolbin}`
    done
}

# $1: device id
remove_checksum_tool()
{
    echo Deleting checksum tools from device $1...
    for toolbin in `ls -1d tool/*|grep -v '^  *$'`
    do
	DELFILE=${TOOLDST}/`basename ${toolbin}`
	echo deleting ${DELFILE}
	echo adb -s $1 shell rm ${DELFILE}
    done
}

# $1: device_id
# original script: sh_checksum_partition.txt
adb_checksum_partition()
{
    ADBRESULTFILE=${RESULTDIR}/${device_id}_${mydate}_checksum_partition.txt
    adb -s ${device_id} shell <<EOF > ${ADBRESULTFILE}
/data/checksum2b /dev/block/bootdevice/by-name/preset &&
/data/checksum2b /dev/block/bootdevice/by-name/firmware2 &&
/data/checksum2b /dev/block/bootdevice/by-name/partner &&
/data/checksum2b /dev/block/bootdevice/by-name/recovery &&
/data/checksum2b /dev/block/bootdevice/by-name/cfgtbl &&
/data/checksum2b /dev/block/bootdevice/by-name/factory &&
/data/checksum2b /dev/block/bootdevice/by-name/fsg &&
/data/checksum2b /dev/block/bootdevice/by-name/tz &&
/data/checksum2b /dev/block/bootdevice/by-name/boot &&
/data/checksum2b /dev/block/bootdevice/by-name/rpm &&
/data/checksum2b /dev/block/bootdevice/by-name/aboot &&
/data/checksum2b /dev/block/bootdevice/by-name/sbl1 &&
/data/checksum2b /dev/block/bootdevice/by-name/modem
exit
EOF
}

# $1: device_id
# original script: sh_gpt_checksum_32G.txt (for 32G eMMC)
#                  sh_gpt_checksum_16G.txt (for 16G eMMC)
adb_checksum_gpt()
{
    ADBRESULTFILE=${RESULTDIR}/${device_id}_${mydate}_checksum_gpt.txt
# 8G eMMC
    adb -s ${device_id} shell <<EOF > ${ADBRESULTFILE}
dd if=/dev/block/mmcblk0 of=/data/gpt_main.bin bs=512 count=34 &&
/data/checksum2b /data/gpt_main.bin &&
rm /data/gpt_main.bin &&
dd if=/dev/block/mmcblk0 of=/data/gpt_main.bin bs=512 count=33 skip=1 &&
/data/checksum2b /data/gpt_main.bin &&
rm /data/gpt_main.bin &&
/data/toolbox dd if=/dev/block/mmcblk0 of=/data/gpt_backup.bin bs=512 count=33 skip=15269855 &&
/data/checksum2b /data/gpt_backup.bin &&
rm /data/gpt_backup.bin
exit
EOF
}


# $1: device_id
# original script: sh_read_qfprom.txt
adb_read_qfprom()
{
    ADBRESULTFILE=${RESULTDIR}/${device_id}_${mydate}_qfprom.txt
    adb -s ${device_id} shell <<EOF > ${ADBRESULTFILE}
/data/busybox devmem 0x007000A8 64
/data/busybox devmem 0x007000B0 64
/data/busybox devmem 0x00700220 64
/data/busybox devmem 0x00700228 64
/data/busybox devmem 0x00700230 64
/data/busybox devmem 0x007002D8 64
/data/busybox devmem 0x007002E0 64
/data/busybox devmem 0x007002E8 64
/data/busybox devmem 0x007002F0 64
/data/busybox devmem 0x007002F8 64
/data/busybox devmem 0x00700300 64
/data/busybox devmem 0x00700308 64
/data/busybox devmem 0x00700310 64
/data/busybox devmem 0x00702050 64
exit
EOF
}

# $1: device_id
adb_read_non_volatile_data()
{
    ALLNVFILE=${RESULTDIR}/$1_${mydate}_Initial_non-volatile_data_all.txt
    HEADNVFILE="${RESULTDIR}/$1_${mydate}_Initial_non-volatile_data(ACPU-EEPROM-vx.x.x).txt"
    adb -s $1 shell nvm_test2 3 2
    adb -s $1 shell cfg_print acpu > ${ALLNVFILE}
    head -1454 ${ALLNVFILE} > "${HEADNVFILE}"
}

# $1: device id, $2: partition name(system, persist, data)
prepare_checksum_partition()
{
    adb -s $1 shell sh /data/make_checksum_result.sh $2
    adb -s $1 pull /data/$2.csv ${RESULTDIR}/$1_${mydate}_$2.csv
}

make_csum_summary()
{
# make_csum_summary.sh
#   making summary of check sum.
#   Written by Hidenori Ishii (PSN/TSBU)
#   2015/4/14
#

    # for TP version
    echo "<Touch Panel Versions>"
    adb shell fwupdater -vi | egrep '[BC]:'|sort -r|sed -e 's/^.*B:/Touch Panel FW version(Cell C10) /' -e 's/^.*C:/Touch Panel Config version(Cell C9) /'

    # REMARK: pick up latest check sum file
    CHECKSUM_PART_FILE=`ls -1t RESULT/*checksum*part*|head -1`
    CHECKSUM_GPT_FILE=`ls -1t RESULT/*checksum*gpt*|head -1`
    PARTITIONS="gpt_backup \
    preset \
    firmware2 \
    partner \
    recovery \
    cfgtbl \
    factory \
    fsg \
    tz \
    boot \
    rpm \
    aboot \
    sbl1 \
    modem "

    # Checksums
    echo
    echo "<For Factory Test (2byte checksum)>"

    for PARTITION in ${PARTITIONS}
    do
	grep "[^a-z0-9]${PARTITION}[^a-z0-9]" ${CHECKSUM_PART_FILE} ${CHECKSUM_GPT_FILE} | grep checksum\ =|sed 's/.*\/\([a-z0-9_.A-Z]*\) .*checksum\ =\ /\1\t /'
    done
    
    # for gpt_main
    CHECKSUM_MBR=`grep "[^a-z0-9]gpt_main[^a-z0-9]" ${CHECKSUM_GPT_FILE}| grep checksum\ =|sed 's/.*\/\([a-z0-9_.A-Z]*\) .*checksum\ =\ //'|head -1`
    CHECKSUM_NOMBR=`grep "[^a-z0-9]gpt_main[^a-z0-9]" ${CHECKSUM_GPT_FILE}| grep checksum\ =|sed 's/.*\/\([a-z0-9_.A-Z]*\) .*checksum\ =\ //'|tail -1`
    echo "gpt_main	${CHECKSUM_MBR}(${CHECKSUM_NOMBR})"
    echo
    
    # print environments
    echo 
    echo "Checksum file=${CHECKSUM_PART_FILE}, ${CHECKSUM_GPT_FILE}"
    echo "PARTITIONS=${PARTITIONS}"
}

adb devices > ${DEVLISTFILE}

for device_id in `grep -v "List of devices" ${DEVLISTFILE} |grep -v "^ *$"|sed 's/[\t ].*$//'`
do
    # preparation
    echo Device ID: ${device_id}
    push_checksum_tool ${device_id}

    adb_checksum_partition ${device_id}   	# 01_checksum_partiton.bat
    adb_checksum_gpt ${device_id}		# 02_checksum_gpt.bat
    #adb_read_qfprom ${device_id}		# 04_read_qfprom.bat
    adb_read_non_volatile_data ${device_id}	# 05_read_non-volatile_data.bat

    # 03_checksum_system_files.bat, 
    # 06_checksum_persist_files.bat, 
    # 07_checksum_data_files.bat
    for partition in system persist data 
    do
	prepare_checksum_partition ${device_id} ${partition}
    done

    # finishing
    remove_checksum_tool ${device_id}

    # making report
    make_csum_summary
done

