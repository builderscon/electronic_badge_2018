#!/bin/bash -eu
# create new NAFUDA drive image and copy template files.

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

BASE_DIR=`dirname "${0}"`

. ${BASE_DIR}/../const.sh

# remove old image.
set +e
umount ${VSD_BASE_DIR}
rm ${VSD_IMG_PATH}
set -e

# create loopback image.
/bin/dd if=/dev/zero of=${VSD_IMG_PATH} bs=1MB count=64

# format and set disk label
/sbin/mkfs.vfat -n "NAFUDA" ${VSD_IMG_PATH}

# make mount point
if [ ! -e ${VSD_BASE_DIR} ]
then
    /bin/mkdir ${VSD_BASE_DIR}
fi

/bin/mount -t vfat -o loop,sync,rw,noatime,dmask=000,fmask=111,iocharset=utf8 ${VSD_IMG_PATH} ${VSD_BASE_DIR}

# copy default files
/bin/cp -r ${BASE_DIR}/skel/* ${VSD_BASE_DIR}

# copy docs(snapshot)
/bin/cp ${BASE_DIR}/../../docs/* ${VSD_BASE_DIR}/docs/

# copy simple sample
/bin/cp -r ${BASE_DIR}/../../simple_sample ${VSD_BASE_DIR}/

# recovery exists files from boot partition
/bin/cp -r /boot/default_* ${VSD_BASE_DIR}

/bin/umount ${VSD_BASE_DIR}

