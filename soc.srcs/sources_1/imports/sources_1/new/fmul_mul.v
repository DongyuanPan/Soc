`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/13 16:32:57
// Design Name: 
// Module Name: fmul_mul
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


module fmul_mul (a, b, sign, exp10, inf_nan, inf_nan_frac, z_sum, z_carry, z8);
    input [31:0] a, b;
    output sign;
    output [9:0] exp10;
    output inf_nan;
    output [22:0] inf_nan_frac;
    output [38:0] z_sum;
    output [39:0] z_carry;
    output [7:0] z8;
    
    wire a_expo_is_00 = ~| a[30:23];
    wire b_expo_is_00 = ~| b[30:23];
    wire a_expo_is_ff = & a[30:23];
    wire b_expo_is_ff = & b[30:23];
    wire a_frac_is_00 = ~| a[22:00];
    wire b_frac_is_00 = ~| b[22:00];
    wire a_is_inf = a_expo_is_ff & a_frac_is_00;
    wire b_is_inf = b_expo_is_ff & b_frac_is_00;
    wire a_is_nan = a_expo_is_ff & ~a_frac_is_00;
    wire b_is_nan = b_expo_is_ff & ~b_frac_is_00;
    wire a_is_0 = a_expo_is_00 & a_frac_is_00;
    wire b_is_0 = b_expo_is_00 & b_frac_is_00;
    assign inf_nan = a_is_inf | b_is_inf | a_is_nan | b_is_nan;
    wire s_is_nan = a_is_nan | (a_is_inf & b_is_0) |
                     b_is_nan | (b_is_inf & a_is_0);
    wire [22:0] nan_frac = ({1'b0, a[22:0]} > {1'b0, b[22:0]}) ? {1'b1, a[21:0]} : {1'b1, b[21:0]};
    assign inf_nan_frac = s_is_nan ? nan_frac : 23'h0;
    assign sign = a[31] ^ b[31];
    assign exp10 = {2'h0, a[30:23]} + {2'h0, b[30:23]} - 10'h7f + a_expo_is_00 + b_expo_is_00;
    wire [23:0] a_frac24 = {~a_expo_is_00, a[22:0]};
    wire [23:0] b_frac24 = {~b_expo_is_00, b[22:0]};
    
    wallace_tree24_unsigned_partial wt24 (a_frac24, b_frac24, z_sum, z_carry, z8);
    
endmodule
