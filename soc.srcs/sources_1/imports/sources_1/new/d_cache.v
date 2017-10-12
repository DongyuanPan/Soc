`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/23 16:54:12
// Design Name: 
// Module Name: d_cache
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


module d_cache (clk, clrn,
                p_a, p_dout, p_din, p_strobe, p_rw, p_ready,
                m_a, m_dout, m_din, m_strobe, m_rw, m_ready);
    
    localparam A_WIDTH = 32;
    localparam C_INDEX = 6;
    localparam T_WIDTH = A_WIDTH - C_INDEX - 2;
    
    input clk, clrn;
    
    input [A_WIDTH-1:0] p_a;
    input [31:0] p_dout;
    input p_strobe;
    input p_rw; // 0:read, 1:write
    output [31:0] p_din;
    output p_ready;
    
    input [A_WIDTH-1:0] m_dout;
    input m_ready;
    output [31:0] m_a;
    output [31:0] m_din;
    output m_strobe;
    output m_rw;
    
    reg               d_valid [0:(1<<C_INDEX)-1];
    reg [T_WIDTH-1:0] d_tags  [0:(1<<C_INDEX)-1];
    reg [31:0]        d_data  [0:(1<<C_INDEX)-1];
    
    wire [C_INDEX-1:0] index = p_a[C_INDEX+1:2];
    wire [T_WIDTH-1:0] tag = p_a[A_WIDTH-1:C_INDEX+2];
    
    // write to cache
    integer i;
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            for (i = 0; i < (1<<C_INDEX); i = i + 1)
                d_valid[i] <= 1'b0;
        end else if (c_write) begin
            d_valid[index] <= 1'b1;
            d_tags[index] <= tag;
            d_data[index] <= c_din;
        end
    end
    
    // read from cache
    wire                valid = d_valid[index];
    wire [T_WIDTH-1:0] tagout = d_tags[index];
    wire [31:0]        c_dout = d_data[index]; 
    
    // cache control
    wire cache_hit = valid & (tagout == tag);
    wire cache_miss = ~cache_hit;
    assign m_din = p_dout;
    assign m_a = p_a;
    assign m_rw = p_strobe & p_rw;
    assign m_strobe = p_strobe & (p_rw | cache_miss); 
    assign p_ready = ~p_rw & cache_hit | (cache_miss | p_rw) & m_ready;
    wire c_write = p_rw | cahce_miss & m_ready;
    wire sel_in = p_rw;
    wire sel_out = cache_hit;
    wire [31:0] c_din = sel_in ? p_dout : m_dout;
    assign p_din = sel_out ? c_dout : m_dout; 
    
endmodule
