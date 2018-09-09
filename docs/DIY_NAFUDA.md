自分で電子名札を作る方法
=====================

会期中に配布した電子名札をご自身で自作してみたい場合の情報です。

# 部品を揃える

- Raspberry pi zero wh
  - 販売店例： https://raspberry-pi.ksyic.com/main/index/pdp.id/406/pdp.open/406
- Waveshare 400x300, 4.2inch E-Ink display module 
  - 販売店例： https://www.robotshop.com/jp/ja/400x300-42-e-ink-display-module.html
  - 販売店例： https://www.waveshare.com/4.2inch-e-paper-module.htm
  - 販売店例： https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-58US
- microSD （配布品においては8GB）
- 板（MDFなどで制作）
  - 配布時のものと意匠が少々異なりますが、`base_board` 内のデータを参照ください。伝導体でない素材であれば、なにでも構わないと思われます
- バッテリー
  - 配布時のものと異なりますが、ダイソーの300円のモバイルバッテリーが形状として同一です
- バッテリーホールド用のゴムバンド
  - 2本、幅6mm、折径80mm
  - 販売店例： https://www.amazon.co.jp/dp/B002P8YO84
− USBケーブル
  - 配布したものは50cmのもの、充電専用ケーブルや、その他一部ケーブルはPCとラズパイで認識ができない場合があります。配布したものはセリアで販売されていた JAN:4560425569125 です  
− ネジ m2.6 6mm
− 長ナット 15mm (ラズパイ固定用)
− 長ナット 10mm (EPD固定用)
- ロックタイト（ネジロック）

# 組み立て

板にゴムバンドを取り付け、EPDとラズパイをネジとナットで板に固定し、EPD添付のケーブルを [`PIN_ASSIGN.md`](PIN_ASSIGN.md)のように接続します。

> ※ ネジで固定時にネジロックを塗布するのはお好みで

バッテリーをゴムバンドにはさみこむようにして固定し、USBケーブルを準備します。

microSDを[`setup_script/README.md`](../setup_script/README.md)を参考に、別のPCで制作します。

制作したmicroSDを差し込み、起動し、[`setup_script/README.md`](../setup_script/README.md)を参考に初期設定してください。

それで完成となります。


# 注意

初期に導入されている「ネットワーク経由での画像アップロード（QRコードをスキャンして更新するもの）」は別途それらを動かすサーバーの用意が必要です。

> ※ 会期中運用していたサーバーは終了いたします

それをセットアップした後、`simple_nafuda`のコード内にあるURLをかきかえる必要があります。

なお、サーバー側[`simple_nafuda_server`](../simple_nafuda_server) がそれですが、これのサポートは予定しておりません。

是非ご自身でもっと良い連携システムをつくってみてください！
