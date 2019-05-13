/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module dnn_relu_fp16_tb();

    logic   clk;
    logic   rst;
    logic   start;
    logic   reset;
    logic   next_tc;

    logic   signed      [15:0]    fp16_mem_data;
    integer                      fp16_mem_exp_y;

    logic   fp16_dnn_done;
    logic   unsigned    [16:0]    fp16_dnn_mem_addr;
    logic   signed      [15:0]    fp16_dnn_out [9:0];

    integer hit;

    mem    #(.ADDR_WIDTH(17),
             .DATA_WIDTH(16),
             .MEM_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fp16.mem"),
             .ARG_X_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fp16_X.mem"),
             .ARG_Y_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fp16_y.mem"))
    FP16_MEM (.data(fp16_mem_data),
              .addr(fp16_dnn_mem_addr),
              .next_tc(next_tc),
              .exp_y(fp16_mem_exp_y)
             );

   dnn_relu_fp16   #(.ADDR_WIDTH(17),
                     .ADDR_BASE_A(17'h00000),
                     .ADDR_BASE_W(17'h00191))
    FP16_DNN_RELU   (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fp16_dnn_done),
                     .mem_addr(fp16_dnn_mem_addr),
                     .mem_data(fp16_mem_data),
                     .out(fp16_dnn_out)
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

            @(posedge(fp16_dnn_done));

            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fp16_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fp16_dnn_out[i];
                end
            end

            if( max_idx == fp16_mem_exp_y) begin
                hit = hit + 1;
            end

            #4 reset = 1'b1;
            #4 reset = 1'b0;

        end

        #4 $finish;
    end
endmodule
