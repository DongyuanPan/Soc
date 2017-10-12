`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 20:28:41
// Design Name: 
// Module Name: single_to_int
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


module single_to_int (a, d, precision_lost, denormalized, invalid);
    
    input [31:0] a;
    output [31:0] d;       // int range : -2^{31} to 2^{31}-1
    output precision_lost; // => 00000000
    output denormalized;   // => 00000000
    output invalid;        // => inf, nan, out-of-range => 80000000
    
    reg [31:0] d;
    reg precision_lost, invalid;
    
    wire hidden_bit = | a[30:23];
    wire frac_is_not_0 = | a[22:0];
    assign denormalized = ~hidden_bit & frac_is_not_0;
    wire is_zero = ~hidden_bit & ~frac_is_not_0;
    wire sign = a[31];
    wire [8:0] shift_right_bits = 9'b010011110 - {1'b0, a[30:23]}; // 127 + 30 - Ea
    wire [55:0] frac0 = {hidden_bit, a[22:0], 32'h0};
    wire [55:0] f_abs = {$signed(shift_right_bits) > 9'h20} ? 
                         frac0 >> 6'h20 :
                         frac0 >> shift_right_bits;
    wire lost_bits = | f_abs[23:0];
    wire [31:0] int32 = (sign) ? -f_abs[55:24] : f_abs[55:24];
    
    always @ * begin
       if (denormalized) begin
            precision_lost = 1'b1;
            invalid = 1'b0;
            d = 32'h0;
       end else begin // not den
            if (shift_right_bits[8]) begin // too big
                precision_lost = 1'b0;
                invalid = 1'b1;
                d = 32'h80000000;
            end else begin // shift right
                if (shift_right_bits[7:0] > 8'h1f) begin // too small
                    precision_lost = ~is_zero;
                    invalid = 1'b0;
                    d = 32'h0;
                end else begin
                    if (sign != int32[31]) begin // out of range
                        precision_lost = 1'b0;
                        invalid = 1'b1;
                        d = 32'h80000000;
                    end else begin // normal case
                        precision_lost = lost_bits;
                        invalid = 1'b0;
                        d = int32;
                    end
                end
            end
       end 
    end    
    
endmodule
