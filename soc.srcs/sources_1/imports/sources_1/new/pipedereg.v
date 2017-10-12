`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:08:04
// Design Name: 
// Module Name: pipedereg
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

module pipedereg (dwreg, dm2reg, dwmem, dmem_mode, daluc, daluimm, da, dd, dimm,
				  drn, dshift, djal, dpc4, dpc, dmfc0, dcancel, disbr, dfwdfe, dwfpr, dmfc1, 
				  clk, clrn,
				  ewreg, em2reg, ewmem, emem_mode, ealuc, ealuimm, ea, ed, eimm,
				  ern, eshift, ejal, epc4, epc, emfc0, ecancel, eisbr, efwdfe, ewfpr, emfc1);
	    input clk, clrn;
		input [31:0] da, dd, dimm, dpc4, dpc;
		input [4:0] drn;
		input [3:0] daluc;
		input [2:0] dmem_mode;
		input [1:0] dmfc0;
		input dwreg, dm2reg, dwmem, daluimm, dshift, djal, dcancel, disbr, dfwdfe, dwfpr, dmfc1;
		output [31:0] ea, ed, eimm, epc4, epc;
		output [4:0] ern;
		output [3:0] ealuc;
		output [2:0] emem_mode;
		output [1:0] emfc0;
		output ewreg, em2reg, ewmem, ealuimm, eshift, ejal, ecancel, eisbr, efwdfe, ewfpr, emfc1;
		
	    reg [31:0] ea, ed, eimm, epc4, epc;
        reg [4:0] ern;
        reg [3:0] ealuc;
        reg [2:0] emem_mode;
        reg [1:0] emfc0;
        reg ewreg, em2reg, ewmem, ealuimm, eshift, ejal, ecancel, eisbr, efwdfe, ewfpr, emfc1;	

		always @ (negedge clrn or posedge clk) begin
			if (clrn == 0) begin
				ewreg <= 0;
				em2reg <= 0;
				ewmem <= 0;
				emem_mode <= 0;
				ealuc <= 0;
				ealuimm <= 0;
				ea <= 0;
				ed <= 0;
				eimm <= 0;
				ern <= 0;
				eshift <= 0;
				ejal <= 0;
				epc4 <= 0;
				epc <= 0;
				emfc0 <= 0;
				ecancel <= 0;
				eisbr <= 0;
				efwdfe <= 0;
				ewfpr <= 0;
				emfc1 <= 0;
			end else begin
				ewreg <= dwreg;
				em2reg <= dm2reg;
				ewmem <= dwmem;
				emem_mode <= dmem_mode;
				ealuc <= daluc;
				ealuimm <= daluimm;
				ea <= da;
				ed <= dd;
				eimm <= dimm;
				ern <= drn;
				eshift <= dshift;
				ejal <= djal;
				epc4 <= dpc4;
                epc <= dpc;
                emfc0 <= dmfc0;
                ecancel <= dcancel;
                eisbr <= disbr;
                efwdfe <= dfwdfe;	
                ewfpr <= dwfpr;		
                emfc1 <= dmfc1;
			end
		end
endmodule