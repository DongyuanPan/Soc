`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/30 22:07:55
// Design Name: 
// Module Name: double_to_single
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


module double_to_single (d, s);

    input [63:0] d;
    output [31:0] s;
    
    wire precision_lost = ~| d[28:0];
    wire exceed = ~| d[62:60];
    assign s = {d[63], d[59:52], d[51:29]};

endmodule
