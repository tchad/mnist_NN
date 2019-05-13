/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

localparam ADDR_WIDTH = 16;
localparam DATA_WIDTH = 12;

module top_relu_fix12
     (input     logic   clk,
      input     logic   rst,
      input     logic   start,
      input     logic   reset,
      output    logic   done,

      output    logic   unsigned    [ADDR_WIDTH-1:0]    mem_addr,
      input     logic   signed      [DATA_WIDTH-1:0]    mem_data,

      input     logic   unsigned    [3:0]     out_idx,
      output    logic   signed      [DATA_WIDTH-1:0]    out);
  

  logic   signed      [DATA_WIDTH-1:0]    out_sel[9:0];
  
  dnn_relu_fix12(.clk(clk),
                .rst(rst),
                .start(start),
                .reset(reset),
                .done(done),
                .mem_addr(mem_addr),
                .mem_data(mem_data),
                .out(out_sel)
               );

  always_comb begin: COMB
      if(out_idx == 0) begin
          out = out_sel[0];
      end else if(out_idx == 1) begin
          out = out_sel[1];
      end else if(out_idx == 2) begin
          out = out_sel[2];
      end else if(out_idx == 3) begin
          out = out_sel[3];
      end else if(out_idx == 4) begin
          out = out_sel[4];
      end else if(out_idx == 5) begin
          out = out_sel[5];
      end else if(out_idx == 6) begin
          out = out_sel[6];
      end else if(out_idx == 7) begin
          out = out_sel[7];
      end else if(out_idx == 8) begin
          out = out_sel[8];
      end else if(out_idx == 9) begin
          out = out_sel[9];
      end else begin
          out = out_sel[0];
      end
  end
endmodule

