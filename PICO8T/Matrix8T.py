# SPDX-License-Identifier: MIT

"""
`8T Matrix`
====================================================

This drives an 80 RGB pixel charlieplexed matrix

* Author: Bertrand Le Roy
"""

import board
import digitalio
import time

class Matrix8T:
    """A 80 RGB pixels charlieplexed LED matrix"""
    red = 0x30
    green = 0x0C
    blue = 0x03
    black = 0x00
    white = 0x3F
    magenta = 0x33
    cyan = 0x0F
    yellow = 0x3C

    gpio = [digitalio.DigitalInOut(getattr(board, 'GP' + str(i))) for i in range(0, 16)]
    flicker_patterns = [
        [0, 0, 0], #0
        [1, 0, 0], #1
        [1, 0, 1], #2
        [1, 1, 1], #3
    ]

    def __init__(self):
        self.screen = [ [ Matrix8T.black for i in range(0, 10) ] for j in range(0, 8) ]
        self._pin1 = -1
        self._pin2 = -1
        for i in range(0, 16):
            pin = Matrix8T.gpio[i]
            pin.switch_to_input(None)
        self.cycle = 0

    def _connect(self, first, second):
        if self._pin1 != -1:
            Matrix8T.gpio[self._pin1].switch_to_input(None)
        if self._pin2 != -1:
            Matrix8T.gpio[self._pin2].switch_to_input(None)
        pin1 = Matrix8T.gpio[first]
        pin1.switch_to_output(True)
        self._pin1 = first
        pin2 = Matrix8T.gpio[second]
        pin2.switch_to_output(False)
        self._pin2 = second

    def _color_offset(self, color):
        return 0 if color == Matrix8T.red else 1 if color == Matrix8T.green else 2

    def _light_pixel(self, row, col, color):
        pin1 = row * 2 + int(col / 5)
        pin2 = self._color_offset(color) + (col % 5) * 3
        if pin2 >= pin1:
            pin2 = pin2 + 1
        self._connect(pin1, pin2)

    def set(self, row, col, color):
        self.screen[row][col] = color

    def get(self, row, col):
        return self.screen[row][col]

    def refresh(self):
        for row in range(0, 8):
            for col in range(0, 10):
                color = self.screen[row][col]
                if color != Matrix8T.black:
                    red_intensity = (color & 0x30) >> 4
                    green_intensity = (color & 0x0C) >> 2
                    blue_intensity = color & 0x03
                    if Matrix8T.flicker_patterns[red_intensity][self.cycle] == 1:
                        self._light_pixel(row, col, Matrix8T.red)
                    if Matrix8T.flicker_patterns[green_intensity][self.cycle] == 1:
                        self._light_pixel(row, col, Matrix8T.green)
                    if Matrix8T.flicker_patterns[blue_intensity][self.cycle] == 1:
                        self._light_pixel(row, col, Matrix8T.blue)
        self.cycle = (self.cycle + 1) % 3

matrix = Matrix8T()

for i in range(Matrix8T.black, Matrix8T.white + 1):
    matrix.set(int(i / 8), i % 8 + 1, i)

print(f'About to display {matrix.screen}')

while True:
    matrix.refresh()

