/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mul4_tb(

    );
    
logic   signed  [3:0]   tb_a;
logic   signed  [3:0]   tb_b;
logic   signed  [3:0]   tb_o;

mul     DUT(.a(tb_a),
            .b(tb_b),
            .o(tb_o));

initial begin : TEST
    integer ref_o;
    logic   passed;
    
    passed = 1'b1;
    for(integer ref_a = -7; ref_a <= 7; ref_a++) begin
        for(integer ref_b = -7; ref_b <= 7; ref_b++) begin
            ref_o = ref_a * ref_b;
            if (ref_o < -7) begin
                ref_o = -7;
            end else if (ref_o > 7) begin
                ref_o = 7;
            end
            
            tb_a <= ref_a;
            tb_b <= ref_b;
            #1
            if(ref_o != tb_o) begin
                passed = 1'b0;
                $display("mul4: Incorrect result: %d * %d = %d , exp: %d ",
                     ref_a, ref_b, tb_o, ref_o); 
            end
        end
    end
    
    if (passed == 1'b0) begin
        $display("TEST FAILED");
    end

    $finish;
end

endmodule
