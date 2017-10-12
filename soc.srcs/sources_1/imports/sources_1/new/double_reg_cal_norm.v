`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 19:58:27
// Design Name: 
// Module Name: double_reg_cal_norm
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


module double_reg_cal_norm (c_rm, c_is_inf_nan, c_inf_nan_frac, c_sign, c_exp, c_frac,
                            clk, clrn, e,
                            n_rm, n_is_inf_nan, n_inf_nan_frac, n_sign, n_exp, n_frac);
               
    input [1:0] c_rm;
    input c_is_inf_nan;
    input [51:0] c_inf_nan_frac;
    input c_sign;
    input [10:0] c_exp;
    input [56:0] c_frac;
    input clk, clrn, e;                 
                     
    output [1:0] n_rm;
    output n_is_inf_nan;
    output [51:0] n_inf_nan_frac;
    output n_sign;
    output [10:0] n_exp;
    output [56:0] n_frac;                     
                     
    reg [1:0] n_rm;
    reg n_is_inf_nan;
    reg [51:0] n_inf_nan_frac;
    reg n_sign;
    reg [10:0] n_exp;
    reg [56:0] n_frac;
    
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            n_rm <= 0;
            n_is_inf_nan <= 0;
            n_inf_nan_frac <= 0;
            n_sign <= 0;
            n_exp <= 0;
            n_frac <= 0;
        end else if (e) begin
            n_rm <= c_rm;
            n_is_inf_nan <= c_is_inf_nan;
            n_inf_nan_frac <= c_inf_nan_frac;
            n_sign <= c_sign;
            n_exp <= c_exp;
            n_frac <= c_frac;
        end
    end      

endmodule
