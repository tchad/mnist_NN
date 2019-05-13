#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import util
import math
from collections import namedtuple
import numpy as np
import float_hp


def ReLU(x):
    # general high accuracy ReLu activation function
    if float(x) > 0:
        return x
    else:
        if isinstance(x, float):
            return float(0)
        else:
            # return zero object
            return x.zero()

def ReLU_scaled(x, scale):
    return ReLU(x)

def Sigmoid(x):
    # General high accuracy sigmoid
    n_x66 = float(x)
    y_x66 = 1 / (1 + math.exp(-n_x66))

    if isinstance(x, float):
        return y_x66
    else:
        return x.clone(y_x66)

def Sigmoid_scaled(x, scale):
    # General high accuracy sigmoid
    n_x66 = float(x)
    y_x66 = 1 / (1 + math.exp(-n_x66*scale))

    return x.clone(y_x66)

class Neuron():
    def __init__(self, weights, fnc, level=0, position=0, act_in_scale=1):
        if len(weights) < 1:
            raise TypeError("Neuron: Empty weights list")
        self.w_x66 = weights
        self.f_x66 = fnc
        self.lvl_x66 = level
        self.pos_x66 = position
        self.scale_x66 = act_in_scale

    def weights(self):
        return self.w_x66

    def weights_size(self):
        return len(self.w_x66)

    def level(self):
        return self.lvl_x66

    def position(self):
        return self.pos_x66

    def process(self, x):
        if len(x) < 1:
            raise TypeError("Neuron L[%d] I[%d]: Empty arg list" % (self.lvl_x66, self.pos_x66))

        if len(x) != len(self.w_x66):
            raise TypeError("Neuron L[%d] I[%d]: Incompatibile vector sizes" % (self.lvl_x66, self.pos_x66))

        if type(x[0]) != type(self.w_x66[0]):
            raise TypeError("Neuron L[%d] I[%d]: Incompatibile vector types" % (self.lvl_x66, self.pos_x66))

        # compute partial sums
        psum_x66 = [x * w for x, w in zip(x, self.w_x66)]

        # check is partial sums contain any NaN's
        for n in psum_x66:
            if util.is_nan(n):
                raise TypeError("Neuron L[%d] I[%d]: NaN present in partial sums" % (self.lvl_x66, self.pos_x66))

        # sum the partial sums
        sum_x66 = psum_x66[0]
        for n in psum_x66[1:]:
            sum_x66 = sum_x66 + n

        return self.f_x66(sum_x66, self.scale_x66)


DNN_FC_LAYER = namedtuple("DNN_FC_LAYER", "layer num_neurons num_inputs one_bias scale_arg scale_w")


class DNN_FC_DESC():
    # descriptor for fully connected portion if NN
    def __init__(self):
        self.layers_count = 0
        self.layers = []
        self.activation_fnc = ''


class DNN_FC():
    # DNN block consisting of fully connected layers
    def __init__(self, descriptor, weights_array, activation_function, num_prototype):
        self.desc_x66 = descriptor
        self.w_x66 = weights_array
        self.fnc_x66 = activation_function
        self.proto_x66 = num_prototype

    def infer(self, X):
        # prescale arguments
        args_x66 = X

        for layer in range(self.desc_x66.layers_count):
            # load descriptor of current layer
            curr_layer_x66 = self.desc_x66.layers[layer]

            # special workflow for first layer as the numbers come as floats
            if layer == 0:
                # add bias 1 element if specified in descriptor
                if curr_layer_x66.one_bias == True:
                    args_x66 = [1] + X

                # scale input args and convert to proper number representation
                args_x66 = [self.proto_x66.clone(i / curr_layer_x66.scale_arg) for i in args_x66]
            else:
                # add bias 1 element if specified in descriptor
                if curr_layer_x66.one_bias == True:
                    args_x66 = [self.proto_x66.clone(1)] + args_x66

                # scale input args and convert to proper number representation
                args_x66 = [i.scale(curr_layer_x66.scale_arg) for i in args_x66]

            out_x66 = []
            # process every neuron
            for n in range(curr_layer_x66.num_neurons):
                # load raw weights from input data
                w_raw_x66 = self.w_x66[layer][n]

                # scale and convert weights to proper number representation
                w_x66 = [self.proto_x66.clone(i / curr_layer_x66.scale_w) for i in w_raw_x66]

                #compute pre activation function scale
                act_scale_x66 = (curr_layer_x66.scale_w * curr_layer_x66.scale_arg)

                # instantiate neuron
                neuron_x66 = Neuron(w_x66, self.fnc_x66, level=layer, position=n, act_in_scale=act_scale_x66)

                # calculate neuron
                result_x66 = neuron_x66.process(args_x66)

                # add result to output
                out_x66.append(result_x66)

            # assign outputs as next stage args
            args_x66 = out_x66

        return args_x66

