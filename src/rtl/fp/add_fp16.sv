/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps

module add_fp16
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
        automatic logic   signed    [11:0] m_a = {2'b01, a[9:0]};
        automatic logic   signed    [11:0] m_b = {2'b01, b[9:0]};

        logic   unsigned    [4:0]   exp_f;
        logic                       sgn_f;
        logic   unsigned    [4:0]   shr;
        logic   signed      [11:0]  m_l;
        logic   signed      [11:0]  m_s;
        logic   signed      [11:0]  m_f;
        logic   signed      [9:0]   m_out;

        if(a == ZERO) begin
            s = b;
        end else if(b == ZERO) begin
            s = a;
        end else if(a == NEG_INF || b == NEG_INF) begin
            s = NEG_INF;
        end else if(a == POS_INF || b == POS_INF) begin
            s = POS_INF;
        end else if( (a[14:0] == b[14:0]) && a[15] != b[15]) begin
            //same magnitudes opposite signs
            s = ZERO;
        end else begin
            if(exp_a == exp_b) begin
                exp_f = exp_a;
                shr = 0;

                if(m_a > m_b) begin
                    m_l = m_a;
                    m_s = m_b;
                    sgn_f = sgn_a;
                end else begin
                    m_l = m_b;
                    m_s = m_a;
                    sgn_f = sgn_b;
                end
            end else if(exp_a > exp_b) begin
                exp_f = exp_a;
                shr = exp_a - exp_b;
                m_l = m_a;
                m_s = m_b;
                sgn_f = sgn_a;
            end else begin
                exp_f = exp_b;
                shr = exp_b - exp_a;
                m_l = m_b;
                m_s = m_a;
                sgn_f = sgn_b;
            end

            m_s = m_s >> shr;

            if(sgn_a != sgn_b) begin
                m_f = m_l - m_s;
            end else begin
                m_f = m_l + m_s;
            end

            if(m_f & 12'b100000000000) begin
                m_out = m_f[10:1];
                exp_f = exp_f + 1;
            end else if(m_f & 12'b010000000000) begin
                m_out = m_f[9:0];
            end else if(m_f & 12'b001000000000) begin
                if(exp_f < 1) begin
                    //zero here
                    m_out = m_f[9:0];
                    exp_f = 0;
                end else begin
                    m_out = {m_f[8:0], 1'b0};
                    exp_f = exp_f - 1;
                end
            end else if(m_f & 12'b000100000000) begin
                if(exp_f < 2) begin
                    //zero here
                    m_out = m_f[8:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[7:0] << 2;
                    exp_f = exp_f - 2;
                end
            end else if(m_f & 12'b000010000000) begin
                if(exp_f < 3) begin
                    //zero here
                    m_out = m_f[7:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[6:0] << 3;
                    exp_f = exp_f - 3;
                end
            end else if(m_f & 12'b000001000000) begin
                if(exp_f < 4) begin
                    //zero here
                    m_out = m_f[6:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[5:0] << 4;
                    exp_f = exp_f - 4;
                end
            end else if(m_f & 12'b000000100000) begin
                if(exp_f < 5) begin
                    //zero here
                    m_out = m_f[5:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[4:0] << 5;
                    exp_f = exp_f - 5;
                end
            end else if(m_f & 12'b000000010000) begin
                if(exp_f < 6) begin
                    //zero here
                    m_out = m_f[4:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[3:0] << 6;
                    exp_f = exp_f - 6;
                end
            end else if(m_f & 12'b000000001000) begin
                if(exp_f < 7) begin
                    //zero here
                    m_out = m_f[3:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[2:0] << 7;
                    exp_f = exp_f - 7;
                end
            end else if(m_f & 12'b000000000100) begin
                if(exp_f < 8) begin
                    //zero here
                    m_out = m_f[2:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[1:0] << 8;
                    exp_f = exp_f - 8;
                end
            end else if(m_f & 12'b000000000010) begin
                if(exp_f < 9) begin
                    //zero here
                    m_out = m_f[1:0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = m_f[0] << 9;
                    exp_f = exp_f - 9;
                end
            end else if(m_f & 12'b000000000001) begin
                if(exp_f < 10) begin
                    //zero here
                    m_out = m_f[0] << exp_f;
                    exp_f = 0;
                end else begin
                    m_out = {10{1'b0}};
                    exp_f = exp_f - 10;
                end
            end else begin
                //Out of range
                m_out = {10{1'b0}};
                exp_f = 0;
            end

            s = {sgn_f, exp_f, m_out};
        end
    end

endmodule
