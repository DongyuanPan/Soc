`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/28 18:22:40
// Design Name: 
// Module Name: mdu
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


module mdu (a, b, clk, clrn);

    input [31:0] a, b;
    input clk, clrn;
    
    // op
    // 0 0 : madd
    // 0 1 : maddu
    // 1 0 : msub
    // 1 1 : msubu
    wire [1:0] op;
    
    // HI & LO registers
    wire w_hilo;
    wire [63:0] HILO;
    dffe32 HI_reg (HILO[63:32], clk, clrn, w_hilo, R_HI);
    dffe32 LO_reg (HILO[31:00], clk, clrn, w_hilo, R_LO);
    
    // mul : 2 cycles
    wire [63:0] s_mul_signed, s_mul_unsigned;
    wallace_tree32_signed ws (a, b, s_mul_signed);
    wallace_tree32_unsigned wu (a, b, s_mul_unsigned);
    wire [63:0] s_mul = signedFlag ?  s_mul_signed : s_mul_unsigned;
    
    // madd, msub
    wire [63:0] HILO_out;
    wire sub;
    cla64 as64 (s_mul, HILO_in ^ {32{sub}}, sub, HILO_out, co);
    assign overflow = 
               ~sub & (~a[31] & ~b[31] & r[31] | a[31] &  b[31] & ~r[31]) | // madd      
                sub & (~a[31] &  b[31] & r[31] | a[31] & ~b[31] & ~r[31]);  // msub
    
    // div : 32 cycles
    wire [31:0] quotient_s, quotient_u;
    wire [31:0] r_signed, r_unsigned;
    wire div_start, div_busy1, div_busy2, ready1, ready2;
    wire [4:0] count1, count2;
    div_nonrestoring_signed ds (a, b, div_start, clk, clrn, quotient_s, r_signed, div_busy1, ready1, count1);
    div_nonrestoring_unsigned du (a, b, div_start, clk, clrn, quotient_u, r_unsigned, div_busy2, ready2, count2);
    
    
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            
        end else if (e) begin
            
        end
    end

endmodule
