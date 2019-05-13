/*
"""
    EE278: Miniproject 4, RTL Implementation of the Inference Engine
           for MNIST Digit Recognition 
    SJSU, Fall 2018
    Tomasz Chadzynski
"""
*/

`timescale 1ns / 1ps


module sm_relu
    #(parameter DATA_WIDTH = 8,
      parameter ADDR_WIDTH = 16,
      parameter ADDR_BASE_A = 0,
      parameter ADDR_BASE_W = 0,
      parameter ADDR_BASE_REG = 0)
    (input  logic   clk,
     input  logic   rst,

     input  logic                                   start,
     input  logic                                   reset,
     output logic   unsigned                        done,

     output logic   unsigned    [ADDR_WIDTH-1:0]    mem_addr,

     output logic   unsigned    [2:0]               r_sh_en,
     input  logic                                   arg_zero,

     output logic   unsigned    [1:0]               mac_en,
     output logic   unsigned    [1:0]               mac_clr);

    typedef enum integer {
                SI_IDLE          = 0,
                S1_L1_LD_A       = 1,
                S2_L1_LD_W       = 2,
                S3_L1_MAC_CYCLE  = 3,
                S4_L2_LA_W       = 4,
                S5_L2_MAC_CYCLE  = 5,
                S6_FINISHED      = 6
               } state_t;


    localparam  L1_NEURON_COUNT = 25;
    localparam  L2_NEURON_COUNT = 10;
    localparam  L1_A_COUNT = 401;
    localparam  L2_A_COUNT = 26;

     //Current state
    state_t state;
    integer a_counter;
    integer w_counter;
    logic   unsigned    [ADDR_WIDTH-1:0]     a_addr_offset;
    logic   unsigned    [ADDR_WIDTH-1:0]     w_addr_offset;

   
     //Next state 
    state_t state_next;
    integer a_counter_next;
    integer w_counter_next;
    logic   unsigned    [ADDR_WIDTH-1:0]     a_addr_offset_next;
    logic   unsigned    [ADDR_WIDTH-1:0]     w_addr_offset_next;


    always_ff @(posedge(clk) or posedge(rst)) begin: SM_SEQ
        if(rst == 1'b1) begin
            a_counter <= 0;
            a_addr_offset <= 0;
            w_counter <= 0;
            w_addr_offset <= 0;

            state <= SI_IDLE;
        end else begin
            a_counter <= #1 a_counter_next;
            a_addr_offset <= #1 a_addr_offset_next;
            w_counter <= #1 w_counter_next;
            w_addr_offset <= #1 w_addr_offset_next;
            state <= #1 state_next;
        end
    end

    always_comb begin: SM_NEXT
        //Default next state assignment
        a_counter_next = a_counter;
        w_counter_next = w_counter;
        a_addr_offset_next = a_addr_offset;
        w_addr_offset_next = w_addr_offset;
        state_next = state;

        case(state)
            SI_IDLE: begin
                if(start == 1'b1) begin
                   a_counter_next = 0;
                   w_counter_next = 0;
                   a_addr_offset_next = 0;
                   w_addr_offset_next = 0;

                   state_next = S1_L1_LD_A;
                end else begin 
                   state_next = SI_IDLE;
                end
            end
            S1_L1_LD_A: begin
                a_counter_next = a_counter + 1;
                a_addr_offset_next = a_addr_offset + 1;
                w_counter_next = 0;

                if(a_counter < L1_A_COUNT) begin
                    state_next = S2_L1_LD_W;
                end else begin
                    state_next = S4_L2_LA_W;
                    a_counter_next = 0;
                end
            end
            S2_L1_LD_W: begin
                if(arg_zero == 1'b1) begin
                    w_counter_next = w_counter + L1_NEURON_COUNT;
                    w_addr_offset_next = w_addr_offset_next + L1_NEURON_COUNT;

                    state_next = S1_L1_LD_A;
                end else if(w_counter < L1_NEURON_COUNT) begin
                    w_counter_next = w_counter + 1;
                    w_addr_offset_next = w_addr_offset + 1;

                    state_next = S2_L1_LD_W;
                end else begin
                    state_next = S3_L1_MAC_CYCLE;
                end
            end
            S3_L1_MAC_CYCLE: begin
                state_next = S1_L1_LD_A;
            end
            S4_L2_LA_W: begin
                if(w_counter < L2_NEURON_COUNT) begin
                    w_counter_next = w_counter + 1;
                    w_addr_offset_next = w_addr_offset + 1;
                    state_next = S4_L2_LA_W;
                end else begin
                    state_next = S5_L2_MAC_CYCLE;
                end

            end
            S5_L2_MAC_CYCLE: begin
                a_counter_next = a_counter + 1;

                if(a_counter_next < L2_A_COUNT) begin
                    w_counter_next = 0;
                    state_next = S4_L2_LA_W;
                end else begin
                    state_next = S6_FINISHED;
                end
            end
            S6_FINISHED: begin
                if(reset == 1'b0) begin
                    state_next = S6_FINISHED;
                end else begin
                    state_next = SI_IDLE;
                end
            end
        endcase
    end

    always_comb begin: SM_OUT
        //Default output assignment
        done = 1'b0;
        mem_addr = {ADDR_WIDTH{1'b0}};
        r_sh_en = 3'b000;
        mac_en = 2'b00;
        mac_clr = 2'b00;

        case(state)
            SI_IDLE: begin
                mac_clr = 2'b11;
            end
            S1_L1_LD_A: begin
                mem_addr = ADDR_BASE_A + a_addr_offset;
                r_sh_en = 3'b001;
            end
            S2_L1_LD_W: begin
                mem_addr = ADDR_BASE_W + w_addr_offset;

                if(w_counter < L1_NEURON_COUNT) begin
                    r_sh_en = 3'b010;
                end
            end
            S3_L1_MAC_CYCLE: begin
                mac_en = 2'b01;
            end
            S4_L2_LA_W: begin
                mem_addr = ADDR_BASE_W + w_addr_offset;

                if(w_counter < L2_NEURON_COUNT) begin
                    r_sh_en = 3'b100;
                end
            end
            S5_L2_MAC_CYCLE: begin
                    mac_en = 2'b10;
                    mem_addr = ADDR_BASE_REG + a_counter;
            end
            S6_FINISHED: begin
                done = 1'b1;
            end
        endcase
    end
endmodule



