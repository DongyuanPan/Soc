`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 20:41:25
// Design Name: 
// Module Name: int_to_double
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


module int_to_double (d, a);
    
    input [31:0] d; // int range : -2^{31} to 2^{31}-1
    output [63:0] a;
    
    wire sign = d[31];
    wire [31:0] f5 = sign ? -d : d;
    wire [31:0] f0;
    wire [5:0] shamt;
    
    count_leading sh (f5, 1'b0, shamt, f0);
    
    wire [51:0] fraction = {f0[30:0], 21'h0};
    wire [10:0] exponent = 11'b10000011110 - {5'h0, shamt}; // 31 - shamt + 1023
    assign a = (~|d[31:0]) ? 0 : {sign, exponent, fraction};    
    
endmodule
