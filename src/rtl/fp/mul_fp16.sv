/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module mul_fp16
    (input  logic   unsigned    [15:0]  a,
     input  logic   unsigned    [15:0]  b,
     output logic   unsigned    [15:0]  s
    );

    localparam ZERO = 16'h0000;
    localparam NEG_INF = 16'hFA00;
    localparam POS_INF = 16'h7A00;


    always_comb begin: COMB
        automatic logic   sgn_a = a[15];
        automatic logic   sgn_b = b[15];
        automatic logic   unsigned    [4:0] exp_a = a[14:10];
        automatic logic   unsigned    [4:0] exp_b = b[14:10];
        automatic logic   unsigned    [10:0] m_a = {1'b1, a[9:0]};
        automatic logic   unsigned    [10:0] m_b = {1'b1, b[9:0]};

        logic   unsigned    [4:0]   exp_f;
        logic                       sgn_f;
        logic   signed      [10:0]  m_f;
        logic   signed      [9:0]   m_out;

        integer                     e1;
        integer                     e2;
        integer                     ef;
        logic   unsigned    [21:0]  m;

        if(a == ZERO || b == ZERO) begin
            s = ZERO;
        end else if(a == NEG_INF || b == NEG_INF) begin
            s = NEG_INF;
        end else if(a == POS_INF || b == POS_INF) begin
            s = POS_INF;
        end else begin
            sgn_f = sgn_a ^ sgn_b;
            e1 = exp_a;
            e1 = e1 - 15;
            e2 = exp_b;
            e2 = e2 - 15;
            ef = e1 + e2;
            if(ef <= -16) begin
                s = ZERO;
            end else begin
                ef = ef + 15;
                exp_f = ef[4:0]; 

                m = m_a * m_b;
                m_f = m[21:11];

                if(m_f & 11'b10000000000) begin
                    m_out = m_f[9:0];
                    exp_f = exp_f + 1;
                end else if(m_f & 11'b01000000000) begin
                    if(exp_f < 1) begin
                        //zero here
                        m_out = m_f[9:0];
                        exp_f = 0;
                    end else begin
                        m_out = {m_f[8:0], 1'b0};
                        exp_f = exp_f;
                    end
                end else if(m_f & 11'b00100000000) begin
                    if(exp_f < 2) begin
                        //zero here
                        m_out = m_f[8:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[7:0] << 2;
                        exp_f = exp_f - 1;
                    end
                end else if(m_f & 11'b00010000000) begin
                    if(exp_f < 3) begin
                        //zero here
                        m_out = m_f[7:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[6:0] << 3;
                        exp_f = exp_f - 2;
                    end
                end else if(m_f & 11'b00001000000) begin
                    if(exp_f < 4) begin
                        //zero here
                        m_out = m_f[6:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[5:0] << 4;
                        exp_f = exp_f - 3;
                    end
                end else if(m_f & 11'b00000100000) begin
                    if(exp_f < 5) begin
                        //zero here
                        m_out = m_f[5:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[4:0] << 5;
                        exp_f = exp_f - 4;
                    end
                end else if(m_f & 11'b00000010000) begin
                    if(exp_f < 6) begin
                        //zero here
                        m_out = m_f[4:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[3:0] << 6;
                        exp_f = exp_f - 5;
                    end
                end else if(m_f & 11'b00000001000) begin
                    if(exp_f < 7) begin
                        //zero here
                        m_out = m_f[3:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[2:0] << 7;
                        exp_f = exp_f - 6;
                    end
                end else if(m_f & 11'b00000000100) begin
                    if(exp_f < 8) begin
                        //zero here
                        m_out = m_f[2:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[1:0] << 8;
                        exp_f = exp_f - 7;
                    end
                end else if(m_f & 11'b00000000010) begin
                    if(exp_f < 9) begin
                        //zero here
                        m_out = m_f[1:0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = m_f[0] << 9;
                        exp_f = exp_f - 8;
                    end
                end else if(m_f & 11'b00000000001) begin
                    if(exp_f < 10) begin
                        //zero here
                        m_out = m_f[0] << exp_f;
                        exp_f = 0;
                    end else begin
                        m_out = {10{1'b0}};
                        exp_f = exp_f - 9;
                    end
                end else begin
                    //Out of range
                    m_out = {10{1'b0}};
                    exp_f = 0;
                end

                s = {sgn_f, exp_f, m_out};
            end
        end
    end

endmodule
