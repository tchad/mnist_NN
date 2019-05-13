/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps


module mem
    #(parameter ADDR_WIDTH = 16,
      parameter DATA_WIDTH = 8,
      parameter MEM_FILE = "/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8.mem",
      parameter ARG_X_FILE = "/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8_X.mem",
      parameter ARG_Y_FILE = "/home/udntneed2knw/sjsu/ee278/prj/repo/prj4/src/data/fix_8_y.mem",
      parameter TEST_CASES_NUM = 5000)
     (output    logic   signed      [DATA_WIDTH-1:0]    data,
      input     logic   unsigned    [ADDR_WIDTH-1:0]    addr,     
      input     logic                                   next_tc,
      output    integer                                 exp_y
     );

    logic   signed  [DATA_WIDTH-1:0]    internal_data    [2**ADDR_WIDTH:0];
    integer test_case_num;
    integer f_x;
    integer f_y;

    integer internal_y;

    task read_next();
        integer i;
        logic   signed  [DATA_WIDTH-1:0]    tmp;
        for(i=0; i<401; i = i+1) begin
            $fscanf(f_x, "%b", tmp);
            internal_data[i] = tmp;
        end

        $fscanf(f_y, "%d", internal_y);

        test_case_num = test_case_num + 1;

    endtask

    always_ff @(posedge(next_tc)) begin: LOAD_NEXT_TEST
        if(next_tc == 1'b1) begin
            read_next();
        end
    end

    always_comb begin
        data = internal_data[addr];
        exp_y = internal_y;
    end

    initial begin
        test_case_num = 0;
        f_x = $fopen(ARG_X_FILE, "r");
        f_y = $fopen(ARG_Y_FILE, "r");
        
        $readmemb(MEM_FILE, internal_data);

    end
endmodule
