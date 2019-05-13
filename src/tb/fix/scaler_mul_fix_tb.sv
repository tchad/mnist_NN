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

module scaler_mul_fix_tb(
);

    localparam W = 8;


    logic   signed [W-1:0]  t_in;
    logic   signed [W-1:0]  t_out;

    scaler_mul_fix #(.WIDTH(W),
                     .SCALE(4))
    DUT0(.in(t_in),
         .out(t_out));

    initial begin
        t_in = 8'h08;
        #1;

        t_in = 8'h81;
        #1;

        t_in = 8'h00;
        #1;

        //Overflow test
        //All 5 should overflow

        t_in = 8'h20;
        #1;

        t_in = 8'h40;
        #1;

        t_in = 8'h60;
        #1;

        t_in = 8'h80;
        #1;

        t_in = 8'hAF;
        #1;

        t_in = 8'hCF;
        #1;


        //This two should not
        t_in = 8'h1F;
        #1;

        t_in = 8'hEF;
        #1;



        $finish;
    end
endmodule

