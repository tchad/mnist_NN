/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module add_fix
    #(parameter w=4)
    (input   logic   signed  [w-1:0]   a,
     input   logic   signed  [w-1:0]   b,
     output  logic   signed  [w-1:0]   o
    );
    
    function logic signed [w*2-1:0] min_ext();
        automatic logic signed [w*2-1:0] tmp = 1'b1 << (w-1); 
        min_ext = -tmp +1;
    endfunction
    
    function logic signed [w*2-1:0] max_ext();
        automatic logic signed [w*2-1:0] tmp = 1'b1 << (w-1); 
        max_ext = tmp -1;
    endfunction
    
    function logic signed [w-1:0] min();
        automatic logic signed [w-1:0] tmp = 1'b1 << (w-1); 
        min = tmp + 1;
    endfunction
    
    function logic signed [w-1:0] max();
        automatic logic signed [w-1:0] tmp = 1'b1 << (w-1); 
        max = ~tmp;
    endfunction


    always_comb begin : COMB
        logic   signed  [w*2-1:0]   buffer;
        logic   signed  [w-1:0]   result;
        
        buffer  =  a+b;
        if(buffer < min_ext()) begin
            result = min();
        end else if(buffer > max_ext()) begin
            result = max();
        end else begin
            result = buffer;
        end
        
        o = result;
    end
endmodule
