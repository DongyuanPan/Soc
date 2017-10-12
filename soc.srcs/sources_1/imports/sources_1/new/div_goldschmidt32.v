`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/17 16:15:27
// Design Name: 
// Module Name: div_goldschmidt32
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


module div_goldschmidt32  (a, b, start, clk, clrn, q, r, busy, ready, count, reg_a, reg_b);

    input [31:0] a; // dividened : fraction : .1xxx...x
    input [31:0] b; // divisor   : fraction : .1xxx...x
    input start;    // ID_STAGE : start = is_div & ~busy
    input clk, clrn;
    output [31:0] q; // quotient
    output busy;     // cannnot receive new div
    output ready;    // ready to save result
    output [2:0] count; // for sim test only
    output [33:0] reg_a;   // 34-bit : x.xx...xx 
    output [33:0] reg_b;   // 34-bit : 0.1xx..xx
    reg [33:0] reg_a, reg_b;
    reg [2:0] count;
    reg busy, busy2;
    
    always @ (posedge clk or negedge clrn) begin
        if (clrn == 0) begin
            count <= 3'b0;
            busy <= 0;
            busy2 <= 0; // for generating 1-cycle ready
        end else begin
            busy2 <= busy; // 1-cycle delay of busy
            if (start) begin
                reg_a <= {1'b0, a, 1'b0};
                reg_b <= {1'b0, b, 1'b0};
                count <= 3'b0;
                busy <= 1'b1;
            end else begin    // execute 5 iterations
                reg_a <= a68[66:33];
                reg_b <= b68[66:33];
                count <= count + 3'b1;
                if (count == 3'h4) busy <= 0; // finish
            end
        end
    end
    
    wire [33:0] b34 = ~reg_b + 1'b1;
    wire [67:0] a68 = reg_a * b34;
    wire [67:0] b68 = reg_b * b34;
    
    assign ready = ~busy & busy2;  // generate 1-cycle ready
    assign q = reg_a[33:02] + (reg_a[01] | reg_a[00]); // rounding

endmodule
