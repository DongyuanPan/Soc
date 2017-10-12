`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/13 21:09:57
// Design Name: 
// Module Name: reg_mul_add
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


module reg_mul_add (m_rm, m_sign, m_exp10, m_is_inf_nan, m_inf_nan_frac, m_sum, m_carry, m_z8,
                    clk, clrn, e,
                    a_rm, a_sign, a_exp10, a_is_inf_nan, a_inf_nan_frac, a_sum, a_carry, a_z8);
        input [1:0] m_rm;
        input m_sign;
        input [9:0] m_exp10;
        input m_is_inf_nan;
        input [22:0] m_inf_nan_frac;
        input [38:0] m_sum;
        input [39:0] m_carry;
        input [7:0] m_z8;
        input clk, clrn, e;
        
        output [1:0] a_rm;
        output a_sign;
        output [9:0] a_exp10;
        output a_is_inf_nan;
        output [22:0] a_inf_nan_frac;
        output [38:0] a_sum;
        output [39:0] a_carry;
        output [7:0] a_z8;
        
        reg [1:0] a_rm;
        reg a_sign;
        reg [9:0] a_exp10;
        reg a_is_inf_nan;
        reg [22:0] a_inf_nan_frac;
        reg [38:0] a_sum;
        reg [39:0] a_carry;
        reg [7:0] a_z8;
        
        always @ (negedge clrn or posedge clk) begin
            if (clrn == 0) begin
                a_rm <= 0;
                a_sign <= 0;
                a_exp10 <= 0;
                a_is_inf_nan <= 0;
                a_inf_nan_frac <= 0;
                a_sum <= 0;
                a_carry <= 0;
                a_z8 <= 0;
            end else if (e) begin
                a_rm <= m_rm;
                a_sign <= m_sign;
                a_exp10 <= m_exp10;
                a_is_inf_nan <= m_is_inf_nan;
                a_inf_nan_frac <= m_inf_nan_frac;
                a_sum <= m_sum;
                a_carry <= m_carry;
                a_z8 <= m_z8;
            end
        end
        
endmodule
