module datapath (input clk, rst, start);;

	//IF
	logic pc_in, pc_out, pc_plus1, instruction;
	
	//ID
	logic [31:0] pc_id, inm_id, RD1_id, RD2_id, WD3_id;
	logic [27:0] instr_27_0;
	logic [4:0] instr_29_25;
	logic [3:0] instr_27_24, instr_21_18, instr_20_17, instr_7_4, instr_23_20,
			instr_16_13, instr_25_22, instr_24_21, instr_11_8, RA1, RA2, WA3_id;
	logic [2:0] ALUOp_id;
	logic [1:0] instr_31_30, ImmSrc, RegDtn, RegSrc1;
	logic JumpI_id, JumpCI_id, JumpCD_id, MemToReg_id, MemRead_id, MemWrite_id,
			ALUSrc_id, RegWrite_id, RegSrc2;
	
	//EX
	logic [31:0] pc_plus_inm, pc_ex, alu_op2, alu_res_ex, RD1_ex, RD2_ex, WD3_ex, inm_ex;
	
	//MEM
	
	//WB




endmodule