`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/17 16:06:22
// Design Name: 
// Module Name: wallace_tree26x24_unsigned
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


module wallace_tree26x24_unsigned (a, b, s);
    input [25:0] a;
    input [23:0] b;
    output [49:0] s;
    
    wire [48:8] sum;
    wire [49:8] carry;
    wallace_tree26x24_unsigned_partial partial (a, b, sum, carry, s[7:0]);

    assign s[49:8] = {1'b0, sum} + carry;
         
endmodule
