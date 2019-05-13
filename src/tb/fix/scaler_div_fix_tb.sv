/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

import util_fix::*;

module scaler_div_fix_tb(
);

    localparam W = 8;


    logic   signed [W-1:0]  t_in;
    logic   signed [W-1:0]  t_out;

    scaler_div_fix #(.WIDTH(W),
                     .SCALE(2))
    DUT0(.in(t_in),
         .out(t_out));


    initial begin
        t_in = 8'h08;
        #1;

        t_in = 8'h88;
        #1;

        t_in = 8'h01;
        #1;

        t_in = 8'h81;
        #1;

        t_in = 8'h00;
        #1;

        t_in = 8'hff;
        #1

        $finish;
    end
endmodule

