#!/usr/bin/python3.5
#
# for development.
# $ export PSEUDO_EPD_MODE=1
# $ python show_txt.py your_image.png
#
# if you want to use your font
# $ export EPD_FONT_PATH="/System/Library/Fonts/ヒラギノ角ゴシック W0.ttc"
# or
# $ export EPD_FONT_PATH="/System/Library/Fonts/Monaco.dfont"
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
import textwrap

sys.path.append(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + '/../lib'))

from nafuda import Nafuda


def main():
    if len(sys.argv) != 2:
        show_help()
        sys.exit()

    if sys.argv[1] == '-h' or sys.argv[1] == '--help':
        show_help()
        sys.exit()

    if sys.argv[1] == '-':
        # ここで一括で読むべきではないのでは？
        input_text = sys.stdin.read()

    else:
        file_path = sys.argv[1]

        if not os.path.isfile(file_path):
            print('file not found :' + file_path)
            sys.exit()

        with open(file_path) as f:
            # ここで一括で読むべきではないのでは？
            input_text = f.read()

    # print(input_text)

    if "EPD_FONT_PATH" in os.environ:
        font_path = os.environ['EPD_FONT_PATH']
    else:
        font_path = '/usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf'

    nafuda = Nafuda()

    # Orientation 90 is vertical nafuda mode. 0 is horizontal
    nafuda.draw_text(input_text, font_path=font_path, font_pt=16, orientation=90)


def show_help():
    print(textwrap.dedent('''\
    usage: 
    $ show_txt.py filename.txt
    $ echo abc | show_txt.py -
    '''))


if __name__ == '__main__':
    main()
