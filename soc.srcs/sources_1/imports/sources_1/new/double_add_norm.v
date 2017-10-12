`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 19:55:14
// Design Name: 
// Module Name: double_add_norm
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


module double_add_norm (n_rm, n_is_inf_nan, n_inf_nan_frac, n_sign, n_exp, n_frac, s);

    input [1:0] n_rm;
    input n_is_inf_nan;
    input [51:0] n_inf_nan_frac;
    input n_sign;
    input [10:0] n_exp;
    input [56:0] n_frac;
    output [63:0] s;
    
    wire [55:0] f5, f4, f3, f2, f1, f0;
    wire [5:0] zeros;
	
	assign zeros[5] = ~| n_frac[55:24]; // 32-bit 0
    assign f5 = zeros[5] ? {n_frac[23:0], 32'h0} : n_frac[55:0];
    assign zeros[4] = ~| f5[55:40]; // 16-bit 0
    assign f4 = zeros[4] ? {f5[39:0], 16'h0} : f5;
    assign zeros[3] = ~| f4[55:48]; // 8-bit 0
    assign f3 = zeros[3] ? {f4[47:0], 8'h0} : f4;
    assign zeros[2] = ~| f3[55:52]; // 4-bit 0
    assign f2 = zeros[2] ? {f3[51:0], 4'h0} : f3;
    assign zeros[1] = ~| f2[55:54]; // 2-bit 0
    assign f1 = zeros[1] ? {f2[53:0], 2'h0} : f2;
    assign zeros[0] = ~f1[55]; // 1-bit 0
    assign f0 = zeros[0] ? {f1[54:0], 1'h0} : f1;
        
    reg [10:0] exp0;
    reg [55:0] frac0;
    always @ * begin
        if (n_frac[56]) begin
            frac0 = n_frac[56:1];  // 1x.xxxxxxxxxxxxxxxxxxxxxxx xxx
            exp0 = n_exp + 11'h1;
        end else begin
            if ((n_exp > zeros) && (f0[55])) begin
                exp0 = n_exp - zeros;  // 01.xxxxxxxxxxxxxxxxxxxxxxx xxx
                frac0 = f0;
            end else begin
                exp0 = 0;   // is a denormalized number or 0
                if (n_exp != 0) begin
                    frac0 = n_frac[55:0] << (n_exp - 11'h1);
                end else begin
                    frac0 = n_frac[55:0];
                end
            end
        end 
    end    
        
    wire frac_plus_1 = 
            ~n_rm[1] & ~n_rm[0] & frac0[2] & (frac0[1] | frac0[0]) | 
            ~n_rm[1] & ~n_rm[0] & frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3] | 
            ~n_rm[1] &  n_rm[0] & (frac0[2] | frac0[1] | frac0[0]) & n_sign |
             n_rm[1] & ~n_rm[0] & (frac0[2] | frac0[1] | frac0[0]) & ~n_sign;
    wire [53:0] frac_round = {1'b0, frac0[55:3]} + frac_plus_1;
    wire [10:0] exponent = frac_round[53] ? exp0 + 11'h1: exp0;
    wire overflow = &exp0 | &exponent;
    wire [10:0] final_exponent;
    wire [51:0] final_fraction;
    assign {final_exponent, final_fraction} = 
            final_result(overflow, n_rm, n_sign, n_is_inf_nan, exponent, frac_round[51:0], n_inf_nan_frac);
    assign s = {n_sign, final_exponent, final_fraction};       
            
    function [62:0] final_result;
        input overflow;
        input [1:0] rm;
        input sign, is_inf_nan;
        input [10:0] exponent;
        input [51:0] fraction, inf_nan_frac;
        casex ({overflow, rm, sign, is_inf_nan})
            5'b1_00_x_x : final_result = {11'h7ff, 52'h0};        // inf
            5'b1_01_0_x : final_result = {11'h7ff, 52'hfffffffffffff};   // max
            5'b1_01_1_x : final_result = {11'h7ff, 52'h0};        // inf
            5'b1_10_0_x : final_result = {11'h7ff, 52'h0};        // inf
            5'b1_10_1_x : final_result = {11'h7fe,52'hfffffffffffff};    // max
            5'b1_11_x_x : final_result = {11'h7fe,52'hfffffffffffff};    // max
            5'b0_xx_x_0 : final_result = {exponent, fraction};  // normal
            5'b0_xx_x_1 : final_result = {11'h7ff, inf_nan_frac}; // inf_nan
            default     : final_result = {11'h0, 52'h0};         // 0
        endcase
    endfunction

endmodule
