#!/bin/bash -eu
# generate and reset hostname when found /mnt/virtual_sd/reset_hostname or default hostname.
# generated hostname will be store in /mnt/virtual_sd/default_hostname.txt

# force reset
# $ sudo reset_hostname.sh -f

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

. const.sh

# どうしてもhostnameをraspberryに固定したい人用
if [ -e ${VSD_BASE_DIR}/i_love_common_hostname ]
then
  echo "raspberrypi" > /etc/hostname
  # add hosts
  # echo "\n127.0.0.1 raspberrypi"  >> /etc/hosts
  /bin/hostname "raspberrypi"
  /bin/systemctl restart avahi-daemon.service
  exit
fi


##
## check commands
##

DO_RENAME=0

# force switch check
if [ $# -gt 0 ] && [ "$1" = "-f" ]
then
  DO_RENAME=1
fi

# default hostname check
if [ "raspberrypi" = `cat /etc/hostname` ]
then
  echo "host name is default(raspberrypi)"
  DO_RENAME=1
fi

# switch check
if [ -e ${VSD_BASE_DIR}/reset_hostname ]
then
  echo "reset hostname requested"
  ${VSD_RW}
  /bin/rm ${VSD_BASE_DIR}/reset_hostname
  ${VSD_RO}

  DO_RENAME=1
fi

# exit when command not found.
if [ ! $DO_RENAME -eq 1 ]
then
  echo "hostname not changed."
  exit
fi


##
## do reset
##

${VSD_RW}

# ランダムHOSTNAMEを生成し、保存
set +e # tweak: for openssl put "unable to write 'random state'" with systemd. FIY https://www.openssl.org/docs/faq.html#USER2
NEW_HOSTNAME="nafuda-`/usr/bin/openssl rand -hex 2`"
set -e
echo "${NEW_HOSTNAME}" > ${VSD_BASE_DIR}/default_hostname.txt

cp ${VSD_BASE_DIR}/default_hostname.txt /boot/default_hostname.txt

# change hostname config
cat ${VSD_BASE_DIR}/default_hostname.txt > /etc/hostname
# add hosts
echo ""  >> /etc/hosts
echo "127.0.0.1 `cat ${VSD_BASE_DIR}/default_hostname.txt`"  >> /etc/hosts

${VSD_RO}

# apply settings.
/bin/hostname "${NEW_HOSTNAME}"
/bin/systemctl restart avahi-daemon.service

echo "hostname changed."
