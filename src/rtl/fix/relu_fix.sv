/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module relu_fix
    #(WIDTH = 16)

    (input  logic   signed  [WIDTH-1:0] in,
     output logic   signed  [WIDTH-1:0] out
    );

    localparam [WIDTH-1:0] ZERO_VAL = 'd0;

    logic   signed  [WIDTH-1:0] sig_out;


    always_comb begin : COMB
        if(in[WIDTH-1] == 1'b0) begin
            sig_out = in;
        end else begin
            sig_out = ZERO_VAL;
        end
    end

    assign out = sig_out;
endmodule
