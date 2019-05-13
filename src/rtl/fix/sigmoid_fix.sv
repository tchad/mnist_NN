/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module sigmoid_fix
    #(parameter WIDTH_IN = 8,
      parameter MSB_OUT = 4)
     (input     logic   unsigned    [WIDTH_IN-1:0]          in,
      output    logic   unsigned    [MSB_OUT-1:0]           out
     );  

     localparam OUT_LSB = WIDTH_IN-MSB_OUT;

     assign out = in[WIDTH_IN-1:OUT_LSB];
 endmodule
