`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:14:35
// Design Name: 
// Module Name: pipemwreg
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

module pipemwreg (mwfpr, mwreg, mm2reg, mmo, malu, mrn, clk, clrn,
				  wwfpr, wwreg, wm2reg, wmo, walu, wrn);
	input [31:0] mmo, malu;
	input [4:0] mrn;
	input mwfpr, mwreg, mm2reg;
	input clk, clrn;
	output [31:0] wmo, walu;
	output [4:0] wrn;
	output wwfpr, wwreg, wm2reg;
	reg [31:0] wmo, walu;
	reg [4:0] wrn;
	reg wwfpr, wwreg, wm2reg;

	always @ (negedge clrn or posedge clk) begin
		if (clrn == 0) begin
		    wwfpr <= 0;
			wwreg <= 0;
			wm2reg <= 0;
			wmo <= 0;
			walu <= 0;
			wrn <= 0;
		end else begin
		    wwfpr <= mwfpr;
			wwreg <= mwreg;
			wm2reg <= mm2reg;
			wmo <= mmo;
			walu <= malu;
			wrn <= mrn;
		end
	end
endmodule