`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 22:05:03
// Design Name: 
// Module Name: single_to_double
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


module single_to_double (s, d);

    input [31:0] s;
    output [63:0] d;
    
    assign d = {a[31], 3'h0, a[30:23], a[22:0], 29'h0};

endmodule
