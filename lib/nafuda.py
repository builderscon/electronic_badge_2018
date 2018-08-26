#
# nafuda.py
#
# nafuda library
#
# LICENSE :
#
# Copyright (C) Aug 4 2018, Junichi Ishida <uzulla@himitsukichi.com>
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
import textwrap
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

# for development in PC.
if "PSEUDO_EPD_MODE" in os.environ:
    import epd4in2_mock as epd4in2
else:
    import epd4in2

EPD_WIDTH = 400
EPD_HEIGHT = 300

# VL-Gothic-Regular.ttf with 16pt
DISP_COLS = 37
DISP_ROWS = 20


# for test memo
# echo 12345678901234567890123456789012345678901234567890 | ./show_txt.py -
# echo -e "1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n" | ./show_txt.py -


class Nafuda:

    def __init__(self):
        # init epd lib
        self.epd = epd4in2.EPD()
        self.epd.init()

    def draw_text(
            self,
            text,
            orientation=0,
            font_path='/usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf',
            font_pt=16,
            max_col=DISP_COLS,
            max_row=DISP_ROWS):

        font = ImageFont.truetype(font_path, font_pt)

        if orientation != 0 and orientation % 90 == 0:
            w = EPD_HEIGHT
            h = EPD_WIDTH
        else:
            w = EPD_WIDTH
            h = EPD_HEIGHT

        image = Image.new('1', (w, h), 1)  # 1: clear the frame
        draw = ImageDraw.Draw(image)

        # XXX NEED NICE width CALC!!!

        # 72pt=96px -> 300pt(400px) 225pt(300px)
        # so, 12pt 25 x 18.75 chars
        # (really?)

        lines_count = 0
        print_str_list = []
        for line in text.split("\n"):
            wrapped_lines = textwrap.wrap(line, max_col)
            lines_count += len(wrapped_lines)
            print_str_list.append("\n".join(wrapped_lines))
            if max_row < lines_count:
                break

        print_str = "\n".join(print_str_list)
        # print(print_str)

        draw.text(
            (0, 0),
            print_str,
            font=font,
            fill=0)

        self.draw_image_buffer(image, orientation)

    def draw_image_file(self, path, orientation=0):
        image_buffer = Image.open(path)

        self.draw_image_buffer(image_buffer, orientation)

    def draw_image_buffer(self, image_buffer, orientation=0):

        # remove Alpha
        if len(image_buffer.split()) > 3:
            # make blank image
            _image_buffer = Image.new('RGB', image_buffer.size, "#FFFFFF")

            # draw image to center
            _image_buffer.paste(image_buffer, (0, 0), image_buffer.split()[3])

            # swap
            image_buffer = _image_buffer

        # rotate image buffer
        if orientation != 0:
            # rotate image (FYI 90=vertical(nafuda mode), 0=holizontal)
            image_buffer = image_buffer.rotate(orientation, 0, True)

        # resize image buffer
        w, h = image_buffer.size
        if EPD_WIDTH < w or EPD_HEIGHT < h:
            # resize
            image_buffer.thumbnail((EPD_WIDTH, EPD_HEIGHT))

            # make blank image
            _image_buffer = Image.new('1', (EPD_WIDTH, EPD_HEIGHT), 1)

            # draw image to center
            _image_buffer.paste(image_buffer, self.get_offset_for_centering((EPD_WIDTH, EPD_HEIGHT), image_buffer.size))

            # swap
            image_buffer = _image_buffer

        # centering
        w, h = image_buffer.size
        if EPD_WIDTH > w or EPD_HEIGHT > h:
            # make blank image
            _image_buffer = Image.new('1', (EPD_WIDTH, EPD_HEIGHT), 1)

            # draw image to center
            _image_buffer.paste(image_buffer, self.get_offset_for_centering((EPD_WIDTH, EPD_HEIGHT), image_buffer.size))

            # swap
            image_buffer = _image_buffer

        self.epd.display_frame(self.epd.get_frame_buffer(image_buffer))

    @staticmethod
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

    # XXX NEED NICE width CALC!!!
    # def get_font_wh_px(self, font_path, text, canvas_w, canvas_h):
    #     pt = 0
    #     max_pt = 256
    #
    #     while True:
    #         # too bulldoze method. but e-paper is more than slow.
    #         pt = pt + 1
    #         if max_pt < pt:
    #             break
    #
    #         font = ImageFont.truetype(font_path, pt)
    #         font_w, font_h = font.getsize(text)
    #
    #         if font_w > canvas_w:
    #             break
    #         if font_h > canvas_h:
    #             break
    #
    #     return pt - 1
