# ハックしたい皆様へ

もともと保証もないですが、ここからはさらに無保証です！

## コード

詳しくは 以下レポジトリを見てください。

https://github.com/builderscon/electronic_badge_2018

> ※ ログインができるなら、まずは`git pull`して更新することをおすすめします


## まずはログイン

ログイン方法は`HOW_TO_LOGIN.md`を参照ください。


### ログインできない方へ

ログインせず、NAFUDAドライブにプログラムをおいて起動する方法があります。

`simple_nafuda`を参照してください。


## python以外で電子ペーパーを制御したい方

オフィシャルのドキュメント、ライブラリはこちらから閲覧できます。

[https://www.waveshare.com/wiki/4.2inch_e-Paper_Module](`https://www.waveshare.com/wiki/4.2inch_e-Paper_Module`)

ただし、基本はCのライブラリなので、C以外で制御するならば以下の方法となります。

- C拡張をつくる
- データシートをみながら、自分で指定のSPI通信を実装する
- 名札のサンプルプログラムにふくまれる `show_txt`, `show_img` コマンドラインツールを自分のプログラムから実行して代用する

基本的には、三番目の方法をおすすめします。

画像を生成して、どこかtmpなどに保存し、`show_img`にそのファイルを指定して実行し、表示する、のが一番簡単です。


## 「どうやってアプリをつくるか？」


### `simple_nafuda`、 `simple_sample`などを参考にしてアプリを作ります

（TBD：寄稿希望）


### 自動起動を設定

一番簡単な方法は以下ファイルを作成し、起動する行を記載することです。

`/mnt/virtual_sd/starup.sh`

> ※ `/mnt/virtual_sd`はroでマウントされているので、rwでマウントしなおすか、NAFUDAドライブ経由で保存して再起動してください。 

> ※ `startup.sh`を作成すると、`simple_nafuda`が起動しなくなります


### もっと細かい起動方法、systemdをつかう

> ※ ここでは細かいsystemdの説明はいたしません。

`/mnt/virtual_sd/starup.sh`

を空で作成して`simple-nafuda`の起動抑制し、独自のsystemd serviceを追加します。

> `simple_nafuda`はsystemdに`system-nafuda` serviceとして登録されています。

その際には、

```
After=nafuda-bootup
```

とserviceの設定に追記しておくと、`nafuda-bootup`サービス完了後に自動的にサービスが起動します。

> ※ simple-nafudaはnafuda-bootupから起動される都合上、Afterの指定をしていません。

