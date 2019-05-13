/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mac_fix
    #(parameter w=4)
    (input   logic   clk,
     input   logic   en,
     input   logic   rst,
     input   logic   clr,
     input   logic   signed  [w-1:0]   x,
     input   logic   signed  [w-1:0]   c,
     output  logic   signed  [w-1:0]   o
    );
    
logic   signed  [w-1:0]   mem;

logic   signed  [w-1:0]   U0_o;
mul_fix     #(.w(w)) U0(.a(x),
           .b(c),
           .o(U0_o));
           
logic   signed  [w-1:0]   U1_o;
add_fix     #(.w(w)) U1(.a(mem),
           .b(U0_o),
           .o(U1_o));

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
