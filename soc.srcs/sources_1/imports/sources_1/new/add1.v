`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/11 15:48:10
// Design Name: 
// Module Name: add1
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


module add1(a, b, ci, s, co);
    input a, b, ci;
    output s, co;
    assign s = a ^ b ^ ci;
    assign co = (a & b) | (b & ci) | (a & ci);
endmodule