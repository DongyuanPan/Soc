`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/16 09:30:51
// Design Name: 
// Module Name: fdiv_newton
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fdiv_newton (a, b, rm, fdiv, e, clk, clrn, s, busy, stall, count, reg_x);
    input [31:0] a, b; // fp a / b
    input [1:0] rm;    // round mode 
    input fdiv;        // ID stage : i_fdiv 
    input e, clk, clrn;
    output [31:0] s;
    output busy, stall;
    output [4:0] count;
    output [25:0] reg_x;
    
    wire a_expo_is_00 = ~| a[30:23];
    wire b_expo_is_00 = ~| b[30:23];
    wire a_expo_is_ff = & a[30:23];
    wire b_expo_is_ff = & b[30:23];
    wire a_frac_is_00 = ~| a[22:00];
    wire b_frac_is_00 = ~| b[22:00];    
    wire sign = a[31] ^ b[31];
    wire [9:0] exp10_temp = {2'h0, a[30:23]} - {2'h0, b[30:23]} + 10'h7f;
    wire [23:0] a_temp24 = a_expo_is_00 ? {a[22:0], 1'b0} : {1'b1, a[22:0]};
    wire [23:0] b_temp24 = b_expo_is_00 ? {b[22:0], 1'b0} : {1'b1, b[22:0]};
    
    wire [23:0] a_frac24, b_frac24;   // to 1xx...xx for den
    wire [4:0] shamt_a, shamt_b;
    shift_to_msb_equ_1 shift_a (a_temp24, a_frac24, shamt_a);
    shift_to_msb_equ_1 shift_b (b_temp24, b_frac24, shamt_b);
    wire [9:0] exp10 = exp10_temp - shamt_a + shamt_b;
    
    wire e1_sign, e1_ae00, e1_aeff, e1_af00, e1_be00, e1_beff, e1_bf00;
    wire e2_sign, e2_ae00, e2_aeff, e2_af00, e2_be00, e2_beff, e2_bf00;
    wire e3_sign, e3_ae00, e3_aeff, e3_af00, e3_be00, e3_beff, e3_bf00;
    wire [1:0] e1_rm, e2_rm, e3_rm;
    wire [9:0] e1_exp10, e2_exp10, e3_exp10;
    
    reg_e123 reg_e1 (sign, a_expo_is_00, a_expo_is_ff, a_frac_is_00, b_expo_is_00, b_expo_is_ff, b_frac_is_00, rm, exp10,
                     clk, clrn, e,
                     e1_sign, e1_ae00, e1_aeff, e1_af00, e1_be00, e1_beff, e1_bf00, e1_rm, e1_exp10);    
    reg_e123 reg_e2 (e1_sign, e1_ae00, e1_aeff, e1_af00, e1_be00, e1_beff, e1_bf00, e1_rm, e1_exp10,
                     clk, clrn, e,
                     e2_sign, e2_ae00, e2_aeff, e2_af00, e2_be00, e2_beff, e2_bf00, e2_rm, e2_exp10);
    reg_e123 reg_e3 (e2_sign, e2_ae00, e2_aeff, e2_af00, e2_be00, e2_beff, e2_bf00, e2_rm, e2_exp10,
                     clk, clrn, e,
                     e3_sign, e3_ae00, e3_aeff, e3_af00, e3_be00, e3_beff, e3_bf00, e3_rm, e3_exp10);              
   
   wire [31:0] q;
   wire [31:0] z0 = q[31] ? q : {q[30:0], 1'b0};
   wire [9:0] exp_adj = q[31] ? e3_exp10 : e3_exp10 - 10'b1;
   newton24 frac_newton (a_frac24, b_frac24, fdiv, e, clk, clrn, q, busy, count, reg_x, stall);
   
  // normolization 
   reg [9:0] exp0;
   reg [31:0] frac0;
   always @ * begin
        if (exp_adj[9]) begin  // exp is negative
            exp0 = 0;
            if (z0[31]) begin
                frac0 = z0 >> (10'b1 - exp_adj);
            end else begin
                frac0 = 0;
            end
        end else if (exp_adj == 0) begin   // exp is 0
            exp0 = 0;
            frac0 = {1'b0, z0[31:2], | z0[1:0]};
        end else begin   // exp > 0
            if (exp_adj > 10'd254) begin  // inf
                exp0 = 10'hff;
                frac0 = 0;
            end else begin     // normal
                exp0 = exp_adj;
                frac0 = z0;
            end
        end
   end
   
   wire [26:0] frac = {frac0[31:6], | frac0[5:0]};
   wire frac_plus_1 = 
           ~e3_rm[1] & ~e3_rm[0] & frac[2] & (frac[1] | frac[0]) | 
           ~e3_rm[1] & ~e3_rm[0] & frac[3] & frac[2] & ~frac[1] & ~frac[0] | 
           ~e3_rm[1] &  e3_rm[0] & (frac[2] | frac[1] | frac[0]) & e3_sign |
            e3_rm[1] & ~e3_rm[0] & (frac[2] | frac[1] | frac[0]) & ~e3_sign;
    wire [24:0] frac_round = {1'b0, frac[26:3]} + frac_plus_1;
    wire [7:0] exponent = frac_round[24] ? exp0 + 10'h1: exp0;
    wire overflow = (exponent >= 10'h0ff);
    
    wire [7:0] final_exponent;
    wire [22:0] final_fraction;
    assign {final_exponent, final_fraction} = 
                    final_result(overflow, e3_rm, e3_sign, e3_ae00, e3_aeff, e3_af00, e3_be00, e3_beff, e3_bf00, {exponent[7:0], frac_round[22:0]});
    assign s = {e3_sign, final_exponent, final_fraction};       
                    
    parameter ZERO = 31'h00000000;
    parameter INF  = 31'h7f800000;
    parameter NaN  = 31'h7fc00000;
    parameter MAX  = 31'h7f7fffff;
                    
    function [30:0] final_result;
            input overflow;
            input [1:0] rm;
            input sign;
            input ae00, aeff, af00, be00, beff, bf00;
            input [30:0] calc;
            casex ({overflow, rm, sign, ae00, aeff, af00, be00, beff, bf00})
                10'b100x_xxx_xxx : final_result = INF;  // overflow
                10'b1010_xxx_xxx : final_result = MAX;  // overflow
                10'b1011_xxx_xxx : final_result = INF;  // overflow
                10'b1100_xxx_xxx : final_result = INF;  // overflow
                10'b1101_xxx_xxx : final_result = MAX;  // overflow
                10'b111x_xxx_xxx : final_result = MAX;  // overflow
                10'b0xxx_010_xxx : final_result = NaN;  // NaN / any
                10'b0xxx_011_010 : final_result = NaN;  // inf / NaN
                10'b0xxx_100_010 : final_result = NaN;  // den / NaN
                10'b0xxx_101_010 : final_result = NaN;  // 0 / NaN
                10'b0xxx_00x_010 : final_result = NaN;  // normal / NaN
                10'b0xxx_011_011 : final_result = NaN;  // inf / inf
                10'b0xxx_100_011 : final_result = ZERO; // den / inf
                10'b0xxx_101_011 : final_result = ZERO; // 0 / inf
                10'b0xxx_00x_011 : final_result = ZERO; // normal / inf
                10'b0xxx_011_101 : final_result = INF;  // inf / 0
                10'b0xxx_100_101 : final_result = INF;  // den / 0
                10'b0xxx_101_101 : final_result = NaN;  // 0 / 0
                10'b0xxx_00x_101 : final_result = INF;  // normal / 0
                10'b0xxx_011_100 : final_result = INF;  // inf / den
                10'b0xxx_100_100 : final_result = calc; // den / den
                10'b0xxx_101_100 : final_result = ZERO; // 0 / den
                10'b0xxx_00x_100 : final_result = calc; // normal / den
                10'b0xxx_011_00x : final_result = INF;  // inf / normal
                10'b0xxx_100_00x : final_result = calc; // den / normal
                10'b0xxx_101_00x : final_result = ZERO; // 0 / den
                10'b0xxx_00x_00x : final_result = calc; // normal / normal
                default          : final_result = NaN;
            endcase
     endfunction             
    
endmodule
