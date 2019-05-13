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

    results_fix_bits = []
    results_fix_vals_relu = []
    results_fix_vals_sig = []
    result_floathp_relu = 0;
    result_floathp_sig = 0;

    result_ulaw_relu = 0;
    result_ulaw_sig = 0;


    results_fix_file = open("results/tst1_dnn_fix_relu.log", "r")
    results_fix_str = results_fix_file.read().split("\n")

    for s in results_fix_str:
        if s == '':
            continue
        tmp = re.sub(':', ' ', s).strip()
        tmp = re.sub('FIX', ' ', tmp).strip()
        tmp = re.sub('\s+', ' ', tmp).strip()
        v = tmp.split(' ');
        results_fix_bits.append(int(v[0]))
        results_fix_vals_relu.append(float(v[1]))

    results_fix_file_sig = open("results/tst2_dnn_fix_sigmoid.log", "r")
    results_fix_str_sig = results_fix_file_sig.read().split("\n")
    
    for s in results_fix_str_sig:
        if s == '':
            continue
        tmp = re.sub(':', ' ', s).strip()
        tmp = re.sub('FIX', ' ', tmp).strip()
        tmp = re.sub('\s+', ' ', tmp).strip()
        v = tmp.split(' ');
        results_fix_vals_sig.append(float(v[1]))


    results_fhp_file = open("results/tst4_dnn_fp16.log", "r")
    results_fhp_str = results_fhp_file.read()
    results_fhp_str = re.sub('\s+', ' ', results_fhp_str).strip()
    results_fhp_str = results_fhp_str.split(" ")

    result_floathp_relu = float(results_fhp_str[1])
    result_floathp_sig = float(results_fhp_str[3])

    results_ulaw_file = open("results/tst3_dnn_ulaw.log", "r")
    results_ulaw_str = results_ulaw_file.read()
    results_ulaw_str = re.sub('\s+', ' ', results_ulaw_str).strip()
    results_ulaw_str = results_ulaw_str.split(" ")

    result_ulaw_relu = float(results_ulaw_str[1])
    result_ulaw_sig = float(results_ulaw_str[3])

    label = []
    err_relu = []
    err_sig = []

    for i  in range(len(results_fix_bits)):
            label.append("fix_%d" % results_fix_bits[i])
            err_relu.append(results_fix_vals_relu[i])
            err_sig.append(results_fix_vals_sig[i])

    label.append("float_hp")
    err_relu.append(result_floathp_relu)
    err_sig.append(result_floathp_sig)

    label.append("u-law")
    err_relu.append(result_ulaw_relu)
    err_sig.append(result_ulaw_sig)


    return (label, err_relu, err_sig)

def plot_err_relu():
    data = gen_stats();
    data_relu = [ 100*(1-(x/5000.0)) for x in data[1]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index, data_relu, width=0.4)
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('err rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Error rate for relu activation function')
    plt.savefig('graph/err_rate_relu.png', bbox_inches='tight')
    plt.clf()

def plot_err_sig():
    data = gen_stats();
    data_sig = [ 100*(1-(x/5000.0)) for x in data[2]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index, data_sig, width=0.4)
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('err rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Error rate for sigmoid activation function')
    plt.savefig('graph/err_rate_sigmoid.png', bbox_inches='tight')
    plt.clf()

def plot_err_combined():
    data = gen_stats();
    data_relu = [ 100*(1-(x/5000.0)) for x in data[1]]
    data_sig = [ 100*(1-(x/5000.0)) for x in data[2]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index-.2, data_relu, width=0.4, label="ReLU")
    plt.bar(index+.2, data_sig, width=0.4, label="Sigmoid")
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('err rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Error rate')
    plt.legend()
    plt.savefig('graph/err_rate_combined.png', bbox_inches='tight')
    plt.clf()

def plot_success_relu():
    data = gen_stats();
    data_relu = [ 100*(x/5000.0) for x in data[1]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index, data_relu, width=0.4)
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('success rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Success rate for relu activation function')
    plt.savefig('graph/success_rate_relu.png', bbox_inches='tight')
    plt.clf()

def plot_success_sig():
    data = gen_stats();
    data_sig = [ 100*(x/5000.0) for x in data[2]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index, data_sig, width=0.4)
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('success rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Success rate for sigmoid activation function')
    plt.savefig('graph/success_rate_sigmoid.png', bbox_inches='tight')
    plt.clf()

def plot_success_combined():
    data = gen_stats();
    data_relu = [ 100*(x/5000.0) for x in data[1]]
    data_sig = [ 100*(x/5000.0) for x in data[2]]

    # this is for plotting purpose
    index = np.arange(len(data[0]))
    #plt.style.use('grayscale')
    plt.bar(index-.2, data_relu, width=0.4, label="ReLU")
    plt.bar(index+.2, data_sig, width=0.4, label="Sigmoid")
    plt.xlabel('Representation', fontsize=12)
    plt.ylabel('success rate [%]', fontsize=12)
    plt.xticks(index, data[0], fontsize=8, rotation=30)
    plt.yticks([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100])
    plt.title('Success rate')
    plt.legend()
    plt.savefig('graph/success_rate_combined.png', bbox_inches='tight')
    plt.clf()

if __name__ == "__main__":
    plot_err_relu()
    plot_err_sig()
    plot_err_combined()

    plot_success_relu()
    plot_success_sig()
    plot_success_combined()
