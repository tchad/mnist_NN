#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import math
import fixed
import dnn
import bitstring

NBIT_INTERMEDIATE = 14


class Num():
    """Represents but accurate u-law representation"""

    def __init__(self, num, create_nan=False):
        # create simple nan if indicated by argument
        if create_nan == True:
            self.val_x66 = math.nan
        else:
            # CONVERSION TO U-LAW
            # [1] Reuse the fixed point module to obtain 14 bit fixed representation
            f14_x66 = fixed.Num(num, NBIT_INTERMEDIATE)

            # [2] save sign and negate if less than one
            if f14_x66.v() < 0:
                sign_x66 = 1
                n_x66 = -f14_x66.v()
            else:
                sign_x66 = 0
                n_x66 = f14_x66.v()

            # [3] add 33 bias
            n_x66 = n_x66 + 33

            # [4] if 14th bit and above are 1 after adding bias then , staurate
            if (n_x66 & 0xE000) != 0:
                if sign_x66 == 1:
                    # create min negative
                    tmp_x66 = create_min()
                else:
                    # create max positive
                    tmp_x66 = create_max()

                self.val_x66 = tmp_x66.val_x66
                return

            # [5] determine the chord
            # start from the largest chord
            chord_pos_x66 = 0x1000

            # mask extracting ABCD synchronized with chord position
            ival_mask_x66 = 0xF00

            # shift that brings ABCD to LSB position
            # synchronized with chord position
            ival_shft_x66 = 8

            # chord index synchronized with chord position
            chord_x66 = 7

            # iterate over chord positions
            # adding 33 in [4] guarantees loop will stop
            while True:
                # if chord found
                if (n_x66 & chord_pos_x66) != 0:
                    # extract ABCD and bring to LSB and exit the loop
                    ival_x66 = (n_x66 & ival_mask_x66) >> ival_shft_x66
                    break
                else:
                    # progress the masks
                    chord_pos_x66 = chord_pos_x66 >> 1
                    ival_mask_x66 = ival_mask_x66 >> 1
                    ival_shft_x66 = ival_shft_x66 - 1
                    chord_x66 = chord_x66 - 1

            # [6] combine into bit representation
            n_x66 = (sign_x66 << 7) | (chord_x66 << 4) | ival_x66

            # [7] negate bits
            n_x66 = (n_x66 ^ 0xFF) & 0xFF

            self.val_x66 = n_x66

    def __add__(self, b):
        f = lambda x, y: x + y
        return op(f, self, b)

    def __sub__(self, b):
        f = lambda x, y: x - y
        return op(f, self, b)

    def __mul__(self, b):
        f = lambda x, y: x * y
        return op(f, self, b)

    def __truediv__(self, b):
        f = lambda x, y: x / y
        return op(f, self, b)

    def __float__(self):
        # reverse U_law conversion
        # [1] negate bits and cleanup 1's coming from 32bit int
        # working representation
        p_x66 = (self.val_x66 ^ 0xFF) & 0xFF

        # [2] put into table format 1ABCD1
        n_x66 = (1 << 5) | ((p_x66 & 0xF) << 1) | 1

        # [3] extract sign bit
        sh_x66 = (p_x66 & 0x70) >> 4

        # [4] shift acording to chord number and subtract 33
        r_x66 = (n_x66 << sh_x66) - 33

        # [5]  convert from fixed point representation to float
        r_x66 = float(r_x66) / (2 ** (NBIT_INTERMEDIATE - 1))

        # [6] restore sign
        if (p_x66 & 0x80) != 0:
            result_x66 = -r_x66
        else:
            result_x66 = r_x66

        return result_x66

    def v(self):
        return self.val_x66

    def is_nan(self):
        return math.isnan(self.val_x66)

    def zero(self):
        # clones the class with all its parameters but the value of 0
        return create_zero()

    def max(self):
        # clones the class with all its parameters but max value
        return create_max()

    def min(self):
        # clones the class with all its parameters but min value
        return create_min()

    def clone(self, num):
        return Num(num)

    def scale(self, s):
        return Num(float(self) / s)

    def to_bin_string(self):
        b = bitstring.Bits(uint=self.val_x66, length=8)
        return b.bin


def op(f, a, b):
    # generalized version of operations taking the actual math operation as lambda function
    if a.is_nan() == True or b.is_nan() == True:
        result_x66 = Num(0, create_nan=True)
    else:
        r_x66 = f(float(a), float(b))
        result_x66 = Num(r_x66)

    return result_x66


def create_max():
    v_x66 = Num(0)
    v_x66.val_x66 = 0x80
    return v_x66


def create_min():
    v_x66 = Num(0)
    v_x66.val_x66 = 0x00
    return v_x66


def create_zero():
    return Num(0)


class SigmoidLUT():
    def __init__(self, lsb_discard):
        if lsb_discard > 4:
            raise TypeError("U-LAW, SigmoidLUT: discarded lsb bits above 4")
        self.A_x66 = lsb_discard

    def generate(self, lsb_discard, scale):
        lut_x66 = []

        # create lut
        shl_x66 = lsb_discard

        # determine max
        max_val_x66 = 1
        for i in range(8 - lsb_discard - 1):
            max_val_x66 = (max_val_x66 << 1) + 1

        val_x66 = 0
        while val_x66 <= max_val_x66:
            v_x66 = val_x66 << shl_x66

            n_x66 = Num(0)
            n_x66.val_x66 = v_x66;

            y_x66 = dnn.Sigmoid_scaled(n_x66, scale)
            lut_x66.append((y_x66, n_x66))
            val_x66 = val_x66 + 1

        return lut_x66


    def __call__(self, x, scale):
        lut = self.generate(self.A_x66, scale)
        v_x66 = x.v()
        v_x66 = v_x66 >> self.A_x66

        return lut[v_x66][0]

    def raw_lut(self, scale):
        return self.generate(self.A_x66, scale)

    def float_lut(self, scale):
        lut = self.generate(scale)

        ret = [(float(n[0]), float(n[1])) for n in lut]
        return ret
