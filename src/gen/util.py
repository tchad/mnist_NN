#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import math


def range_check(num):
    if (float(num) < 1) and (float(num) >= -1):
        return True
    else:
        return False


def calculate_scaler_pwr2(data):
    # Finds smallest power or two scaler that converst all values to quentities below 1
    max_val = 0;
    for v in data:
        if abs(v) > max_val:
            max_val = abs(v)

    pwr = 0
    while (2 ** pwr) <= max_val:
        pwr = pwr + 1

    return 2 ** pwr


def round(num):
    """The standard round() function will not always produce bit accurate result.
       The rounding partially depends on the ability to represent certain number as float.
       Performing manual rounding
    """
    ret = 0
    if (num % 1) >= .5:
        ret = math.floor(num) + 1
    else:
        ret = math.floor(num)

    return ret


def is_nan(x):
    if type(x) == type(0.0):
        return math.isnan(x)
    else:
        return x.is_nan()


class Scaler():
    """Scales and restores data set"""

    def __init__(self, scale, bias=0):
        self.s_x66 = scale
        self.b_x66 = bias

    def scale_val(self):
        return self.s_x66

    def bias_val(self):
        return self.b_x66

    def scale(self, data):
        f = lambda v, b, s: (v + b) / float(s)
        return [f(n, self.b_x66, self.s_x66) for n in data]

    def restore(self, data):
        f = lambda v, b, s: (v * s) - b
        return [f(n, self.b_x66, self.s_x66) for n in data]
