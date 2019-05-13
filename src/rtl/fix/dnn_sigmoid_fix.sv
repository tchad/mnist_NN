/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps


module dnn_sigmoid_fix
    #(parameter DATA_WIDTH = 8,
      parameter ADDR_WIDTH = 16,
      parameter ADDR_BASE_A = 0,
      parameter ADDR_BASE_W = 0,
      parameter ADDR_BASE_LUT_L1 = 0,
      parameter ADDR_BASE_LUT_L2 = 0,
      parameter SM1_SCALE = 1,
      parameter SD1_SCALE = 1,
      parameter SM2_SCALE = 1,
      parameter L2_ONE_BIAS_VAL = 0,
      parameter WIDTH_SIG_LUT = 15)
     (input     logic   clk,
      input     logic   rst,
      input     logic   start,
      input     logic   reset,
      output    logic   done,

      output    logic   unsigned    [ADDR_WIDTH-1:0]    mem_addr,
      input     logic   signed      [DATA_WIDTH-1:0]    mem_data,

      output    logic   signed      [DATA_WIDTH-1:0]    out [9:0]);


  logic   unsigned    [ADDR_WIDTH-1:0]    SM_lut_pos;
  logic                                   SM_lut_sel;
  logic   unsigned    [3:0]               SM_r_sh_en;
  logic   unsigned    [1:0]               SM_mac_en;
  logic   unsigned    [1:0]               SM_mac_clr;
  
  logic   unsigned    [ADDR_WIDTH-1:0]    D_PATH_lut_idx;
  logic                                   D_PATH_arg_zero;

  sm_sigmoid    #(.DATA_WIDTH(DATA_WIDTH),
                  .ADDR_WIDTH(ADDR_WIDTH),
                  .ADDR_BASE_A(ADDR_BASE_A),
                  .ADDR_BASE_W(ADDR_BASE_W),
                  .ADDR_BASE_LUT_L1(ADDR_BASE_LUT_L1),
                  .ADDR_BASE_LUT_L2(ADDR_BASE_LUT_L2))
    SM  (.clk(clk),
         .rst(rst),
         .start(start),
         .reset(reset),
         .done(done),
         .lut_idx(D_PATH_lut_idx),
         .lut_pos(SM_lut_pos),
         .lut_sel(SM_lut_sel),
         .mem_addr(mem_addr),
         .r_sh_en(SM_r_sh_en),
         .arg_zero(D_PATH_arg_zero),
         .mac_en(SM_mac_en),
         .mac_clr(SM_mac_clr));

  datapath_sigmoid_fix  #(.WIDTH(DATA_WIDTH),
                          .ADDR_WIDTH(ADDR_WIDTH),
                          .L2_ONE_BIAS_VAL(L2_ONE_BIAS_VAL),
                          .WIDTH_SIG_LUT(WIDTH_SIG_LUT))
    D_PATH  (.clk(clk),
             .rst(rst),
             .mem_data(mem_data),
             .r_sh_en(SM_r_sh_en),
             .arg_zero(D_PATH_arg_zero),
             .mac_en(SM_mac_en),
             .mac_clr(SM_mac_clr),
             .out(out),
             .lut_idx(D_PATH_lut_idx),
             .lut_pos(SM_lut_pos),
             .lut_sel(SM_lut_sel));
 endmodule

