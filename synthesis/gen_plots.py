#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import matplotlib.pyplot as plt
import re
import numpy as np

def gen_stats():
    label = []
    lut_relu = []
    reg_relu = []
    dsp_relu = []
    lut_sig = []
    reg_sig = []
    dsp_sig = []


    data_file = open("synth.log", 'r')
    data_file.readline()
    data_str = data_file.read()
    data = data_str.split('\n')

    for l in data:
        if l == '':
            continue
        l_data = l.split(' ')
        label.append(l_data[0])
        lut_relu.append(float(l_data[1]))
        reg_relu.append(float(l_data[2]))
        dsp_relu.append(float(l_data[3]))
        lut_sig.append(float(l_data[4]))
        reg_sig.append(float(l_data[5]))
        dsp_sig.append(float(l_data[6]))

    return (label, lut_relu, reg_relu, dsp_relu, lut_sig, reg_sig, dsp_sig)

def generate_usage_plot_relu():
    data = gen_stats()

    # this is for plotting purpose
    index = np.arange(len(data[0]))

    plt.bar(index-.3, data[1], width=0.3, label="LUT")
    plt.bar(index, data[2], width=0.3, label="REG")
    plt.bar(index+.3, data[3], width=0.3, label="DSP")
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('Usage [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50])
    plt.title('Resource usage ReLU')
    plt.legend()
    plt.savefig('graph/resources_usage_relu.png', bbox_inches='tight')
    plt.clf()

def generate_usage_plot_sigmoid():
    data = gen_stats()

    # this is for plotting purpose
    index = np.arange(len(data[0]))

    plt.bar(index-.3, data[4], width=0.3, label="LUT")
    plt.bar(index, data[5], width=0.3, label="REG")
    plt.bar(index+.3, data[6], width=0.3, label="DSP")
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('Usage [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50])
    plt.title('Resource usage Sigmoid')
    plt.legend()
    plt.savefig('graph/resources_usage_sigmoid.png', bbox_inches='tight')
    plt.clf()


if __name__ == "__main__":
    generate_usage_plot_relu()
    generate_usage_plot_sigmoid()
