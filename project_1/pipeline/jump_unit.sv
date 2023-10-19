module jump_unit(
	input FlagZ,
	input FlagN,
	input BranchB,
	input BranchI,
	input BranchGEQ,
	input BranchLEQ,
	output PCSource
	);
	
	// geq instruction
	// xor_gate_geq = FlagN ^ BranchGEQ;
	
	// and_gate_geq_1 = (FlagN ^ BranchGEQ) & BranchGEQ;	
	
	// and_gate_geq_2 = BranchGEQ & FlagZ;	
	
	// or_gate_geq = ((FlagN ^ BranchGEQ) & BranchGEQ) | (BranchGEQ & FlagZ);

	// leq instruction
	// and_gate_leq_1 = FlagN & BranchLEQ;	
	
	// and_gate_leq_2 = BranchLEQ & FlagZ;	
	
	// or_gate_leq = (FlagN & BranchLEQ) | (BranchLEQ & FlagZ);

	// eq instruction
	// and_gate_equal = FlagZ & BranchI;

	// final gate 
	// or_gate = ((FlagN & BranchLEQ) | (BranchLEQ & FlagZ)) | (((FlagN ^ BranchGEQ) & BranchGEQ) | (BranchGEQ & FlagZ)) | (FlagZ & BranchI) | BranchB;
	
	assign PCSource = ((FlagN & BranchLEQ) | (BranchLEQ & FlagZ)) | (((FlagN ^ BranchGEQ) & BranchGEQ) | (BranchGEQ & FlagZ)) | (FlagZ & BranchI) | BranchB;
	
endmodule