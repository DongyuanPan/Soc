`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:11:14
// Design Name: 
// Module Name: addsub32
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

module addsub32 (a, b, sub, s, co);
	input [31:0] a, b;
	input sub;
	output [31:0] s;
	output co;
	cla32 as32 (a, b^{32{sub}}, sub, s, co);
endmodule
