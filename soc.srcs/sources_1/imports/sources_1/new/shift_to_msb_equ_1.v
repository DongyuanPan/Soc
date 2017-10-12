`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/16 09:49:13
// Design Name: 
// Module Name: shift_to_msb_equ_1
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


module shift_to_msb_equ_1 (a, b, shamt);
    input [23:0] a;  // shift a = xx..xxx tp b = 1xxx..xx
    output [23:0] b;
    output [4:0] shamt;
    
    wire [23:0] f4, f3, f2, f1;
    assign shamt[4] = ~| a[23:08]; // 16-bit 0
    assign f4 = shamt[4] ? {a[07:0], 16'h0} : a;
    assign shamt[3] = ~| f4[23:16]; // 8-bit 0
    assign f3 = shamt[3] ? {f4[15:0], 8'h0} : f4;
    assign shamt[2] = ~| f3[23:20]; // 4-bit 0
    assign f2 = shamt[2] ? {f3[19:0], 4'h0} : f3;
    assign shamt[1] = ~| f2[23:22]; // 2-bit 0
    assign f1 = shamt[1] ? {f2[21:0], 2'h0} : f2;
    assign shamt[0] = ~f1[23]; // 1-bit 0
    assign b = shamt[0] ? {f1[22:0], 1'h0} : f1;    
    
endmodule
