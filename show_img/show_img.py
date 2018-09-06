#!/usr/bin/python3.5
#
# e-paper nafuda sample code.
# just draw to e-paper program.
#
# usage:
# $ python show_img.py your_image.png
#
# for development.
# $ export PSEUDO_EPD_MODE=1
# $ python show_img.py your_image.png
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

sys.path.append(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + '/../lib'))

from nafuda import Nafuda


def main():
    if len(sys.argv) != 2:
        show_help()
        sys.exit()

    if sys.argv[1] == '-h' or sys.argv[1] == '--help':
        show_help()
        sys.exit()

    file_path = sys.argv[1]

    if not os.path.isfile(file_path):
        print('file not found :' + file_path)
        sys.exit()

    nafuda = Nafuda()

    # Orientation 90 is vertical nafuda mode. 0 is horizontal
    nafuda.draw_image_file(file_path, orientation=90)


def show_help():
    print("usage: show_img.py filename.png\n")


if __name__ == '__main__':
    main()
