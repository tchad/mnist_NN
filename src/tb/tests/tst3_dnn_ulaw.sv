/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module tst3_dnn_ulaw();

    //returns 1 if a greater -1 if b greater 0 is equal
    function integer cmp(input logic [7:0] a, input logic [7:0] b);
        logic [7:0] tmp_a;
        logic [7:0] tmp_b;
        logic sgn_a;
        logic sgn_b;
        logic unsigned [2:0] chord_a;
        logic unsigned [2:0] chord_b;
        logic unsigned [3:0] val_a;
        logic unsigned [3:0] val_b;

        tmp_a = ~a;
        tmp_b = ~b;
        sgn_a = tmp_a[7];
        sgn_b = tmp_b[7];
        chord_a = tmp_a[6:4];
        chord_b = tmp_b[6:4];
        val_a =  tmp_a[3:0];
        val_b =  tmp_b[3:0];
        
        if(sgn_a == 1'b0 && sgn_b == 1'b0) begin
            //both positive
            if(chord_a == chord_b) begin
                if(val_a == val_b) begin
                    cmp = 0;
                end else if(val_a > val_b) begin
                    cmp = 1;
                end else begin
                    cmp = -1;
                end
            end else if(chord_a > chord_b) begin
                cmp = 1;
            end else begin
                cmp = -1;
            end
        end else if(sgn_a == 1'b1 && sgn_b == 1'b1) begin
            //both negative
            if(chord_a == chord_b) begin
                if(val_a == val_b) begin
                    cmp = 0;
                end else if(val_a > val_b) begin
                    cmp = -1;
                end else begin
                    cmp = 1;
                end
            end else if(chord_a > chord_b) begin
                cmp = -1;
            end else begin
                cmp = 1;
            end
        end else begin
            //positive and negative
            if(sgn_a == 1'b1) begin //imply sgn_b == 1'b0
                cmp = -1;
            end else begin //imply sgn_a == 1'b1
                cmp = 1;
            end
        end
    endfunction

    logic   clk;
    logic   rst;
    logic   start;
    logic   reset;
    logic   next_tc;

    //ULAW RELU
    logic   signed      [7:0]     ulaw_relu_mem_data;
    integer                       ulaw_relu_mem_exp_y;

    logic                         ulaw_relu_dnn_done;
    logic   unsigned    [15:0]    ulaw_relu_dnn_mem_addr;
    logic   signed      [7:0]     ulaw_relu_dnn_out [9:0];

    integer                       ulaw_relu_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(8),
             .MEM_FILE("../src/data/ulaw.mem"),
             .ARG_X_FILE("../src/data/ulaw_X.mem"),
             .ARG_Y_FILE("../src/data/ulaw_y.mem"))
    ULAW_RELU_MEM   (.data(ulaw_relu_mem_data),
                     .addr(ulaw_relu_dnn_mem_addr),
                     .next_tc(next_tc),
                     .exp_y(ulaw_relu_mem_exp_y)
                    );

   dnn_relu_ulaw  
   ULAW_DNN_RELU   (.clk(clk),
                    .rst(rst),
                    .start(start),
                    .reset(reset),
                    .done(ulaw_relu_dnn_done),
                    .mem_addr(ulaw_relu_dnn_mem_addr),
                    .mem_data(ulaw_relu_mem_data),
                    .out(ulaw_relu_dnn_out)
                   );




    //ULAW SIGMOID
    logic   signed      [7:0]    ulaw_sigmoid_mem_data;
    integer                       ulaw_sigmoid_mem_exp_y;

    logic                         ulaw_sigmoid_dnn_done;
    logic   unsigned    [15:0]    ulaw_sigmoid_dnn_mem_addr;
    logic   signed      [7:0]    ulaw_sigmoid_dnn_out [9:0];

    integer                       ulaw_sigmoid_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(8),
             .MEM_FILE("../src/data/ulaw.mem"),
             .ARG_X_FILE("../src/data/ulaw_X.mem"),
             .ARG_Y_FILE("../src/data/ulaw_y.mem"))
    ULAW_SIGMOID_MEM   (.data(ulaw_sigmoid_mem_data),
                        .addr(ulaw_sigmoid_dnn_mem_addr),
                        .next_tc(next_tc),
                        .exp_y(ulaw_sigmoid_mem_exp_y)
                       );

   dnn_sigmoid_ulaw
   ULAW_DNN_SIGMOID (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(ulaw_sigmoid_dnn_done),
                     .mem_addr(ulaw_sigmoid_dnn_mem_addr),
                     .mem_data(ulaw_sigmoid_mem_data),
                     .out(ulaw_sigmoid_dnn_out)
                    );


    logic all_done;
    assign all_done = ulaw_sigmoid_dnn_done & 
                      ulaw_relu_dnn_done; 

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
                automatic integer result = cmp(max_confidence, ulaw_relu_dnn_out[i]);
                if(result == -1) begin
                    max_idx = i + 1;
                    max_confidence = ulaw_relu_dnn_out[i];
                end
            end

            if( max_idx == ulaw_relu_mem_exp_y) begin
                ulaw_relu_hit = ulaw_relu_hit + 1;
            end

            //ULAW SIGMOID
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                automatic integer result = cmp(max_confidence, ulaw_sigmoid_dnn_out[i]);
                if(result == -1) begin
                    max_idx = i + 1;
                    max_confidence = ulaw_sigmoid_dnn_out[i];
                end
            end

            if( max_idx == ulaw_sigmoid_mem_exp_y) begin
                ulaw_sigmoid_hit = ulaw_sigmoid_hit + 1;
            end

            testcase = testcase + 1;

            #4 reset = 1'b1;
            #4 reset = 1'b0;
        end

        f = $fopen("results/tst3_dnn_ulaw.log", "w+");
        $fwrite(f, "RELU: %d\n", ulaw_relu_hit);
        $fwrite(f, "SIGMOID: %d\n", ulaw_sigmoid_hit);
        $fclose(f);
        
        #4 $finish;
    end
endmodule
