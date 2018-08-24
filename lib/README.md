ライブラリ
=========

Python3で、E-paper displayを簡単にあつかう単純なライブラリです。


# nafuda ライブラリ

簡単にe-paper Displayに画像を表示するためのヘルパー関数群です。

```
sys.path.append('/path/to/lib')
from nafuda import Nafuda

nafuda = Nafuda()

# 文字列表示
nafuda.draw_text("Hello world", orientation=90)
# 画像表示
nafuda.draw_image_file(file_path, orientation=90)
```

## 実機以外での開発テクニック

### 疑似画面

`PSEUDO_EPD_MODE`環境変数がある場合は、ライブラリmockのものがよみこまれ、表示すべき画像は`PIL.show()`で表示されます。

> ※ つまり、PCで動作させたときにはPCの画像ビューワーなどで画像ファイルが開く等します。


### `nafuda.draw_text`のフォント指定

show_txtなど、`nafuda.draw_text`を用いる場合には、別途フォントパスの指定が必要です。 TTFやOTFなどが指定できます。

```
# たとえばMacなら…
nafuda.draw_text(input_text, font_path="/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc", font_pt=16, orientation=90)
```

> ※ 指定をしない場合は、`/usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf`が読み込まれます。

### `show_txt`を利用するプログラムをつくる場合

`EPD_FONT_PATH`環境変数で外部からフォントパスを指定できます。

```bash
$ export EPD_FONT_PATH="/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc"
$ show_txt.py some.txt
```

## サンプル

### `nafuda.draw_text()`

テキストを描画します。

```
nafuda.draw_text(
  input_text, # 入力テキスト
  orientation=90, # 角度（90は縦（名札状態）、0は横）
  font_pt=16, # フォントサイズ、pt（省略可能
  font_path=font_path # フォントファイルのパス （省略可能
)
```

### `nafuda.draw_image_file()`

画像ファイルを表示します

```
nafuda.draw_image_file(
  file_path, # 画像のファイルパス
  orientation=90 # 角度（90は縦（名札状態）、0は横）
)
```

### `nafuda.draw_image_buffer()`

Pillow(PIL)のimageインスタンスを表示します。生成したイメージを表示します。

```
nafuda.draw_image_buffer(
  image_buffer,  
  orientation=90 # 角度（90は縦（名札状態）、0は横）
)
```


