`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/20 21:52:25
// Design Name: 
// Module Name: iu
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


module iu (e1n, e2n, e3n, e1w, e2w, e3w, stall_div_sqrt, st,
           dfb, e3d, clk, clrn, intr,
           fs, ft, wmo, wrn, wwfpr, mmo, fwdla, fwdlb, fwdfa, fwdfb, fd, fc, wf, fasmds,
           pc, inst, ealu, malu, walu, inta, 
           stall_lw, stall_fp, stall_lwc1, stall_swc1,
           io_addr, io_read, io_write, io_data_read, io_data_write);

    input [31:0] dfb, e3d;
    input [4:0] e1n, e2n, e3n;
    input e1w, e2w, e3w;
    input stall_div_sqrt, st, clk, clrn, intr;
    
    output [31:0] pc, inst, ealu, malu, walu;
    output [31:0] wmo, mmo;
    output [4:0] fs, ft, fd, wrn;
    output [2:0] fc;
    output inta, wwfpr, fwdla, fwdlb, fwdfa, fwdfb, wf, fasmds;
    output stall_lw, stall_fp, stall_lwc1, stall_swc1;
    
    output [9:0] io_addr;
    output io_read, io_write;
    input [15:0] io_data_read;
    output [15:0] io_data_write;
    
    wire [31:0] bpc, jpc, npc, pc4, inst0, next_pc;
    wire [1:0] pcsource;
    wire wpcir;
        
    wire [31:0] da, dd, dimm, dpc, dpc4, pc8c0r;
    wire [4:0] drn;
    wire [3:0] daluc;
    wire [2:0] dmem_mode;
    wire [1:0] dmfc0;
    wire dwfpr, dfwdfe, dwreg, dm2reg, dwmem, daluimm, dshift, djal, disbr, dcancel;
    
    wire [31:0] ea, eb, eimm, epc, epc4, epc8, ed;
    wire [4:0] ern0, ern;
    wire [3:0] ealuc;
    wire [2:0] emem_mode;
    wire [1:0] emfc0;
    wire ewfpr, efwdfe, ewreg0, ewreg, em2reg, ewmem, ealuimm, eshift, ejal, eov, ecancel, eisbr;
    
    wire [31:0] mmo, mpc, mb;
    wire [4:0] mrn;
    wire [2:0] mmem_mode;
    wire mwfpr, mwreg, mm2reg, mwmem;
    
    wire [31:0] wdi, wmo;
    wire [4:0] wrn;
    wire wwfpr, wwreg, wm2reg;    
    
    wire swfp, fwdf;
  
    wire dmfc1, emfc1;
    
    wire [31:0] mem_a, mem_st_data, mem_data;
    wire mem_access, mem_write, mem_ready;
    wire no_cache_stall = 1'b1;
    
    wire wpcir_with_no_cache_stall = wpcir & no_cache_stall;
    
    // IF
    pipepc prog_cnt (next_pc, wpcir_with_no_cache_stall, clk, clrn, pc);
    pipeif if_stage (clk, pcsource, pc, bpc, da, jpc, npc, pc4, inst0);
    
    // IF-ID
    pipeir fd_reg (pc4, inst0, pc, wpcir_with_no_cache_stall, clk, clrn, dpc4, inst, dpc);
    
    // ID          
    wire [5:0] op, func;
    wire [4:0] rs, rt, rd, shamt;
    wire [31:0] qa, qb, br_offset, db, dc;
    wire [15:0] ext16;
    wire [1:0] fwda, fwdb;
    wire regrt, sext, rsrtequ;

    assign op = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign shamt = inst[10:6];
    assign func = inst[5:0];
    assign jpc = {dpc4[31:28], inst[25:0], 2'b00};
				
    regfile rf (rs, rt, wdi, wrn, wwreg, ~clk, clrn, qa, qb);
    mux2x5 des_reg_no (rd, rt, regrt, drn);
    mux4x32 alu_a (qa, ealu, malu, mmo, fwda, da);
    mux4x32 alu_b (qb, ealu, malu, mmo, fwdb, db);
    assign rsrtequ = ~|(da^db); // rsrtequ = (a == b);
    assign ext16 = {16{sext & inst[15]}};
    assign dimm = {ext16, inst[15:0]};
    assign br_offset = {dimm[29:0], 2'b00};
    cla32 br_addr (dpc4, br_offset, 1'b0, bpc);
   
	// CPO
	wire [31:0] cp0_index,   cp0_random,   cp0_entrylo0, cp0_entrylo1,
                 cp0_context, cp0_pagemask, cp0_wired,    cp0_badaddr,
                 cp0_status, cp0_cause, cp0_epc;
    wire [31:0] sta_in, cau_in, epc_in, stalr, epcin, cause;   
    wire [1:0] epc_sel, selpc;
    wire exc, w_index, w_epc, w_cause, w_status;
    
	parameter EXC_BASE = 32'h00000008;
	
	mux2x32 sta_lr ({4'h0, cp0_status[31:4]}, {cp0_status[27:0], 4'h0}, exc, stalr);
	mux4x32 epc_l0 (pc, dpc, epc, mpc, epc_sel, epcin);
	mux4x32 irq_pc (npc, cp0_epc, EXC_BASE, 32'h0, selpc, next_pc);
	mux4x32 fromc0 (epc8, cp0_status, cp0_cause, cp0_epc, emfc0, pc8c0r); 
	mux2x32 sta_mx (stalr, db, mtc0, sta_in);
	mux2x32 cau_mx (cause, db, mtc0, cau_in);
	mux2x32 epc_mx (epcin, db, mtc0, epc_in);
	
	dffe32 _CP0_12_status (sta_in, clk, clrn, w_status & no_cache_stall, cp0_status);
	dffe32 _CP0_13_cause (cau_in, clk, clrn, w_cause & no_cache_stall, cp0_cause);
	dffe32 _CP0_14_epc (epc_in, clk, clrn, w_epc & no_cache_stall, cp0_epc);
	
//	dffe32     _CP0_0_index (sta_in, clk, clrn, w_index, cp0_index);
//	random_reg _CP0_1_random (cp0_wired, clk, clrn, cp0_random);
//    dffe32     _CP0_2_index (sta_in, clk, clrn, w_index, cp0_entrylo0);
//    dffe32     _CP0_3_index (sta_in, clk, clrn, w_index, cp0_entrylo1);
//    dffe32     _CP0_4_context (sta_in, clk, clrn, w_context, cp0_context);
//    dffe32     _CP0_5_pagemask (sta_in, clk, clrn, w_pagemask, cp0_pagemask);
//    dffe32     _CP0_6_wired (sta_in, clk, clrn, w_wired, cp0_wired);
//    dffe32     _CP0_7_badaddr (sta_in, clk, clrn, 1'b0, cp0_badaddr);
//    dffe32     _CP0_8_count (sta_in, clk, clrn, w_count, cp0_count);
//    dffe32     _CP0_9_entryhi (sta_in, clk, clrn, w_wired, cp0_entryhi);
	
	// CP1 : FPU
	assign ft = inst[20:16];
	assign fs = inst[15:11];
	assign fd = inst[10:6];
	mux2x32 store_f (db, dfb, swfp, dc); // swc1
	mux2x32 fwd_f_d (dc, e3d, fwdf, dd); // forward fp result
   
	// control unit
	pipeidcu cu (rsrtequ, func, op, rs, rt, rd, shamt,
					 ern, ewreg, em2reg, ewfpr, ecancel, eov, eisbr, 
					 mwreg, mrn, mm2reg, mwfpr, misbr,
					 fs, ft, e1w, e1n, e2w, e2n, e3w, e3n, stall_div_sqrt, st,
					 intr, cp0_status,
					 dwreg, dm2reg, dwmem, dmem_mode, daluc, regrt, daluimm, fwda, fwdb, wpcir, sext, pcsource, dshift, djal, 
					 inta, selpc, exc, epc_sel, cause, mtc0, w_epc, w_cause, w_status, dmfc0, disbr, dcancel, dmfc1, 
					 swfp, fwdf, dfwdfe, dwfpr,
					 fwdla, fwdlb, fwdfa, fwdfb, fc, wf, fasmds,
					 stall_lw, stall_fp, stall_lwc1, stall_swc1);                   
    
                     
    // ID-EXE
    pipedereg de_reg (dwreg, dm2reg, dwmem, dmem_mode, daluc, daluimm, da, dd, dimm,
                      drn, dshift, djal, dpc4, dpc, dmfc0, dcancel, disbr, dfwdfe, dwfpr, dmfc1,
                      clk, clrn,
                      ewreg0, em2reg, ewmem, emem_mode, ealuc, ealuimm, ea, ed, eimm,
                      ern0, eshift, ejal, epc4, epc, emfc0, ecancel, eisbr, efwdfe, ewfpr, emfc1);
    
    // EXE
    pipeexe exe_state (ealuc, ealuimm, ea, ed, eimm, eshift, ern0, epc4, ejal, ewreg0, emfc0, pc8c0r, efwdfe, e3d, emfc1,
                       eov, ern, ealu, ewreg, epc8, eb);
    
    // EXE-MEM           
    pipeemreg em_reg (
        .clk(clk), 
        .clrn(clrn),
        .ewfpr(ewfpr), 
        .ewreg(ewreg), 
        .em2reg(em2reg), 
        .ewmem(ewmem),
        .emem_mode(emem_mode),
        .ealu(ealu), 
        .eb(eb), 
        .ern(ern), 
        .eisbr(eisbr), 
        .epc(epc),
        .mwfpr(mwfpr), 
        .mwreg(mwreg),
        .mm2reg(mm2reg),
        .mwmem(mwmem),
        .mmem_mode(mmem_mode),
        .malu(malu),
        .mb(mb), 
        .mrn(mrn), 
        .misbr(misbr), 
        .mpc(mpc)
    );
    
    // MEM 
    pipemem mem_stage (
        .clk(clk), 
        .write(mwmem),
        .read(mm2reg),
        .mem_mode(mmem_mode),
        .addr(malu), 
        .datain(mb),
        .dataout(mmo),
        .io_addr(io_addr),
        .io_read(io_read),
        .io_write(io_write),
        .io_data_read(io_data_read),
        .io_data_write(io_data_write)
     );
    
    // MEM-WB
    pipemwreg mw_reg (mwfpr, mwreg, mm2reg, mmo, malu, mrn, clk, clrn, 
                      wwfpr, wwreg, wm2reg, wmo, walu, wrn);
     
    // WB
    mux2x32 wb_state (
        .a0(walu),
        .a1(wmo),
        .s(wm2reg), 
        .y(wdi)
    );
    
    //physical_memory mem (mem_a, mem_st_data, mem_access, mem_write, clk, ~clk, clrn, 
     //                    mem_data, mem_ready);
           
endmodule
