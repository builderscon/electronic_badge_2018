#!/bin/bash -eu

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

. const.sh

# すでになんらかのusb gadget moduleがロードされていれば処理しない
ALREADY_LOADED_MOD=`lsmod|grep -e ^g_mass_storage -e ^g_ether -e ^g_serial|cut -f 1 --delim=" "`

if [ ${#ALREADY_LOADED_MOD} -gt 0 ]
then
    echo ${ALREADY_LOADED_MOD}
    exit
fi

G_MODE=""
if [ -e ${VSD_BASE_DIR}/enable_g_ether ]
then
    G_MODE="g_ether"
    ${VSD_RW}
    /bin/rm ${VSD_BASE_DIR}/enable_g_ether
    ${VSD_RO}
    modprobe g_ether
    ifconfig usb0 up
    ifconfig usb0 169.254.123.45/16 # IP固定
fi

if [ -e ${VSD_BASE_DIR}/enable_g_serial ]
then
    G_MODE="g_serial"
    ${VSD_RW}
    /bin/rm ${VSD_BASE_DIR}/enable_g_serial
    ${VSD_RO}
    modprobe g_serial
    systemctl start getty@ttyGS0.service
fi

if [ -z "${G_MODE}" ]
then
    G_MODE="g_mass_storage"
    modprobe g_mass_storage file=${VSD_IMG_PATH} stall=0 removable=0
    sudo sysctl -w vm.dirty_expire_centisecs=50
    sudo sysctl -w vm.dirty_writeback_centisecs=100
fi

echo "${G_MODE}"
