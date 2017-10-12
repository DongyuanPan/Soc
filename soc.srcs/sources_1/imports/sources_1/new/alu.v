`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:10:17
// Design Name: 
// Module Name: alu
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

module alu (a, b, aluc, r, zero, overflow);
	input [31:0] a, b;
	input [3:0] aluc;
	output [31:0] r;
	output zero, overflow;
	wire cf;
	wire [31:0] d_and = a & b;
	wire [31:0] d_or = a | b;
	wire [31:0] d_xor = a ^ b;
	wire [31:0] d_nor = ~(a | b);
	wire [31:0] d_lui = {b[15:0], 16'h0};
	wire [31:0] d_as, d_shift;
	addsub32 as32 (a, b, aluc[2], d_as, cf);
	shift_mux shifter (b, a[4:0], aluc[0], aluc[1], d_shift);
	wire [31:0] d_slt;
	mux2x32 slt_mux ({32{overflow}}, {32{cf}}, aluc[0], d_slt);
	assign r = r_mux (aluc, d_as, d_slt, d_and, d_or, d_xor, d_nor, d_shift, d_lui);
	assign zero = ~|r;
	assign overflow = 
	           aluc[3] & ~aluc[2] & ~aluc[1] & ~aluc[0] & (~a[31] & ~b[31] & r[31] | a[31] &  b[31] & ~r[31]) | // 1 0 0 0  : add, addi        
	           aluc[3] &  aluc[2] & ~aluc[1] & ~aluc[0] & (~a[31] &  b[31] & r[31] | a[31] & ~b[31] & ~r[31]);  // 1 1 0 0  : sub
	           
    function [31:0] r_mux;
        input [3:0] aluc;
        input [31:0] d_as, d_slt, d_and, d_or, d_xor, d_nor, d_shift, d_lui;
        casex (aluc)
            4'b1x0x : r_mux = d_as;
            4'b111x : r_mux = d_slt;
            4'b0000 : r_mux = d_and;
            4'b0001 : r_mux = d_or;
            4'b0010 : r_mux = d_xor;
            4'b0011 : r_mux = d_nor;
            4'b0100 : r_mux = d_shift;
            4'b0101 : r_mux = d_shift;
            4'b0111 : r_mux = d_shift;
            4'b0110 : r_mux = d_lui;
        endcase
    endfunction	           
	           
     // aluc[3:0]
     // 1 0 0 0 : add, addi, 
     // 1 0 0 1 : addu, addiu
     // 1 1 0 0 : sub
     // 1 1 0 1 : subu, 
     // 1 1 1 0 : slt, slti
     // 1 1 1 1 : sltu, sltiu
     // 0 0 0 0 : and, andi
     // 0 0 0 1 : or, ori
     // 0 0 1 0 : xor, xori, beq, bne
     // 0 0 1 1 : nor
     // 0 1 0 0 : sll, sllv
     // 0 1 0 1 : srl, srlv
     // 0 1 1 1 : sra, srav
     // 0 1 1 0 : lui  	           
	           
endmodule