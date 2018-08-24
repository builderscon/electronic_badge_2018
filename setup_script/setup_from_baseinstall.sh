#!/bin/bash -eu

# このスクリプトはラズパイの依存ライブラリをインストールし、nafudaソフトウェアをインストールするものです。
# ラズパイがインターネットに接続された状態で実行する必要があります。

if [ "raspberrypi" != `hostname` ]
then
  echo "this scirpt must be execute in raspberrypi"
  exit 1
fi

# install deps
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install git vim python-imaging python3-pil python-spidev python3-spidev fonts-freefont-ttf fonts-vlgothic  python-rpi.gpio python3-rpi.gpio

sudo update-alternatives --set editor /usr/bin/vim.basic

# install nafuda codes
set +e
rm -rf /home/pi/bcon_nafuda
set -e
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
git -C /home/pi clone git@github.com:uzulla/bcon_nafuda.git

/home/pi/bcon_nafuda/show_img/show_img.py /home/pi/bcon_nafuda/bootup/virtual_sd_builder/skel/img/info.png

sudo cp /home/pi/bcon_nafuda/bootup/nafuda-bootup.service /etc/systemd/system/
sudo cp /home/pi/bcon_nafuda/simple_nafuda/simple-nafuda.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable nafuda-bootup

set +e
sudo mv /etc/motd /etc/motd.default
sudo cp /home/pi/bcon_nafuda/resource/motd /etc/motd

sudo cp /home/pi/bcon_nafuda/resource/show_txt /usr/bin/
sudo cp /home/pi/bcon_nafuda/resource/show_img /usr/bin/
sudo cp /home/pi/bcon_nafuda/resource/mount_vsd_ro /usr/bin/
sudo cp /home/pi/bcon_nafuda/resource/mount_vsd_rw /usr/bin/

set -e

echo "DONE"
echo "don't forget wipe wpa_supplicant.conf and .ssh/authorized_keys!!"

# sudo cp ~/bcon_nafuda/bootup/virtual_sd_builder/skel/wpa_supplicant.conf.sample /etc/wpa_supplicant/wpa_supplicant.conf

# sudo shutdown -h now
