`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/17 21:09:21
// Design Name: 
// Module Name: fsqrt_newton
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


module fsqrt_newton (d, rm, fsqrt, e, clk, clrn, s, busy, stall, count, reg_x);

    input [31:0] d;
    input [1:0] rm;    // round mode 
    input fsqrt;        // ID stage : i_fsqrt 
    input e, clk, clrn;
    output [31:0] s;
    output busy, stall;
    output [4:0] count;
    output [25:0] reg_x;
    
    wire d_expo_is_00 = ~| d[30:23];
    wire d_expo_is_ff = & d[30:23];
    wire d_frac_is_00 = ~| d[22:00];
    wire sign = d[31];
    
    wire [7:0] exp_8 = {1'b0, d[30:24]} + 8'h3f + d[23];
    wire [23:0] d_f24 = d_expo_is_00 ? {d[22:0], 1'b0} : {1'b1, d[22:0]};
    wire [23:0] d_temp24 = d[23] ? {1'b0, d_f24[23:1]} : d_f24;   // .01
    
    wire [23:0] d_frac24;
    wire [4:0] shamt_d;
    shift_even_bits shift_d (d_temp24, d_frac24, shamt_d);
    wire [7:0] exp0 = exp_8 - {4'h0, shamt_d[4:1]};


    wire e1_sign, e1_e00, e1_eff, e1_f00;
    wire e2_sign, e2_e00, e2_eff, e2_f00;
    wire e3_sign, e3_e00, e3_eff, e3_f00;
    wire [1:0] e1_rm, e2_rm, e3_rm;
    wire [7:0] e1_exp, e2_exp, e3_exp;
    fsqrt_reg_e123 reg_e1 (sign, d_expo_is_00, d_expo_is_ff, d_frac_is_00, rm, exp0,
                           clk, clrn, e,
                           e1_sign, e1_e00, e1_eff, e1_f00, e1_rm, e1_exp);
    fsqrt_reg_e123 reg_e2 (e1_sign, e1_e00, e1_eff, e1_f00, e1_rm, e1_exp,
                           clk, clrn, e,
                           e2_sign, e2_e00, e2_eff, e2_f00, e2_rm, e2_exp);
    fsqrt_reg_e123 reg_e3 (e2_sign, e2_e00, e2_eff, e2_f00, e2_rm, e2_exp,
                           clk, clrn, e,
                           e3_sign, e3_e00, e3_eff, e3_f00, e3_rm, e3_exp);
                           
     wire [31:0] frac0;    
     wire [26:0] frac = {frac0[31:6], | frac0[5:0]};  // stickys 
     root_newton24 frac_newton (
        .d(d_frac24), 
        .fsqrt(fsqrt), 
        .e(e), 
        .clk(clk), 
        .clrn(clrn), 
        .q(frac0), 
        .busy(busy), 
        .count(count), 
        .reg_x(reg_x), 
        .stall(stall)
     );
     
     wire frac_plus_1 = 
             ~e3_rm[1] & ~e3_rm[0] & frac[2] & (frac[1] | frac[0]) | 
             ~e3_rm[1] & ~e3_rm[0] & frac[3] & frac[2] & ~frac[1] & ~frac[0] | 
             ~e3_rm[1] &  e3_rm[0] & (frac[2] | frac[1] | frac[0]) & e3_sign |
              e3_rm[1] & ~e3_rm[0] & (frac[2] | frac[1] | frac[0]) & ~e3_sign;
     wire [24:0] frac_round = {1'b0, frac[26:3]} + frac_plus_1;
     wire [7:0] exponent = frac_round[24] ? e3_exp + 8'h1: e3_exp;
     wire overflow = (exponent >= 10'h0ff);
      
     wire [7:0] final_exponent;
     wire [22:0] final_fraction;
     assign {final_exponent, final_fraction} = 
           final_result(overflow, e3_rm, e3_sign, e3_sign, e3_e00, e3_eff, e3_f00, {exponent[7:0], frac_round[22:0]});
     assign s = {e3_sign, final_exponent, final_fraction};       
                      
     parameter ZERO = 31'h00000000;
     parameter INF  = 31'h7f800000;
     parameter NaN  = 31'h7fc00000;
     parameter MAX  = 31'h7f7fffff;
                      
     function [30:0] final_result;
        input overflow;
        input [1:0] rm;
        input sign;
        input d_sign, e00, eff, f00;
        input [30:0] calc;
        casex ({overflow, rm, sign, d_sign, e00, eff, f00})
            8'b100x_xxxx : final_result = INF;  // overflow
            8'b1010_xxxx : final_result = MAX;  // overflow
            8'b1011_xxxx : final_result = INF;  // overflow
            8'b1100_xxxx : final_result = INF;  // overflow
            8'b1101_xxxx : final_result = MAX;  // overflow 
            8'b111x_xxxx : final_result = MAX;  // overflow
            8'b0xxx_1xxx : final_result = NaN;  // negative  
            8'b0xxx_0010 : final_result = NaN;  // nan
            8'b0xxx_0011 : final_result = INF;  // inf
            8'b0xxx_0101 : final_result = ZERO; // 0
            8'b0xxx_000x : final_result = calc;  // normal
            8'b0xxx_0100 : final_result = calc;  // den    
            default      : final_result = NaN;
         endcase
     endfunction
                                                                             
endmodule
