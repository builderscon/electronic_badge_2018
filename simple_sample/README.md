simple sample
=============

一番簡単なHello worldサンプル。

「ログインせずに」NAFUDAドライブの中身だけでハックする！

# 試し方

- このディレクトリの`startup.sh`をNAFUDAドライブのトップに設置する
- 名札を再起動する
- 「hello nafuda world!」


# 概要説明

systemdに登録された`nafuda-bootup.service`(`bcon_nafuda/bootup/bootup.sh`)は、最後にNAFUDAドライブの直下にstartup.shがあればそれを起動します。

> ※ その場合、simple-nafudaは起動されません。

この`starup.sh`は無限ループで名札内に保存されている `show_txt`や`show_img`コマンドを用いて画像を表示しています。

このシェルスクリプトを改変することで、簡単なものならばログインなしにプログラムが可能です。

> ※ エラー原因を特定するなどを考えるとなかなか難しいですが…

> ※ `show_txt`や`show_img`の使い方はGitHubのレポジトリのそれぞれをみてください。

> ※ この`startup.sh`はroot権限で起動されます


# たとえば他の例

```
# nictの現在時刻取得jsonをたたいて表示してみるとか
curl http://ntp-a1.nict.go.jp/cgi-bin/json | show_txt -

# 画像をDLして表示するとか
# ※ /mnt/virtual_sdは初期ではread onlyでマウントしているため、
# 　 書き込みが必要であれば/tmpを指定してください。
# 　 もしご自身でmount_vsd_rwを用いて再マウントすればその限りではありません。
curl 'https://builderscon.io/static/images/mrbeacon-001.png' > /tmp/bcon.png
show_img /tmp/bcon.png
```

> ※ `show_img`の実体は `/home/pi/bcon_nafuda/show_img/show_img.py`

> ※ `show_txt`の実体は `/home/pi/bcon_nafuda/show_txt/show_txt.py`

# おまけ

## 各インタプリタへのパス

```
/usr/bin/python3.5
※ /usr/bin/python は python2なので推奨はしません
/usr/bin/perl
```

## 「とにかくなにか実行して結果が知りたい」

`show_txt`をつかえば、表示することが可能です。

```bash
#!/bin/bash
ls -al ~/ 2>&1 | show_txt -
# 2>&1 をいれないと、エラー出力がすてられます
```

> ※ 大変なので、ログインしたほうが良いとおもいます！


## git cloneやpullできるのでは？

やってやれないことはありません。

```bash
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
git -C /home/pi clone git@github.com:uzulla/bcon_nafuda.git 2>&1 | show_txt -
git -C /home/pi pull 2>&1 | show_txt -
```

> ※ コンフリクトしていたときに解消が難しいので、おすすめはできませんが…

## Do you want PHP?

php が必要？以下のstartup.shを作成して再起動すればインストールできるよ！

```bash
#!/bin/bash
echo "php installing now..." | show_txt -
# とても時間かかります！
sudo apt -y install php 2>&1 | show_txt -
LOG=`which php`
LOG="${LOG} `php -v`"
echo "${LOG}"
echo "finished. ${LOG}" | show_txt -
```


あとは、たとえば以下みたいなコードをかけば表示もできます！

```php
<?php

`echo "HELLO PHP!" | show_txt -`;
```

startup.shに`php -S`指定をいれればウェブサーバもたてられるよ！

> ※ NAFUDAドライブは読み込み専用でマウントされているので、一時ファイルを作成するときは /tmp/ に作成してください。

> ※ もしご自身の自己責任でmount_vsd_rw.shを用いて再マウントすればその限りではありません。
