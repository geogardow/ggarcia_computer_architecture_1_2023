module datapath (input clkFPGA, rst, start);

	//IF
	logic [31:0] pc_in_if, pc_out_if, pc_plus1_if, instruction_if;
	
	//ID
	logic [31:0] pc_id, extend_out_id, RD1_id, RD2_id, RD3_id;
	logic [27:0] instr_27_0_id;
	logic [4:0] instr_29_25_id;
	logic [3:0] instr_27_24_id, instr_20_17_id, instr_23_20_id,
			instr_16_13_id, instr_24_21_id, RA1_id, RA2_id, RA3_id;
	logic [2:0] ALUOp_id;
	logic [1:0] instr_31_30_id, ImmSr_id;
	logic BranchB_id, BranchI_id, BranchGEQ_id, BranchLEQ_id, RegDtn_id, MemToReg_id, MemRead_id, MemWrite_id,
			ALUSrc_id, RegWrite_id, RegSrc2_id, RegSrc1_id;
	
	//EX
	logic [31:0] pc_plus_imm_ex, pc_ex, alu_op2_ex, alu_out_ex, RD1_ex, RD2_ex, RD3_ex, extend_ex;
	logic [3:0] RA3_ex; 
	logic PCSource_out_ex;
	logic [2:0] ALUOp_ex;
	logic MemToReg_ex, MemRead_ex, MemWrite_ex, ALUSrc_ex, RegWrite_ex, flagZ_ex, flagN_ex,
			BranchB_ex, BranchI_ex, BranchGEQ_ex, BranchLEQ_ex;
	
	//MEM
	logic [31:0] alu_out_mem, RD3_WD_mem, data_out_mem;
	logic [3:0] RA3_mem;
	logic MemRead_mem, MemWrite_mem, RegWrite_mem, MemToReg_mem;
	
	
	//WB
	logic [31:0] data_out_wb, alu_out_wb, data_mux_wb;
	logic [3:0] RA3_wb;
	logic RegWrite_wb, MemToReg_wb;

	
	// Instantiating modules
	
	//clks
	new_clk #(.frec(2)) frec_mem (clk_mem, clkFPGA);
	new_clk #(.frec(8)) frec_clk (clk, clkFPGA);


	// IF
	mux_2to1 #(.N(32)) mux_2to1_if (pc_plus1_if, pc_plus_imm_ex, PCSource_out_ex, pc_in_if);
	pc pc_if (clk, ~rst, 1'd1, pc_in_if, pc_out_if);
	adder adder_if (pc_out_if, 32'd1, pc_plus1_if);
	rom rom_inst(.address(pc_out_if[7:0]), .clock(clk), .q(instruction_if));

	// IF/ID Segmentation
	segment_if_id if_id (clk, rst, pc_out_if, instruction_if, pc_id, instr_31_30_id, instr_29_25_id,
								instr_27_24_id, instr_20_17_id, instr_23_20_id,
								instr_16_13_id, instr_24_21_id, instr_27_0_id);

	// ID
	control_unit control_unit_id (instr_31_30_id, instr_29_25_id, rst, BranchB_id, BranchI_id, BranchGEQ_id, BranchLEQ_id,
								  MemToReg_id, MemRead_id, MemWrite_id, ALUOp_id, ALUSrc_id, RegWrite_id, ImmSr_id,
									RegSrc2_id, RegSrc1_id);

	mux_2to1 #(.N(4)) mux_2to1_id1 (instr_20_17_id, instr_27_24_id, RegSrc1_id, RA1_id);
	mux_2to1 #(.N(4)) mux_2to1_id2 (instr_16_13_id, instr_23_20_id, RegSrc2_id, RA2_id);

	extend extend_id (instr_27_0_id, ImmSr_id, extend_out_id);

	// instr_24_21_id = RA3_id
	regfile regfile_id (RA1_id, RA2_id, instr_24_21_id, RA3_wb, data_mux_wb, RegWrite_wb, clk, rst, RD1_id, RD2_id, RD3_id);

	// ID/EX Segmentation
	segment_id_ex id_ex (BranchB_id, BranchI_id, BranchGEQ_id, BranchLEQ_id, clk, rst, MemToReg_id, MemRead_id, MemWrite_id, ALUOp_id, ALUSrc_id, RegWrite_id,
							pc_id, RD1_id, RD2_id, RD3_id, instr_24_21_id, extend_out_id,
							MemToReg_ex, MemRead_ex, MemWrite_ex, ALUOp_ex, ALUSrc_ex, RegWrite_ex,
							pc_ex, RD1_ex, RD2_ex, RD3_ex, RA3_ex, extend_ex,
							BranchB_ex, BranchI_ex, BranchGEQ_ex, BranchLEQ_ex);

	// EX
	mux_2to1 #(.N(32)) mux_2to1_ex (RD2_ex, extend_ex, ALUSrc_ex, alu_op2_ex);
	adder adder_ex (pc_ex, extend_ex, pc_plus_imm_ex);
	alu alu_ex (RD1_ex, alu_op2_ex, ALUOp_ex, alu_out_ex, flagZ_ex, flagN_ex);
	jump_unit jump_unit_ex (flagZ_ex, flagN_ex, BranchB_ex, BranchI_ex, BranchGEQ_ex, BranchLEQ_ex, PCSource_out_ex);

	// EX/MEM Segmentation
	segment_ex_mem ex_mem (clk, rst, MemToReg_ex, MemRead_ex, MemWrite_ex, RegWrite_ex,
						   alu_out_ex, RD3_ex, RA3_ex,
						   MemToReg_mem, MemRead_mem, MemWrite_mem, RegWrite_mem,
						   alu_out_mem, RD3_WD_mem, RA3_mem);

	// MEM
	ram mem(.address(alu_out_mem[15:0]), .clock(clk_mem), .data(RD3_WD_mem), .wren(MemWrite_mem), .q(data_out_mem)); 

	// MEM/WB Segmentation
	segment_mem_wb mem_wb (clk, rst, MemToReg_mem, RegWrite_mem, 
					data_out_mem, alu_out_mem, RA3_mem,
					MemToReg_wb, RegWrite_wb, data_out_wb, alu_out_wb, RA3_wb);

	// WB
	mux_2to1 #(.N(32)) mux_2to1_wb (alu_out_wb, data_out_wb, MemToReg_wb, data_mux_wb); //TODO: data_mux_id debería estar conectado a regfile

endmodule