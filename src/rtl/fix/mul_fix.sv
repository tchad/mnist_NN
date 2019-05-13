/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mul_fix
    #(parameter w=4)
    (input   logic   signed  [w-1:0]   a,
     input   logic   signed  [w-1:0]   b,
     output  logic   signed  [w-1:0]   o
    );


    localparam  ARG_WIDTH = w;
    localparam  MUL_WIDTH = w*2-1;

    always_comb begin : COMB
        logic   signed  [MUL_WIDTH-1:0]   buffer;
        
        buffer  =  a*b;
        o = buffer[MUL_WIDTH-1:ARG_WIDTH-1];
        
    end
endmodule
