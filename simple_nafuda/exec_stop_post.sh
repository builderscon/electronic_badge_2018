#!/bin/bash
#
# the script will run when error exit on simple-nafuda.service
#

SCRIPT_DIR=$(cd $(dirname $0); pwd)
VSD_BASE_DIR=/mnt/virtual_sd

#
#STOPPED
#success
#killed
#TERM
#
#STOPPED
#exit-code
#exited
#1

if [ "${SERVICE_RESULT}" = "success" ]
then
  exit
fi

sudo /home/pi/electronic_badge_2018/bootup/mount_vsd_rw.sh
echo "exit with error" > ${VSD_BASE_DIR}/stop.log
journalctl -b >> ${VSD_BASE_DIR}/stop.log
sudo /home/pi/electronic_badge_2018/bootup/mount_vsd_ro.sh

echo "== exit with error ==" > ${SCRIPT_DIR}/stop.log
journalctl -u "simple-nafuda" >>  ${SCRIPT_DIR}/stop.log

cat ${SCRIPT_DIR}/stop.log | \
  grep -v "\-\- Logs begin" | \
  grep -v "pam_unix(sudo:session)" | \
  grep -v "bootup/mount_vsd_" | \
  sed  "s/simple-nafuda.service: //" | \
  sed "s/.*\]: //" | \
  tail -10 | /home/pi/electronic_badge_2018/show_txt/show_txt.py -
