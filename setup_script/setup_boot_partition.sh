#!/bin/bash -eu

# このスクリプトは、raspbianをmicroSDに焼いた後、母艦で実行するためのものです。

# BOOT_DIRは、Macだと/Volumes/bootにマウントされる。
# Windowsの場合は`boot`という名前のドライブが認識される
BOOT_DIR=/Volumes/boot


# BOOT ドライブがあるか確認（なかったら終了させるため）
ls ${BOOT_DIR} > /dev/null


# このスクリプトはラズパイで動作扠せるためのものではないので、ホスト名で確認
if [ "raspberrypi" = `hostname` ]
then
  echo "this scirpt must be execute in PC (not raspberrypi)"
  exit 1
fi


# cmdline.txtを編集
# - remove `quiet init=/usr/lib/raspi-config/init_resize.sh`
# - add `modules-load=dwc2`

cp ${BOOT_DIR}/cmdline.txt ${BOOT_DIR}/cmdline.txt.orig
cat ${BOOT_DIR}/cmdline.txt.orig | \
 sed -e 's/quiet init=\/usr\/lib\/raspi-config\/init_resize.sh/modules-load=dwc2/g' > \
  ${BOOT_DIR}/cmdline.txt


# config.txt に以下テキストを追記
ADD_CONFIG="
# for e-paper display
dtparam=spi=on

# usb gadget
dtoverlay=dwc2

# for serial
enable_uart=1
dtoverlay=pi3-miniuart-bt
"
echo "${ADD_CONFIG}" >> ${BOOT_DIR}/config.txt


# sshd を自動起動するように、bootドライブにsshファイルを設置（raspbianの機能）
touch ${BOOT_DIR}/ssh


# wifi接続情報を保存
set +u
# Wifi ID/PASS環境変数があれば
if [ ! -z "${WPA_SSID}" ] && [ ! -z "${WPA_PSK}" ]
then
  # Wifiのコンフィグを生成して、保存
  WPA_CONFIG="ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=JP

network={
        ssid=\"${WPA_SSID}\"
        psk=${WPA_PSK}
}
"
  echo "${WPA_CONFIG}" > ${BOOT_DIR}/wpa_supplicant.conf
else
  # なくても処理は完了するが、注意書き出力
  echo "No WPA_SSID env. skip generate wpa_supplicant.conf"
  echo "  example:"
  echo "  export WPA_SSID=\"adsf\""
  echo "  export WPA_PSK=\"\\\"adsf\\\"\""
  echo "  (\\\" is important)"
fi
set -u


# ラズパイにログインしてから実行する初期化スクリプトを`boot`にコピーしておく
cp setup_from_baseinstall.sh ${BOOT_DIR}/nafuda_setup.sh


# microSD のとりはずし
diskutil unmount ${BOOT_DIR}

echo DONE
