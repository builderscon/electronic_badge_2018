#!/bin/bash -eu

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

. const.sh

${VSD_RO}

DO_VSD_REBUILD=0

# mount failed. need rebuild
if [ 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
then
  DO_VSD_REBUILD=1
fi

# force rebuild switch
if [ -e "${VSD_BASE_DIR}/vsd_rebuild" ]
then
  DO_VSD_REBUILD=1
fi


REBUILDED=""

# do rebuild.
if [ ${DO_VSD_REBUILD} -eq 1 ]
then
  echo "REBUILD VSD"
  ${SCRIPT_DIR}/virtual_sd_builder/build_img.sh
  ${VSD_RO}
  REBUILDED="REBUILDED"
fi


# check rebuild success
if [ 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
then
  # broken
  echo "FATAL: VSD REBUILD FAIL"
  echo "FATAL: VSD REBUILD FAIL" | ${SCRIPT_DIR}/../show_txt/show_txt.py -
  exit 1
fi

echo "${REBUILDED}"
