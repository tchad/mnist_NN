/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module ulaw_to_fix14
    (input  logic   unsigned    [7:0] in,
     output logic   unsigned    [13:0] out
    );

    always_comb begin: COMB
        logic sign;
        logic   unsigned [2:0] chord;
        logic   unsigned [3:0] val;  
        logic   unsigned [12:0] tmp;
        logic   unsigned [13:0] tmp_decoded;


        tmp = ~in;

        sign = tmp[7];
        chord = tmp[6:4];
        val = tmp[3:0];

        if(chord == 3'b000) begin
            tmp_decoded = {9'b000000001, val, 1'b1};
        end else if(chord == 3'b001) begin
            tmp_decoded = {8'b00000001, val, 2'b10};
        end else if(chord == 3'b010) begin
            tmp_decoded = {7'b0000001, val, 3'b100};
        end else if(chord == 3'b011) begin
            tmp_decoded = {6'b000001, val, 4'b1000};
        end else if(chord == 3'b100) begin
            tmp_decoded = {5'b00001, val, 5'b10000};
        end else if(chord == 3'b101) begin
            tmp_decoded = {4'b0001, val, 6'b100000};
        end else if(chord == 3'b110) begin
            tmp_decoded = {3'b001, val, 7'b1000000};
        end else if(chord == 3'b111) begin
            tmp_decoded = {2'b01, val, 8'b10000000};
        end

        tmp_decoded = tmp_decoded - 33;

        if(sign == 1'b1) begin
            tmp_decoded = -tmp_decoded;
        end

        out = tmp_decoded;
    end

endmodule
