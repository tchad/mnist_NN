/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module datapath_relu_ulaw
    #(parameter ADDR_WIDTH = 16,
      parameter SM1_SCALE = 1,
      parameter SD1_SCALE = 1,
      parameter SM2_SCALE = 1,
      parameter L2_ONE_BIAS_VAL = 0)
    (input  logic   clk,
     input  logic   rst,

     input  logic   signed      [7:0]         mem_data,
     input  logic   unsigned    [ADDR_WIDTH-1:0]    l2_src_addr,

     input  logic   unsigned    [2:0]               r_sh_en,

     input  logic   unsigned    [1:0]               mac_en,
     input  logic   unsigned    [1:0]               mac_clr,

     output logic                                   arg_zero,
     output logic   signed      [7:0]         out [9:0]);

    localparam WIDTH = 8;
    localparam DEC_WIDTH = 14;
    localparam [WIDTH-1:0] ZERO_VAL = 8'hFF;


    logic   signed  [WIDTH-1:0] R_ARG_p_out [0:0];

    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(1))
    R_ARG   (.sh_in(mem_data),
             .p_out(R_ARG_p_out),
             .sh_en(r_sh_en[0]),
             .rst(rst),
             .clk(clk));

    assign arg_zero = R_ARG_p_out[0] == ZERO_VAL;

    logic   signed  [WIDTH-1:0] R1_p_out    [24:0];
    
    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(25))
    R1  (.sh_in(mem_data),
         .p_out(R1_p_out),
         .sh_en(r_sh_en[1]),
         .rst(rst),
         .clk(clk));

    logic   unsigned    [DEC_WIDTH-1:0] DEC_A1_out  [24:0];
    logic   unsigned    [DEC_WIDTH-1:0] DEC_B1_out  [24:0];
    logic   signed      [DEC_WIDTH-1:0] M1_o        [24:0];
    logic   signed      [DEC_WIDTH-1:0] SM1_out     [24:0];
    logic   signed      [DEC_WIDTH-1:0] RELU1_out   [24:0];
    logic   signed      [DEC_WIDTH-1:0] SD1_out     [24:0];

    generate begin : GEN_L1
        genvar gi;
        for(gi = 0; gi<25; gi=gi+1)begin
            ulaw_to_fix14
            DEC_A1  (.in(R_ARG_p_out[0]),
                     .out(DEC_A1_out[gi]));

            ulaw_to_fix14
            DEC_B1  (.in(R1_p_out[gi]),
                     .out(DEC_B1_out[gi]));

            mac_fix #(.w(DEC_WIDTH))
            MAC (.clk(clk),
                 .en(mac_en[0]),
                 .rst(rst),
                 .clr(mac_clr[0]),
                 .x(DEC_A1_out[gi]),
                 .c(DEC_B1_out[gi]),
                 .o(M1_o[gi]));

            scaler_mul_fix  #(.WIDTH(DEC_WIDTH),
                              .SCALE(SM1_SCALE))
            SCALER_MUL (.in(M1_o[gi]),
                 .out(SM1_out[gi]));

            relu_fix  #(.WIDTH(DEC_WIDTH))
            RELU (.in(SM1_out[gi]),
                 .out(RELU1_out[gi]));

            scaler_div_fix  #(.WIDTH(DEC_WIDTH),
                              .SCALE(SD1_SCALE))
            SCALER_DIV (.in(RELU1_out[gi]),
                 .out(SD1_out[gi]));
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

    logic   signed  [DEC_WIDTH-1:0] mac2_a;
    always_comb begin : MAC2_INPUT
        if(l2_src_addr == 0) begin
            mac2_a = L2_ONE_BIAS_VAL;
        end else if(l2_src_addr > 25) begin
            mac2_a = 0;
        end else begin
            mac2_a = SD1_out[l2_src_addr-1];
        end 
    end

    logic   unsigned    [DEC_WIDTH-1:0] DEC_A2_out  [9:0];
    logic   signed      [DEC_WIDTH-1:0] M2_o        [9:0];
    logic   signed      [DEC_WIDTH-1:0] SM2_out     [9:0];
    logic   signed      [DEC_WIDTH-1:0] RELU2_out   [9:0];

    generate begin : GEN_L2
        genvar gi;
        for(gi = 0; gi<10; gi=gi+1)begin

            ulaw_to_fix14
            DEC_A2  (.in(R2_p_out[gi]),
                     .out(DEC_A2_out[gi]));

            mac_fix #(.w(DEC_WIDTH))
            M2  (.clk(clk),
                 .en(mac_en[1]),
                 .rst(rst),
                 .clr(mac_clr[1]),
                 .x(mac2_a),
                 .c(DEC_A2_out[gi]),
                 .o(M2_o[gi]));

            scaler_mul_fix  #(.WIDTH(DEC_WIDTH),
                              .SCALE(SM2_SCALE))
            SCALER_MUL2   (.in(M2_o[gi]),
                 .out(SM2_out[gi]));

            relu_fix  #(.WIDTH(DEC_WIDTH))
            RELU2   (.in(SM2_out[gi]),
                 .out(RELU2_out[gi]));

            fix14_to_ulaw
            ENC2(.in(RELU2_out[gi]),
                 .out(out[gi]));
        end
    end
    endgenerate
 endmodule

