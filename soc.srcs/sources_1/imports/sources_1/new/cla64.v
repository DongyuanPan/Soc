`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/31 21:00:16
// Design Name: 
// Module Name: cla64
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


module cla64 (a, b, ci, s, co);
    
    input [63:0] a, b;
    input ci;
    output [63:0] s;
    output co;
    
    wire [1:0] g, p;
    wire c_out, p_out, g_out;
    
    cla_32 cla0 ( a[31:0],  b[31:0],    ci, g[0], p[0], s[31:0]);
    cla_32 cla1 (a[63:32], b[63:32], c_out, g[1], p[1], s[63:32]);
    g_p g_p0 (g, p, ci, g_out, p_out, c_out);
    assign co = g_out | p_out & ci;

endmodule
