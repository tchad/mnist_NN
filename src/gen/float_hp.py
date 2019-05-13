#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import math
import util
import dnn
import numpy as np

NBIT_MANTISA_FLOAT_HP = 10

class SigmoidLUT():
    def __init__(self, lsb_discard):
        if lsb_discard > 9:
            raise TypeError("Float_hp, SigmoidLUT: discarded lsb bits above 9")
        self.A_x66 = lsb_discard
        self.lut_x66 = []

        # create lut
        shl_x66 = lsb_discard

        sign_bit_x66 = 1 << (10 - lsb_discard)

        # determine max
        max_val_x66 = 1
        for i in range(10 - lsb_discard):
            max_val_x66 = (max_val_x66 << 1) + 1

        val_x66 = 0
        while val_x66 <= max_val_x66:
            if (val_x66 & sign_bit_x66) != 0:
                neg = True
                v_x66 = val_x66 ^ sign_bit_x66
            else:
                neg = False
                v_x66 = val_x66
            v_x66 = v_x66 << shl_x66

            fn_x66 = v_x66 / (2 ** NBIT_MANTISA_FLOAT_HP)
            if neg == True:
                fn_x66 = -fn_x66

            n_x66 = Num(fn_x66)

            y_x66 = dnn.Sigmoid(n_x66)
            self.lut_x66.append((y_x66, n_x66))
            val_x66 = val_x66 + 1

    def __call__(self, x):
        v_x66 = x.v()
        sign_bit_x66 = 1 << (10 - self.A_x66)
        if v_x66 < 0:
            neg_x66 = True
            v_x66 = -v_x66
        else:
            neg_x66 = False

        iv_x66 = math.floor(v_x66 * (2 ** NBIT_MANTISA_FLOAT_HP))
        iv_x66 = iv_x66 >> self.A_x66
        if neg_x66 == True:
            iv_x66 = iv_x66 | sign_bit_x66

        return self.lut_x66[iv_x66][0]

    def raw_lut(self):
        return self.lut_x66

    def float_lut(self):
        ret_x66 = [(float(n[0]), float(n[1])) for n in self.lut_x66]
        return ret_x66
