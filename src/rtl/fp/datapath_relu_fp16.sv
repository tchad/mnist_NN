/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module datapath_relu_fp16
    #(parameter ADDR_WIDTH = 17,
      parameter L2_ONE_BIAS_VAL = 16'b0011110000000000)
    (input  logic   clk,
     input  logic   rst,

     input  logic   signed      [15:0]         mem_data,
     input  logic   unsigned    [ADDR_WIDTH-1:0]    l2_src_addr,

     input  logic   unsigned    [2:0]               r_sh_en,

     input  logic   unsigned    [1:0]               mac_en,
     input  logic   unsigned    [1:0]               mac_clr,

     output logic                                   arg_zero,
     output logic   signed      [15:0]         out [9:0]);

    localparam  WIDTH = 16;

    logic   signed  [WIDTH-1:0] R_ARG_p_out [0:0];

    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(1))
    R_ARG   (.sh_in(mem_data),
             .p_out(R_ARG_p_out),
             .sh_en(r_sh_en[0]),
             .rst(rst),
             .clk(clk));

    assign arg_zero = ((R_ARG_p_out[0] == 16'h0000) || (R_ARG_p_out[0] == 16'h8000));

    logic   signed  [WIDTH-1:0] R1_p_out    [24:0];
    
    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(25))
    R1  (.sh_in(mem_data),
         .p_out(R1_p_out),
         .sh_en(r_sh_en[1]),
         .rst(rst),
         .clk(clk));

    logic   signed  [WIDTH-1:0] M1_o        [24:0];
    logic   signed  [WIDTH-1:0] RELU1_out   [24:0];

    generate begin : GEN_L1
        genvar gi;
        for(gi = 0; gi<25; gi=gi+1)begin
            mac_fp16 
            MAC (.clk(clk),
                 .en(mac_en[0]),
                 .rst(rst),
                 .clr(mac_clr[0]),
                 .x(R_ARG_p_out[0]),
                 .c(R1_p_out[gi]),
                 .o(M1_o[gi]));

            relu_fix  #(.WIDTH(WIDTH))
            RELU (.in(M1_o[gi]),
                 .out(RELU1_out[gi]));
        end
    end
    endgenerate

    logic   signed  [WIDTH-1:0] R2_p_out    [9:0];

    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(10))
    R2  (.sh_in(mem_data),
         .p_out(R2_p_out),
         .sh_en(r_sh_en[2]),
         .rst(rst),
         .clk(clk));

    logic   signed  [WIDTH-1:0] mac2_a;
    always_comb begin : MAC2_INPUT
        if(l2_src_addr == 0) begin
            mac2_a = L2_ONE_BIAS_VAL;
        end else if(l2_src_addr > 25) begin
            mac2_a = 0;
        end else begin
            mac2_a = RELU1_out[l2_src_addr-1];
        end 
    end

    logic   signed  [WIDTH-1:0] M2_o        [9:0];
    logic   signed  [WIDTH-1:0] RELU2_out   [9:0];

    generate begin : GEN_L2
        genvar gi;
        for(gi = 0; gi<10; gi=gi+1)begin
            mac_fp16
            MAC (.clk(clk),
                 .en(mac_en[1]),
                 .rst(rst),
                 .clr(mac_clr[1]),
                 .x(mac2_a),
                 .c(R2_p_out[gi]),
                 .o(M2_o[gi]));

            relu_fix  #(.WIDTH(WIDTH))
            RELU    (.in(M2_o[gi]),
                 .out(out[gi]));
        end
    end
    endgenerate
 endmodule

