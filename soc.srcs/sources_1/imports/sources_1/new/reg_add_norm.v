`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/13 21:17:23
// Design Name: 
// Module Name: reg_add_norm
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


module reg_add_norm (a_rm, a_sign, a_exp10, a_is_inf_nan, a_inf_nan_frac, a_z48,
                     clk, clrn, e,
                     n_rm, n_sign, n_exp10, n_is_inf_nan, n_inf_nan_frac, n_z48);
    input [1:0] a_rm;
    input a_sign;
    input [9:0] a_exp10;
    input a_is_inf_nan;
    input [22:0] a_inf_nan_frac;
    input [47:0] a_z48;
    input clk, clrn, e;
    
    output [1:0] n_rm;
    output n_sign;
    output [9:0] n_exp10;
    output n_is_inf_nan;
    output [22:0] n_inf_nan_frac;
    output [47:0] n_z48;
    
    reg [1:0] n_rm;
    reg n_sign;
    reg [9:0] n_exp10;
    reg n_is_inf_nan;
    reg [22:0] n_inf_nan_frac;
    reg [47:0] n_z48;
    
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            n_rm <= 0;
            n_sign <= 0;
            n_exp10 <= 0;
            n_is_inf_nan <= 0;
            n_inf_nan_frac <= 0;
            n_z48 <= 0;
        end else if (e) begin
            n_rm <= a_rm;
            n_sign <= a_sign;
            n_exp10 <= a_exp10;
            n_is_inf_nan <= a_is_inf_nan;
            n_inf_nan_frac <= a_inf_nan_frac;
            n_z48 <= a_z48;
        end
    end

endmodule
