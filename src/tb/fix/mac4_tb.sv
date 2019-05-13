/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mac4_tb();

logic   signed  [3:0]   tb_x;
logic   signed  [3:0]   tb_c;
logic   signed  [3:0]   tb_o;

logic                   clk = 1'b0;
logic                   rst = 1'b0;

mac     DUT(.rst(rst),
            .clk(clk),
            .x(tb_x),
            .c(tb_c),
            .o(tb_o));

initial begin : TEST
    #2
    rst = 1'b1;
    #2;
    rst = 1'b0;
    #2
    
    tb_x = 4'b0100;
    tb_c = 4'b1101;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    tb_x = 4'b0110;
    tb_c = 4'b1111;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    tb_x = 4'b1100;
    tb_c = 4'b1101;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    $finish;
end

endmodule
