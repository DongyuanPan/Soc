`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/12 20:52:47
// Design Name: 
// Module Name: fadd_align
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


module fadd_align (a, b, sub, a_is_inf_nan, a_inf_nan_frac, a_sign, a_exp, a_op_sub, a_large_frac, a_small_frac);
    input [31:0] a,b;
    input sub;
    output a_is_inf_nan;
    output [22:0] a_inf_nan_frac;
    output a_sign;
    output [7:0] a_exp;
    output a_op_sub;
    output [23:0] a_large_frac;
    output [26:0] a_small_frac;
    
    wire exchange = ({1'b0, b[30:0]} > {1'b0, a[30:0]});
    wire [31:0] fp_large = exchange ? b : a;
    wire [31:0] fp_small = exchange ? a : b;
    wire fp_large_hidden_bit = | fp_large[30:23];
    wire fp_small_hidden_bit = | fp_small[30:23];
    assign a_large_frac = {fp_large_hidden_bit, fp_large[22:0]};
    wire [23:0] small_frac24 = {fp_small_hidden_bit, fp_small[22:0]};
    assign a_exp = fp_large[30:23];
    assign a_sign = exchange ? sub ^ b[31] : a[31];  
    assign a_op_sub = sub ^ fp_large[31] ^ fp_small[31];
    wire fp_large_expo_is_ff = & fp_large[30:23];
    wire fp_small_expo_is_ff = & fp_small[30:23];
    wire fp_large_frac_is_00 = ~| fp_large[22:0];
    wire fp_small_frac_is_00 = ~| fp_small[22:0];
    wire fp_large_is_inf = fp_large_expo_is_ff & fp_large_frac_is_00;
    wire fp_small_is_inf = fp_small_expo_is_ff & fp_small_frac_is_00;
    wire fp_large_is_nan = fp_large_expo_is_ff & ~fp_large_frac_is_00;
    wire fp_small_is_nan = fp_small_expo_is_ff & ~fp_small_frac_is_00;
    assign a_is_inf_nan = fp_large_is_inf | fp_small_is_inf | fp_large_is_nan | fp_small_is_nan;
    wire s_is_nan = fp_large_is_nan | fp_small_is_nan | 
                    ((sub ^ fp_small[31] ^ fp_large[31]) & fp_large_is_inf & fp_small_is_inf);
    wire [22:0] nan_frac = {1'b0, a[22:0]} > {1'b0, b[22:0]} ? {1'b1, a[21:0]} : {1'b1, b[21:0]};
    assign a_inf_nan_frac = s_is_nan ? nan_frac : 23'h0;
    wire [7:0] exp_diff = fp_large[30:23] - fp_small[30:23];
    wire small_den_only = (fp_large[30:23] != 0) & (fp_small[30:23] == 0);
    wire [7:0] shift_amount = small_den_only ? exp_diff - 8'h1 : exp_diff;
    wire [49:0] small_frac50 = (shift_amount >= 7'd26) ? 
                                {26'h0, small_frac24} : 
                                {small_frac24, 26'h0} >> shift_amount;
    assign a_small_frac = {small_frac50[49:24], | small_frac50[23:0]};
endmodule
 