/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module dnn_fix_sigmoid_tb();

    logic   clk;
    logic   rst;
    logic   start;
    logic   reset;
    logic   next_tc;

    logic   signed      [7:0]    fix8_mem_data;
    integer                      fix8_mem_exp_y;

    logic   fix8_dnn_done;
    logic   unsigned    [15:0]    fix8_dnn_mem_addr;
    logic   signed      [7:0]    fix8_dnn_out [9:0];

    integer hit;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(8),
             .MEM_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8.mem"),
             .ARG_X_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8_X.mem"),
             .ARG_Y_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8_y.mem"))
    FIX8_MEM    (.data(fix8_mem_data),
             .addr(fix8_dnn_mem_addr),
             .next_tc(next_tc),
             .exp_y(fix8_mem_exp_y)
            );

   dnn_sigmoid_fix    #(.DATA_WIDTH(8),
                      .ADDR_WIDTH(16),
                      .ADDR_BASE_A(16'h0000),
                      .ADDR_BASE_W(16'h0191),
                      .ADDR_BASE_LUT(16'h29be),
                      .SM1_SCALE(1), //4
                      .SD1_SCALE(2),
                      .SM2_SCALE(1), //16
                      .L2_ONE_BIAS_VAL(8'b01000000),
                      .WIDTH_SIG_LUT(8))
    FIX8_DNN_SIGMOID   (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix8_dnn_done),
                     .mem_addr(fix8_dnn_mem_addr),
                     .mem_data(fix8_mem_data),
                     .out(fix8_dnn_out)
                 );

    always begin
        #2 clk = ~clk;
    end

    initial begin
        integer i; 
        integer max_idx = 0;
        integer max_confidence = 0;

        hit = 0;
        clk = 1'b0;
        rst = 1'b1;
        reset = 1'b0;
        start = 1'b0;
        next_tc = 1'b0;

        #4 rst = 1'b0;

        repeat (5000) begin
            #4 next_tc = 1'b1;
            #4 next_tc = 1'b0;

            #4 start = 1'b1;
            #4 start = 1'b0;

            @(posedge(fix8_dnn_done));

            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix8_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix8_dnn_out[i];
                end
            end

            if( max_idx == fix8_mem_exp_y) begin
                hit = hit + 1;
            end

            #4 reset = 1'b1;
            #4 reset = 1'b0;

        end
        $display(hit);

        #4 $finish;
    end
endmodule
