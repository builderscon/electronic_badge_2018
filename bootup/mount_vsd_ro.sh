#!/bin/bash -eu

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

VSD_BASE_DIR=/mnt/virtual_sd
VSD_IMG_PATH=/home/pi/virtual_sd.img

set +e
umount ${VSD_BASE_DIR}
mount -t vfat -o loop,sync,ro,noatime,dmask=000,fmask=111,iocharset=utf8,noauto ${VSD_IMG_PATH} ${VSD_BASE_DIR}
set -e
