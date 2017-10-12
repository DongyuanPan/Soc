`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:01:48
// Design Name: 
// Module Name: pipeimem
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


module pipeimem (clk, a, inst);
	input clk;
	input [31:0] a;
	output [31:0] inst;
			
	inst_rom my_inst (
      .clka(clk),    // input wire clka
      .ena(1'b1),      // input wire ena
      .addra(a[5:2]),  // input wire [3 : 0] addra
      .douta(inst)  // output wire [31 : 0] douta
    );
	
endmodule



