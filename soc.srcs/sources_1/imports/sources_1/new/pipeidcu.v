`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:04:54
// Design Name: 
// Module Name: pipeidcu
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

module pipeidcu (rsrtequ, func, op, rs, rt, rd, shamt,
                 ern, ewreg, em2reg, ewfpr, ecancel, eov, eisbr, 
                 mwreg, mrn, mm2reg, mwfpr, misbr,
                 fs, ft, e1w, e1n, e2w, e2n, e3w, e3n, stall_div_sqrt, st,
                 intr, sta,
				 dwreg, dm2reg, dwmem, dmem_mode, daluc, regrt, daluimm, fwda, fwdb, wpcir, sext, pcsource, dshift, djal, 
				 inta, selpc, exc, epc_sel, cause, mtc0, w_epc, w_cause, w_status, dmfc0, disbr, dcancel, dmfc1, 
				 swfp, fwdf, fwdfe, wfpr,
				 fwdla, fwdlb, fwdfa, fwdfb, fc, wf, fasmds,
				 stall_lw, stall_fp, stall_lwc1, stall_swc1);
				 
		input mwreg, mwfpr, ewreg, em2reg, mm2reg, rsrtequ;
		input [4:0] mrn, ern, rs, rt, rd, shamt;
		input [5:0] func, op;
		output dwreg, dm2reg, dwmem, regrt, daluimm, sext, dshift, djal, dmfc1;
		output [3:0] daluc;
		output [2:0] dmem_mode;
		output [1:0] pcsource;
		output [1:0] fwda, fwdb;
		output wpcir;
		
		// for interrupt/exception
		input intr, ecancel, eov, eisbr, misbr;
		input [31:0] sta;  // IM[3:0] : ov, unimpl, sys, int
		output inta, exc, mtc0, w_epc, w_cause, w_status, disbr, dcancel;
		output [1:0] selpc, dmfc0, epc_sel;
		output [31:0] cause;
		
		input e1w, e2w, e3w, stall_div_sqrt, st, ewfpr;
        input [4:0] e1n, e2n, e3n, fs, ft;
        output [2:0] fc;
        output swfp, fwdf, fwdfe;
        output fwdla, fwdlb, fwdfa, fwdfb;
        output wfpr, wf, fasmds;
        output stall_lw, stall_fp, stall_lwc1, stall_swc1;
        
		wire r_type, f_type;
		wire i_add, i_addu, i_sub, i_subu, i_and, i_or, i_xor, i_nor, 
		      i_slt, i_sltu, i_sll, i_srl, i_sra, i_sllv, i_srlv, i_srav, i_rotr, i_rotrv;
		wire i_jr, i_jrhb, i_jalr, i_jalrhb;
		wire i_movn, i_movz, i_movf, i_movt;
		wire i_syscall, i_break, i_sdbbp;
		wire i_mfhi, i_mflo, i_mthi, i_mtlo;
		wire i_mul, i_mult, i_multu, i_div, i_divu;
		wire i_tge, i_tgeu, i_tlt, i_tltu, i_teq, i_tne;
		wire i_addi, i_addiu, i_andi, i_ori, i_xori, i_lui, i_slti, i_sltiu;
	    wire i_beq, i_bne, i_blez, i_bgtz;
	    wire i_bltz, i_bltzal, i_bgez, i_bgezal;

		and(r_type, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
		and(f_type, ~op[5],  op[4], ~op[3], ~op[2], ~op[1],  op[0]);
		
		// R-type instructions
		and(i_add,  r_type,  func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
		and(i_addu, r_type,  func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0]);
		and(i_sub,  r_type,  func[5], ~func[4], ~func[3], ~func[2],  func[1], ~func[0]);
		and(i_subu, r_type,  func[5], ~func[4], ~func[3], ~func[2],  func[1],  func[0]);
		and(i_and,  r_type,  func[5], ~func[4], ~func[3],  func[2], ~func[1], ~func[0]);
		and(i_or,   r_type,  func[5], ~func[4], ~func[3],  func[2],  func[1],  func[0]);
		and(i_xor,  r_type,  func[5], ~func[4], ~func[3],  func[2],  func[1], ~func[0]);
		and(i_nor,  r_type,  func[5], ~func[4], ~func[3],  func[2],  func[1],  func[0]);
		and(i_slt,  r_type,  func[5], ~func[4],  func[3], ~func[2],  func[1], ~func[0]);
		and(i_sltu, r_type,  func[5], ~func[4],  func[3], ~func[2],  func[1],  func[0]);
		and(i_sll,  r_type, ~func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
		and(i_srl,  r_type, ~func[5], ~func[4], ~func[3], ~func[2],  func[1], ~func[0]);
		and(i_sra,  r_type, ~func[5], ~func[4], ~func[3], ~func[2],  func[1],  func[0]);
		and(i_sllv, r_type, ~func[5], ~func[4], ~func[3],  func[2], ~func[1], ~func[0]);
		and(i_srlv, r_type, ~func[5], ~func[4], ~func[3],  func[2],  func[1], ~func[0]);
		and(i_srav, r_type, ~func[5], ~func[4], ~func[3],  func[2],  func[1],  func[0]);
		and(i_rotr, r_type, ~func[5], ~func[4], ~func[3], ~func[2],  func[1], ~func[0], 
		                    ~rs[4], ~rs[3], ~rs[2], ~rs[1], rs[0]);
		and(i_rotrv,r_type, ~func[5], ~func[4], ~func[3],  func[2],  func[1], ~func[0], 
		                    ~shamt[4], ~shamt[3], ~shamt[2], ~shamt[1], shamt[0]);		
		
		and(i_jr,     r_type, ~func[5], ~func[4],  func[3], ~func[2], ~func[1], ~func[0]);
        and(i_jrhb,   r_type, ~func[5], ~func[4],  func[3], ~func[2], ~func[1], ~func[0],
                             shamt[4], ~shamt[3], ~shamt[2], ~shamt[1], ~shamt[0]);
        and(i_jalr,   r_type, ~func[5], ~func[4],  func[3], ~func[2], ~func[1],  func[0]);
		and(i_jalrhb, r_type, ~func[5], ~func[4], func[3], ~func[2], ~func[1],  func[0],
		                      shamt[4], ~shamt[3], ~shamt[2], ~shamt[1], ~shamt[0]);
		                      
	    and(i_movn, r_type, ~func[5], ~func[4],  func[3], ~func[2],  func[1],  func[0]);
        and(i_movz, r_type, ~func[5], ~func[4],  func[3], ~func[2],  func[1], ~func[0]);
        
        and(i_movf, r_type, ~func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0], ~rt[0]);
        and(i_movt, r_type, ~func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0],  rt[0]);
        
        and(i_syscall, r_type, ~func[5], ~func[4], func[3], func[2], ~func[1], ~func[0]);
        and(i_break,   r_type, ~func[5], ~func[4], func[3], func[2], ~func[1],  func[0]);
        and(i_sdbbp,   r_type, ~func[5], ~func[4], func[3], func[2],  func[1], ~func[0]);
        
        and(i_mfhi, r_type, ~func[5],  func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
        and(i_mflo, r_type, ~func[5],  func[4], ~func[3], ~func[2],  func[1], ~func[0]);
        and(i_mthi, r_type, ~func[5],  func[4], ~func[3], ~func[2], ~func[1],  func[0]);
        and(i_mtlo, r_type, ~func[5],  func[4], ~func[3], ~func[2],  func[1],  func[0]);
        
        and(i_mul, ~op[5], op[4], op[3], op[2], ~op[1], ~op[0],
                   ~func[5], ~func[4], ~func[3], ~func[2],  func[1], ~func[0]);
                   
        and(i_mult, r_type, ~func[5],  func[4],  func[3], ~func[2], ~func[1], ~func[0]);
        and(i_multu,r_type, ~func[5],  func[4],  func[3], ~func[2], ~func[1],  func[0]);
        
        and(i_div,  r_type, ~func[5],  func[4],  func[3], ~func[2],  func[1], ~func[0]);
        and(i_divu, r_type, ~func[5],  func[4],  func[3], ~func[2],  func[1],  func[0]);
        
        and(i_tge,  r_type,  func[5],  func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
        and(i_tgeu, r_type,  func[5],  func[4], ~func[3], ~func[2], ~func[1],  func[0]);
        and(i_tlt,  r_type,  func[5],  func[4], ~func[3], ~func[2],  func[1], ~func[0]);
        and(i_tltu, r_type,  func[5],  func[4], ~func[3], ~func[2],  func[1],  func[0]);
        and(i_teq,  r_type,  func[5],  func[4], ~func[3],  func[2], ~func[1], ~func[0]);
        and(i_tne,  r_type,  func[5],  func[4], ~func[3],  func[2], ~func[1],  func[0]);
        
        // I-type instructions : 12
		and(i_addi,  ~op[5], ~op[4],  op[3], ~op[2], ~op[1], ~op[0]);
		and(i_addiu, ~op[5], ~op[4],  op[3], ~op[2], ~op[1],  op[0]);
		and(i_andi,  ~op[5], ~op[4],  op[3],  op[2], ~op[1], ~op[0]);
		and(i_ori,   ~op[5], ~op[4],  op[3],  op[2], ~op[1],  op[0]);
		and(i_xori,  ~op[5], ~op[4],  op[3],  op[2],  op[1], ~op[0]);
		and(i_lui,   ~op[5], ~op[4],  op[3],  op[2],  op[1],  op[0]);
		and(i_slti,  ~op[5], ~op[4],  op[3], ~op[2],  op[1], ~op[0]);
        and(i_sltiu, ~op[5], ~op[4],  op[3], ~op[2],  op[1],  op[0]);		
		
	    and(i_beq,   ~op[5], ~op[4], ~op[3],  op[2], ~op[1], ~op[0]);
	    and(i_bne,   ~op[5], ~op[4], ~op[3],  op[2], ~op[1],  op[0]);
	    and(i_blez,  ~op[5], ~op[4], ~op[3],  op[2],  op[1], ~op[0]);
	    and(i_bgtz,  ~op[5], ~op[4], ~op[3],  op[2],  op[1],  op[0]);
        
        wire sp1;
        and(sp1, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1],  op[0]);
        and(i_bltz,   sp1, ~rt[4], ~rt[3], ~rt[2], ~rt[1], ~rt[0]);
        and(i_bltzal, sp1,  rt[4], ~rt[3], ~rt[2], ~rt[1], ~rt[0]);
        and(i_bgez,   sp1, ~rt[4], ~rt[3], ~rt[2], ~rt[1],  rt[0]);
        and(i_bgezal, sp1,  rt[4], ~rt[3], ~rt[2], ~rt[1],  rt[0]);

 		// J-type instructions : 2
 		wire i_j, i_jal;
        and(i_j  ,   ~op[5], ~op[4], ~op[3], ~op[2],  op[1], ~op[0]);
        and(i_jal,   ~op[5], ~op[4], ~op[3], ~op[2],  op[1],  op[0]);       
        
        wire c0_type, i_mfc0, i_mtc0, i_eret;
        and(c0_type,  ~op[5],   op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
        and(i_mfc0,  c0_type, ~rs[4], ~rs[3], ~rs[2], ~rs[1], ~rs[0]);
        and(i_mtc0,  c0_type, ~rs[4], ~rs[3],  rs[2], ~rs[1], ~rs[0]);
        and(i_eret,  c0_type,  rs[4], ~rs[3], ~rs[2], ~rs[1], ~rs[0],
                    ~func[5], func[4], func[3], ~func[2], ~func[1], ~func[0]);
        
        wire tlb_type, i_tlbwi, i_tlbwr, i_tlbp, i_tlbr;
        and(tlb_type, rs[4], ~rs[3], ~rs[2], ~rs[1], ~rs[0]);
        and(i_tlbwi,  c0_type, tlb_type, ~func[5], ~func[4], ~func[3], ~func[2], func[1], ~func[0]);
        and(i_tlbwr,  c0_type, tlb_type, ~func[5], ~func[4], ~func[3],  func[2], func[1], ~func[0]);
        and(i_tlbp,   c0_type, tlb_type, ~func[5], ~func[4],  func[3], ~func[2],~func[1], ~func[0]);
        and(i_tlbr,   c0_type, tlb_type, ~func[5], ~func[4], ~func[3], ~func[2],~func[1],  func[0]);
        
        wire i_lwc1, i_swc1;
        and(i_lwc1,  op[5],  op[4], ~op[3], ~op[2], ~op[1],  op[0]);
        and(i_swc1,  op[5],  op[4],  op[3], ~op[2], ~op[1],  op[0]);
        
        // float piont instructions 
        wire i_fadd, i_fsub, i_fmul, i_fdiv, i_fsqrt;
        and(i_fadd,  f_type,  ~func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
        and(i_fsub,  f_type,  ~func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0]);
        and(i_fmul,  f_type,  ~func[5], ~func[4], ~func[3], ~func[2],  func[1], ~func[0]);
        and(i_fdiv,  f_type,  ~func[5], ~func[4], ~func[3], ~func[2],  func[1],  func[0]);
        and(i_fsqrt, f_type,  ~func[5], ~func[4], ~func[3],  func[2], ~func[1], ~func[0]);     
       
        wire if_type, i_mfc1, i_mtc1, i_cvtsw, i_cvtws;
        and(if_type,  ~op[5],   op[4], ~op[3], ~op[2], ~op[1],  op[0]);
        and(i_mfc1,  if_type, ~rs[4], ~rs[3], ~rs[2], ~rs[1], ~rs[0]);
        and(i_mtc1,  if_type, ~rs[4], ~rs[3],  rs[2], ~rs[1], ~rs[0]);        
        and(i_cvtsw, if_type,  rs[4], ~rs[3],  rs[2], ~rs[1], ~rs[0]);
        and(i_cvtws, if_type,  rs[4], ~rs[3], ~rs[2], ~rs[1], ~rs[0]);            
        
        wire i_lb, i_lbu, i_lh, i_lhu, i_lw, i_lwl, i_lwr;
        wire i_sb, i_sh, i_sw, i_swl, i_swr;
        and(i_lb,  op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
        and(i_lbu, op[5], ~op[4], ~op[3],  op[2], ~op[1], ~op[0]);
        and(i_lh,  op[5], ~op[4], ~op[3], ~op[2], ~op[1],  op[0]);
        and(i_lhu, op[5], ~op[4], ~op[3],  op[2], ~op[1],  op[0]);
        and(i_lw,  op[5], ~op[4], ~op[3], ~op[2],  op[1],  op[0]);
        and(i_lwl, op[5], ~op[4], ~op[3], ~op[2],  op[1], ~op[0]);
        and(i_lwr, op[5], ~op[4], ~op[3],  op[2],  op[1], ~op[0]);
        
        and(i_sb,  op[5], ~op[4],  op[3], ~op[2], ~op[1], ~op[0]);
        and(i_sh,  op[5], ~op[4],  op[3], ~op[2], ~op[1],  op[0]);
        and(i_sw,  op[5], ~op[4],  op[3], ~op[2],  op[1],  op[0]);
        and(i_swl, op[5], ~op[4],  op[3], ~op[2],  op[1], ~op[0]);
        and(i_swr, op[5], ~op[4],  op[3],  op[2],  op[1], ~op[0]);
        
        wire i_ll, i_sc;
        and(i_ll,  op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
        and(i_sc,  op[5], op[4],  op[3], ~op[2], ~op[1], ~op[0]);
        
        wire i_clz, i_clo;
        and(i_clz, ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                   func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
        and(i_clo, ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                   func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0]);        
        
        wire i_madd, i_maddu, i_msub, i_msubu;
        and(i_madd,  ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                  ~func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);
        and(i_maddu, ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                  ~func[5], ~func[4], ~func[3], ~func[2], ~func[1],  func[0]);  
        and(i_msub,  ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                  ~func[5], ~func[4], ~func[3],  func[2], ~func[1], ~func[0]);
        and(i_msubu, ~op[5], op[4],  op[3],  op[2], ~op[1], ~op[0],
                  ~func[5], ~func[4], ~func[3],  func[2], ~func[1],  func[0]);                             
        
        
        wire i_rs = i_add  | i_addu | i_sub | i_subu | 
                     i_and  | i_or | i_xor | i_nor |
                     i_slt | i_sltu |
                     i_sllv | i_srlv | i_srav |  
                     i_jr  | 
                     i_addi | i_addiu | i_andi | i_ori | i_xori | i_lw | i_sw | 
                     i_beq | i_bne | i_slti | i_sltiu |  
                     i_lwc1 | i_swc1;
        wire i_rt = i_add  | i_addu | i_sub | i_subu | 
                     i_and  | i_or | i_xor | i_nor |
                     i_slt | i_sltu |  
                     i_sll | i_srl  | i_sra |
                     i_sw  | i_beq  | i_bne | i_mtc0 | i_mtc1;

        wire unimplemented_inst = ~(i_mfc0 | i_mtc0 | i_eret | i_syscall | 
                                     i_add | i_addu | i_sub | i_subu | 
                                     i_and  | i_or  | i_xor | i_nor | 
                                     i_slt | i_sltu | 
                                     i_sll | i_srl | i_sra | i_sllv | i_srlv | i_srav | 
                                     i_jr | 
                                     i_addi | i_addiu | i_andi | i_ori | i_xori | i_lui |
                                     i_lw | i_sw | 
                                     i_beq | i_bne | i_slti | i_sltiu | 
                                     i_j | i_jal |
                                     i_fadd | i_fsub | i_fmul | i_fdiv | i_fsqrt | 
                                     i_lwc1 | i_swc1 |
                                     i_mfc1 | i_mtc1 | i_cvtsw | i_cvtws);
        // alu control signals
		wire mem_write_enable = wpcir & ~ecancel & ~exc_ovr;
		assign dwmem = (i_swc1 | i_sw | i_sh | i_sb ) & mem_write_enable;
		//assign drmem = i_lwc1 | i_lw | i_lh | i_lhu | i_lb | i_lbu;
		assign dmem_mode[0] = i_lw | i_sw | i_lwc1 | i_swc1;
		assign dmem_mode[1] = i_lh | i_lhu | i_sh | i_lw | i_sw | i_lwc1 | i_swc1;
		assign dmem_mode[2] = i_lbu | i_lhu;
		
		assign dwreg = (i_add | i_addu | i_sub | i_subu | 
		                i_and  | i_or   | i_xor | i_nor |
		                i_sll  | i_srl | i_sra | i_sllv | i_srlv | i_srav |
		                i_slt | i_sltu | i_slti | i_sltiu | 
		                i_addi | i_addiu | i_andi | i_ori | i_xori | 
		                i_lw | i_lh | i_lhu | i_lb | i_lbu |
		                i_lui | i_jal | 
		                i_mfc0 | i_mfc1) 
                        & wpcir & ~ecancel & ~exc_ovr;
        assign regrt = i_addi | i_addiu | i_andi | i_ori | i_xori | i_lw | i_lui | i_slti | i_sltiu | i_mfc0 | i_lwc1 | i_mfc1;
        assign djal   = i_jal;
        assign dm2reg = i_lw | i_lh | i_lhu | i_lb | i_lbu;
        assign dshift = i_sll | i_srl | i_sra;
        assign daluimm = i_addi | i_addiu | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_lw | i_lui | i_sw | i_lwc1 | i_swc1;
        assign sext   = i_addi | i_lw | i_sw | i_beq | i_bne | i_slti | i_lwc1 | i_swc1;
        
        // aluc[3:0]
        // 1 0 0 0 : add, addi, lw, sw, lwc1, swc1
        // 1 0 0 1 : addu, addiu
        // 1 1 0 0 : sub
        // 1 1 0 1 : subu, 
        // 1 1 1 0 : slt, slti
        // 1 1 1 1 : sltu, sltiu
        // 0 0 0 0 : and, andi
        // 0 0 0 1 : or, ori
        // 0 0 1 0 : xor, xori, beq, bne
        // 0 0 1 1 : nor
        // 0 1 0 0 : sll, sllv
        // 0 1 0 1 : srl, srlv
        // 0 1 1 1 : sra, srav
        // 0 1 1 0 : lui
        assign daluc[3] = i_add | i_addu | i_addi | i_addiu | i_sub | i_subu | i_slt | i_sltu | i_slti | i_sltiu | i_lw | i_sw | i_lwc1 | i_swc1;
        assign daluc[2] = i_sub | i_subu | i_slt | i_sltu | i_slti | i_sltiu | i_sll | i_sllv | i_srl | i_srlv | i_sra | i_srav | i_lui;
        assign daluc[1] = i_slt | i_sltu | i_slti | i_sltiu |  i_xor | i_xori | i_beq | i_bne | i_nor | i_sra | i_srav | i_lui;
        assign daluc[0] = i_addu | i_addiu | i_subu | i_sltu | i_sltiu | i_or | i_ori | i_nor | i_srl | i_srlv | i_sra | i_srav;
        
        assign pcsource[1] = i_jr | i_j | i_jal;
        assign pcsource[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;                                     
                                     
        // stall pipeline with 1-cycle because of lw instruction					
        assign stall_lw = ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) | i_rt & (ern == rt));
        
        // fop
        //  0 0 0 : fadd 
        //  0 0 1 : fsub
        //  0 1 x : fmul
        //  1 0 x : fdiv
        //  1 1 x : fsqrt
        wire [2:0] fop;
        assign fop[0] = i_fsub;
        assign fop[1] = i_fmul | i_fsqrt;
        assign fop[2] = i_fdiv | i_fsqrt;
        
        // fp signals                             
        wire i_fs = i_fadd | i_fsub | i_fmul | i_fdiv | i_fsqrt | i_mfc1 | i_cvtsw | i_cvtws;
        wire i_ft = i_fadd | i_fsub | i_fmul | i_fdiv;
        
        // forward data between fp instructions
        assign fwdfa = e3w & (e3n == fs);            
        assign fwdfb = e3w & (e3n == ft);   
        assign stall_fp = (e1w & (i_fs & (e1n == fs) | i_ft & (e1n == ft))) | 
                          (e2w & (i_fs & (e2n == fs) | i_ft & (e2n == ft)));
        
        // forward data from mmo of lwc1 instruction to fp ID stage, with stall if it's followed
        assign wfpr = i_lwc1 & wpcir;
        assign fwdla = mwfpr & (mrn == fs); // forward mmo to fp a
        assign fwdlb = mwfpr & (mrn == ft); // forward mmo to fp b
        assign stall_lwc1 = ewfpr & (i_fs & (ern == fs) | i_ft & (ern == ft));
        
        // forward data to swc1 instruction
        assign swfp = i_swc1;
        assign fwdf = swfp & e3w & (ft == e3n);  // forward to id stage
        assign fwdfe = swfp & e2w & (ft == e2n); // forward to exe stage
        assign stall_swc1 = swfp & e1w & (ft == e1n);
        
        assign dmfc1 = i_mfc1;
        
        wire stall_others = stall_lw | stall_fp | stall_lwc1 | stall_swc1 | st;
        assign fc = fop & {3{~stall_others}};       
        assign wf = i_fs & wpcir;
        assign fasmds = i_fs;      
        
        assign wpcir = ~(stall_div_sqrt | stall_others);
               
        //  exception and interruption signals             
        assign disbr = i_beq | i_bne | i_j | i_jal;
        wire exc_int, exc_sys, exc_uni, exc_ovr;
        assign exc_int = sta[0] & intr;
        assign exc_sys = sta[1] & i_syscall;
        assign exc_uni = sta[2] & unimplemented_inst;
        assign exc_ovr = sta[3] & eov;
        assign exc = exc_int | exc_sys | exc_uni | exc_ovr;
        assign dcancel = exc;
        assign epc_sel[1] =  exc_uni & eisbr | exc_ovr;
        assign epc_sel[0] =  exc_int & disbr | exc_sys | exc_uni & ~eisbr | exc_ovr & misbr;
         
        assign inta = exc_int;
         
        // ExcCode
        // 0 0 : intr
        // 0 1 : i_syscall
        // 1 0 : unimplemented_inst
        // 1 1 : overflow
        wire ExcCode0 = i_syscall | eov;
        wire ExcCode1 = unimplemented_inst | eov;
        assign cause = {eisbr, 27'h0, ExcCode1, ExcCode0, 2'b00};
        
        wire rd_is_status = (rd == 5'd12); // cp0 statuc register
        wire rd_is_cause = (rd == 5'd13);  // cp0 cause register
        wire rd_is_epc = (rd == 5'd14);    // cp0 EPC register
        assign mtc0 = i_mtc0;
        assign w_status = exc | mtc0 & rd_is_status | i_eret;
        assign w_cause = exc | mtc0 & rd_is_cause;
        assign w_epc = exc | mtc0 & rd_is_epc;
        
        // mfc0
        // 0 0 : pc + 8
        // 0 1 : sta
        // 1 0 : cau
        // 1 1 : epc
        assign dmfc0[0] = i_mfc0 & (rd_is_status | rd_is_epc);
        assign dmfc0[1] = i_mfc0 & (rd_is_cause | rd_is_epc);
        
        // selpc
        // 0 0 : npc
        // 0 1 : epc
        // 1 0 : EXC_BASE
        // 1 1 : x
        assign selpc[0] = i_eret;
        assign selpc[1] = exc;

        reg [1:0] fwda, fwdb;
		always @ (ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or rt) begin

			fwda = 2'b00;  // default forward a : no hazards
			if (ewreg & (ern != 0) & (ern == rs) & ~em2reg) begin
				fwda = 2'b01; // select exe_alu
			end else begin
				if (mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg) begin
					fwda = 2'b10; // select mem_alu
				end else begin
					if (mwreg & (mrn != 0) & (mrn == rs) & mm2reg) begin
						fwda = 2'b11; // select mem_lw
					end
				end
			end

			fwdb = 2'b00;  // default forward a : no hazards
			if (ewreg & (ern != 0) & (ern == rt) & ~em2reg) begin
				fwdb = 2'b01; // select exe_alu
			end else begin
				if (mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg) begin
					fwdb = 2'b10; // select mem_alu
				end else begin
					if (mwreg & (mrn != 0) & (mrn == rt) & mm2reg) begin
						fwdb = 2'b11; // select mem_lw
					end
				end
			end

		end
	
endmodule

