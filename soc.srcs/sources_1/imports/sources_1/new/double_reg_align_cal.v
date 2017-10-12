`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 19:56:25
// Design Name: 
// Module Name: double_reg_align_cal
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


module double_reg_align_cal (a_rm, a_is_inf_nan, a_inf_nan_frac, a_sign, a_exp, a_op_sub, a_large_frac, a_small_frac,
                             clk, clrn, e,
                             c_rm, c_is_inf_nan, c_inf_nan_frac, c_sign, c_exp, c_op_sub, c_large_frac, c_small_frac);
    input [1:0] a_rm;
    input a_is_inf_nan;
    input [51:0] a_inf_nan_frac;
    input a_sign;
    input [10:0] a_exp;
    input a_op_sub;
    input [52:0] a_large_frac;
    input [55:0] a_small_frac;
    input clk, clrn, e;
    
    output [1:0] c_rm;
    output c_is_inf_nan;
    output [51:0] c_inf_nan_frac;
    output c_sign;
    output [10:0] c_exp;
    output c_op_sub;
    output [23:0] c_large_frac;
    output [26:0] c_small_frac;
    
    reg [1:0] c_rm;
    reg c_is_inf_nan;
    reg [51:0] c_inf_nan_frac;
    reg c_sign;
    reg [10:0] c_exp;
    reg c_op_sub;
    reg [52:0] c_large_frac;
    reg [55:0] c_small_frac;
    
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            c_rm <= 0;
            c_is_inf_nan <= 0;
            c_inf_nan_frac <= 0;
            c_sign <= 0;
            c_exp <= 0;
            c_op_sub <= 0;
            c_large_frac <= 0;
            c_small_frac <= 0;
        end else if (e) begin
            c_rm <= a_rm;
            c_is_inf_nan <= a_is_inf_nan;
            c_inf_nan_frac <= a_inf_nan_frac;
            c_sign <= a_sign;
            c_exp <= a_exp;
            c_op_sub <= a_op_sub;
            c_large_frac <= a_large_frac;
            c_small_frac <= a_small_frac;
        end
    end  

endmodule
