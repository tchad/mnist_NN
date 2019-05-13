/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module sm_sigmoid_tb();

    
    localparam ADDR_WIDTH = 16;

    //Inputs
    logic                                   tb_clk;
    logic                                   tb_rst;
    logic                                   tb_start;
    logic                                   tb_reset;

    logic   unsigned    [ADDR_WIDTH-1:0]    tb_lut_idx;

    //Outputs
    logic   unsigned    [ADDR_WIDTH-1:0]    tb_lut_pos;
    logic                                   tb_lut_sel;
    logic   unsigned                        tb_done;
    logic   unsigned    [ADDR_WIDTH-1:0]    tb_mem_addr;
    logic   unsigned    [2:0]               tb_r_sh_en;
    logic   unsigned    [1:0]               tb_mac_en;
    logic   unsigned    [1:0]               tb_mac_clr;

    assign tb_lut_idx = 16'h0087;

    sm_sigmoid #(.ADDR_BASE_A(16'h0000),
              .ADDR_BASE_W(16'h0000))
    DUT(.clk(tb_clk),
        .rst(tb_rst),
        .start(tb_start),
        .reset(tb_reset),
        .done(tb_done),
        .lut_idx(tb_lut_idx),
        .lut_pos(tb_lut_pos),
        .lut_sel(tb_lut_sel),
        .mem_addr(tb_mem_addr),
        .r_sh_en(tb_r_sh_en),
        .mac_en(tb_mac_en),
        .mac_clr(tb_mac_clr));

    always begin
        #2 tb_clk = ~tb_clk;
    end


    initial begin
        tb_clk = 1'b0;
        tb_start = 1'b0;
        tb_reset = 1'b0;


        #4 tb_rst = 1'b1;
        #4 tb_rst = 1'b0;
        
        #4 tb_start = 1'b1;
        #4 tb_start = 1'b0;

        @(posedge(tb_done));

        #4 tb_reset = 1'b1;
        #4 tb_reset = 1'b0;

        #4 $finish;
    end

endmodule
