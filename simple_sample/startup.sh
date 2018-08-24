#!/bin/bash

# 無限ループ
while :
do

    # テキストを標準入力から受け取って、電子ペーパーに表示
    echo "hello NAFUDA world!" | /home/pi/bcon_nafuda/show_txt/show_txt.py -

    # テキストをファイルから読み込んで、電子ペーパーに表示
    /home/pi/bcon_nafuda/show_txt/show_txt.py /mnt/virtual_sd/startup.sh

    # 画像をファイルから読み込んで、電子ペーパーに表示
    /home/pi/bcon_nafuda/show_img/show_img.py /mnt/virtual_sd/img/bcon-logo.png

    # コマンド結果を電子ペーパーに表示
    ls -al ~/ 2>&1 | /home/pi/bcon_nafuda/show_txt/show_txt.py -

done

