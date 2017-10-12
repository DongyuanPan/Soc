`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/24 20:58:46
// Design Name: 
// Module Name: count_leading
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


module count_leading (a, s_sign, shamt, b);
    
    input [31:0] a;  // shift a = xx..xxx tp b = 1xxx..xx
    input s_sign;      // 0 : count zero, 1 : count one 
    output [31:0] b;
    output [5:0] shamt;
    wire [31:0] sign = {32{s_sign}};
    wire [31:0] data = a ^ sign; 
    wire [31:0] f5, f4, f3, f2, f1, f0;
    assign shamt[5] = ~| data[31:0]; // 32-bit 0
    assign f5 = shamt[5] ? {32'hffffffff} : data;
    assign shamt[4] = ~| f5[31:16]; // 16-bit 0
    assign f4 = shamt[4] ? {f5[15:0], sign[15:0]} : f5;
    assign shamt[3] = ~| f4[31:24]; // 8-bit 0
    assign f3 = shamt[3] ? {f4[23:0], sign[7:0]} : f4;
    assign shamt[2] = ~| f3[31:28]; // 4-bit 0
    assign f2 = shamt[2] ? {f3[27:0], sign[3:0]} : f3;
    assign shamt[1] = ~| f2[31:30]; // 2-bit 0
    assign f1 = shamt[1] ? {f2[29:0], sign[1:0]} : f2;
    assign shamt[0] = ~f1[31]; // 1-bit 0
    assign f0 = shamt[0] ? {f1[30:0], sign[0]} : f1;
    
    assign b = shamt[5] ? 32'h0 : f0 ^ sign;
    
endmodule
