/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module fix14_to_ulaw
    (input  logic   unsigned    [13:0]  in,
     output logic   unsigned    [7:0]   out
    );

    always_comb begin: COMB
        logic   sign;
        logic   unsigned [2:0] chord;
        logic   unsigned [3:0] val;  
        logic   unsigned [12:0] tmp;
        logic   tmp_overflow;
        logic   unsigned [7:0] tmp_combined;


        chord = 3'b000;
        val = 4'b0000;
        if(in[13] == 1'b1) begin
            //negative number
            sign = 1'b1;
            tmp = -in;
        end else begin
            //positive
            sign = 1'b0;
            tmp = in;
        end

        {tmp_overflow , tmp} = tmp + 33;
        if(tmp_overflow == 1'b1) begin
            tmp = 13'b1111111111111;
        end
        
        if(tmp & 13'b1000000000000) begin
            chord = 3'b111;
            val = tmp[11:8];
        end else if(tmp & 13'b0100000000000) begin
            chord = 3'b110;
            val = tmp[10:7];
        end else if(tmp & 13'b0010000000000) begin
            chord = 3'b101;
            val = tmp[9:6];
        end else if(tmp & 13'b0001000000000) begin
            chord = 3'b100;
            val = tmp[8:5];
        end else if(tmp & 13'b0000100000000) begin
            chord = 3'b011;
            val = tmp[7:4];
        end else if(tmp & 13'b0000010000000) begin
            chord = 3'b010;
            val = tmp[6:3];
        end else if(tmp & 13'b0000001000000) begin
            chord = 3'b001;
            val = tmp[5:2];
        end else if(tmp & 13'b0000000100000) begin
            chord = 3'b000;
            val = tmp[4:1];
        end

        tmp_combined = {sign, chord, val};

        out = ~tmp_combined;
    end


endmodule
