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
if [ ! 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
then
    umount ${VSD_BASE_DIR}
    if [ ! $? -eq 0 ]
    then
        echo "unmount failed"
        fuser -muv ${VSD_BASE_DIR}
        echo "unmount failed disk busy `fuser -muv ${VSD_BASE_DIR}`" | show_txt -
        exit 1
    fi
fi

if [ -e ${VSD_IMG_PATH} ]
then
    rm  ${VSD_IMG_PATH}
fi
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

${VSD_RW}

# copy default files
/bin/cp -r ${BASE_DIR}/skel/* ${VSD_BASE_DIR}

# copy docs(snapshot)
/bin/cp -r ${BASE_DIR}/../../docs/* ${VSD_BASE_DIR}/docs/

# copy simple sample
/bin/cp -r ${BASE_DIR}/../../simple_sample ${VSD_BASE_DIR}/

# recovery exists files from boot partition
set +e
/bin/cp -r /boot/default_* ${VSD_BASE_DIR}
set -e

/bin/umount ${VSD_BASE_DIR}

exit 0
