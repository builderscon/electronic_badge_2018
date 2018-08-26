# 名札へのログイン方法

名札のラズパイ（Raspberry Pi Zeo wh）にログインするための方法を紹介します。

こちらはアドバンスドな方法となりますので、自己責任の作業でお願いいたします。

## ログインするには？

添付の物品だけで行う場合は以下の方法があります。

1. usb gadget etherを用いてsshログイン
2. wifiでsshログイン
3. usb gadget serialでログイン

> ※ Windowsの場合、1の`g_ether`はあまりおすすめできません。

## 共通情報

### ID/PASS

まず、NAFUDAドライブの中のファイルを確認し、パスワードを別の所にメモしてください。

- ログインユーザー名 : `pi`
- ログインパスワード : NAFUDAドライブ内 `default_passwd.txt`に記載されています。
- ホスト名（Bonjourで利用可能） : NAFUDAドライブ内 `default_hostname.txt`に記載されています。

> ※ パスワードは起動時の情報表示でも表示されます。通常設定だと数秒後`simple-nafuda`が起動するので、スマホで撮影などしてください。

> ※ 通常の設定においてはパスワードは初回の起動時に生成されるため、共通のマスターパスワードは存在しません。

### rootについて

rootでログインはできません。

`pi` ユーザーはパスワード無しで`sudo`ができます。

rootのシェルが必要な場合には、`sudo su`をしてください。

### 「パスワードを忘れた」

- まず、ログインIDは`pi`です。
- NAFUDAドライブの`default_passwd.txt`に初期パスワードは保存されています、こちらをためしてください。
- 名札として起動が可能なら、NAFUDAドライブに`reset_passwd`という空のファイルを作成し、名札を再起動してください。
- いずれもうまくいかない場合は、別ドキュメントの「初期化」を参照してください。


### 「名札を取り外す」の意味

電子名札をNAFUDAドライブとして認識するようにPCに接続した後は、
PCでアンマウントや、イジェクトや、「取り外し」操作をした後、LEDの点滅なないことを確認してからUSBケーブルを抜いてください。

アンマウントをせずに抜き差しをすると、NAFUDAドライブが壊れる事があります。

> ※ 何も操作せずに抜き差しすると、PC上で警告も表示されます。


## 1. usb gadget etherを用いてsshログイン

> ※ このモードにした際には、利便性のために情報表示画面で停止し、名札は起動しません。`sudo systemctl start simple-nafuda`で起動することができます。

NAFUDAドライブの直下に`enable_g_ether`というファイルを作ります（中身は空でかまいません）。

```
Macでの例
$ touch /Volumes/NAFUDA/enable_g_ether
```

> ※ テキストエディタやExplorerなどで作成する場合は、拡張子が自動的に付与されないように注意してください。

> ※ 正しく設定されていると、起動時の情報表示で`usb gadget mode: g_ether`と表示されます。

名札を取り外して、再度PCに接続してください。しばらくするとPCにネットワークインターフェイスとして認識されます。

> ※ Windowsの場合はネットワークインターフェイスとして認識させるのに様々な手法があり「公式」な手法はありません。
> [ドライバーを導入して認識させる例をこちらに記載いたします](G_ETHER_WITH_WINDOWS.md)が、うまくいかない事もあります。
> うまくいかない場合は、`g_ether windows ssh`などでネットを検索して、お手元のWindowsで正しく動作する方法を探してみてください。



`169.254.123.45`のIPアドレスにsshしてください

```
例
$ ssh pi@169.254.123.45
```

> ※ `g_ether`時にはIPアドレスを固定しています。もし、複数の名札をおもちの場合は注意してください。

> ※ 接続するPCでDHCPなどを用意したり、インターネット共有を用いる場合は `~/bcon_nafuda/bootup/bootup.sh`の`ifconfig usb0 169.254.123.45/16 # IP固定`行をコメントアウトや削除してください。

もし、上記IPアドレスに接続ができず、pingなども通らない場合は以下を確認してください。

- ただしく `enable_g_ether` ファイルが作成できているか（NAFUDAドライブとして認識される場合はできていない）
- 接続しているUSBポートが正しく内側か
- USBケーブルが充電専用でないか
- （Macの場合）コントロールパネル＞ネットワークにて `RNDIS/Ethernet Gadget`が認識されているか
- OS側でドライバのインストールが正しくできているか

> ※ 起動時に自動的に`enable_g_*`は削除され、次の起動時にはUSBドライブとして認識するモードへ戻ります。


## 2. wifiでsshログイン

> ※ WifiのAP（アクセスポイント）がいわゆる「プライバシーセパレータ」有効などで、接続している端末同士の通信を禁止している場合は接続ができません。

> ※ Wifiが別途ブラウザでのアクセスを必要とするような場合は、以下方法では接続できません。

> ※ Wifiの提供があるカンファレンス会場では、自前のWifiアクセスポイントはできるだけオフにしましょう。

お手持ちのスマホやPCなどをインターネット共有やテザリングモードにして、Wifi APとして有効にします。

電子名札をドライブとしてマウントし、`wpa_supplicant.conf.sample` ファイルを `wpa_supplicant.conf`としてコピーし、エディタで内容を編集します。

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=JP
ap_scan=1

