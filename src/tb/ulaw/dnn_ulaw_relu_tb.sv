/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module dnn_ulaw_relu_tb();


    //returns 1 if a greater -1 if b greater 0 is equal
    function integer cmp(input logic [7:0] a, input logic [7:0] b);
        automatic logic [7:0] tmp_a = ~a;
        automatic logic [7:0] tmp_b = ~b;
        automatic logic sgn_a = tmp_a[7];
        automatic logic sgn_b = tmp_b[7];
        automatic logic unsigned [2:0] chord_a = tmp_a[6:4];
        automatic logic unsigned [2:0] chord_b = tmp_b[6:4];
        automatic logic unsigned [3:0] val_a =  tmp_a[3:0];
        automatic logic unsigned [3:0] val_b =  tmp_b[3:0];

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

    logic   signed      [7:0]    ulaw_mem_data;
    integer                      ulaw_mem_exp_y;

    logic   ulaw_dnn_done;
    logic   unsigned    [15:0]    ulaw_dnn_mem_addr;
    logic   signed      [7:0]     ulaw_dnn_out [9:0];

    integer hit;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(8),
             .MEM_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/ulaw.mem"),
             .ARG_X_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/ulaw_X.mem"),
             .ARG_Y_FILE("/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/ulaw_y.mem"))
    ULAW_MEM    (.data(ulaw_mem_data),
             .addr(ulaw_dnn_mem_addr),
             .next_tc(next_tc),
             .exp_y(ulaw_mem_exp_y)
            );

   dnn_relu_ulaw    #(.ADDR_WIDTH(16),
                     .ADDR_BASE_A(16'h0000),
                     .ADDR_BASE_W(16'h0191),
                     .SM1_SCALE(4),
                     .SD1_SCALE(2),
                     .SM2_SCALE(16),
                     .L2_ONE_BIAS_VAL(14'b01000000000000))
    ULAW_DNN_RELU   (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(ulaw_dnn_done),
                     .mem_addr(ulaw_dnn_mem_addr),
                     .mem_data(ulaw_mem_data),
                     .out(ulaw_dnn_out)
                 );

    always begin
        #2 clk = ~clk;
    end

    initial begin
        integer i; 
        integer max_idx;
        logic [7:0] max_confidence;

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

            @(posedge(ulaw_dnn_done));

            max_idx = 1;
            max_confidence = ulaw_dnn_out[0];

            for(i=1; i< 10; i = i+1) begin
                integer result = cmp(max_confidence, ulaw_dnn_out[i]);
                if(result == -1) begin
                    max_idx = i + 1;
                    max_confidence = ulaw_dnn_out[i];
                end
            end

            if( max_idx == ulaw_mem_exp_y) begin
                hit = hit + 1;
            end

            #4 reset = 1'b1;
            #4 reset = 1'b0;

        end

        #4 $finish;
    end
endmodule
