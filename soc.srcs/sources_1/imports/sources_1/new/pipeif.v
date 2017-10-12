`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 16:59:29
// Design Name: 
// Module Name: pipeif
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

module pipeif (clk, pcsource, pc, bpc, rpc, jpc, npc, pc4, ins);
	input [31:0] pc, bpc, rpc, jpc;
	input [1:0] pcsource;
	input clk;
	output [31:0] npc, pc4, ins;
	mux4x32 next_pc (pc4, bpc, rpc, jpc, pcsource, npc);
	cla32 pc_plus4 (pc, 32'h4, 1'b0, pc4);
	pipeimem inst_mem (clk, pc, ins);
endmodule