def Sigmoid_FP16(x):
    if np.isnan(x) or np.isneginf(x):
        x = np.float16(-50)
    elif np.isposinf(x):
        x = np.float16(50)

    return  np.float16(1) / (np.float16(1) + np.exp(-x))

def ReLU_FP16(x):
    # general high accuracy ReLu activation function
    if x > 0:
        return x
    else:
        return np.float16(0)

class Neuron_FP16():
    def __init__(self, weights, fnc, level=0, position=0):
        if len(weights) < 1:
            raise TypeError("Neuron: Empty weights list")
        self.w_x66 = weights
        self.f_x66 = fnc
        self.lvl_x66 = level
        self.pos_x66 = position

    def weights(self):
        return self.w_x66

    def weights_size(self):
        return len(self.w_x66)

    def level(self):
        return self.lvl_x66

    def position(self):
        return self.pos_x66

    def process(self, x):
        if len(x) < 1:
            raise TypeError("Neuron L[%d] I[%d]: Empty arg list" % (self.lvl_x66, self.pos_x66))

        if len(x) != len(self.w_x66):
            raise TypeError("Neuron L[%d] I[%d]: Incompatibile vector sizes" % (self.lvl_x66, self.pos_x66))

        if type(x[0]) != type(self.w_x66[0]):
            raise TypeError("Neuron L[%d] I[%d]: Incompatibile vector types" % (self.lvl_x66, self.pos_x66))

        # compute partial sums
        psum_x66 = [x * w for x, w in zip(x, self.w_x66)]

        # check is partial sums contain any NaN's
        for n in psum_x66:
            if np.isnan(n):
                raise TypeError("Neuron L[%d] I[%d]: NaN present in partial sums" % (self.lvl_x66, self.pos_x66))

        # sum the partial sums
        sum_x66 = psum_x66[0]
        for n in psum_x66[1:]:
            sum_x66 = sum_x66 + n

        return self.f_x66(sum_x66)

class DNN_FC_FP16():
    # DNN block consisting of fully connected layers
    def __init__(self, descriptor, weights_array, activation_function):
        self.desc_x66 = descriptor
        self.w_x66 = weights_array
        self.fnc_x66 = activation_function

    def infer(self, X):
        args_x66 = [np.float16(x) for x in X]

        for layer in range(self.desc_x66.layers_count):
            # load descriptor of current layer
            curr_layer_x66 = self.desc_x66.layers[layer]

            # add bias 1 element if specified in descriptor
            if curr_layer_x66.one_bias == True:
                args_x66 = [np.float16(1)] + args_x66

            out_x66 = []
            # process every neuron
            for n in range(curr_layer_x66.num_neurons):
                # load raw weights from input data
                w_raw_x66 = self.w_x66[layer][n]
                w_x66 = [np.float16(i) for i in w_raw_x66]

                # instantiate neuron
                neuron_x66 = Neuron_FP16(w_x66, self.fnc_x66, level=layer, position=n)

                # calculate neuron
                result_x66 = neuron_x66.process(args_x66)

                # add result to output
                out_x66.append(result_x66)

            # assign outputs as next stage args
            args_x66 = out_x66

        return args_x66
