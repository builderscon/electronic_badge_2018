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

import urllib.request
import json
from pprint import pprint


class Weather:

    @staticmethod
    def get_data(city_id=130010):
        # Livedoor Weather Web Service
        # http://weather.livedoor.com/weather_hacks/webservice
        url = 'http://weather.livedoor.com/forecast/webservice/json/v1'
        params = {
            'city': city_id,
        }

        req = urllib.request.Request('{}?{}'.format(url, urllib.parse.urlencode(params)))
        with urllib.request.urlopen(req) as res:
            body = res.read()

        return json.loads(body.decode('utf-8'))

    @staticmethod
    def get_usable_array(city_id):
        data = Weather.get_data(city_id)
        # pprint(data['forecasts'])

        telop = data['forecasts'][0]['telop']

        if data['forecasts'][0]['temperature']['max'] is None:
            max_temperture = "データ無し"
        else:
            max_temperture = data['forecasts'][0]['temperature']['max']['celsius']

        return {
            'telop': telop,
            'max_temperature': max_temperture
        }


if __name__ == '__main__':
    pprint(Weather.get_usable_array(130010))
