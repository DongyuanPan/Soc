`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/13 21:25:29
// Design Name: 
// Module Name: fmul_norm
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


module fmul_norm (rm, sign, exp10, is_inf_nan, inf_nan_frac, z, s, f0);
    input [1:0] rm;
    input sign;
    input [9:0] exp10;
    input is_inf_nan;
    input [22:0] inf_nan_frac;
    input [47:0] z;
    output [31:0] s;
    output [47:0] f0;
    
    wire [46:0] f5, f4, f3, f2, f1, f0;
    wire [5:0] zeros;
    assign zeros[5] = ~| z[46:15]; // 32-bit 0
    assign f5 = zeros[5] ? {z[14:0], 32'h0} : z[46:0];
    assign zeros[4] = ~| f5[46:31]; // 16-bit 0
    assign f4 = zeros[4] ? {f5[30:0], 16'h0} : f5;
    assign zeros[3] = ~| f4[46:39]; // 8-bit 0
    assign f3 = zeros[3] ? {f4[38:0], 8'h0} : f4;
    assign zeros[2] = ~| f3[46:43]; // 4-bit 0
    assign f2 = zeros[2] ? {f3[42:0], 4'h0} : f3;
    assign zeros[1] = ~| f2[46:45]; // 2-bit 0
    assign f1 = zeros[1] ? {f2[44:0], 2'h0} : f2;
    assign zeros[0] = ~f1[46]; // 1-bit 0
    assign f0 = zeros[0] ? {f1[45:0], 1'h0} : f1;
        
    reg [9:0] exp0;
    reg [46:0] frac0;
    always @ * begin
        if (z[47]) begin
            frac0 = z[47:1];  // 1x.xxxxxxxxxxxxxxxxxxxxxxx xxx
            exp0 = exp10 + 10'h1;
        end else begin
            if (!exp10[9] && (exp10[8:0] > zeros) && (f0[46])) begin
                exp0 = exp10 - zeros;  // 01.xxxxxxxxxxxxxxxxxxxxxxx xxx
                frac0 = f0;
            end else begin
                exp0 = 0;   // is a denormalized number or 0
                if (!exp10[9] && exp10 != 0) begin
                    frac0 = z[46:0] << (exp10 - 10'h1);
                end else begin
                    frac0 = z[46:0] >> (10'h1 - exp10);
                end
            end
        end 
    end    
    
    wire [26:0] frac = {frac0[46:21], |frac0[20:0]};
    wire frac_plus_1 = 
            ~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0]) | 
            ~rm[1] & ~rm[0] & frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3] | 
            ~rm[1] &  rm[0] & (frac0[2] | frac0[1] | frac0[0]) & sign |
             rm[1] & ~rm[0] & (frac0[2] | frac0[1] | frac0[0]) & ~sign;
    wire [24:0] frac_round = {1'b0, frac[26:3]} + frac_plus_1;
    wire [9:0] exp1 = frac_round[24] ? exp0 + 10'h1: exp0;
    wire overflow = (exp0 >= 10'h0ff) | (exp1 >= 10'h0ff);
    wire [7:0] final_exponent;
    wire [22:0] final_fraction;
    assign {final_exponent, final_fraction} = 
            fmul_final_result(overflow, rm, sign, is_inf_nan, exp1[7:0], frac_round[22:0], inf_nan_frac);
    assign s = {sign, final_exponent, final_fraction};
    
    function [30:0] fmul_final_result;
        input overflow;
        input [1:0] rm;
        input sign, is_inf_nan;
        input [7:0] exponent;
        input [22:0] fraction, inf_nan_frac;
        casex ({overflow, rm, sign, is_inf_nan})
            5'b1_00_x_x : fmul_final_result = {8'hff, 23'h0};        // inf
            5'b1_01_0_x : fmul_final_result = {8'hfe, 23'h7fffff};   // max
            5'b1_01_1_x : fmul_final_result = {8'hff, 23'h0};        // inf
            5'b1_10_0_x : fmul_final_result = {8'hff, 23'h0};        // inf
            5'b1_10_1_x : fmul_final_result = {8'hfe,23'h7fffff};    // max
            5'b1_11_x_x : fmul_final_result = {8'hfe,23'h7fffff};    // max
            5'b0_xx_x_0 : fmul_final_result = {exponent, fraction};  // normal
            5'b0_xx_x_1 : fmul_final_result = {8'hff, inf_nan_frac}; // inf_nan
            default     : fmul_final_result = {8'h0, 23'h0};         // 0
        endcase
    endfunction
    
endmodule
