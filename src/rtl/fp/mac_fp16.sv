/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mac_fp16
    (input   logic   clk,
     input   logic   en,
     input   logic   rst,
     input   logic   clr,
     input   logic   unsigned  [15:0]   x,
     input   logic   unsigned  [15:0]   c,
     output  logic   unsigned  [15:0]   o
    );
    
    localparam w = 16;
        
    logic   unsigned  [15:0]   mem;

    logic   unsigned  [15:0]   U0_o;
    mul_fp16 U0(.a(x),
                 .b(c),
                 .s(U0_o));
               
    logic   unsigned  [w-1:0]   U1_o;
    add_fp16 U1(.a(mem),
               .b(U0_o),
               .s(U1_o));

    always_ff @(posedge(clk) or posedge(rst)) begin : SEQ
        if( rst == 1'b1) begin
            mem <= 'd0;
        end else begin
            if(clr == 1'b1) begin
                mem <= #1 'd0;
            end else  if(en == 1'b1) begin
                mem <= #1 U1_o;
            end else begin
                mem <= #1 mem;
            end
        end
    end

    //Output assignment
    assign o = mem;
endmodule
