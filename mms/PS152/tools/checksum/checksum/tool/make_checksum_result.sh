#!/bin/bash
# 
# Calculate checksum of all files in system area and output result to csv file
#   arg1:directory of checking
#
CHECK_DIR=${1}
INSTALL_DIR="/data"
BB_PATH="/data/busybox"

IFS=$'\n';

TMP_OUT_CSV="/data/temp.csv"
OUT_CSV="/data/${CHECK_DIR}.csv"

if [ ! -d ${CHECK_DIR} ]; then
	echo "Directory ${CHECK_DIR} does not exit."
	return 1
fi

if [ -e ${OUT_CSV} ]; then
	echo "remove and make new ${OUT_CSV}"
	rm -f ${OUT_CSV}
fi

if [ -e ${TMP_OUT_CSV} ]; then
	rm -f ${TMP_OUT_CSV}
fi

# create empty CSV
touch ${TMP_OUT_CSV}

TMP_STR=`${BB_PATH} find ${CHECK_DIR} -type f -o -type l |${BB_PATH} sort -f 2>/dev/null`

dnum='0'
set -- $TMP_STR

for file in "$@"
do
	#echo ${file}
	if [ ! -L ${file} ]; then
		sz=`${BB_PATH} wc -c $file | ${BB_PATH} awk '{print $1}'`
	else
		sz=0
	fi
	if [ $sz -gt 0 ]; then
		sum_ret=`${INSTALL_DIR}/checksum2b $file`
		sum=`echo $sum_ret | ${BB_PATH} sed -e "s/.*checksum = 0x//"`
		case ${#sum} in
			4) ;;
			3) sum="0$sum";;
			2) sum="00$sum";;
			1) sum="000$sum";;
			*) sum="0000"
		esac
	else
		sum="0000"
	fi
	fpath=`echo $file | ${BB_PATH} sed -e "s/${CHECK_DIR}/\/${CHECK_DIR}/"`
	dnum=`${BB_PATH} expr $dnum + 1`

	echo "$dnum,$fpath,$sz,$sum" >> ${TMP_OUT_CSV}
done

#nkf -Lw ${TMP_OUT_CSV} > ${OUT_CSV}
#rm -f ${TMP_OUT_CSV}
mv ${TMP_OUT_CSV} ${OUT_CSV}
