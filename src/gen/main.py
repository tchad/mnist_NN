#####################################################
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
#####################################################

import input_data
import multiprocessing
import fixed
import u_law
import bitstring
import numpy as np
import dnn

def gen_fix_data():
    descriptor_x66 = input_data.load_DNN_descriptor('descriptor.txt')
    weights_x66 = input_data.load_DNN_weights('weights.mat')
    data_x66 = input_data.load_data('data.mat')

    bits_array = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]

    for bits in bits_array:
        filename_X = "../data/fix_%d_X.mem" % bits
        filename_y = "../data/fix_%d_y.mem" % bits
        filename_mem = "../data/fix_%d.mem" % bits
        filename_mem_dbg = "../data/fix_%d.mem.dbg" % bits
        filename_mmap = "../data/fix_%d.mmap" % bits
        
        with open(filename_X, 'w+') as f:
            for tst_case in data_x66['X']:
                bias = 1.0/descriptor_x66.layers[0].scale_arg    
                bias_encoded = fixed.Num(bias,bits)
                f.write(bias_encoded.to_bin_string() + '\n')

                for val in tst_case:
                    v = float(val)/descriptor_x66.layers[0].scale_arg
                    v_encoded = fixed.Num(v,bits)
                    f.write(v_encoded.to_bin_string() + '\n')

        with open(filename_y, 'w+') as f:
            for y in data_x66['y']:
                f.write(str(int(y[0])) + '\n')

        counter = 0
        ADDR_BASE_A = 0
        ADDR_BASE_W = 0
        ADDR_BASE_LUT_L1 = 0
        ADDR_BASE_LUT_L2 = 0
        ADDR_LAST = 0

        with open(filename_mem, 'w+') as f:
            f_dbg = open(filename_mem_dbg, 'w+');
            #arg mem
            for z in range(401):
                n = fixed.Num(0,bits)
                f.write(n.to_bin_string() + '\n')
                counter = counter + 1

            ADDR_BASE_W = counter

            for arg_num in range(401):
                for neuron_w in range(25):
                    v = weights_x66[0][neuron_w][arg_num]
                    v = float(v)/descriptor_x66.layers[0].scale_w
                    v_encoded = fixed.Num(v, bits)
                    v_str = v_encoded.to_bin_string();
                    f.write(v_str + '\n')
                    f_dbg.write(v_str + ' #L1 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                    counter = counter + 1

            for arg_num in range(26):
                for neuron_w in range(10):
                    v = weights_x66[1][neuron_w][arg_num]
                    v = float(v)/descriptor_x66.layers[1].scale_w
                    v_encoded = fixed.Num(v, bits)
                    v_str = v_encoded.to_bin_string();
                    f.write(v_str + '\n')
                    f_dbg.write(v_str + ' #L2 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                    counter = counter + 1

            ADDR_BASE_LUT_L1 = counter
            lut = fixed.SigmoidLUT(bits,bits)
            l1_scale = descriptor_x66.layers[0].scale_arg * descriptor_x66.layers[0].scale_w
            for n in lut.raw_lut(l1_scale):
                v = n[0].scale(descriptor_x66.layers[1].scale_arg)
                f.write(v.to_bin_string() + '\n')
                f_dbg.write(" LUT L1: " + v.to_bin_string() + '\n')
                counter = counter + 1

            ADDR_BASE_LUT_L2 = counter
            lut = fixed.SigmoidLUT(bits,bits)
            l2_scale = descriptor_x66.layers[1].scale_arg * descriptor_x66.layers[1].scale_w
            for n in lut.raw_lut(l2_scale):
                v = n[0]
                f.write(v.to_bin_string() + '\n')
                f_dbg.write(" LUT L2: " + v.to_bin_string() + '\n')
                counter = counter + 1

            ADDR_LAST = counter

        with open(filename_mmap, 'w+') as f:
            bias = 1.0/descriptor_x66.layers[1].scale_arg    
            bias_encoded = fixed.Num(bias,bits)
            f.write('L2_ONE_BIAS_VAL: ' + bias_encoded.to_bin_string() + '\n')

            ADDR_BASE_A_BIN = bitstring.Bits(uint=ADDR_BASE_A, length=32).hex
            f.write('ADDR_BASE_A: ' + ADDR_BASE_A_BIN + '\n')

            ADDR_BASE_W_BIN = bitstring.Bits(uint=ADDR_BASE_W, length=32).hex
            f.write('ADDR_BASE_W: ' + ADDR_BASE_W_BIN + '\n')

            ADDR_BASE_LUT_BIN = bitstring.Bits(uint=ADDR_BASE_LUT_L1, length=32).hex
            f.write('ADDR_BASE_LUT L1: ' + ADDR_BASE_LUT_BIN + '\n')

            ADDR_BASE_LUT_BIN = bitstring.Bits(uint=ADDR_BASE_LUT_L2, length=32).hex
            f.write('ADDR_BASE_LUT L2: ' + ADDR_BASE_LUT_BIN + '\n')

            ADDR_LAST_BIN = bitstring.Bits(uint=ADDR_LAST, length=32).hex
            f.write('ADDR_LAST: ' + ADDR_LAST_BIN + '\n')

            SM1_SCALE = descriptor_x66.layers[0].scale_arg * descriptor_x66.layers[0].scale_w
            f.write('SM1_SCALE: ' + str(SM1_SCALE) + '\n')

            SM2_SCALE = descriptor_x66.layers[1].scale_arg * descriptor_x66.layers[1].scale_w
            f.write('SM2_SCALE: ' + str(SM2_SCALE) + '\n')

            SD1_SCALE = descriptor_x66.layers[0].scale_arg 
            f.write('SD1_SCALE: ' + str(SD1_SCALE) + '\n')

            SD2_SCALE = descriptor_x66.layers[1].scale_arg 
            f.write('SD2_SCALE: ' + str(SD2_SCALE) + '\n')

def gen_ulaw_data():
    descriptor_x66 = input_data.load_DNN_descriptor('descriptor.txt')
    weights_x66 = input_data.load_DNN_weights('weights.mat')
    data_x66 = input_data.load_data('data.mat')

    bits = 8
    filename_X = "../data/ulaw_X.mem" 
    filename_y = "../data/ulaw_y.mem" 
    filename_mem = "../data/ulaw.mem" 
    filename_mem_dbg = "../data/ulaw.mem.dbg" 
    filename_mmap = "../data/ulaw.mmap" 
    
    with open(filename_X, 'w+') as f:
        for tst_case in data_x66['X']:
            bias = 1.0/descriptor_x66.layers[0].scale_arg    
            bias_encoded = u_law.Num(bias)
            f.write(bias_encoded.to_bin_string() + '\n')

            for val in tst_case:
                v = float(val)/descriptor_x66.layers[0].scale_arg
                v_encoded = u_law.Num(v)
                f.write(v_encoded.to_bin_string() + '\n')
    with open(filename_y, 'w+') as f:
        for y in data_x66['y']:
            f.write(str(int(y[0])) + '\n')

    counter = 0
    ADDR_BASE_A = 0
    ADDR_BASE_W = 0
    ADDR_BASE_LUT = 0
    ADDR_LAST = 0

    with open(filename_mem, 'w+') as f:
        f_dbg = open(filename_mem_dbg, 'w+');
        #arg mem
        for z in range(401):
            n = u_law.Num(0)
            f.write(n.to_bin_string() + '\n')
            f_dbg.write(n.to_bin_string() + " #ARG PLACEHOLDER\n")
            counter = counter + 1

        ADDR_BASE_W = counter

        for arg_num in range(401):
            for neuron_w in range(25):
                v = weights_x66[0][neuron_w][arg_num]
                v = float(v)/descriptor_x66.layers[0].scale_w
                v_encoded = u_law.Num(v)
                v_str = v_encoded.to_bin_string();
                f.write(v_str + '\n')
                f_dbg.write(v_str + ' #L1 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                counter = counter + 1

        for arg_num in range(26):
            for neuron_w in range(10):
                v = weights_x66[1][neuron_w][arg_num]
                v = float(v)/descriptor_x66.layers[1].scale_w
                v_encoded = u_law.Num(v)
                v_str = v_encoded.to_bin_string();
                f.write(v_str + '\n')
                f_dbg.write(v_str + ' #L2 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                counter = counter + 1

        ADDR_BASE_LUT_L1 = counter
        lut = u_law.SigmoidLUT(0)
        l1_scale = descriptor_x66.layers[0].scale_arg * descriptor_x66.layers[0].scale_w
        lut_idx = 0
        for n in lut.raw_lut(l1_scale):
            v = n[0].scale(descriptor_x66.layers[1].scale_arg)
            f.write(v.to_bin_string() + '\n')
            f_dbg.write(v.to_bin_string() + " #LUT L1 IDX: %d (%.3f:%.3f)\n" %(lut_idx,float(n[1]),float(v)))
            counter = counter + 1
            lut_idx = lut_idx + 1

        ADDR_BASE_LUT_L2 = counter
        lut = u_law.SigmoidLUT(0)
        l2_scale = descriptor_x66.layers[1].scale_arg * descriptor_x66.layers[1].scale_w
        lut_idx = 0
        for n in lut.raw_lut(l2_scale):
            v = n[0]
            f.write(v.to_bin_string() + '\n')
            f_dbg.write(v.to_bin_string() + " #LUT L2 IDX: %d (%.3f:%.3f)\n" %(lut_idx,float(n[1]),float(v)))
            counter = counter + 1
            lut_idx = lut_idx + 1

        ADDR_LAST = counter

    with open(filename_mmap, 'w+') as f:
        bias = 1.0/descriptor_x66.layers[1].scale_arg    
        bias_encoded = u_law.Num(bias)
        f.write('L2_ONE_BIAS_VAL: ' + bias_encoded.to_bin_string() + '\n')
        bias_encoded = fixed.Num(bias,14)
        f.write('L2_ONE_BIAS_VAL_DEC: ' + bias_encoded.to_bin_string() + '\n')

        ADDR_BASE_A_BIN = bitstring.Bits(uint=ADDR_BASE_A, length=32).hex
        f.write('ADDR_BASE_A: ' + ADDR_BASE_A_BIN + '\n')

        ADDR_BASE_W_BIN = bitstring.Bits(uint=ADDR_BASE_W, length=32).hex
        f.write('ADDR_BASE_W: ' + ADDR_BASE_W_BIN + '\n')

        ADDR_BASE_LUT_BIN = bitstring.Bits(uint=ADDR_BASE_LUT_L1, length=32).hex
        f.write('ADDR_BASE_LUT_L1: ' + ADDR_BASE_LUT_BIN + '\n')

        ADDR_BASE_LUT_BIN = bitstring.Bits(uint=ADDR_BASE_LUT_L2, length=32).hex
        f.write('ADDR_BASE_LUT_L2: ' + ADDR_BASE_LUT_BIN + '\n')

        ADDR_LAST_BIN = bitstring.Bits(uint=ADDR_LAST, length=32).hex
        f.write('ADDR_LAST: ' + ADDR_LAST_BIN + '\n')

        SM1_SCALE = descriptor_x66.layers[0].scale_arg * descriptor_x66.layers[0].scale_w
        f.write('SM1_SCALE: ' + str(SM1_SCALE) + '\n')

        SM2_SCALE = descriptor_x66.layers[1].scale_arg * descriptor_x66.layers[1].scale_w
        f.write('SM2_SCALE: ' + str(SM2_SCALE) + '\n')

        SD1_SCALE = descriptor_x66.layers[0].scale_arg 
        f.write('SD1_SCALE: ' + str(SD1_SCALE) + '\n')

        SD2_SCALE = descriptor_x66.layers[1].scale_arg 
        f.write('SD2_SCALE: ' + str(SD2_SCALE) + '\n')

def to_bin_string(v):
    fp16 = np.float16(v)
    fp16_bytes = fp16.tobytes()
    msb = bitstring.Bits(uint=fp16_bytes[1],length=8)
    lsb = bitstring.Bits(uint=fp16_bytes[0],length=8)

    return msb.bin + lsb.bin

def to_hex_string(v):
    fp16 = np.float16(v)
    fp16_bytes = fp16.tobytes()
    msb = bitstring.Bits(uint=fp16_bytes[1],length=8)
    lsb = bitstring.Bits(uint=fp16_bytes[0],length=8)

    return msb.hex + lsb.hex

def generate_lut():
    ret = []

    for n in [np.uint16(x) for x in range(0,65536)]:
        b = n.tobytes();
        f = np.frombuffer(b, dtype=np.float16)[0]
        v = dnn.Sigmoid_FP16(f)
        ret.append(v)

    return ret


def gen_fp16_data():
    descriptor_x66 = input_data.load_DNN_descriptor('descriptor.txt')
    weights_x66 = input_data.load_DNN_weights('weights.mat')
    data_x66 = input_data.load_data('data.mat')

    filename_X = "../data/fp16_X.mem" 
    filename_y = "../data/fp16_y.mem" 
    filename_mem = "../data/fp16.mem" 
    filename_mem_dbg = "../data/fp16.mem.dbg" 
    filename_mmap = "../data/fp16.mmap" 
    
    with open(filename_X, 'w+') as f:
        for tst_case in data_x66['X']:
            bias = np.float16(1.0)
            f.write(to_bin_string(bias) + '\n')

            for val in tst_case:
                v = np.float16(val)
                f.write(to_bin_string(v) + '\n')

    with open(filename_y, 'w+') as f:
        for y in data_x66['y']:
            f.write(str(int(y[0])) + '\n')

    counter = 0
    ADDR_BASE_A = 0
    ADDR_BASE_W = 0
    ADDR_BASE_LUT = 0
    ADDR_LAST = 0

    with open(filename_mem, 'w+') as f:
        f_dbg = open(filename_mem_dbg, 'w+');
        #arg mem
        for z in range(401):
            n = np.float16(0)
            f.write(to_bin_string(n) + '\n')
            counter = counter + 1

        ADDR_BASE_W = counter

        for arg_num in range(401):
            for neuron_w in range(25):
                v = weights_x66[0][neuron_w][arg_num]
                v = np.float16(v)
                v_str = to_bin_string(v);
                f.write(v_str + '\n')
                f_dbg.write(v_str + ' #L1 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                counter = counter + 1

        for arg_num in range(26):
            for neuron_w in range(10):
                v = weights_x66[1][neuron_w][arg_num]
                v = np.float16(v)
                v_str = to_bin_string(v);
                f.write(v_str + '\n')
                f_dbg.write(v_str + ' #L2 arg : %d neuron: %d\n' % (arg_num, neuron_w) )
                counter = counter + 1

        ADDR_BASE_LUT = counter
        lut = generate_lut()
        for n in lut:
            f.write(to_bin_string(n) + '\n')
            f_dbg.write(to_bin_string(n) + " LUT: " + str(counter) + " " + str(n)  + '\n')
            counter = counter + 1

        ADDR_LAST = counter

    with open(filename_mmap, 'w+') as f:
        bias_encoded = np.float16(1.0)
        f.write('L2_ONE_BIAS_VAL: ' + to_bin_string(bias_encoded) + '\n')

        ADDR_BASE_A_BIN = bitstring.Bits(uint=ADDR_BASE_A, length=32).hex
        f.write('ADDR_BASE_A: ' + ADDR_BASE_A_BIN + '\n')

        ADDR_BASE_W_BIN = bitstring.Bits(uint=ADDR_BASE_W, length=32).hex
        f.write('ADDR_BASE_W: ' + ADDR_BASE_W_BIN + '\n')

        ADDR_BASE_LUT_BIN = bitstring.Bits(uint=ADDR_BASE_LUT, length=32).hex
        f.write('ADDR_BASE_LUT_L1: ' + ADDR_BASE_LUT_BIN + '\n')
        f.write('ADDR_BASE_LUT_L2: ' + ADDR_BASE_LUT_BIN + '\n')

        ADDR_LAST_BIN = bitstring.Bits(uint=ADDR_LAST, length=32).hex
        f.write('ADDR_LAST: ' + ADDR_LAST_BIN + '\n')
        
def fp16_test_cases():

    fi = np.finfo(np.float16())
    vals = []
    cases = []
    a = np.float16(-2)
    print("Gen vals")
    while(a <= np.float16(2)):
        vals.append(a)
        a = a + 0.01
    #    print("Gen vals %f, %f" % (a, fi.resolution))


    print("Gen tst")
    filename_tst_cases = "../data/fp16.tst" 
    with open(filename_tst_cases, 'w+') as f:
        for a in vals:
            for b in vals:
                print("%f, %f" %(a,b))
                s = a+b
                m = a*b
                f.write("tb_a = 16'h" + to_hex_string(a) +
                        "; tb_b = 16'h" + to_hex_string(b) + 
                        "; tb_exp = 16'h" + to_hex_string(s) +
                        "; tb_m_exp = 16'h" + to_hex_string(m) + "; #1; \n")




if __name__ == "__main__":
    gen_fix_data()
    gen_ulaw_data()
    gen_fp16_data()
    fp16_test_cases()
            







