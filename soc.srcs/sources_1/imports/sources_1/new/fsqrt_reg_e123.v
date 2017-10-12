`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/17 21:18:21
// Design Name: 
// Module Name: fsqrt_reg_e123
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


module fsqrt_reg_e123 (i_sign, i_e00, i_eff, i_f00, i_rm, i_exp,
                       clk, clrn, e,
                       o_sign, o_e00, o_eff, o_f00, o_rm, o_exp);
    
    input i_sign, i_e00, i_eff, i_f00;
    input [1:0] i_rm;
    input [7:0] i_exp;                   
    input clk, clrn, e;
    
    output o_sign, o_e00, o_eff, o_f00;
    output [1:0] o_rm;
    output [7:0] o_exp;      
    
    reg o_sign, o_e00, o_eff, o_f00;
    reg [1:0] o_rm;
    reg [7:0] o_exp;            
             
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            o_sign <= 0;
            o_e00 <= 0;
            o_eff <= 0;
            o_f00 <= 0;
            o_rm <= 0;
            o_exp <= 0;
        end else if (e) begin
            o_sign <= i_sign;
            o_e00 <= i_e00;
            o_eff <= i_eff;
            o_f00 <= i_f00;
            o_rm <= i_rm;
            o_exp <= i_exp;
        end
    end        
    
endmodule
