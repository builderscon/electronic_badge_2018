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


# 実MicroSDからimageを吸い出すときのメモ

MacにMicroSDを接続して、クローンするためにイメージを作る。

### 状況を確認

> diskX については、mountコマンドの結果や抜き差しなどによって特定する。

```
$ sudo fdisk /dev/disk7
Password:
Disk: /dev/disk7	geometry: 958/255/63 [15400960 sectors]
Signature: 0xAA55
         Starting       Ending
 #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
 1: 0C   64   0   1 - 1023   3  32 [      8192 -     524288] Win95 FAT32L
 2: 83 1023   3  32 - 1023   3  32 [    532480 -    3858432] Linux files*
 3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
 4: 00    0   0   0 -    0   0   0 [         0 -          0] unused
```

### 吸い出す長さを決定する

8GBのDiskでもパーティーションが2GBなら2GBでよいし、そうしたい。（そういうことをかんがえなければ、長さの指定は不要、イメージは大きくなるが確実）

fdiskでセクタ数を計算し、それに512（バイト）を書けて長さを特定する。

上記、最後のパーティションをみて、 `532480 + 3858432 = 4390912` が（有意な）最終セクタだと判断する。

セクタサイズは512なので、`4390912 * 512 = 2248146944` が吸い出すデータ量。

> この計算方法は適当なので、あんまり信用しないこと、後述のcountをふやせば解決することも多い

吸い出す長さが間違っていてもエラーはでないし、特に足りてないときは「後できづくことになる」ので気をつけないといけない。

### 実読み込み

わかりやすく512byteごとの読み込み等とかすると無限に時間がかかるので、1mくらい一気に読み込みをさせたい。`if=rdisk`なのは、Macの場合こちらが速度が出るから。

`2248146944 / 1024/1024 = 2144` 。ここから適当な余裕をみて2200とした

> 繰り返しになるが、countは、きっちりにすると（自分の計算ミスで）エラーすることがあるので、計算ミスを考えるとちょっと多めにしておいてもいい。まあ色々試してみてほしい。

```
sudo dd if=/dev/rdisk2 of=~/rp.img bs=1m count=2200
```

### 書き込み

生成された`~/rp.img`を別のsdに書き込む。

ddでもできるが、すなおにEtcherを使ったほうが楽。


