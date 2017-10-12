`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/20 15:17:47
// Design Name: 
// Module Name: fpu
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


module fpu (clk, clrn,
            fc, wf, fd, fs, ft, ein, 
            wmo, wrn, wwfpr, mmo, fwdla, fwdlb, fwdfa, fwdfb,
            dfb, stall, e1n, e1w, e2n, e2w, e3n, e3w, e3d, e, wd);
    
    input [31:0] wmo, mmo;
    input [4:0] fs, ft, fd, wrn;
    input [2:0] fc;  // 000:add, 001:sub, 01x:mul, 10x:div, 11x:sqrt
    input wf;        // write fp regfile
    input ein;       // enable input
    input wwfpr, fwdla, fwdlb, fwdfa, fwdfb;
    input clk, clrn;
    
    output [31:0] dfb, e3d, wd;  // wd is fp result
    output [4:0] e1n, e2n, e3n;  // reg numbers
    output e1w, e2w, e3w;
    output stall, e; // caused by fdiv and fsqrt
    
    wire [31:0] qfa, qfb, fa, fb, dfa;
    wire [4:0] count_div, count_sqrt;
    
    reg [31:0] wd;
    reg sub;
    reg [31:0] efa, efb;
    reg [4:0] e1n, e2n, e3n, wn;
    reg [1:0] e1c, e2c, e3c;
    reg e1w, e2w, e3w, ww;
    
    wire [31:0] s_add, s_mul, s_div, s_sqrt;
    wire busy_div, stall_div, busy_sqrt, stall_sqrt;
    wire [25:0] reg_x_div, reg_x_sqrt;
    wire fdiv  = fc[2] & ~fc[1];
    wire fsqrt = fc[2] &  fc[1];
    
    regfile2w fpr (
        .rna(fs),
        .rnb(ft), 
        .dx(wd), 
        .wnx(wn), 
        .wex(ww), 
        .dy(mmo), 
        .wny(wrn), 
        .wey(wwfpr), 
        .clk(~clk), 
        .clrn(clrn), 
        .qa(qfa), 
        .qb(qfb)
    );
    
    mux2x32 fwd_f_load_a (qfa, mmo, fwdla, fa);  // forward lwc1 to fp a
    mux2x32 fwd_f_load_b (qfb, mmo, fwdlb, fb);  // forward lwc1 to fp b
    mux2x32 fwd_f_res_a (fa, e3d, fwdfa, dfa);  // forward fp res to fp a
    mux2x32 fwd_f_res_b (fb, e3d, fwdfb, dfb);  // forward fp res to fp b
    
    wire [1:0] rm = 2'b0;  
    fadder f_add (efa, efb, sub, rm, clk, clrn, e, s_add);             
    fmul   f_mul (efa, efb, rm, clk, clrn, e, s_mul);
    fdiv_newton f_div (dfa, dfb, rm, fdiv, e, clk, clrn, s_div, busy_div, stall_div, count_div, reg_x_div);
    fsqrt_newton f_sqrt (
        .d(dfa), 
        .rm(rm), 
        .fsqrt(fsqrt), 
        .e(e), 
        .clk(clk), 
        .clrn(clrn), 
        .s(s_sqrt), 
        .busy(busy_sqrt), 
        .stall(stall_sqrt), 
        .count(count_sqrt), 
        .reg_x(reg_x_sqrt)
    );
    
    assign stall =  stall_div | stall_sqrt;
    assign e = ~stall & ein;
    mux4x32 fsel (s_add, s_mul, s_div, s_sqrt, e3c, e3d);
    
    always @ (posedge clk or negedge clrn) begin
        if (clrn == 0) begin
            sub <= 0;       efa <= 0;     efb <= 0;
            e1c <= 0;       e1w <= 0;     e1n <= 0;
            e2c <= 0;       e2w <= 0;     e2n <= 0;
            e3c <= 0;       e3w <= 0;     e3n <= 0;
            wd  <= 0;        ww <= 0;     wn  <= 0;
        end else if (e) begin
            sub <= fc[0];   efa <= dfa;   efb <= dfb;
            e1c <= fc[2:1]; e1w <= wf;    e1n <= fd;
            e2c <= e1c;     e2w <= e1w;   e2n <= e1n;
            e3c <= e2c;     e3w <= e2w;   e3n <= e2n;
            wd  <= e3d;      ww <= e3w;   wn  <= e3n;            
        end
    end
            
endmodule
