`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/12 19:22:38
// Design Name: 
// Module Name: div_nonrestoring_unsigned
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


module div_nonrestoring_unsigned (a, b, start, clk, clrn, reg_q, r, busy, ready, count);
    input [31:0] a; // dividened
    input [31:0] b; // divisor
    input start;    // ID_STAGE : start = is_div & ~busy
    input clk, clrn;
    
    output [31:0] reg_q;
    output [31:0] r;
    output busy;     // cannnot receive new div
    output ready;    // ready to save result
    output [4:0] count; // for sim test only
    
    reg [31:0] reg_q;
    reg [31:0] reg_r, reg_b;
    reg [4:0] count;
    reg busy, busy2, r_sign;
    
    always @ (posedge clk or negedge clrn) begin
        if (clrn == 0) begin
            count <= 5'b0;
            busy <= 0;
            busy2 <= 0; // for generating 1-cycle ready
        end else begin
            busy2 <= busy; // 1-cycle delay of busy
            if (start) begin
                reg_r <= 32'h0;
                r_sign <= 0;  // sub first
                reg_q <= a;
                reg_b <= b;
                count <= 5'b0;
                busy <= 1'b1;
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
    wire [32:0] sub_add = r_sign ? {reg_r, reg_q[31]} + {1'b0, reg_b} : {reg_r, reg_q[31]} - {1'b0, reg_b};
    assign r = r_sign ? reg_r + reg_b : reg_r;
    
endmodule
