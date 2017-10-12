`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/13 16:25:14
// Design Name: 
// Module Name: fmul
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


module fmul (a, b, rm, clk, clrn, e, s);
    input [31:0] a, b;
    input [1:0] rm; // round mode
    input clk,clrn, e;
    output [31:0] s;
    
    // multiple stage
    wire m_sign;
    wire [9:0] m_exp10;
    wire m_is_inf_nan;
    wire [22:0] m_inf_nan_frac;
    wire [38:0] m_sum;
    wire [39:0] m_carry;
    wire [7:0] m_z8;
    fmul_mul mul1 (a, b, m_sign, m_exp10, m_is_inf_nan, m_inf_nan_frac, m_sum, m_carry, m_z8);
    
    // reg between multiple and add
    wire [1:0] a_rm;
    wire a_sign;
    wire [9:0] a_exp10;
    wire a_is_inf_nan;
    wire [22:0] a_inf_nan_frac;
    wire [38:0] a_sum;
    wire [39:0] a_carry;
    wire [7:0] a_z8;
    reg_mul_add reg_ma (rm, m_sign, m_exp10, m_is_inf_nan, m_inf_nan_frac, m_sum, m_carry, m_z8,
                        clk, clrn, e,
                        a_rm, a_sign, a_exp10, a_is_inf_nan, a_inf_nan_frac, a_sum, a_carry, a_z8);
    
    // add stage
    wire [47:8] a_z40;
    assign a_z40 = {1'b0, a_sum} + a_carry;
    
    // reg between add and normolization
    wire [47:0] a_z48 = {a_z40, a_z8};
    wire [1:0] n_rm;
    wire n_sign;
    wire [9:0] n_exp10;
    wire n_is_inf_nan;
    wire [22:0] n_inf_nan_frac;
    wire [47:0] n_z48;
    reg_add_norm reg_an (a_rm, a_sign, a_exp10, a_is_inf_nan, a_inf_nan_frac, a_z48,
                         clk, clrn, e,
                         n_rm, n_sign, n_exp10, n_is_inf_nan, n_inf_nan_frac, n_z48);
    
    // normolization stage
    fmul_norm mul3 (n_rm, n_sign, n_exp10, n_is_inf_nan, n_inf_nan_frac, n_z48, s);
    
endmodule
 