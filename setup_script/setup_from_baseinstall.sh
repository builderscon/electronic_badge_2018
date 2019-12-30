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

sudo apt -y install git vim python-pil python3-pil python-spidev python3-spidev fonts-freefont-ttf fonts-vlgothic  python-rpi.gpio python3-rpi.gpio python3-pip python-pip
sudo pip3 install qrcode requests

sudo update-alternatives --set editor /usr/bin/vim.basic

# install nafuda codes
set +e
rm -rf /home/pi/electronic_badge_2018
set -e
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
git -C /home/pi clone https://github.com/builderscon/electronic_badge_2018.git

/home/pi/electronic_badge_2018/show_img/show_img.py /home/pi/electronic_badge_2018/bootup/virtual_sd_builder/skel/img/0_info.png

sudo cp /home/pi/electronic_badge_2018/bootup/nafuda-bootup.service /etc/systemd/system/
sudo cp /home/pi/electronic_badge_2018/simple_nafuda/simple-nafuda.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable nafuda-bootup

set +e
sudo mv /etc/motd /etc/motd.default
sudo cp /home/pi/electronic_badge_2018/resource/motd /etc/motd

sudo cp /home/pi/electronic_badge_2018/resource/show_txt /usr/bin/
sudo cp /home/pi/electronic_badge_2018/resource/show_img /usr/bin/
sudo cp /home/pi/electronic_badge_2018/resource/mount_vsd_ro /usr/bin/
sudo cp /home/pi/electronic_badge_2018/resource/mount_vsd_rw /usr/bin/

set -e

# boot speedup tweaks
sudo systemctl disable hciuart.service
sudo sed -i -e 's/root\=PARTUUID\=4d3ee428\-02/root\=\/dev\/mmcblk0p2/' /boot/cmdline.txt
sudo sed -i -e 's/rootwait/rootwait quiet/' /boot/cmdline.txt


echo "DONE"
echo "don't forget wipe wpa_supplicant.conf and .ssh/authorized_keys!!"

# sudo cp ~/electronic_badge_2018/bootup/virtual_sd_builder/skel/wpa_supplicant.conf.sample /etc/wpa_supplicant/wpa_supplicant.conf

# sudo shutdown -h now
