# `show_img` 

単に画像をEpaperに表示します。他のプログラムなどからキックするなどで利用してください。

Draw image file to Epaper display.

## usage

```
$ show_img.py your_image.png
```

## info

ハードウェア的にはディスプレイ解像度は400x300ですが、このコマンドは左に90度回転させますので300x400の画像を用意してください。

画像がディスプレイ解像度を超える場合は縮小されます。

電子ペーパーはモノクロ（2値）ですが、カラー画像を読み込むことができ、ライブラリによってディザリングによる擬似マルチカラー（グレイスケール）になります。

読み込めるファイルタイプはJpeg、PNG、BMPなどです。

Dot by dot display size is 400x300,
But `show_img` will be rotate an image to 90 degree counter clockwise (to 300x400).

Loaded image will be resize when the image file is lager than the display. 

Epaper display is completely monochrome,
But you can input color(RGB)file (jpeg, png, and other).
Library will be do auto dithering (pseudo color).
