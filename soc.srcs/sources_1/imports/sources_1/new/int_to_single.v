`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 20:29:53
// Design Name: 
// Module Name: int_to_single
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


module int_to_single (d, a, precision_lost);
    
    input [31:0] d; // int range : -2^{31} to 2^{31}-1
    output [31:0] a;
    output precision_lost;
    
    wire sign = d[31]; 
    wire [31:0] f5 = sign ? -d : d;
    wire [31:0] f0;
    wire [5:0] shamt;
    
    count_leading sh (f5, 1'b0, shamt, f0);
    
    assign precision_lost = | f0[7:0]; 
    wire [22:0] fraction = f0[30:8];
    wire [7:0] exponent = 8'b10011110 - {2'h0, shamt};  // 31 - shamt + 127
    assign a = (~|d[31:0]) ? 0 : {sign, exponent, fraction};
    
endmodule
