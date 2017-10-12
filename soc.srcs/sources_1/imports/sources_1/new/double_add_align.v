`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 20:01:04
// Design Name: 
// Module Name: double_add_align
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


module double_add_align (a, b, sub, a_is_inf_nan, a_inf_nan_frac, a_sign, a_exp, a_op_sub, a_large_frac, a_small_frac);
    input [63:0] a,b;
    input sub;
    output a_is_inf_nan;
    output [51:0] a_inf_nan_frac;
    output a_sign;
    output [10:0] a_exp;
    output a_op_sub;
    output [52:0] a_large_frac;
    output [55:0] a_small_frac;
    
    wire exchange = ({1'b0, b[62:0]} > {1'b0, a[62:0]});
    wire [63:0] fp_large = exchange ? b : a;
    wire [63:0] fp_small = exchange ? a : b;
    wire fp_large_hidden_bit = | fp_large[62:52];
    wire fp_small_hidden_bit = | fp_small[62:52];
    assign a_large_frac = {fp_large_hidden_bit, fp_large[51:0]};
    wire [52:0] small_frac53 = {fp_small_hidden_bit, fp_small[51:0]};
    assign a_exp = fp_large[62:52];
    assign a_sign = exchange ? sub ^ b[63] : a[63];  
    assign a_op_sub = sub ^ fp_large[63] ^ fp_small[63];
    wire fp_large_expo_is_ff = & fp_large[62:52];
    wire fp_small_expo_is_ff = & fp_small[62:52];
    wire fp_large_frac_is_00 = ~| fp_large[51:0];
    wire fp_small_frac_is_00 = ~| fp_small[51:0];
    wire fp_large_is_inf = fp_large_expo_is_ff & fp_large_frac_is_00;
    wire fp_small_is_inf = fp_small_expo_is_ff & fp_small_frac_is_00;
    wire fp_large_is_nan = fp_large_expo_is_ff & ~fp_large_frac_is_00;
    wire fp_small_is_nan = fp_small_expo_is_ff & ~fp_small_frac_is_00;
    assign a_is_inf_nan = fp_large_is_inf | fp_small_is_inf | fp_large_is_nan | fp_small_is_nan;
    wire s_is_nan = fp_large_is_nan | fp_small_is_nan | 
                    ((sub ^ fp_small[63] ^ fp_large[63]) & fp_large_is_inf & fp_small_is_inf);
    wire [51:0] nan_frac = {1'b0, a[51:0]} > {1'b0, b[51:0]} ? {1'b1, a[50:0]} : {1'b1, b[50:0]};
    assign a_inf_nan_frac = s_is_nan ? nan_frac : 52'h0;
    wire [10:0] exp_diff = fp_large[62:52] - fp_small[62:52];
    wire small_den_only = (fp_large[62:52] != 0) & (fp_small[62:52] == 0);
    wire [10:0] shift_amount = small_den_only ? exp_diff - 11'h1 : exp_diff;
    wire [107:0] small_frac108 = (shift_amount >= 11'd55) ? 
                                {55'h0, small_frac53} :
                                {small_frac53, 55'h0} >> shift_amount;
    assign a_small_frac = {small_frac108[107:53], | small_frac108[52:0]};    
    
    
endmodule
