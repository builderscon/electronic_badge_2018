#!/bin/bash

# 無限ループ
while :
do

    # テキストを標準入力から受け取って、電子ペーパーに表示
    echo "hello NAFUDA world!" | show_txt -

    # テキストをファイルから読み込んで、電子ペーパーに表示
    show_txt /mnt/virtual_sd/startup.sh

    # 画像をファイルから読み込んで、電子ペーパーに表示
    show_img /mnt/virtual_sd/img/bcon-logo.png

    # コマンド結果を電子ペーパーに表示
    ls -al ~/ 2>&1 | show_txt -

done

