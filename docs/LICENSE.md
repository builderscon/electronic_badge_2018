# LICENSE

## 電子名札のmicroSDにプリインストールされたOSなどソフトウェア群

> ※ これらは配布された名札のmicroSD、およびReleasesのイメージに関わります。

電子名札のmicroSDにインストールされた環境は、以下のバージョンのraspbianの上に構築されています。

```
RASPBIAN STRETCH LITE
Minimal image based on Debian Stretch
Version:June 2018
Release date:2018-06-27
Kernel version:4.14
```

それらのソフトウェアは以下をたどり、ダウンロード、ソースコードの取得が可能です。

- https://www.raspbian.org/
- https://www.raspberrypi.org/downloads/raspbian/

内容されているソフトウェアのライセンスは、ログイン後に以下ファイル群から確認できます。

`/usr/share/doc/*/copyright`

## `lib` 以下の一部ファイルについて

- `epd4in2.py` オフィシャルのライブラリを修正し、再配布
- `epdif.py` オフィシャルのライブラリからの再配布

オフィシャルのファイルは以下からもダウンロードできます。

- https://www.waveshare.com/wiki/File:4.2inch_e-paper_module_code.7z
- https://www.waveshare.com/wiki/4.2inch_e-Paper_Module


## 上記以外の`~/electronic_badge_2018`以下の電子名札のソフトウェア、ドキュメント、データ

上記を除き、本レポジトリにふくまれる「ソースコード」はそれぞれのファイルに記載されたライセンスとなります。

> 特別な表記のないかぎり、MITライセンスです。

README.md, 及びdocs内の「ドキュメント」は特別な表記のないかぎりCC BY-SA 4.0です。

名札サンプル画像などの「画像ファイル」については

- mercari のロゴが含まれた画像(`gadget_sponsor_mercari.png`)は再配布禁止です。
- builderscon ロゴ（とテキスト）で構成された画像はCC BY-SAです。
