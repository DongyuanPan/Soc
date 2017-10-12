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

module shift_mux (d, sa, right, arith, sh);
	input [31:0] d;  // input data
	input [4:0] sa;  // shift amout
	input right, arith;
	output [31:0] sh; // output data
	wire [31:0] t0, t1, t2, t3, t4, s1, s2, s3, s4;
	wire a = d[31] & arith;
	wire [15:0] e = {16{a}};
	parameter z = 16'b0;
	wire [31:0] sdl4, sdr4, sdl3, sdr3, sdl2, sdr2, sdl1, sdr1, sdl0, sdr0;

	assign sdl4 = {d[15:0], z};                // shift left 16-bit
	assign sdr4 = {e, d[31:16]};               // shift right 16-bit
	mux2x32 m_right4 (sdl4, sdr4, right, t4);  // left or right
	mux2x32 m_shift4 (d, t4, sa[4], s4);       // not_shift or shift

	assign sdl3 = {s4[23:0], z[7:0]};          // shift left 8-bit
	assign sdr3 = {e[7:0], s4[31:8]};          // shift right 8-bit
	mux2x32 m_right3 (sdl3, sdr3, right, t3);  // left or right
	mux2x32 m_shift3 (s4, t3, sa[3], s3);      // not_shift or shift

	assign sdl2 = {s3[27:0], z[3:0]};          // shift left 4-bit
	assign sdr2 = {e[3:0], s3[31:4]};           // shift right 4-bit
	mux2x32 m_right2 (sdl2, sdr2, right, t2);  // left or right
	mux2x32 m_shift2 (s3, t2, sa[2], s2);      // not_shift or shift

	assign sdl1 = {s2[29:0], z[1:0]};          // shift left 2-bit
	assign sdr1 = {e[1:0], s2[31:2]};          // shift right 2-bit
	mux2x32 m_right1 (sdl1, sdr1, right, t1);  // left or right
	mux2x32 m_shift1 (s2, t1, sa[1], s1);      // not_shift or shift

	assign sdl0 = {s1[30:0], z[0]};            // shift left 1-bit
	assign sdr0 = {e[0], s1[31:1]};            // shift right 1-bit
	mux2x32 m_right0 (sdl0, sdr0, right, t0);  // left or right
	mux2x32 m_shift0 (s1, t0, sa[0], sh);      // not_shift or shift

endmodule