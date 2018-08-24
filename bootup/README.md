# bootup script

起動時に以下のようなことを行うコードです。

- パスワード再生成・再設定
- ホスト名再生性・再設定
- NAFUDA ドライブの初期化
- `wpa_supplicant.conf`のコピー
- `g_ether`,`g_mass_storage`,`g_serial`などの起動切り分け
- 起動直後、各種情報を表示
- 緊急脱出ハッチ
- 上記完了後、`simple-nafuda`サービス起動

systemdに`simple-bootup` サービスとして登録されており、`bootup.sh`がエントリポイントです。


# スイッチ群

NAFUDAドライブ直下にファイルを作成することで、起動時の動作を変更できます。

たとえば、`enable_g_ether`オプションを有効にする場合は以下のようにできます。

```bash
# MacやLinuxの場合、NAFUDAドライブは/Volumes/NAFUDAにマウントされているものとする
$ touch /Volumes/NAFUDA/enable_g_ether
```

FinderやExplorerでも作成は可能ですが、拡張子をまちがってつけないように注意してください。

## `reset_passwd`

passwordをリセットし、`default_password.txt`というファイルを作成します。

## `i_love_common_password`

パスワードを`raspberrypi`に設定します。

> ※ 必要がなければ、セキュリティ的に危険なのでつかわないでください。

## `reset_hostname`

`hostname`をランダムなものに変更します。`hosts`も変更します。

`default_password.txt`というファイルを作成します。

## `i_love_common_hostname`

ホスト名を`raspberrypi`に設定します。

> ※ 他にraspberrypiや名札のいるネットワークではおすすめしません


## `wpa_supplicant.conf`

`/etc/wpa_supplicant/wpa_supplicant.conf` にコピーします。

サンプルはNAFUDAドライブの直下に`wpa_supplicant.conf.sample`として設置されています

> ※ ラズパイの典型的な、`/boot/wpa_supplicant.conf` に制作した時と同じです

## `id_rsa.pub`

お手持ちの公開鍵を登録する時に使うことができます、内容を`/home/pi/authorized_keys` に追記します。

## `enable_g_ether`

ファイルがあれば、起動後に`modprobe g_ether`などを実行します。

> ※ 再起動すると、上記ファイルは削除されます。

> ※ なければ、g_mass_storageを有効にします

## `enable_g_serial`

ファイルがあれば、起動後に`modprobe g_serial`などを実行します。

> ※ 再起動すると、上記ファイルは削除されます。

> ※ なければ、g_mass_storageを有効にします

## `disable_simple_nafuda`

ファイルがあれば、`simple-nafuda`を起動しません。

## `disable_startup_info`

ファイルがあれば、起動時にIPやパスワードの情報表示をディスプレイにおこないません。

## `startup.sh`

`startup.sh`があれば、起動後に`/bin/bash`の引数として実行します。

詳しい使い方の一部は`simple_sample`にも記載されています。


## `vsd_rebuild`

強制的にNAFUDAドライブを初期化します。

たとえば、git pullした後にNAFUDAドライブの内容を最新にしたい場合に実行します。

> ※ NAFUDAドライブにはいっていたファイルは消失します。

> ※ これはNAFUDAシステムの完全初期化ではありません。NAFUDAドライブの外にあるファイルや、ID/PASSが初期化されるわけではありません。
