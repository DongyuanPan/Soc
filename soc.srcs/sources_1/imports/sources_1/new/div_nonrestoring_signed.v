`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/26 19:12:07
// Design Name: 
// Module Name: div_nonrestoring_signed
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


module div_nonrestoring_signed (a, b, start, clk, clrn, quotient, r, busy, ready, count);
   input [31:0] a; // dividened
   input [31:0] b; // divisor
   input start;    // ID_STAGE : start = is_div & ~busy
   input clk, clrn;
   
   output [31:0] quotient;
   output [31:0] r; 
   output busy;     // cannnot receive new div
   output ready;    // ready to save result
   output [4:0] count; // for sim test only
   
   reg [31:0] reg_q;
   reg [31:0] reg_r, reg_b;
   reg [4:0] count;
   reg busy, busy2, r_sign, sign;
   reg b_sign;
   
   wire [31:0] a_data = a[31] ? ~a + 32'b1 : a;
   wire [31:0] b_data = b[31] ? ~b + 32'b1 : b; 
   
   always @ (posedge clk or negedge clrn) begin
       if (clrn == 0) begin
           count <= 5'b0;
           busy <= 0;
           busy2 <= 0; // for generating 1-cycle ready
       end else begin
           busy2 <= busy; // 1-cycle delay of busy
           if (start) begin
               reg_r <= 0;
               r_sign <= a_data[31];  // if signs diff, add
               sign <= a[31] ^ b[31]; // result sign
               reg_q <= a_data;
               reg_b <= b_data;
               count <= 5'b0;
               busy <= 1'b1;
               b_sign <= b[31];
           end else if (busy) begin    // execute 32 cycles
               reg_r <= sub_add[31:0];
               r_sign <= sub_add[32];   // if minus, add next
               reg_q <= {reg_q[30:0], ~sub_add[32]};
               count <= count + 5'b1;
               if (count == 5'h1f) busy <= 0; // finish
           end
       end
   end
   
   assign ready = ~busy & busy2;  // generate 1-cycle ready
   wire [32:0] sub_add = (r_sign ^ reg_b[31]) ? 
                          {reg_r, reg_q[31]} + {reg_b[31], reg_b} : 
                          {reg_r, reg_q[31]} - {reg_b[31], reg_b};
   
   wire [31:0] abs_b = reg_b[31] ? ~reg_b + 32'b1 : reg_b;
   wire [31:0] r_temp = r_sign ? reg_r + abs_b : reg_r;
   assign r = b_sign ? 0 - r_temp : r_temp;
   assign quotient = sign ? ~reg_q + 32'b1 : reg_q;
   
endmodule
