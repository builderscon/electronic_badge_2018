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

# check virtual sd (NAFUDA drivec) mount and, rebuild when mount error.
IS_REBUILDED=`${SCRIPT_DIR}/check_vsd.sh | tail -1`

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
  cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.old
  ${VSD_RW}
  mv ${VSD_BASE_DIR}/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
  ${VSD_RO}
  sudo systemctl restart networking.service
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
systemctl stop simple-nafuda

IPADDR_LIST=`ip -f inet -o addr show |grep -v 127.0.0.1 |cut -d\  -f 2,7 |cut -d/ -f 1`
COMMIT_ID=`git -C /home/pi/bcon_nafuda log --oneline |head -1`

STARUP_TEXT="NAFUDA
commit: ${COMMIT_ID}

=INFO=
ip: ${IPADDR_LIST}
default password: `cat ${VSD_BASE_DIR}/default_passwd.txt`
usb gadget mode: ${G_MODE}

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
### escape hatch 2
###

if [ -e ${VSD_BASE_DIR}/startup.sh ]
then
  /bin/bash ${VSD_BASE_DIR}/startup.sh | tee /boot/startup2.log
fi


###
### start nafuda
###

# 以下いずれかの場合はsimple nafudaを起動しない
# - ${VSD_BASE_DIR}/startup.sh がある
# - mass storageモードではない
if [ ! -e ${VSD_BASE_DIR}/startup.sh ] && [ ${G_MODE} = "g_mass_storage" ]
then
  # ただし、リビルド直後（初回起動時）は、info.pngを表示して終了する
  if [ "REBUILDED" = "${IS_REBUILDED}" ]
  then
    ${SCRIPT_DIR}/../show_img/show_img.py ${VSD_BASE_DIR}/img/info.png
  else
    systemctl start simple-nafuda
  fi

  # 消費電力を抑えるため
  /opt/vc/bin/tvservice --off
fi
