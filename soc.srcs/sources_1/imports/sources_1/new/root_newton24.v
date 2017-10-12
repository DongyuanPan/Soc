`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/17 21:42:08
// Design Name: 
// Module Name: root_newton24
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


module root_newton24 (d, fsqrt, e, clk, clrn, q, busy, count, reg_x, stall);

    input [23:0] d; 
    input fsqrt;        // ID stage : i_fsqrt 
    input e, clk, clrn;
    output [31:0] q;
    output busy, stall;
    output [4:0] count;
    output [25:0] reg_x;
    
    reg [31:0] q;
    reg busy;
    reg [4:0] count;
    reg [25:0] reg_x;
    reg [23:0] reg_d;    

    wire [7:0] x0 = rom (d[23:19]);
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            count <= 5'h0;
            busy <= 1'b0;
        end else begin
            if (fsqrt & (count == 5'h0)) begin
                count <= 5'h1;
                busy <= 1'b1;
            end else begin
                if (count == 5'h1) begin
                    reg_x <= {2'b1, x0, 16'h0};  // 01.xxxx0...0
                    reg_d <= d;
                end
                if (count != 5'h0) count <= count + 5'h1;
                if (count == 5'h15) busy <= 0;   // ready 
                if (count == 5'h16) count <= 5'h0; // reset count
                if ((count == 5'h08) || (count == 5'h0f) || (count == 5'h16)) reg_x <= x52[50:25];
            end
        end
    end
    
    assign stall = fsqrt & (count == 0) | busy;    

    wire [51:0] x_2, x2d, x52;
    wallace_tree26_unsigned x2 (reg_x, reg_x, x_2);
    wallace_tree28x24_unsigned xd (x_2[51:24], reg_d, x2d);
    //assign x2d = x_2[51:24] * reg_d;
    wire [25:0] b26 = 26'h3000000 - x2d[49:24]; 
    wallace_tree26_unsigned xip1 (reg_x, b26, x52);
    
    wire [48:0] m_s;
    wire [41:0] m_c;
    wallace_tree26x24_unsigned_partial wt (reg_x, reg_d, m_s[48:8], m_c, m_s[7:0]);
    reg [48:0] a_s;
    reg [41:0] a_c;
    always @ (negedge clrn or posedge clk) begin
            if (clrn == 0) begin
                a_s <= 0;
                a_c <= 0;
                q <= 0;
            end else begin
                a_s <= m_s;
                a_c <= m_c;
                q <= e2p;                
            end
    end
    wire [49:0] d_x = {1'b0, a_s} + {a_c, 8'h0};
    wire [31:0] e2p = {d_x[47:17], | d_x[16:0]};


    function [7:0] rom; // 1 / d^{1/2}
        input [4:0] b;
        case (b)
            5'h08 : rom = 8'hf0;
            5'h09 : rom = 8'hd5;           
            5'h0a : rom = 8'hbe;
            5'h0b : rom = 8'hab;
            5'h0c : rom = 8'h99;
            5'h0d : rom = 8'h8a;           
            5'h0e : rom = 8'h7c;
            5'h0f : rom = 8'h6f;
            5'h10 : rom = 8'h64;
            5'h11 : rom = 8'h5a;           
            5'h12 : rom = 8'h50;
            5'h13 : rom = 8'h47;
            5'h14 : rom = 8'h3f;
            5'h15 : rom = 8'h38;           
            5'h16 : rom = 8'h31;
            5'h17 : rom = 8'h2a;
            5'h18 : rom = 8'h24;           
            5'h19 : rom = 8'h1e;
            5'h1a : rom = 8'h19;
            5'h1b : rom = 8'h14;
            5'h1c : rom = 8'h0f;           
            5'h1d : rom = 8'h0a;
            5'h1e : rom = 8'h06;  
            5'h1f : rom = 8'h02; 
            default : rom = 8'hff;                                                 
        endcase
    endfunction

endmodule
