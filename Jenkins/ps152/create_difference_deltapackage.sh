#!/bin/sh
list_name=$1

EWriterDir=/qnap/PS152-1
DPDir=$EWriterDir/release/DP/.
DEVELOP=develop/nightly
RELEASE=release/nightly

COBRA_DEV=$DEVELOP/ps152-cobra-dev
COBRA_ADVANCE_DEV=$DEVELOP/ps152-cobra-advance-dev
PINGU_DEV=$DEVELOP/ps152-pingu-dev

COBRA_RELEASE=$RELEASE/ps152-cobra-release
COBRA_CONTACT_RELEASE=$RELEASE/ps152-cobra-contact-release
PINGU_RELEASE=$RELEASE/ps152-pingu-release
ARCH_CL_RELEASE=$RELEASE/ps152-arch-cl-release

RET_CODE=0

cd /home/gitosis/make_dp/build/tools/create_dp

function unzip_image() {
    EWpath=$EWriterDir

    CUSTOM_VERSION=$1
    SI_VERSION=$2
    REGION_VERSION=$3

    case $CUSTOM_VERSION in
        "C02" ) EWpath=$EWpath/$COBRA_DEV
            ;;
        "C03" ) EWpath=$EWpath/$COBRA_ADVANCE_DEV
            ;;
        "A21" | "D21" ) EWpath=$EWpath/$PINGU_DEV
            ;;
        "C12" ) if [ $SI_VERSION -lt "32" ]; then
                    EWpath=$EWpath/$COBRA_RELEASE
                else
                    EWpath=$EWpath/$COBRA_CONTACT_RELEASE
                fi
            ;;
        "C13" | "C14" ) EWpath=$EWpath/$COBRA_RELEASE
            ;;
        "D31" | "D33" ) EWpath=$EWpath/$PINGU_RELEASE
            ;;
        "D32" ) EWpath=$EWpath/$ARCH_CL_RELEASE
            ;;
        "C04" ) EWpath=$EWpath/$COBRA_RELEASE
            ;;
    esac
    EWpath=$EWpath/PS152-12-${CUSTOM_VERSION}-${SI_VERSION}-${REGION_VERSION}_EWriter.zip
    if [ -f $EWpath ]; then
        echo "unzip" $EWpath
        unzip -q $EWpath -d .
    else
        echo $EWpath "not exists"
        RET_CODE=1
        return
    fi
}

function delete_image() {
    rm -rf PS152-12-*_EWriter
}

function move_dp() {
    echo "gitosis" | sudo -S chmod 777 -R *-to-*
    mv *-to-* $DPDir
}

function exec_oneline() {
    version1=$1
    version2=$2
    
    EWname1=`echo $version1 | sed -e "s/\(.*\)\.\(.*\)\.\(.*\)/PS152-12-\1-\2-\3_EWriter/"`
    EWname2=`echo $version2 | sed -e "s/\(.*\)\.\(.*\)\.\(.*\)/PS152-12-\1-\2-\3_EWriter/"`
    
    if [ -d ${DPDir}/${version1}-to-${version2} ]; then
        echo "${DPDir}/${version1}-to-${version2} exists!!!"
        RET_CODE=1
        return
    fi
    
    echo "create ${version1}-to-${version2}"

    if [ ! -d $EWname1 ]; then
        unzip_image `echo $version1 | sed -e "s/\./ /g"`
    fi
    if [ ! -d $EWname2 ]; then
        unzip_image `echo $version2 | sed -e "s/\./ /g"`
    fi
    if [ ! -d $EWname1 -o ! -d $EWname2 ]; then
        echo "EWriter image not exists"
        RET_CODE=1
        return
    fi
    echo "gitosis" | sudo -S ./create_test_dp.sh $EWname1 $EWname2
}

if [ $# -ne 1 ]; then
    echo "argument error: ./create_difference_deltapackage.sh dp_list"
    exit 1
fi
if [ ! -f $list_name ]; then
    echo $list_name "not exists"
    exit 1
fi

while read ff
do
    if [[ $ff != "" ]]; then
        exec_oneline $ff
    fi
done < $list_name

move_dp
delete_image

exit $RET_CODE
