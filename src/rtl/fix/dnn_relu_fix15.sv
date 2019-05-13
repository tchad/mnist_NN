/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module dnn_relu_fix15
     (input     logic                       clk,
      input     logic                       rst,
      input     logic                       start,
      input     logic                       reset,
      input     logic   signed      [14:0]  mem_data,
      output    logic   unsigned    [16:0]  mem_addr,
      output    logic                       done,
      output    logic   signed      [14:0]  out [9:0]);

    dnn_relu_fix   #(.DATA_WIDTH(15),
                     .ADDR_WIDTH(17),
                     .ADDR_BASE_A(16'h0000),
                     .ADDR_BASE_W(16'h0191),
                     .SM1_SCALE(4),
                     .SD1_SCALE(2),
                     .SM2_SCALE(16),
                     .L2_ONE_BIAS_VAL(15'b010000000000000))
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
