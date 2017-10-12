`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:13:48
// Design Name: 
// Module Name: pipemem
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

module pipemem (clk, write, read, mem_mode, addr, datain, dataout, 
                io_addr, io_read, io_write, io_data_read, io_data_write);
    input clk, write, read;
    input [2:0] mem_mode;
	input [31:0] addr, datain;
	input [15:0] io_data_read;
	output [9:0] io_addr;
	output reg [15:0] io_data_write;
	output [31:0] dataout;
	output io_read, io_write;
	
	wire memAddr = ~| addr[31:16]; // 0x0000_0000 ~ 0x0000_ffff 64KB
	wire ioAddr = & addr[31:10];   // 0xffff_fc00 ~ 0xffff_ffff 1KB
	wire mem_read = memAddr & read; 
	wire mem_write = memAddr & write;
	wire io_read = ioAddr & read;
	wire io_write = ioAddr & write;
    assign io_addr = (io_read | io_write) ? addr[9:0] : 10'hzzz;
    
    wire [3:0] wea;
    assign wea[0] = mem_write & (~addr[1] & ~addr[0]);
    assign wea[1] = mem_write & (
                    ~addr[1] & ~addr[0] & ~mem_mode[1] &  mem_mode[0] |
                    ~addr[1] & ~addr[0] &  mem_mode[1] &  mem_mode[0] |
                    ~addr[1] &  addr[0] & ~mem_mode[1] & ~mem_mode[0] );
    assign wea[2] = mem_write & (
                    ~addr[1] & ~addr[0] &  mem_mode[1] &  mem_mode[0] |
                     addr[1] & ~addr[0] & ~mem_mode[1] & ~mem_mode[0] |
                     addr[1] & ~addr[0] & ~mem_mode[1] &  mem_mode[0] );
    assign wea[3] = mem_write & (
                    ~addr[1] & ~addr[0] &  mem_mode[1] &  mem_mode[0] |
                     addr[1] & ~addr[0] & ~mem_mode[1] &  mem_mode[0] |
                     addr[1] &  addr[0] & ~mem_mode[1] & ~mem_mode[0] );
                     
    wire addr_err = mem_write & (
                     ~addr[1] &  addr[0] & ~mem_mode[1] &  mem_mode[0] |
                     ~addr[1] &  addr[0] &  mem_mode[1] &  mem_mode[0] |
                      addr[1] & ~addr[0] &  mem_mode[1] &  mem_mode[0] |
                      addr[1] &  addr[0] & ~mem_mode[1] &  mem_mode[0] |
                      addr[1] &  addr[0] &  mem_mode[1] &  mem_mode[0] );
    
    wire [31:0] mem_data_out;
    
    data_mem mem_unit (
      .clka(~clk),    // input wire clka
      .wea(wea),      // input wire [3 : 0] wea
      .addra(addr[15:2]),  // input wire [13 : 0] addra
      .dina(datain),    // input wire [31 : 0] dina
      .douta(mem_data_out)  // output wire [31 : 0] douta
    );
    
    wire [31:0] data_out_1 = io_read ? { 16'b0, io_data_read} : mem_data_out;
    assign dataout = load_data (data_out_1, addr, mem_mode);
    
    always @* begin
        io_data_write = io_write ? datain[15:0] : 16'hzzzz;
    end
    
    function [31:0] load_data;
        input [31:0] data_in;
        input [1:0] addr;
        input [2:0] mode;
        casex ({addr, mode})
            5'b00_000 : load_data = {{24{data_in[7]}}, data_in[7:0]};
            5'b00_100 : load_data = {24'b0, data_in[7:0]};
            5'b00_001 : load_data = {{16{data_in[15]}}, data_in[15:0]};
            5'b00_101 : load_data = {16'b0, data_in[15:0]};
            5'b00_x11 : load_data = data_in[31:0];
            5'b01_000 : load_data = {{24{data_in[15]}}, data_in[15:8]};
            5'b01_100 : load_data = {24'b0, data_in[15:8]};
            5'b10_000 : load_data = {{24{data_in[23]}}, data_in[23:16]};
            5'b10_100 : load_data = {24'b0, data_in[23:16]};
            5'b10_001 : load_data = {{16{data_in[31]}}, data_in[31:16]};
            5'b10_101 : load_data = {16'b0, data_in[31:16]};
            5'b11_000 : load_data = {{24{data_in[31]}}, data_in[31:24]};
            5'b11_100 : load_data = {24'b0, data_in[31:24]};
            default : load_data = 32'hzzzz_zzzz;
        endcase
    endfunction
    
endmodule