/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module reg_shift
    #(parameter WIDTH = 16,
      parameter SIZE = 32)

      (input   logic   signed     [WIDTH-1:0] sh_in,
       input   logic   signed     [WIDTH-1:0] p_in [SIZE-1:0],
       output  logic   signed     [WIDTH-1:0] sh_out,
       output  logic   signed     [WIDTH-1:0] p_out [SIZE-1:0],
       input   logic   unsigned   sh_en,
       input   logic   unsigned   pi_en,
       input   logic   unsigned   rst,
       input   logic   unsigned   clk
      );

    localparam [WIDTH-1:0] RESET_VAL = 'd0;

    logic   signed  [WIDTH-1:0] internal_data [SIZE-1:0];


    always_ff @(posedge(clk) or posedge(rst)) begin : SEQ
        integer idx;

        if(rst == 1'b1) begin
           for (idx = 0; idx < SIZE; idx++) begin
              internal_data[idx] <= RESET_VAL;
           end
       end else begin
           if(pi_en == 1'b1) begin
               for (idx = 0; idx < SIZE; idx++) begin
                  internal_data[idx] <= #1 p_in[idx];
               end
           end else if(sh_en == 1'b1) begin
               internal_data[SIZE-1] <= #1 sh_in;
               for(idx = 1; idx < SIZE; idx++) begin
                   internal_data[SIZE-1-idx] <= #1 internal_data[SIZE-idx];
               end
           end
       end 
    end

    assign sh_out = internal_data[0];
    assign p_out = internal_data;
endmodule
