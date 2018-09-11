# 追加情報

以下はすべて無保証です。


## NAFUDAドライブの構造について

電子名札は`g_mass_storage`を用いることで、`/home/pi/virtual_sd.img`のloop deviceをMass Storage deviceとしてUSBポートへ公開しています。

そのloop deviceは、別途 `/mnt/virtual_sd`にread onlyでマウントされており、起動時に`/home/pi/electronic_badge_2018/simple_nafuda`プログラムから読み込まれています。

> ※ ラズパイとPC（母艦）両方から同時にマウントされるため、結構危険なやり方です。最低限の対処としてroでマウントしています。ラズパイからrwでもマウントできますが自己責任でお願いいたします。

> ※ PCからファイルを書き込んでも、Linuxから見えるファイルには即時反映はされるとはかぎりません。再起動やumount/mountをして読み込み直す必要があります。


## ディレクトリ構成

Raspberry pi側からから見たディレクトリ構成は以下の通りです。

- `/home/pi/electronic_badge_2018` 各種コード、詳しくはそれぞれの内容をご確認ください
- `/home/pi/virtual_sd.img` NAFUDAドライブの実態（`/mnt/virtual_sd`にループバックでマウントされます）
- `/mnt/virtual_sd` NAFUDAドライブのイメージをマウントしたもの
- `/mnt/virtual_sd/img` 名札に表示する画像ファイルが保存された、NAFUDAドライブのimgディレクトリ


## NAFUDAドライブをLinuxから読み書きするためには

NAFUDAドライブは `/home/pi/virtual_sd.img` が実体で、readonlyでマウントされています。マウントは`bootup/bootup.sh`で行われています。

rw(書き込み可)でマウントするには、`sudo ~/electronic_badge_2018/bootup/mount_vsd_rw.sh`を実行してください。

ro(書き込み不可)でマウントするには、`sudo ~/electronic_badge_2018/bootup/mount_vsd_ro.sh`を実行してください。

> ※ PCでNAFUDAドライブをマウントしつつ読み書きするとFSが壊れたりします。rwに変更する場合は自己責任でお願いいたします。

## E-paper仕様、オフィシャルライブラリ

オリジナルのライブラリは以下からダウンロードできます。

https://www.waveshare.com/wiki/4.2inch_e-Paper_Module

> python以外に、C言語向けのサンプルコード・ライブラリがあります。

> オリジナルのpythonライブラリは、python2用です。

## disk sizeについて

初期状態ではSDカードの容量を「一杯まで」つかっていません。

```
pi@raspberrypi:~ $ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       1.7G  1.1G  471M  70% /
```

> ※ 大きい容量だと、microSDを焼くのがすごい時間がかかるからです！

コマンドで拡張することができますが、以下は自己責任でお願いいたします。

#### 方法１

以下のコマンドを実行するとサイズを広げる事ができます

```bash
$ raspi-config --expand-rootfs
```

#### 方法２

あるいは、`/boot/cmdline.txt`の最後に以下を追記し、再起動することでmicroSDのフルサイズである8GBまでパーティーションを拡大できます。

```
 init=/usr/lib/raspi-config/init_resize.sh
```

## 初期状態でBLEなどBluetoothが動作しない件について

起動時間の短縮と、ハードウェアシリアルを有効化する為にBTのserviceを一部無効にしています。

そのため、`hcitool lescan`などを実行した際に以下のエラーが発生する事があります。

```
Could not open device: No such device
```

BLEを利用するには、ログインして`/boot/config.txt`ファイルの以下の該当行を消すかコメントアウトし、

```
enable_uart=1
dtoverlay=pi3-miniuart-bt
```

以下を実行して、一部サービスを有効化してください。

```
$ sudo systemctl enable hciuart.service
```
 