#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import math
from enum import Enum
import util
import dnn
import bitstring


class RSz(Enum):
    LARGR = 1
    SMALLER = 2
    CUSTOM = 3


class Num:
    """Represents bit accurate half precision fixed point number"""

    def __init__(self, num, N, create_nan=False):
        if not (type(N) is int) or (N <= 0):
            raise TypeError("Fix_hp: Expected N to be positive integer")

        self.N_x66 = N

        if create_nan == True:
            self.val_x66 = math.nan
        elif num >= 1.0:
            tmp_x66 = create_max(N)
            self.val_x66 = tmp_x66.val_x66
        elif num <= -1.0:
            tmp_x66 = create_min(N)
            self.val_x66 = tmp_x66.val_x66
        else:
            n_x66 = num * (2 ** (N - 1))
            self.val_x66 = util.round(n_x66)

    def __add__(self, o):
        f = lambda x, y: x + y
        return op(f, self, o)

    def __sub__(self, o):
        f = lambda x, y: x - y
        return op(f, self, o)

    def __mul__(self, o):
        f = lambda x, y: x * y
        return op(f, self, o)

    def __truediv__(self, o):
        f = lambda x, y: x / y
        return op(f, self, o)

    def __float__(self):
        # Undefined behavior if nan() == True
        return self.val_x66 / (2 ** (self.N_x66 - 1))

    def v(self):
        return self.val_x66

    def size(self):
        return self.N_x66

    def is_nan(self):
        return math.isnan(self.val_x66)

    def zero(self):
        # clones the class with all its parameters but the value of 0
        return create_zero(self.N_x66)

    def max(self):
        # clones the class with all its parameters but the maximum value
        return create_max(self.N_x66)

    def min(self):
        # clones the class with all its parameters but the minimum value
        return create_min(self.N_x66)

    def clone(self, num):
        # clones the object type with all class parameters and new value
        return Num(num, self.N_x66)

    def scale(self, s):
        return Num(float(self) / s, self.N_x66)

    def to_bin_string(self):
        mask = 0
        for i in range(0,self.N_x66):
            mask = mask | (1 << i)
        
        masked = self.val_x66 & mask
        b = bitstring.Bits(uint=masked, length=self.N_x66)
        return b.bin


def r_sz_sel(a, b, sel, custom):
    # select bit size for resulting value
    if a.size() > b.size():
        larger_x66 = a.size()
        smaller_x66 = b.size()
    else:
        larger_x66 = b.size()
        smaller_x66 = a.size()

    if sel == RSz.LARGR:
        return larger_x66
    elif sel == RSz.SMALLER:
        return smaller_x66
    else:
        return custom


def op(f, a, b, result_size=RSz.LARGR, cust_size=None):
    # generalized version of operations taking the actual math operation as lambda function
    if a.is_nan() == True or b.is_nan() == True:
        result_x66 = Num(0, 1, create_nan=True)
    else:
        r_x66 = f(float(a), float(b))
        s_x66 = r_sz_sel(a, b, result_size, cust_size)
        result_x66 = Num(r_x66, s_x66)

    return result_x66


def create_max(N):
    tmp_x66 = 0
    for n in range(0, N-1 ):
        tmp_x66 = tmp_x66 | (1 << n)

    v_x66 = Num(0, N)
    v_x66.val_x66 = tmp_x66

    return v_x66


def create_min(N):
    # inverts all bits of max value creates min -1
    tmp_x66 = create_max(N).val_x66

    v_x66 = Num(0, N)
    v_x66.val_x66 = ~tmp_x66 | 0x1

    return v_x66


def create_zero(N):
    return Num(0, N)


class SigmoidLUT():
    def __init__(self, bits, accuracy):
        self.N_x66 = bits
        self.A_x66 = accuracy

        # create lut

    def generate(self, bits, accuracy, scale):
        lut_x66 = []
        shl_x66 = bits - accuracy

        # determine max
        max_val_x66 = 1
        for i in range(accuracy - 1):
            max_val_x66 = (max_val_x66 << 1) + 1

        val_x66 = 0
        sign_bit_x66 = 1 << (accuracy - 1)
        while val_x66 <= max_val_x66:
            # saturate if sign bit is 1
            if (val_x66 & sign_bit_x66) != 0:
                v_x66 = val_x66 | ~max_val_x66
            else:
                v_x66 = val_x66

            # shift by proper amount
            v_x66 = v_x66 << shl_x66

            n_x66 = Num(0, bits)
            n_x66.val_x66 = v_x66

            y_x66 = dnn.Sigmoid_scaled(n_x66, scale)
            # raw unshifted binary value will be the index
            lut_x66.append((y_x66, n_x66))
            val_x66 = val_x66 + 1

        return lut_x66


    def __call__(self, x, scale):
        lut = self.generate(self.N_x66, self.A_x66, scale)

        max_val_x66 = 1
        for i in range(self.A_x66 - 1):
            max_val_x66 = (max_val_x66 << 1) + 1

        shr_x66 = self.N_x66 - self.A_x66
        v_x66 = x.v()

        # shift our truncated lsb
        v_x66 = v_x66 >> shr_x66

        # mask out unused bits to the left
        v_x66 = v_x66 & max_val_x66

        return lut[v_x66][0]

    def raw_lut(self, scale):
        return self.generate(self.N_x66, self.A_x66, scale);

    def float_lut(self, scale):
        lut = self.raw_lut(scale)
        ret_x66 = [(float(n[0]), float(n[1])) for n in lut]
        return ret_x66
