`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/12 20:45:15
// Design Name: 
// Module Name: fadder
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


module fadder (a, b, sub, rm, clk, clrn, e, s);
    input [31:0] a, b;
    input sub; // 0 : add; 1 : sub
    input [1:0] rm; // round mode
    input clk, clrn, e;
    output [31:0] s;
    
    // alignment stage
    wire a_is_inf_nan;
    wire [22:0] a_inf_nan_frac;
    wire a_sign;
    wire [7:0] a_exp;
    wire a_op_sub;
    wire [23:0] a_large_frac;
    wire [26:0] a_small_frac;
    fadd_align alignment (a, b, sub, a_is_inf_nan, a_inf_nan_frac, a_sign, a_exp, a_op_sub, a_large_frac, a_small_frac);
    
    // reg between alignment and calculation
    wire [1:0] c_rm;
    wire c_is_inf_nan;
    wire [22:0] c_inf_nan_frac;
    wire c_sign;
    wire [7:0] c_exp;
    wire c_op_sub;
    wire [23:0] c_large_frac;
    wire [26:0] c_small_frac;
    reg_align_cal reg_ac (rm, a_is_inf_nan, a_inf_nan_frac, a_sign, a_exp, a_op_sub, a_large_frac, a_small_frac,
                          clk, clrn, e,
                          c_rm, c_is_inf_nan, c_inf_nan_frac, c_sign, c_exp, c_op_sub, c_large_frac, c_small_frac);
    
    // calculation stage
    wire [27:0] c_frac;
    fadd_cal calculation (c_op_sub, c_large_frac, c_small_frac, c_frac);
    
    // reg between calculation and normalization
    wire [1:0] n_rm;
    wire n_is_inf_nan;
    wire [22:0] n_inf_nan_frac;
    wire n_sign;
    wire [7:0] n_exp;
    wire [27:0] n_frac;
    reg_cal_norm reg_cn (c_rm, c_is_inf_nan, c_inf_nan_frac, c_sign, c_exp, c_frac,
                         clk, clrn, e,
                         n_rm, n_is_inf_nan, n_inf_nan_frac, n_sign, n_exp, n_frac);
    
    // normalization stage
    fadd_norm normalization (n_rm, n_is_inf_nan, n_inf_nan_frac, n_sign, n_exp, n_frac, s);
    
endmodule
