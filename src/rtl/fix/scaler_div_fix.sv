/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module scaler_div_fix
    #(parameter WIDTH = 16,
      parameter SCALE = 2)


    (input  logic   signed  [WIDTH-1:0] in,
     output logic   signed  [WIDTH-1:0] out
    );

    localparam IN_MSB_IDX = WIDTH-1;
    localparam SHAMT = $clog2(SCALE);

    function logic signed [WIDTH-1:0] max_neg();
        automatic logic signed [WIDTH-1:0] tmp = 1'b1 << (WIDTH-1); 
        max_neg = tmp + 1;
    endfunction
    
    function logic signed [WIDTH-1:0] max_pos();
        automatic logic signed [WIDTH-1:0] tmp = 1'b1 << (WIDTH-1); 
        max_pos = ~tmp;
    endfunction

    logic   signed  [WIDTH-1:0] sig_out;

    always_comb begin : COMB
        automatic logic unsigned [WIDTH-1:0] tmp;

        if ( in == 0 ) begin
            //If zero
            sig_out = in;
        end else begin
            if ( in[IN_MSB_IDX] == 1'b1) begin
                //If in negative
                tmp = -in;
            end else begin
                tmp = in;
            end

            if(((WIDTH-1) <= SHAMT)) begin
            //Special case when scaling exceeded the bit accuracy
                if (tmp == 0) begin
                    tmp = 0;
                end else begin
                    tmp = 1;
                end
            end else begin
                tmp = tmp >> SHAMT;
                if(tmp == 0) begin
                    tmp = 1;
                end
            end
            
            if (in[IN_MSB_IDX] == 1'b0) begin
                tmp = tmp; //Redundant but kept for clarity
            end else begin //in negative
                tmp = -tmp;
            end

            sig_out = tmp;
        end
    end

    assign out = sig_out;

endmodule
