module datapath (input clk, rst, start);;

	//IF
	logic [31:0] pc_in_if, pc_out_if, pc_plus1_if, instruction_if;
	
	//ID
	logic [31:0] pc_id, extend_out_id, RD1_id, RD2_id, RD3_id;
	logic [27:0] instr_27_0_id;
	logic [4:0] instr_29_25_id;
	logic [3:0] instr_27_24_id, instr_20_17_id, instr_23_20_id,
			instr_16_13_id, instr_24_21_id, RA1_id, RA2_id, RA3_id;
	logic [2:0] ALUOp_id;
	logic [1:0] instr_31_30_id, ImmSr_id, RegSrc1_id;
	logic BranchB_id, BranchI_id, BranchNI_id, RegDtn, MemToReg_id, MemRead_id, MemWrite_id,
			ALUSrc_id, RegWrite_id, RegSrc2_id;
	
	//EX
	logic [31:0] pc_plus_extend_ex, pc_ex, alu_op2_ex, alu_out_ex, RD1_ex, RD2_ex, RD3_ex, extend_ex;
	logic [3:0] RA3_ex; 
	logic PCSource_out_ex;
	logic [2:0] ALUOp_ex;
	logic MemToReg_ex, MemRead_ex, MemWrite_ex, ALUSrc_ex, RegWrite_ex, flagZ_ex,
			BranchB_ex, BranchI_ex, BranchNI_ex;
	
	//MEM
	logic [31:0] alu_out_mem, RD3_WD_mem, data_out_mem;
	logic [3:0] RA3_mem;
	logic MemRead_mem, MemWrite_mem, RegWrite_mem, MemToReg_mem;
	
	
	//WB
	logic [31:0] data_out_wb, alu_out_wb, data_mux_wb;
	logic [3:0] RA3_wb;
	logic RegWrite_wb, MemToReg_wb;



endmodule