/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module datapath_sigmoid_ulaw
    #(parameter ADDR_WIDTH = 16,
      parameter L2_ONE_BIAS_VAL = 0,
      parameter WIDTH_SIG_LUT = 8)
    (input  logic   clk,
     input  logic   rst,

     input  logic   signed      [7:0]         mem_data,
     input  logic   unsigned    [3:0]               r_sh_en,

     input  logic   unsigned    [1:0]               mac_en,
     input  logic   unsigned    [1:0]               mac_clr,

     output logic                                   arg_zero,
     output logic   signed      [7:0]         out [9:0],

     output logic   unsigned    [ADDR_WIDTH-1:0]    lut_idx,
     input  logic   unsigned    [ADDR_WIDTH-1:0]    lut_pos,
     input  logic                                   lut_sel);

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

    logic   unsigned    [DEC_WIDTH-1:0]     DEC_A1_out  [24:0];
    logic   unsigned    [DEC_WIDTH-1:0]     DEC_B1_out  [24:0];
    logic   signed      [DEC_WIDTH-1:0]     M1_o        [24:0];
    logic   unsigned    [WIDTH-1:0]         ENC1_out    [24:0];
    logic   unsigned    [WIDTH_SIG_LUT-1:0] SIG1_out    [24:0];


    generate begin : GEN_L1
        genvar gi;
        for(gi = 0; gi<25; gi=gi+1) begin
            ulaw_to_fix14
            DEC_A1  (.in(R_ARG_p_out[0]),
                     .out(DEC_A1_out[gi]));

            ulaw_to_fix14
            DEC_B1  (.in(R1_p_out[gi]),
                     .out(DEC_B1_out[gi]));

            mac_fix #(.w(DEC_WIDTH))
            M1  (.clk(clk),
                 .en(mac_en[0]),
                 .rst(rst),
                 .clr(mac_clr[0]),
                 .x(DEC_A1_out[gi]),
                 .c(DEC_B1_out[gi]),
                 .o(M1_o[gi]));

            fix14_to_ulaw
            ENC1 (.in(M1_o[gi]),
                  .out(ENC1_out[gi]));

            sigmoid_fix  #(.WIDTH_IN(WIDTH),
                           .MSB_OUT(WIDTH_SIG_LUT))
            SIG1    (.in(ENC1_out[gi]),
                 .out(SIG1_out[gi]));
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

    logic   signed  [WIDTH-1:0] sig_out_data;

    logic   unsigned    [DEC_WIDTH-1:0]     DEC_A2_out  [9:0];
    logic   unsigned    [DEC_WIDTH-1:0]     DEC_B2_out  [9:0];
    logic   signed      [DEC_WIDTH-1:0]     M2_o        [9:0];
    logic   unsigned    [WIDTH-1:0]         ENC2_out    [9:0];
    logic   signed      [WIDTH_SIG_LUT-1:0] SIG2_out    [9:0];

    always_comb begin : LUT_INDEX_FEEDBACK
        logic   unsigned [WIDTH_SIG_LUT-1:0] idx;
        if(lut_sel == 0) begin
            if(lut_pos == 0) begin
                lut_idx = 0;
                sig_out_data = L2_ONE_BIAS_VAL;
            end else if(lut_pos > 25) begin
                sig_out_data = 8'hFF;
                lut_idx = 0;
            end else begin
                idx = SIG1_out[lut_pos-1];
                lut_idx = idx;
                sig_out_data = mem_data;
            end
        end else begin
            if(lut_pos > 9) begin
                lut_idx = 0;
                sig_out_data = 8'hFF;
            end else begin
                idx = SIG2_out[lut_pos];
                lut_idx = idx;
                sig_out_data = mem_data;
            end
        end
    end

    generate begin : GEN_L2
        genvar gi;
        for(gi = 0; gi<10; gi=gi+1)begin
            ulaw_to_fix14
            DEC_A2  (.in(sig_out_data),
                     .out(DEC_A2_out[gi]));

            ulaw_to_fix14
            DEC_B2  (.in(R2_p_out[gi]),
                     .out(DEC_B2_out[gi]));

            mac_fix #(.w(DEC_WIDTH))
            M2    (.clk(clk),
                 .en(mac_en[1]),
                 .rst(rst),
                 .clr(mac_clr[1]),
                 .x(DEC_A2_out[gi]),
                 .c(DEC_B2_out[gi]),
                 .o(M2_o[gi]));

            fix14_to_ulaw
            ENC2 (.in(M2_o[gi]),
                  .out(ENC2_out[gi]));

            sigmoid_fix  #(.WIDTH_IN(WIDTH),
                           .MSB_OUT(WIDTH_SIG_LUT))
            SIG2    (.in(ENC2_out[gi]),
                 .out(SIG2_out[gi]));
        end
    end
    endgenerate

    reg_shift   #(.WIDTH(WIDTH),
                  .SIZE(10))
    R3  (.sh_in(sig_out_data),
         .p_out(out),
         .sh_en(r_sh_en[3]),
         .rst(rst),
         .clk(clk));

 endmodule

