/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module tst4_dnn_fp16();

    logic   clk;
    logic   rst;
    logic   start;
    logic   reset;
    logic   next_tc;

    //fp16 RELU
    logic   signed      [15:0]     fp16_relu_mem_data;
    integer                       fp16_relu_mem_exp_y;

    logic                         fp16_relu_dnn_done;
    logic   unsigned    [16:0]    fp16_relu_dnn_mem_addr;
    logic   signed      [15:0]     fp16_relu_dnn_out [9:0];

    integer                       fp16_relu_hit = 0;

    mem    #(.ADDR_WIDTH(17),
             .DATA_WIDTH(16),
             .MEM_FILE("../src/data/fp16.mem"),
             .ARG_X_FILE("../src/data/fp16_X.mem"),
             .ARG_Y_FILE("../src/data/fp16_y.mem"))
    FP16_RELU_MEM   (.data(fp16_relu_mem_data),
                     .addr(fp16_relu_dnn_mem_addr),
                     .next_tc(next_tc),
                     .exp_y(fp16_relu_mem_exp_y)
                    );

   dnn_relu_fp16  
   FP16_DNN_RELU   (.clk(clk),
                    .rst(rst),
                    .start(start),
                    .reset(reset),
                    .done(fp16_relu_dnn_done),
                    .mem_addr(fp16_relu_dnn_mem_addr),
                    .mem_data(fp16_relu_mem_data),
                    .out(fp16_relu_dnn_out)
                   );




    //fp16 SIGMOID
    logic   signed      [15:0]    fp16_sigmoid_mem_data;
    integer                       fp16_sigmoid_mem_exp_y;

    logic                         fp16_sigmoid_dnn_done;
    logic   unsigned    [16:0]    fp16_sigmoid_dnn_mem_addr;
    logic   signed      [15:0]    fp16_sigmoid_dnn_out [9:0];

    integer                       fp16_sigmoid_hit = 0;

    mem    #(.ADDR_WIDTH(17),
             .DATA_WIDTH(16),
             .MEM_FILE("../src/data/fp16.mem"),
             .ARG_X_FILE("../src/data/fp16_X.mem"),
             .ARG_Y_FILE("../src/data/fp16_y.mem"))
    ULAW_SIGMOID_MEM   (.data(fp16_sigmoid_mem_data),
                        .addr(fp16_sigmoid_dnn_mem_addr),
                        .next_tc(next_tc),
                        .exp_y(fp16_sigmoid_mem_exp_y)
                       );

   dnn_sigmoid_fp16
   ULAW_DNN_SIGMOID (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fp16_sigmoid_dnn_done),
                     .mem_addr(fp16_sigmoid_dnn_mem_addr),
                     .mem_data(fp16_sigmoid_mem_data),
                     .out(fp16_sigmoid_dnn_out)
                    );


    logic all_done;
    assign all_done = fp16_sigmoid_dnn_done & 
                      fp16_relu_dnn_done; 

    always begin
        #2 clk = ~clk;
    end

    initial begin
        integer i; 
        automatic integer max_idx = 0;
        automatic integer max_confidence = 0;
        automatic integer testcase = 0;
        integer f;

        clk = 1'b0;
        rst = 1'b1;
        reset = 1'b0;
        start = 1'b0;
        next_tc = 1'b0;

        #4 rst = 1'b0;

        repeat (5000) begin
            $display("Test case: %d", testcase);
            #4 next_tc = 1'b1;
            #4 next_tc = 1'b0;

            #4 start = 1'b1;
            #4 start = 1'b0;

            @(posedge(all_done));
            
            //ULAW RELU
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if(max_confidence < fp16_relu_dnn_out[i]) begin
                    max_idx = i + 1;
                    max_confidence = fp16_relu_dnn_out[i];
                end
            end

            if( max_idx == fp16_relu_mem_exp_y) begin
                fp16_relu_hit = fp16_relu_hit + 1;
            end

            //ULAW SIGMOID
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if(max_confidence < fp16_sigmoid_dnn_out[i]) begin
                    max_idx = i + 1;
                    max_confidence = fp16_sigmoid_dnn_out[i];
                end
            end

            if( max_idx == fp16_sigmoid_mem_exp_y) begin
                fp16_sigmoid_hit = fp16_sigmoid_hit + 1;
            end

            testcase = testcase + 1;

            #4 reset = 1'b1;
            #4 reset = 1'b0;
        end

        f = $fopen("results/tst4_dnn_fp16.log", "w+");
        $fwrite(f, "RELU: %d\n", fp16_relu_hit);
        $fwrite(f, "SIGMOID: %d\n", fp16_sigmoid_hit);
        $fclose(f);
        
        #4 $finish;
    end
endmodule
