setup script
============

電子名札用にmicroSDを最初からビルドするための手順や、サポートスクリプトです。

> ※ 配布状態に戻すためのものです。


## 1. raspbian をmicroSDに焼く

一般的な Raspberry pi への raspbianと同じ作業となります。

ここでは省略します。

## 2. `boot`パーティションの初期設定

焼いたmicroSDを一度ぬいて、もう一度さして `boot`ドライブをマウントし、内容を編集します。

Macの場合は、以下のように`setup_boot_partition.sh`を走らせると自動的にアンマウントまで実施されます。 このとき、以下のようにWifiのパスワードを環境変数にいれてください（`wpa_supplicant.conf`を生成します）。

> ※ この後の手順で、ラズパイはインターネットにつながっている必要があります。Wifi以外の別途のネットワークが確保できれば不要です。

```bash
$ export WPA_SSID="YOUR SSID"
$ export WPA_PSK="\"YOUR PASSWORD\"" 
# 上記の `\"` は平文のパスワードで設定するのには重要です

$ cd electronic_badge_2018/setup_script
$ ./setup_boot_partition.sh

# 以下成功時出力例
Volume boot on disk2s1 unmounted
DONE
```

Mac以外の場合は、`setup_boot_partition.sh`を参考にして手動で作業してください。


## 3. 起動し、sshなどでログイン

ここではまだraspbianのデフォルトID/PASSである`pi`/`raspberry`でログインできます。

ログインしたら以下のスクリプトを実行します。

```bash
$ cd /boot
$ ./nafuda-setup.sh
```

ここで

- apt update
- apt upgrade
- git clone simple-nafuda
- systemdへのサービス登録

などを行います。

状態にもよりますが、2〜30分以上の時間がかかりますので、気長に待ってください。


## 4. Wifi接続情報などを必要ならば削除

必要ならば`/etc/wpa_supplicant/wpa_supplicant.conf`を消します。

> ※ この時点でのmicroSDが「配布状態」となります。


## 5. 再起動

再起動すると、パスワード、hostnameなどが生成され、完了です。

ここからは`docs/README.md`を参照してください。
