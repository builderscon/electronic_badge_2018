# `show_txt` 

テキストををEpaperに表示します。他のプログラムなどからキックするなどで利用してください。

Draw text to Epaper display.

## usage

```
$ echo 123 | show_txt.py -

or

$ show_txt.py something.txt
```


## font

環境変数 `EPD_FONT_PATH` にTTFやOTFなどのフォントファイルパスを指定することでフォントが指定できます。

```
$ export EPD_FONT_PATH="/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc"
```
