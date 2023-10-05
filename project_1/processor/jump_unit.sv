module jump_unit(
	input FlagZ,
	input BranchNI,
	input BranchI,
	input BranchB,
	output PCSource
	);
	
	// xor_gate = FlagZ ^ BranchNI
	
	// and_gate_1 = (FlagZ ^ BranchNI) & BranchNI	
	
	// and_gate_2 = FlagZ & BranchI	
	
	// or_gate = ((FlagZ ^ BranchNI) & BranchNI) | BranchB | (FlagZ & BranchI)
	
	assign PCSource = ((FlagZ ^ BranchNI) & BranchNI) | BranchB | (FlagZ & BranchI);
	
endmodule