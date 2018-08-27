#!/bin/bash -eu

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

### Escape hatch

if [ -e /boot/startup.sh ]
then
  /bin/bash /boot/startup.sh | tee /boot/startup.log
fi

. const.sh

# mount vsd (NAFUDA drive) or rebuild vsd.
set +e
CHECK_VSD_RESULT=`${SCRIPT_DIR}/check_vsd.sh | tail -1`

# mount failed.
# VSDがないときは、g_etherにフォールバックして終了する。
if [ 0 -eq `mount | grep -c ${VSD_BASE_DIR}` ]
then
    modprobe g_ether
    ifconfig usb0 up
    ifconfig usb0 169.254.123.45/16 # IP固定
    IPADDR_LIST=`ip -f inet -o addr show |grep -v 127.0.0.1 |cut -d\  -f 2,7 |cut -d/ -f 1`

    STARUP_TEXT="NAFUDA SAFE MODE
VSD MOUNT FAILED!

=INFO=
ip: ${IPADDR_LIST}
default password: `cat /boot/default_passwd.txt`
usb gadget mode: g_ether
"
    # dump to hw serial
    echo "${STARUP_TEXT}" > /dev/ttyAMA0

    # show text to e-paper display
    echo "${STARUP_TEXT}" | ${SCRIPT_DIR}/../show_txt/show_txt.py -

    exit 1
fi
set -e

###
### enable usb gadget
###
G_MODE=`${SCRIPT_DIR}/enable_usb_gadget.sh`


#
${SCRIPT_DIR}/reset_password.sh


#
${SCRIPT_DIR}/reset_hostname.sh


###
### copy wpa_supplicant.conf
###

if [ -e ${VSD_BASE_DIR}/wpa_supplicant.conf ]
then
  if [ -e /etc/wpa_supplicant/wpa_supplicant.conf ]
  then
    cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.old
  fi
  ${VSD_RW}
  mv ${VSD_BASE_DIR}/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
  ${VSD_RO}
  sudo systemctl restart networking.service
  sudo systemctl daemon-reload
  sudo systemctl restart dhcpcd
  sleep 5 # wait for dhcp
fi


###
### add id_rsa.pub
###

if [ -e ${VSD_BASE_DIR}/id_rsa.pub ]
then
  if [ -d /home/pi/.ssh ]
  then
    mkdir /home/pi/.ssh
    chown pi:pi /home/pi/.ssh
    chmod 700 /home/pi/.ssh
  fi

  cat ${VSD_BASE_DIR}/id_rsa.pub >> /home/pi/.ssh/authorized_keys
  chmod 700 /home/pi/.ssh/authorized_keys
  chown pi:pi /home/pi/.ssh/authorized_keys

  ${VSD_RW}
  rm ${VSD_BASE_DIR}/id_rsa.pub
  ${VSD_RO}
fi


###
### show info to e-paper display
###

# 一応同時起動を避けるため
set +e
systemctl stop simple-nafuda
set -e

IPADDR_LIST=`ip -f inet -o addr show |grep -v 127.0.0.1 |cut -d\  -f 2,7 |cut -d/ -f 1`
COMMIT_ID=`git -C /home/pi/electronic_badge_2018 log --oneline |head -1`

DEFAULT_PASSWORD="default_passwd.txt missing"
if [ -e "${VSD_BASE_DIR}/default_passwd.txt" ]
then
    DEFAULT_PASSWORD=`cat ${VSD_BASE_DIR}/default_passwd.txt`
fi

set +e
HOSTNAME=`hostname`
set -e

STARUP_TEXT="NAFUDA
commit: ${COMMIT_ID}

=INFO=
ip: ${IPADDR_LIST}
default password: ${DEFAULT_PASSWORD}
usb gadget mode: ${G_MODE}
default hostname: ${HOSTNAME}

======
builderscon
discover something new!!
"

echo "${STARUP_TEXT}"

if [ ! -e ${VSD_BASE_DIR}/disable_startup_info ]
then
    # dump to hw serial
    set +e
    echo "${STARUP_TEXT}" > /dev/ttyAMA0
    set -e

    # show text to e-paper display
    echo "${STARUP_TEXT}" | ${SCRIPT_DIR}/../show_txt/show_txt.py -
fi


###
### start program
###

if [ -e ${VSD_BASE_DIR}/startup.sh ]
then
  # execute user program
  exec /bin/bash ${VSD_BASE_DIR}/startup.sh | tee /boot/startup2.log
else
    # mass storageモードの場合は simple-nafudaを起動する
    if [ ${G_MODE} = "g_mass_storage" ]
    then
        systemctl start simple-nafuda
    fi

    # 消費電力を抑える
    /opt/vc/bin/tvservice --off
fi
