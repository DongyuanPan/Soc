`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:09:26
// Design Name: 
// Module Name: pipeexe
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


module pipeexe (ealuc, ealuimm, ea, ed, eimm, eshift, ern0, epc4, ejal, ewreg0, emfc0, pc8c0r, efwdfe, e3d, emfc1,
                eov, ern, ealu, ewreg, epc8, eb);
	input [31:0] ea, ed, eimm, epc4, pc8c0r, e3d;
	input [4:0] ern0;
	input [3:0] ealuc;
	input [1:0] emfc0;
	input ealuimm, eshift, ejal, ewreg0, efwdfe, emfc1;
	output [31:0] ealu, epc8, eb;
	output [4:0] ern;
	output ewreg, eov;
	wire [31:0] alua, alub, sa, ealu0, ealu1;
	wire z, eov;
	
	assign sa = {eimm[5:0], eimm[31:6]};
	cla32 ret_addr (epc4, 32'h4, 1'b0, epc8);
	mux2x32 alu_ina (ea, sa, eshift, alua);
	mux2x32 alu_inb (eb, eimm, ealuimm, alub);
	mux2x32 save_pc8 (ealu1, pc8c0r, ejal | emfc0[1] | emfc0[0], ealu);
	assign ern = ern0 | {5{ejal}};
	alu al_unit (alua, alub, ealuc, ealu0, z, eov);
	mux2x32 alu_eb_mux (ealu0, eb, emfc1, ealu1);
	assign ewreg = ewreg0 & ~eov; // cancel ov inst
	mux2x32 fwd_f_e (ed, e3d, efwdfe, eb);
endmodule