network={
    ssid="ここにあなたの接続したいWifiのSSID"
    psk="ここにあなたの接続したWifiのパスワード"
    # scan_ssid=1 # ステルスAPの場合に必要な場合があります
}
```

保存した後名札を再起動してください。再起動後、設定ファイルは`/etc/wpa_supplicant`に移動され、名札は自動的にWifiに接続します。

適切なネットワークであれば生成されたホスト名をBonjourで検索できるため、ホスト名でもログインできるようになります。
`nafuda888`の場合`nafuda888.local`で接続ができるようになります。

あるいは、起動時の情報表示に表示される`ip:`欄で `wlan0`に付与されたIPアドレスを確認してください。

> ※ Wifiの状況によっては、起動時までにip取得が間に合わず、表示されないことがあります

> ※ Wifiはどのモードにおいても有効になり、手軽にオフにする方法やフライトモードは提供していません。必要ならば設定を消すなどしてください。

> ※ ステルスAPなどの場合で接続ができなければ、`scan_ssid`行のコメントをはずしてみてください。

## 3. usb gadget serialでログイン

> ※ このモードにした際には、利便性のために情報表示画面で停止し、名札は起動しません。`sudo systemctl start simple-nafuda`で起動することができます。

`g_ether`同様に`enable_g_serial`ファイルを作成し、名札をPCにつなぎ直し、再起動します。

後述の各種方法で接続した後、Enterなどを一度叩くとログインプロンプトなどが表示されます。

### Macの場合

`/dev/cu.usbmodem1421`などのファイルができますので、`ls /dev/cu*`で探してください。

デバイスファイルがみつかれば、`cu`コマンドや`screen`コマンドなどで接続が可能です。

screenを利用する場合には、以下のようにします。（cuはLinuxの場合を参考にしてください）

```
$ screen /dev/cu.usbmodem1421

# 必要があってbaud を指定するなら例
$ screen /dev/cu.usbmodem1421 9600
```

> ※ screenの終了は、デフォルトではctrl+a , ctrl-k で「Really kill this window y/n」と質問されるので、yをおします。

> ※ screen等は切断したタイミングによって、端末入出力オプションが崩れたままになることがあります。ターミナルソフトを終了するか、「（Enter) `reset`（Enter） `clear`（Enter）」等と（表示されなくとも）つづけてコマンドを入力することで、多くの場合復帰できます。

### Linuxの場合

`cu`や`screen`などを用いてください。`/dev/ttyACM0`は環境によって異なる場合があります。

`Connected.`などと表示されたら、一回Enterを打ってください。

```
$ sudo cu -l /dev/cu.ttyACM0
Password:
Connected.

Raspbian GNU/Linux 9 nafuda-xxxx ttyGS0
nafuda-xxxx login:

# 必要があってbaud を指定するなら例
$ sudo cu -l /dev/cu.ttyACM0 115200
```

> ※ cuの終了は、`~.`とタイプしてEnterです。

### Windowsの場合

デバイスマネージャからCOMポートを確認し、Teratermなど通信ターミナルをもちいてください

- [`enable_g_serial`を作成し、名札を取り外す](assets/g_serial_win_1.png)
- [再度さしこむと、Serialとして認識開始（ドライブは表示されません０](assets/g_serial_win_2.png)
- [認識完了し、COMポート番号が表示される](assets/g_serial_win_3.png)
- [デバイスマネージャからもCOMポート番号は確認可能です](assets/g_serial_win_4.png)
- [Tera Termなどをつかい、COMポート番号を指定して接続](assets/g_serial_win_5.png)
- [ログインプロンプトが表示されるので、ID/PASSを入力してログイン](assets/g_serial_win_6.png)
- [ログイン成功の様子](assets/g_serial_win_7.png)

> ※ Tera Termは[こちらなどからダウンロードできます](https://forest.watch.impress.co.jp/library/software/utf8teraterm/)

> ※ 起動時に自動的に`enable_g_*`は削除され、次の起動時にはUSBドライブとして認識するモードへ戻ります。


## 補足：アドバンスドな方法、USB to Serial（UART）を接続する

USB シリアル変換ケーブル（amazonなどで1000円くらい）を接続することで、OSのブートアップ中から確認できるように設定がなされています。

かならず3.3Vのものを使用し、TX,RX,GNDのみを接続して電源ラインは接続しないことをおすすめします。

> 例 https://www.switch-science.com/catalog/1196/

> 設定例 https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/overview


## 補足：g_etherなどのモードを固定したい場合

もし再起動しても`g_mass_storage`モードにもどしたくない場合は、microSDを別のPCでマウントし`boot`ドライブの`cmdline.txt`の`modules-load`指定に、`,g_ether`などと追記することで固定ができます。

```
# 修正前
省略) modules-load=dwc2
# 修正後 g_ether例
省略) modules-load=dwc2,g_ether
```

その上で、`boot`ドライブに`startup.sh`を作成し、以下をを追記します。

#### g_etherの場合

```bash
ifconfig usb0 up
ifconfig usb0 169.254.123.45/16 # IP固定
```

#### g_serialの場合

```
systemctl start getty@ttyGS0.service
```

> ※ 起動時、`bootup.sh`が呼ばれた時点で`g_mass_storage`,`g_ether`,`g_serial`いずれかのmoduleがロードされていた場合には、`bootup.sh`内でモジュールをロードしません。

> ※ `g_multi`, `g_cdc`などは十分な検証ができませんでしたので対象外としています。もし指定したい場合には`bootup.sh`を修正するなどご自身でトライしてみてください。

もし、この固定を戻したい場合には、再度microSDをマウントし、`cmdline.txt`と`startup.sh`の記述を削ってください。

