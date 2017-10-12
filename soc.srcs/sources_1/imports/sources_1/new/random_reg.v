`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/28 21:57:58
// Design Name: 
// Module Name: random_reg
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


module random_reg (min, clk, clrn, random);
    input clk, clrn;
    input [31:0] min;
    output [31:0] random;
    reg [31:0] random;
    
    localparam max = 32;
    
    wire reset = ~| (random[31:0] ^ min);
    always @ (negedge clrn  or posedge clk) begin
        if (clrn == 0) begin
            random = 0;
        end else begin
            if (reset) begin
                random <= max;
            end else begin
                random <= random - 32'b1;
            end
        end
    end
endmodule
