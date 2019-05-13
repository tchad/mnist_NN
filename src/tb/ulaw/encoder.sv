/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module encoder(

    );
    
    logic   unsigned    [13:0]  in;
    logic   unsigned    [7:0]   out;
    fix14_to_ulaw DUT(.in(in),
                      .out(out));
                      
    initial begin
     in = 14'b10000010000011;
     #1;
     
     in = 14'b01111111111100;
          #1;
    end
endmodule

