/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mac5_tb();

logic   signed  [4:0]   tb_x;
logic   signed  [4:0]   tb_c;
logic   signed  [4:0]   tb_o;

logic                   clk = 1'b0;
logic                   rst = 1'b0;

mac #(.w(5)) DUT(.rst(rst),
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
    
    tb_x = 5'b00100;
    tb_c = 5'b11101;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    tb_x = 5'b00110;
    tb_c = 5'b11111;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    tb_x = 5'b11100;
    tb_c = 5'b11101;
    #2
    clk  = 1'b1;
    #2;
    clk  = 1'b0;
    #2
    
    $finish;
end

endmodule
