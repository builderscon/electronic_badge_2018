#!bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

VSD_BASE_DIR=/mnt/virtual_sd
VSD_IMG_PATH=/home/pi/virtual_sd.img

VSD_RW=${SCRIPT_DIR}/mount_vsd_rw.sh
VSD_RO=${SCRIPT_DIR}/mount_vsd_ro.sh

