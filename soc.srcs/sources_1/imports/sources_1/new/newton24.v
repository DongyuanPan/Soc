`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/16 15:25:35
// Design Name: 
// Module Name: newton24
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


module newton24 (a, b, fdiv, e, clk, clrn, q, busy, count, reg_x, stall);
    input [23:0] a;  // dividened : fraction is .1xxx..xx
    input [23:0] b;  // divisor   : fraction is .1xxx..xx
    input e, clk, clrn;
    input fdiv;
    output [31:0] q; // a / b
    output busy, stall;
    output [25:0] reg_x;
    output [4:0] count;
    
    reg [31:0] q; // a / b
    reg busy;
    reg [25:0] reg_x;
    reg [23:0] reg_a, reg_b;
    reg [4:0] count;
    
    wire [7:0] x0 = rom (b[22:19]);
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            count <= 5'h0;
            busy <= 1'b0;
        end else begin
            if (fdiv & (count == 5'h0)) begin
                count <= 5'h1;
                busy <= 1'b1;
            end else begin
                if (count == 5'h1) begin
                    reg_x <= {2'b1, x0, 16'h0};  // 01.xxxx0...0
                    reg_a <= a;                  //   .1xxx...x
                    reg_b <= b;                  //   .1xxx...x
                end
                if (count != 5'h0) count <= count + 5'h1;
                if (count == 5'h0f) busy <= 0;   // ready for next
                if ((count == 5'h06) || (count == 5'h0b) || (count == 5'h10)) reg_x <= x52[50:25];
            end
        end
    end
    
    assign stall = fdiv & (count == 0) | busy;
    
    wire [49:0] bxi;
    wire [51:0] x52;
    wallace_tree26x24_unsigned bxxi (reg_x, reg_b, bxi);
    wire [25:0] b26 = ~bxi[48:23] + 1'b1;
    wallace_tree26_unsigned xip1 (reg_x, b26, x52);
    
    wire [48:0] m_s;
    wire [41:0] m_c;
    wallace_tree26x24_unsigned_partial wt (reg_x, reg_a, m_s[48:8], m_c, m_s[7:0]);
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
    wire [31:0] e2p = {d_x[48:18], | d_x[17:0]};
    
    
    function [7:0] rom;
        input [3:0] b;
        case (b)
            4'h0 : rom = 8'hf0;
            4'h1 : rom = 8'hd4;           
            4'h2 : rom = 8'hba;
            4'h3 : rom = 8'ha4;
            4'h4 : rom = 8'h8f;
            4'h5 : rom = 8'h7d;           
            4'h6 : rom = 8'h6c;
            4'h7 : rom = 8'h5c;
            4'h8 : rom = 8'h4e;
            4'h9 : rom = 8'h41;           
            4'ha : rom = 8'h35;
            4'hb : rom = 8'h29;
            4'hc : rom = 8'h1f;
            4'hd : rom = 8'h15;           
            4'he : rom = 8'h0c;
            4'hf : rom = 8'h04;                                        
        endcase
    endfunction
    
endmodule
