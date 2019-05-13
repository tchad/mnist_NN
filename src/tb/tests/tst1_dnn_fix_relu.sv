/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module tst1_dnn_fix_relu();

    logic   clk;
    logic   rst;
    logic   start;
    logic   reset;
    logic   next_tc;

    //FIX16
    logic   signed      [15:0]    fix16_mem_data;
    integer                       fix16_mem_exp_y;

    logic                         fix16_dnn_done;
    logic   unsigned    [17:0]    fix16_dnn_mem_addr;
    logic   signed      [15:0]    fix16_dnn_out [9:0];

    integer                       fix16_hit = 0;

    mem    #(.ADDR_WIDTH(18),
             .DATA_WIDTH(16),
             .MEM_FILE("../src/data/fix_16.mem"),
             .ARG_X_FILE("../src/data/fix_16_X.mem"),
             .ARG_Y_FILE("../src/data/fix_16_y.mem"))
    FIX16_MEM   (.data(fix16_mem_data),
                 .addr(fix16_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix16_mem_exp_y)
                );



    dnn_relu_fix16 
    FIX16_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix16_dnn_done),
                     .mem_addr(fix16_dnn_mem_addr),
                     .mem_data(fix16_mem_data),
                     .out(fix16_dnn_out)
                    );

    //FIX15
    logic   signed      [14:0]    fix15_mem_data;
    integer                       fix15_mem_exp_y;

    logic                         fix15_dnn_done;
    logic   unsigned    [16:0]    fix15_dnn_mem_addr;
    logic   signed      [14:0]    fix15_dnn_out [9:0];

    integer                       fix15_hit = 0;

    mem    #(.ADDR_WIDTH(17),
             .DATA_WIDTH(15),
             .MEM_FILE("../src/data/fix_15.mem"),
             .ARG_X_FILE("../src/data/fix_15_X.mem"),
             .ARG_Y_FILE("../src/data/fix_15_y.mem"))
    FIX15_MEM   (.data(fix15_mem_data),
                 .addr(fix15_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix15_mem_exp_y)
                );



    dnn_relu_fix15 
    FIX15_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix15_dnn_done),
                     .mem_addr(fix15_dnn_mem_addr),
                     .mem_data(fix15_mem_data),
                     .out(fix15_dnn_out)
                    );

    //FIX14
    logic   signed      [13:0]    fix14_mem_data;
    integer                       fix14_mem_exp_y;

    logic                         fix14_dnn_done;
    logic   unsigned    [15:0]    fix14_dnn_mem_addr;
    logic   signed      [13:0]    fix14_dnn_out [9:0];

    integer                       fix14_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(14),
             .MEM_FILE("../src/data/fix_14.mem"),
             .ARG_X_FILE("../src/data/fix_14_X.mem"),
             .ARG_Y_FILE("../src/data/fix_14_y.mem"))
    FIX14_MEM   (.data(fix14_mem_data),
                 .addr(fix14_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix14_mem_exp_y)
                );



    dnn_relu_fix14 
    FIX14_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix14_dnn_done),
                     .mem_addr(fix14_dnn_mem_addr),
                     .mem_data(fix14_mem_data),
                     .out(fix14_dnn_out)
                    );

    //FIX13
    logic   signed      [12:0]    fix13_mem_data;
    integer                       fix13_mem_exp_y;

    logic                         fix13_dnn_done;
    logic   unsigned    [15:0]    fix13_dnn_mem_addr;
    logic   signed      [12:0]    fix13_dnn_out [9:0];

    integer                       fix13_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(13),
             .MEM_FILE("../src/data/fix_13.mem"),
             .ARG_X_FILE("../src/data/fix_13_X.mem"),
             .ARG_Y_FILE("../src/data/fix_13_y.mem"))
    FIX13_MEM   (.data(fix13_mem_data),
                 .addr(fix13_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix13_mem_exp_y)
                );



    dnn_relu_fix13 
    FIX13_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix13_dnn_done),
                     .mem_addr(fix13_dnn_mem_addr),
                     .mem_data(fix13_mem_data),
                     .out(fix13_dnn_out)
                    );

    //FIX12
    logic   signed      [11:0]    fix12_mem_data;
    integer                       fix12_mem_exp_y;

    logic                         fix12_dnn_done;
    logic   unsigned    [15:0]    fix12_dnn_mem_addr;
    logic   signed      [11:0]    fix12_dnn_out [9:0];

    integer                       fix12_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(12),
             .MEM_FILE("../src/data/fix_12.mem"),
             .ARG_X_FILE("../src/data/fix_12_X.mem"),
             .ARG_Y_FILE("../src/data/fix_12_y.mem"))
    FIX12_MEM   (.data(fix12_mem_data),
                 .addr(fix12_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix12_mem_exp_y)
                );



    dnn_relu_fix12 
    FIX12_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix12_dnn_done),
                     .mem_addr(fix12_dnn_mem_addr),
                     .mem_data(fix12_mem_data),
                     .out(fix12_dnn_out)
                    );

    //FIX11
    logic   signed      [10:0]    fix11_mem_data;
    integer                       fix11_mem_exp_y;

    logic                         fix11_dnn_done;
    logic   unsigned    [15:0]    fix11_dnn_mem_addr;
    logic   signed      [10:0]    fix11_dnn_out [9:0];

    integer                       fix11_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(11),
             .MEM_FILE("../src/data/fix_11.mem"),
             .ARG_X_FILE("../src/data/fix_11_X.mem"),
             .ARG_Y_FILE("../src/data/fix_11_y.mem"))
    FIX11_MEM   (.data(fix11_mem_data),
                 .addr(fix11_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix11_mem_exp_y)
                );



    dnn_relu_fix11 
    FIX11_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix11_dnn_done),
                     .mem_addr(fix11_dnn_mem_addr),
                     .mem_data(fix11_mem_data),
                     .out(fix11_dnn_out)
                    );

    //FIX10
    logic   signed      [9:0]    fix10_mem_data;
    integer                       fix10_mem_exp_y;

    logic                         fix10_dnn_done;
    logic   unsigned    [15:0]    fix10_dnn_mem_addr;
    logic   signed      [9:0]    fix10_dnn_out [9:0];

    integer                       fix10_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(10),
             .MEM_FILE("../src/data/fix_10.mem"),
             .ARG_X_FILE("../src/data/fix_10_X.mem"),
             .ARG_Y_FILE("../src/data/fix_10_y.mem"))
    FIX10_MEM   (.data(fix10_mem_data),
                 .addr(fix10_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix10_mem_exp_y)
                );



    dnn_relu_fix10 
    FIX10_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix10_dnn_done),
                     .mem_addr(fix10_dnn_mem_addr),
                     .mem_data(fix10_mem_data),
                     .out(fix10_dnn_out)
                    );

    //FIX9
    logic   signed      [8:0]    fix9_mem_data;
    integer                       fix9_mem_exp_y;

    logic                         fix9_dnn_done;
    logic   unsigned    [15:0]    fix9_dnn_mem_addr;
    logic   signed      [8:0]    fix9_dnn_out [9:0];

    integer                       fix9_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(9),
             .MEM_FILE("../src/data/fix_9.mem"),
             .ARG_X_FILE("../src/data/fix_9_X.mem"),
             .ARG_Y_FILE("../src/data/fix_9_y.mem"))
    FIX9_MEM   (.data(fix9_mem_data),
                 .addr(fix9_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix9_mem_exp_y)
                );



    dnn_relu_fix9 
    FIX9_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix9_dnn_done),
                     .mem_addr(fix9_dnn_mem_addr),
                     .mem_data(fix9_mem_data),
                     .out(fix9_dnn_out)
                    );

    //FIX8
    logic   signed      [7:0]     fix8_mem_data;
    integer                       fix8_mem_exp_y;

    logic                         fix8_dnn_done;
    logic   unsigned    [15:0]    fix8_dnn_mem_addr;
    logic   signed      [7:0]     fix8_dnn_out [9:0];

    integer                       fix8_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(8),
             .MEM_FILE("../src/data/fix_8.mem"),
             .ARG_X_FILE("../src/data/fix_8_X.mem"),
             .ARG_Y_FILE("../src/data/fix_8_y.mem"))
    FIX8_MEM    (.data(fix8_mem_data),
                 .addr(fix8_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix8_mem_exp_y)
                );

    dnn_relu_fix8 
    FIX8_DNN_RELU   (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix8_dnn_done),
                     .mem_addr(fix8_dnn_mem_addr),
                     .mem_data(fix8_mem_data),
                     .out(fix8_dnn_out)
                    );

    //FIX7
    logic   signed      [6:0]    fix7_mem_data;
    integer                       fix7_mem_exp_y;

    logic                         fix7_dnn_done;
    logic   unsigned    [15:0]    fix7_dnn_mem_addr;
    logic   signed      [6:0]    fix7_dnn_out [9:0];

    integer                       fix7_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(7),
             .MEM_FILE("../src/data/fix_7.mem"),
             .ARG_X_FILE("../src/data/fix_7_X.mem"),
             .ARG_Y_FILE("../src/data/fix_7_y.mem"))
    FIX7_MEM   (.data(fix7_mem_data),
                 .addr(fix7_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix7_mem_exp_y)
                );



    dnn_relu_fix7 
    FIX7_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix7_dnn_done),
                     .mem_addr(fix7_dnn_mem_addr),
                     .mem_data(fix7_mem_data),
                     .out(fix7_dnn_out)
                    );

    //FIX6
    logic   signed      [5:0]    fix6_mem_data;
    integer                       fix6_mem_exp_y;

    logic                         fix6_dnn_done;
    logic   unsigned    [15:0]    fix6_dnn_mem_addr;
    logic   signed      [5:0]    fix6_dnn_out [9:0];

    integer                       fix6_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(6),
             .MEM_FILE("../src/data/fix_6.mem"),
             .ARG_X_FILE("../src/data/fix_6_X.mem"),
             .ARG_Y_FILE("../src/data/fix_6_y.mem"))
    FIX6_MEM   (.data(fix6_mem_data),
                 .addr(fix6_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix6_mem_exp_y)
                );



    dnn_relu_fix6 
    FIX6_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix6_dnn_done),
                     .mem_addr(fix6_dnn_mem_addr),
                     .mem_data(fix6_mem_data),
                     .out(fix6_dnn_out)
                    );

    //FIX5
    logic   signed      [4:0]    fix5_mem_data;
    integer                       fix5_mem_exp_y;

    logic                         fix5_dnn_done;
    logic   unsigned    [15:0]    fix5_dnn_mem_addr;
    logic   signed      [4:0]    fix5_dnn_out [9:0];

    integer                       fix5_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(5),
             .MEM_FILE("../src/data/fix_5.mem"),
             .ARG_X_FILE("../src/data/fix_5_X.mem"),
             .ARG_Y_FILE("../src/data/fix_5_y.mem"))
    FIX5_MEM   (.data(fix5_mem_data),
                 .addr(fix5_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix5_mem_exp_y)
                );



    dnn_relu_fix5 
    FIX5_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix5_dnn_done),
                     .mem_addr(fix5_dnn_mem_addr),
                     .mem_data(fix5_mem_data),
                     .out(fix5_dnn_out)
                    );

    //FIX4
    logic   signed      [3:0]    fix4_mem_data;
    integer                       fix4_mem_exp_y;

    logic                         fix4_dnn_done;
    logic   unsigned    [15:0]    fix4_dnn_mem_addr;
    logic   signed      [3:0]    fix4_dnn_out [9:0];

    integer                       fix4_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(4),
             .MEM_FILE("../src/data/fix_4.mem"),
             .ARG_X_FILE("../src/data/fix_4_X.mem"),
             .ARG_Y_FILE("../src/data/fix_4_y.mem"))
    FIX4_MEM   (.data(fix4_mem_data),
                 .addr(fix4_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix4_mem_exp_y)
                );


    dnn_relu_fix4 
    FIX4_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix4_dnn_done),
                     .mem_addr(fix4_dnn_mem_addr),
                     .mem_data(fix4_mem_data),
                     .out(fix4_dnn_out)
                    );

    //FIX3
    logic   signed      [2:0]    fix3_mem_data;
    integer                       fix3_mem_exp_y;

    logic                         fix3_dnn_done;
    logic   unsigned    [15:0]    fix3_dnn_mem_addr;
    logic   signed      [2:0]    fix3_dnn_out [9:0];

    integer                       fix3_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(3),
             .MEM_FILE("../src/data/fix_3.mem"),
             .ARG_X_FILE("../src/data/fix_3_X.mem"),
             .ARG_Y_FILE("../src/data/fix_3_y.mem"))
    FIX3_MEM   (.data(fix3_mem_data),
                 .addr(fix3_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix3_mem_exp_y)
                );



    dnn_relu_fix3 
    FIX3_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix3_dnn_done),
                     .mem_addr(fix3_dnn_mem_addr),
                     .mem_data(fix3_mem_data),
                     .out(fix3_dnn_out)
                    );

    //FIX2
    logic   signed      [1:0]    fix2_mem_data;
    integer                       fix2_mem_exp_y;

    logic                         fix2_dnn_done;
    logic   unsigned    [15:0]    fix2_dnn_mem_addr;
    logic   signed      [1:0]    fix2_dnn_out [9:0];

    integer                       fix2_hit = 0;

    mem    #(.ADDR_WIDTH(16),
             .DATA_WIDTH(2),
             .MEM_FILE("../src/data/fix_2.mem"),
             .ARG_X_FILE("../src/data/fix_2_X.mem"),
             .ARG_Y_FILE("../src/data/fix_2_y.mem"))
    FIX2_MEM   (.data(fix2_mem_data),
                 .addr(fix2_dnn_mem_addr),
                 .next_tc(next_tc),
                 .exp_y(fix2_mem_exp_y)
                );



    dnn_relu_fix2 
    FIX2_DNN_RELU  (.clk(clk),
                     .rst(rst),
                     .start(start),
                     .reset(reset),
                     .done(fix2_dnn_done),
                     .mem_addr(fix2_dnn_mem_addr),
                     .mem_data(fix2_mem_data),
                     .out(fix2_dnn_out)
                    );


    logic all_done;
    assign all_done = fix2_dnn_done & 
                      fix3_dnn_done & 
                      fix4_dnn_done & 
                      fix5_dnn_done & 
                      fix6_dnn_done & 
                      fix7_dnn_done & 
                      fix8_dnn_done & 
                      fix9_dnn_done & 
                      fix10_dnn_done & 
                      fix11_dnn_done & 
                      fix12_dnn_done & 
                      fix13_dnn_done & 
                      fix14_dnn_done & 
                      fix15_dnn_done & 
                      fix16_dnn_done;

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
            
            //FIX16 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix16_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix16_dnn_out[i];
                end
            end

            if( max_idx == fix16_mem_exp_y) begin
                fix16_hit = fix16_hit + 1;
            end

            ////////////////
            //FIX15 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix15_dnn_out[i]) begin max_idx = i+1;
                    max_confidence = fix15_dnn_out[i];
                end
            end

            if( max_idx == fix15_mem_exp_y) begin
                fix15_hit = fix15_hit + 1;
            end

            //FIX14 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix14_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix14_dnn_out[i];
                end
            end

            if( max_idx == fix14_mem_exp_y) begin
                fix14_hit = fix14_hit + 1;
            end

            //FIX13 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix13_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix13_dnn_out[i];
                end
            end

            if( max_idx == fix13_mem_exp_y) begin
                fix13_hit = fix13_hit + 1;
            end

            //FIX12 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix12_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix12_dnn_out[i];
                end
            end

            if( max_idx == fix12_mem_exp_y) begin
                fix12_hit = fix12_hit + 1;
            end

            //FIX11 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix11_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix11_dnn_out[i];
                end
            end

            if( max_idx == fix11_mem_exp_y) begin
                fix11_hit = fix11_hit + 1;
            end

            //FIX10 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix10_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix10_dnn_out[i];
                end
            end

            if( max_idx == fix10_mem_exp_y) begin
                fix10_hit = fix10_hit + 1;
            end

            //FIX9 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix9_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix9_dnn_out[i];
                end
            end

            if( max_idx == fix9_mem_exp_y) begin
                fix9_hit = fix9_hit + 1;
            end

            //FIX8 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix8_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix8_dnn_out[i];
                end
            end

            if( max_idx == fix8_mem_exp_y) begin
                fix8_hit = fix8_hit + 1;
            end

            //FIX7 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix7_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix7_dnn_out[i];
                end
            end

            if( max_idx == fix7_mem_exp_y) begin
                fix7_hit = fix7_hit + 1;
            end

            //FIX6 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix6_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix6_dnn_out[i];
                end
            end

            if( max_idx == fix6_mem_exp_y) begin
                fix6_hit = fix6_hit + 1;
            end

            //FIX5 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix5_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix5_dnn_out[i];
                end
            end

            if( max_idx == fix5_mem_exp_y) begin
                fix5_hit = fix5_hit + 1;
            end

            //FIX4 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix4_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix4_dnn_out[i];
                end
            end

            if( max_idx == fix4_mem_exp_y) begin
                fix4_hit = fix4_hit + 1;
            end

            //FIX3 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix3_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix3_dnn_out[i];
                end
            end

            if( max_idx == fix3_mem_exp_y) begin
                fix3_hit = fix3_hit + 1;
            end

            //FIX2 Verf
            max_idx = 0;
            max_confidence = 0;

            for(i=0; i< 10; i = i+1) begin
                if( max_confidence < fix2_dnn_out[i]) begin
                    max_idx = i+1;
                    max_confidence = fix2_dnn_out[i];
                end
            end

            if( max_idx == fix2_mem_exp_y) begin
                fix2_hit = fix2_hit + 1;
            end

            testcase = testcase + 1;

            #4 reset = 1'b1;
            #4 reset = 1'b0;

        end

        f = $fopen("results/tst1_dnn_fix_relu.log", "w+");
        $fwrite(f, "FIX2: %d\n", fix2_hit);
        $fwrite(f, "FIX3: %d\n", fix3_hit);
        $fwrite(f, "FIX4: %d\n", fix4_hit);
        $fwrite(f, "FIX5: %d\n", fix5_hit);
        $fwrite(f, "FIX6: %d\n", fix6_hit);
        $fwrite(f, "FIX7: %d\n", fix7_hit);
        $fwrite(f, "FIX8: %d\n", fix8_hit);
        $fwrite(f, "FIX9: %d\n", fix9_hit);
        $fwrite(f, "FIX10: %d\n", fix10_hit);
        $fwrite(f, "FIX11: %d\n", fix11_hit);
        $fwrite(f, "FIX12: %d\n", fix12_hit);
        $fwrite(f, "FIX13: %d\n", fix13_hit);
        $fwrite(f, "FIX14: %d\n", fix14_hit);
        $fwrite(f, "FIX15: %d\n", fix15_hit);
        $fwrite(f, "FIX16: %d\n", fix16_hit);
        $fclose(f);
        
        #4 $finish;
    end
endmodule
