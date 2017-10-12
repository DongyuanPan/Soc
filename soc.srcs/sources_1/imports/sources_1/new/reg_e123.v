`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/16 09:56:07
// Design Name: 
// Module Name: reg_e123
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


module reg_e123 (i_sign, i_ae00, i_aeff, i_af00, i_be00, i_beff, i_bf00, i_rm, i_exp10,
                 clk, clrn, e,
                 o_sign, o_ae00, o_aeff, o_af00, o_be00, o_beff, o_bf00, o_rm, o_exp10);
    input i_sign, i_ae00, i_aeff, i_af00, i_be00, i_beff, i_bf00;
    input [1:0] i_rm;
    input [9:0] i_exp10;                   
    input clk, clrn, e;
    
    output o_sign, o_ae00, o_aeff, o_af00, o_be00, o_beff, o_bf00;
    output [1:0] o_rm;
    output [9:0] o_exp10;      
    
    reg o_sign, o_ae00, o_aeff, o_af00, o_be00, o_beff, o_bf00;
    reg [1:0] o_rm;
    reg [9:0] o_exp10;            
             
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            o_sign <= 0;
            o_ae00 <= 0;
            o_aeff <= 0;
            o_af00 <= 0;
            o_be00 <= 0;
            o_beff <= 0;
            o_bf00 <= 0;
            o_rm <= 0;
            o_exp10 <= 0;
        end else if (e) begin
            o_sign <= i_sign;
            o_ae00 <= i_ae00;
            o_aeff <= i_aeff;
            o_af00 <= i_af00;
            o_be00 <= i_be00;
            o_beff <= i_beff;
            o_bf00 <= i_bf00;
            o_rm <= i_rm;
            o_exp10 <= i_exp10;
        end
    end    
                     
             
endmodule
