`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/28 18:52:40
// Design Name: 
// Module Name: top_design
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


module top_design ();//(clk, reset, out_seg, out_sel);    
    reg clk;//, reset; 
    wire [7:0] out_seg, out_sel;
    wire [2:0] count;
    wire pclk;
    reg clrn = 1;//~reset;
    reg intr = 0;
    
    wire [31:0] pc, inst, ealu, malu, walu;
    wire [31:0] wd, e3d;
    wire [4:0] e1n, e2n, e3n;
    wire stall_lw, stall_fp, stall_lwc1, stall_swc1, stall_div_sqrt;
    wire e, inta;
    
    wire [31:0] dfb, mmo, wmo;
    wire [4:0] fs, ft, fd;
    wire [2:0] fc;
    wire fwdla, fwdlb, fwdfa, fwdfb, wf, fasmds;
    wire e1w, e2w, e3w, wwfpr;
    wire [4:0] wrn;
    
    wire [15:0] io_data_read, io_data_write;
    wire [9:0] io_addr;
    wire io_read, io_write;

    wire st = 1'b0;
    
    iu integer_unit (e1n, e2n, e3n, e1w, e2w, e3w, stall_div_sqrt, st,
           dfb, e3d, clk, clrn, intr,
           fs, ft, wmo, wrn, wwfpr, mmo, fwdla, fwdlb, fwdfa, fwdfb, fd, fc, wf, fasmds,
           pc, inst, ealu, malu, walu, inta, 
           stall_lw, stall_fp, stall_lwc1, stall_swc1,
           io_addr, io_read, io_write, io_data_read, io_data_write);
            
    fpu float_point_unit (
        .clk(clk), 
        .clrn(clrn),
        .fc(fc), 
        .wf(wf), 
        .fd(fd), 
        .fs(fs), 
        .ft(ft), 
        .ein(1'b1), 
        .wmo(wmo), 
        .wrn(wrn), 
        .wwfpr(wwfpr), 
        .mmo(mmo), 
        .fwdla(fwdla), 
        .fwdlb(fwdlb), 
        .fwdfa(fwdfa), 
        .fwdfb(fwdfb), 
        .dfb(dfb),
        .stall(stall_div_sqrt), 
        .e1n(e1n), 
        .e1w(e1w), 
        .e2n(e2n), 
        .e2w(e2w), 
        .e3n(e3n), 
        .e3w(e3w), 
        .e3d(e3d), 
        .e(e),
        .wd(wd)
    );
    
    IOCtrl io_part (
        .clk(clk),
        .reset(clrn),
        .io_addr(io_addr),
        .io_read(io_read),
        .io_write(io_write),
        .mread_data(io_data_write),
        .rdata(io_data_read),
        .out_seg(out_seg),
        .out_sel(out_sel),
        .count(count),
        .pclk(pclk)
    );
    
    initial begin
           clk = 1;
           clrn = 1;
           intr = 0;
           #0.3 clrn = 0;
           #0.2 clrn = 1;
    end
            
    always begin
           #1 clk = ~clk;
     end

endmodule
