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
	logic BranchB_id, BranchI_id, BranchNI_id, RegDtn_id, MemToReg_id, MemRead_id, MemWrite_id,
			ALUSrc_id, RegWrite_id, RegSrc2_id;
	
	//EX
	logic [31:0] pc_plus_imm_ex, pc_ex, alu_op2_ex, alu_out_ex, RD1_ex, RD2_ex, RD3_ex, extend_ex;
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

	
	// Instantiating modules
	
	// IF
	pc pc_if (clk, rst, pc_in_if, pc_out_if);
	adder adder_if (pc_out_if, 32'd1, pc_plus1_if);
	mux_2to1 mux_2to1_if (pc_plus1_if, alu_out_ex, PCSource_out_ex, pc_in_if);
	//TODO: ROM

	// IF/ID Segmentation
	segment_if_id if_id (clk, rst, pc_out_if, instruction_if, pc_id, instr_31_30_id, instr_29_25_id,
								instr_27_24_id, instr_20_17_id, instr_23_20_id,
								instr_16_13_id, instr_24_21_id, instr_27_0_id);

	// ID
	control_unit control_unit_id (instr_31_30_id, instr_29_25_id, rst, BranchB_id, BranchI_id, BranchNI_id,
								  MemToReg_id, MemRead_id, MemWrite_id, ALUOp_id, ALUSrc_id, RegWrite_id, ImmSr_id
								  RegDtn_id, RegSrc2_id, RegSrc1_id);

	mux_4to1 mux_4to1_id (instr_20_17_id, instr_20_17_id, instr_27_24_id, 32'd0, RegSrc1_id, RA1_id);
	mux_2to1 #(.N(4)) mux_2to1_id1 (instr_16_13_id, instr_23_20_id, RegSrc2_id, RA2_id);
	mux_2to1 #(.N(4)) mux_2to1_id2 (instr_24_21_id, instr_24_21_id, RegDtn_id, RA3_id);

	extend extend_id (instr_27_0_id, ImmSr_id, extend_out_id);

	regfile regfile_id (RA1_id, RA2_id, RA3_id, RA3_wb, data_out_wb, RegWrite_wb, clk, rst, RD1_id, RD2_id, RD3_id);

	// ID/EX Segmentation
	segment_id_ex id_ex (BranchB_id, BranchI_id, BranchNI_id, clk, rst, MemToReg_id, MemRead_id, MemWrite_id, ALUOp_id, ALUSrc_id, RegWrite_id,
							pc_id, RD1_id, RD2_id, RD3_id, RA3_id, extend_out_id,
							MemToReg_ex, MemRead_ex, MemWrite_ex, ALUOp_ex, ALUSrc_ex, RegWrite_ex,
							pc_ex, RD1_ex, RD2_ex, RD3_ex, RA3_ex, extend_ex,
							BranchB_ex, BranchI_ex, BranchNI_ex);

	// EX
	mux_2to1 mux_2to1_ex (RD2_ex, extend_ex, ALUSrc_ex, ALUOp_ex);
	adder adder_ex (pc_ex, extend_ex, pc_plus_imm_ex);
	alu alu_ex (RD1_ex, alu_op2_ex, ALUOp_ex, alu_out_ex, flagZ_ex);
	jump_unit jump_unit_ex (flagZ, BranchNI, BranchI, BranchB, PCSource_out_ex);

	// EX/MEM Segmentation
	segment_ex_mem ex_mem (clk, rst, MemToReg_ex, MemRead_ex, MemWrite_ex, RegWrite_ex,
						   alu_out_ex, RD3_ex, RA3_ex,
						   MemToReg_mem, MemRead_mem, MemWrite_mem, RegWrite_mem,
						   alu_out_mem, RD3_WD_mem, RA3_mem);

	// MEM
	//TODO: RAM

	// MEM/WB Segmentation
	segment_mem_wb mem_wb (clk, rst, MemToReg_mem, RegWrite_mem, 
					data_out_mem, alu_out_mem, RA3_mem,
					MemToReg_wb, RegWrite_wb, data_out_wb, alu_out_wb, RA3_wb);

	// WB
	mux_2to1 mux_2to1_wb (alu_out_wb, data_out_wb, MemToReg_wb, data_mux_wb); //TODO: data_mux_id debería estar conectado a regfile

endmodule