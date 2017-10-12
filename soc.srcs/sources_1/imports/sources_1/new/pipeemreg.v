`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:12:48
// Design Name: 
// Module Name: pipeemreg
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

module pipeemreg (clk, clrn,
                  ewfpr, ewreg, em2reg, ewmem, emem_mode, ealu, eb, ern, eisbr, epc,
				  mwfpr, mwreg, mm2reg, mwmem, mmem_mode, malu, mb, mrn, misbr, mpc);
		input [31:0] ealu, eb, epc;
		input [4:0] ern;
		input [2:0] emem_mode;
		input ewfpr, ewreg, em2reg, ewmem, eisbr, clk, clrn;
		
		output reg [31:0] malu, mb, mpc;
		output reg [4:0] mrn;
		output reg [2:0] mmem_mode;
		output reg mwfpr, mwreg, mm2reg, mwmem, misbr;

		always @ (negedge clrn or posedge clk) begin
			if (clrn == 0) begin
			    mwfpr <= 0;
				mwreg <= 0;
				mm2reg <= 0;
				mwmem <= 0;
				mmem_mode <= 0;
				malu <= 0;
				mb <= 0;
				mrn <= 0;
				misbr <= 0;
				mpc <= 0;
			end else begin
			    mwfpr <= ewfpr;
				mwreg <= ewreg;
				mm2reg <= em2reg;
				mwmem <= ewmem;
				mmem_mode <= emem_mode;
				malu <= ealu;
				mb <= eb;
				mrn <= ern;
				misbr <= eisbr;
				mpc <= epc;
			end
		end
endmodule