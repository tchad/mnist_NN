#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import re
import dnn
import scipy.io

'''
Descriptor File format
<#layers> <#neurons #inputs #one_bias scale_arg scale_w>[n] <fnc:ReLu|Sig|SigLUT>
'''


def load_DNN_descriptor(filename):
    data_s_x66 = ''
    with open(filename, 'r') as f:
        data_s_x66 = f.read().replace('\n', ' ')

    data_s_x66 = re.sub('\s+', ' ', data_s_x66).strip()
    data_list_s_x66 = data_s_x66.split(' ')

    desc_x66 = dnn.DNN_FC_DESC()
    desc_x66.layers_count = int(data_list_s_x66[0])

    for l in range(0, desc_x66.layers_count):
        n_neurons_x66 = int(data_list_s_x66[1 + l * 5])
        n_inputs_x66 = int(data_list_s_x66[1 + l * 5 + 1])
        one_bias_x66 = int(data_list_s_x66[1 + l * 5 + 2])
        one_bias_x66 = True if one_bias_x66 == 1 else False
        scalea_x66 = int(data_list_s_x66[1 + l * 5 + 3])
        scalew_x66 = int(data_list_s_x66[1 + l * 5 + 4])


        tmp_x66 = dnn.DNN_FC_LAYER(l, n_neurons_x66, n_inputs_x66, one_bias_x66, scalea_x66, scalew_x66)
        desc_x66.layers.append(tmp_x66)

    desc_x66.activation_fnc = data_list_s_x66[1 + 5 * desc_x66.layers_count]

    return desc_x66


'''
This version is tested with matlab v6 .mat files.
Use save -6 file.mat A B C when saving data from matlab
'''


def load_DNN_weights(filename):
    mat_data_x66 = scipy.io.loadmat(filename)

    keys_full_x66 = list(mat_data_x66.keys())
    keys_x66 = keys_full_x66[3:]

    ret_x66 = []

    for key in keys_x66:
        ret_x66.append(mat_data_x66[key])

    return ret_x66


def load_data(filename):
    mat_data_x66 = scipy.io.loadmat(filename)

    ret_x66 = {"X": mat_data_x66['X'],
           "y": mat_data_x66['y']
           }

    return ret_x66
