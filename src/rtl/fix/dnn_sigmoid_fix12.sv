/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module dnn_sigmoid_fix12
     (input     logic                       clk,
      input     logic                       rst,
      input     logic                       start,
      input     logic                       reset,
      input     logic   signed      [11:0]  mem_data,
      output    logic   unsigned    [15:0]  mem_addr,
      output    logic                       done,
      output    logic   signed      [11:0]  out [9:0]);

    dnn_sigmoid_fix   #(.DATA_WIDTH(12),
                     .ADDR_WIDTH(16),
                     .ADDR_BASE_A(16'h0000),
                     .ADDR_BASE_W(16'h0191),
                     .ADDR_BASE_LUT_L1(16'h29be),
                     .ADDR_BASE_LUT_L2(16'h39be),
                     .L2_ONE_BIAS_VAL(12'b010000000000),
                     .WIDTH_SIG_LUT(12))
    DNN             (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(done),
                     .mem_addr(mem_addr),
                     .mem_data(mem_data),
                     .out(out)
                    );
endmodule