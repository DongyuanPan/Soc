`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:03:27
// Design Name: 
// Module Name: pipeir
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


module pipeir (pc4, inst0, pc, wir, clk, clrn, dpc4, inst, dpc);
	input [31:0] pc4, inst0, pc;
	input wir, clk, clrn;
	output [31:0] dpc4, inst, dpc;
	dffe32 pc_plus4 (pc4, clk, clrn, wir, dpc4);
	dffe32 instruction (inst0, clk, clrn, wir, inst);
	dffe32 pcd_r (pc, clk, clrn, wir, dpc);
endmodule
