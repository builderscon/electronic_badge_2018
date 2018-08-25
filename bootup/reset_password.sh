#!/bin/bash -eu
# generate and reset password when found /mnt/virtual_sd/reset_passwd or default pasword.
# generated passwd will be store in /mnt/virtual_sd/default_passwd.txt

# force reset
# $ sudo reset_password.sh -f

if [ 0 -ne ${EUID:-${UID}} ]
then
	echo "You need to be root to perform this command."
	exit 1
fi

. const.sh

# どうしてもpasswdをraspberryに固定したい人用
if [ -e ${VSD_BASE_DIR}/i_love_common_password ]
then
  echo "pi:raspberrypi" | /usr/sbin/chpasswd
  echo "password reset, use 'raspberrypi'"
  exit
fi


##
## check commands
##

DO_PASSWD_RESET=0

# force switch check
if [ $# -gt 0 ] && [ "$1" = "-f" ]
then
  DO_PASSWD_RESET=1
fi

# check switch
if [ -e ${VSD_BASE_DIR}/reset_passwd ]
then
  DO_PASSWD_RESET=1
  ${VSD_RW}
  /bin/rm ${VSD_BASE_DIR}/reset_passwd
  ${VSD_RO}
fi

# check another switch
if [ -e /boot/reset_passwd ]
then
  DO_PASSWD_RESET=1
  /bin/rm /boot/reset_passwd
fi

# check default password.
if [ "good" != `${SCRIPT_DIR}/check_bad_password.py` ]
then
  DO_PASSWD_RESET=1
fi

# exit when command not found.
if [ ! ${DO_PASSWD_RESET} -eq 1 ]
then
  echo "password not changed."
  exit
fi


###
### do reset.
###

${VSD_RW}

# ランダム文字列をパスワード用に生成する
set +e # tweak: for openssl put "unable to write 'random state'" with systemd. FIY https://www.openssl.org/docs/faq.html#USER2
/usr/bin/openssl rand -base64 6 > /boot/default_passwd.txt
set -e

cp /boot/default_passwd.txt ${VSD_BASE_DIR}/default_passwd.txt
/bin/echo "pi:`/bin/cat ${VSD_BASE_DIR}/default_passwd.txt`" | /usr/sbin/chpasswd

${VSD_RO}

echo "password changed."
