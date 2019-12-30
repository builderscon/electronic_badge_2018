#!/usr/bin/python3
# draw today weather

# for development.
# $ export PSEUDO_EPD_MODE=1
# $ python show.py your_image.png
#
# if you want to use your fav font
# $ export EPD_FONT_PATH="/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc"
# $ python main.py
#
# Copyright (C) Aug 4 2018, Junichi Ishida <uzulla@himitsukichi.com>
#
# LICENSE : MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of
#  the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

import os
import sys
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import weather

sys.path.append(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + '/../lib'))

# for PC development
if "PSEUDO_EPD_MODE" in os.environ:
    import epd4in2_mock as epd4in2
else:
    import epd4in2

EPD_WIDTH = 400
EPD_HEIGHT = 300


def main():
    epd = epd4in2.EPD()
    epd.init()

    weather_client = weather.Weather()

    # 130010 is tokyo
    weather_data = weather_client.get_usable_array(130010)

    # For simplicity, the arguments are explicit numerical coordinates
    image = Image.new('1', (EPD_WIDTH, EPD_HEIGHT), 1)  # 1: clear the frame

    if "EPD_FONT_PATH" in os.environ:
        font_path = os.environ['EPD_FONT_PATH']
    else:
        font_path = '/usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf'

    draw_fit_text_to_image(
        image,
        font_path,
        weather_data['telop'],
        # 縦半分の高さで、y軸0始点
        (EPD_WIDTH, EPD_HEIGHT / 2),
        (0, 0))

    temperture_text = "最高気温" + weather_data['max_temperature'] + "度"

    draw_fit_text_to_image(
        image,
        font_path,
        temperture_text,
        # 縦半分の高さで、y軸中央を始点
        (EPD_WIDTH, EPD_HEIGHT / 2),
        (0, EPD_HEIGHT / 2))

    epd.display_frame(epd.get_frame_buffer(image))


def draw_fit_text_to_image(image, font_path, text, window_size, window_offset):
    font_pt = get_fit_font_pt(font_path, text, window_size[0], window_size[1])

    font = ImageFont.truetype(font_path, font_pt)

    draw = ImageDraw.Draw(image)
    offset = get_offset_for_centering(window_size, font.getsize(text))

    draw.text(
        (offset[0] + window_offset[0], offset[1] + window_offset[1]),
        text,
        font=font,
        fill=0)


def get_fit_font_pt(font_path, text, canvas_w, canvas_h):
    pt = 0
    max_pt = 256

    while True:
        # too bulldoze method. but e-paper is more than slow.
        pt = pt + 1
        if max_pt < pt:
            break

        font = ImageFont.truetype(font_path, pt)
        font_w, font_h = font.getsize(text)

        if font_w > canvas_w:
            break
        if font_h > canvas_h:
            break

    return pt - 1


def get_offset_for_centering(canvas_size, img_size):
    x = 0
    y = 0
    # print(canvas_size)
    # print(canvas_size[0])
    # print(img_size)
    # print(img_size[0])

    if canvas_size[0] > img_size[0]:
        x = int((canvas_size[0] - img_size[0]) / 2)
    if canvas_size[1] > img_size[1]:
        y = int((canvas_size[1] - img_size[1]) / 2)

    return x, y


if __name__ == '__main__':
    main()
