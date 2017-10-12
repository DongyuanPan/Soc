`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/25 20:48:24
// Design Name: 
// Module Name: physical_memory
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


module physical_memory (a, din, strobe, rw, clk, memclk, clrn, dout, ready);
    
    localparam A_WIDTH = 32;
    
    input [A_WIDTH-1:1] a;
    input [31:0] din;
    input strobe, rw, clk, memclk, clrn;
    
    output [31:0] dout;
    output ready;
    
    // for memory ready
    reg [2:0] wait_counter;
    reg ready;
    always @ (negedge clrn or posedge clk) begin
        if (clrn == 0) begin
            wait_counter <= 3'b0;
        end else begin
            if (strobe) begin
                if (wait_counter == 3'h5) begin
                    ready <= 1'b1;
                    wait_counter <= 3'b0;
                end else begin
                    ready <= 1'b0;
                    wait_counter <= wait_counter + 3'b1;
                end
            end else begin
                ready <= 1'b0;
                wait_counter <= 3'b0;
            end
        end
    end
    
    // 31 30 29 28 ... 15 14 13 12 ... 3 2 1 0
    //  0  0  0  0      0  0  0  0     0 0 0 0  (0) 0x0000_0000
    //  0  0  0  1      0  0  0  0     0 0 0 0  (1) 0x1000_0000
    //  0  0  1  0      0  0  0  0     0 0 0 0  (2) 0x2000_0000
    //  0  0  1  0      0  0  1  0     0 0 0 0  (3) 0x2000_2000      
    wire [31:0] m_out32 = a[13] ? mem_data_out3 : mem_data_out2;
    wire [31:0] m_out10 = a[28] ? mem_data_out1 : mem_data_out0;
    wire [31:0] mem_out = a[29] ? m_out32 : m_out10;
    assign dout = ready ? mem_out : 32'hzzzz_zzzz;
    
    
    // (0) 0x0000_0000 - (virtual address 0x8000_0000 -)
    wire [31:0] mem_data_out0;
    wire write_enable_0 = ~a[29] & ~a[28] & rw & ~clk;
    
    
    // (1) 0x1000_0000 - (virtual address 0x9000_0000 -)
    wire [31:0] mem_data_out1;
    wire write_enable_1 = ~a[29] &  a[28] & rw & ~clk;
    
    
    // (2) 0x2000_0000 - (map va 0x0000_0000 -)
    wire [31:0] mem_data_out2;
    wire write_enable_2 = a[29] & ~a[13] & rw & ~clk;
    
    
    // (3) 0x2000_2000 - (map va 0x0000_0000 -)
    wire [31:0] mem_data_out3;
    wire write_enable_3 = a[29] & a[13] & rw & ~clk;            
    
endmodule
