#!/bin/bash -eu

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

. const.sh

# スタック回避のため
set +e

## fsck、失敗したら削除
if [ -e ${VSD_IMG_PATH} ]
then
  fsck.vfat -a "${VSD_IMG_PATH}"
  if [ $? -ne 0 ] || [ $? -ne 1 ]
  then
    echo "fsck failed. force rm disk."
    rm -f "${VSD_IMG_PATH}"
  fi
fi

# try mount vsd
${VSD_RO}

DO_VSD_REBUILD=0

# check mount success
if [ 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
then
    DO_VSD_REBUILD=1
fi

# force rebuild switch 1
if [ -e "/boot/vsd_rebuild" ]
then
    rm  "/boot/vsd_rebuild"
    DO_VSD_REBUILD=1
fi

# force rebuild switch 2
if [ -e "${VSD_BASE_DIR}/vsd_rebuild" ]
then
    # vsd_rebuildは後のrebuildで消えるはずなので削除しない
    DO_VSD_REBUILD=1
fi

# Rebuild execute when need.
if [ ${DO_VSD_REBUILD} -eq 1 ]
then
    REBUILD_IMG_RESULT="`${SCRIPT_DIR}/virtual_sd_builder/build_img.sh 2>&1`"

    if [ ! $? -eq 0 ]
    then
        echo "VSD REBUILD FAILED ${REBUILD_IMG_RESULT}"
        echo "VSD REBUILD FAILED ${REBUILD_IMG_RESULT}" | show_txt -
        exit 1
    fi

    ${VSD_RO}

    # check mount success
    if [ 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
    then
        # broken
        echo "VSD MOUNT FAILED"
        echo "VSD MOUNT FAILED" show_txt -
        exit 1
    fi

    echo "REBUILDED"
fi

# スタック回避のため
set -e

echo "vsd mount success"
