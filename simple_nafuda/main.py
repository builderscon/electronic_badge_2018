#!/usr/bin/python3.5
#
# simple nafuda slide show
#
# for development.
# $ export PSEUDO_EPD_MODE=1
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
import time
import re

sys.path.append(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + '/../lib'))

from nafuda import Nafuda

if "IMG_DIR" in os.environ:
    IMG_DIR = os.environ["IMG_DIR"]
else:
    if os.path.exists('/mnt/virtual_sd/img/'):
        IMG_DIR = '/mnt/virtual_sd/img/'
    else:
        IMG_DIR = os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + '/img')


def main():
    # load image file list
    file_list = []
    for file in os.listdir(IMG_DIR):
        # get (png|jpg|jpeg|gif) files. and skip dot files.
        if re.search('^[^\.].+\.(png|jpg|jpeg|gif)', file, re.IGNORECASE):
            file_list.append(file)

    if len(file_list) == 0:
        print('no image, exit.')
        sys.exit(0)

    file_list.sort()

    print(file_list)

    nafuda = Nafuda()

    while True:
        for file in file_list:
            try:
                nafuda.draw_image_file(IMG_DIR + '/' + file, 90)

            except OSError:
                # maybe, the file is not correct image file.
                print("load image fail: " +file)

            if "PSEUDO_EPD_MODE" in os.environ:
                # guard for img bomb.
                time.sleep(3)


if __name__ == '__main__':
    main()