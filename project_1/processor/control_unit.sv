 module control_unit (input logic [1:0] instruction_type, 
								input logic [4:0] func,
								input logic rst,
								output logic BranchB, BranchI, BranchGEQ, BranchLEQ, MemToReg, MemRead, MemWrite, 
								output logic [2:0] ALUOp,
								output logic ALUSrc, RegWrite,
								output logic [1:0] ImmSrc, 
								output logic RegSrc2,RegSrc1);
			
	always_latch
	begin
		if(rst)
			begin
				BranchB = 0;
				BranchI = 0;
				BranchGEQ = 0;
				BranchLEQ = 0;
				MemToReg = 0;
				MemRead = 0;
				MemWrite = 0;
				ALUOp = 0;
				ALUSrc = 0;
				RegWrite = 0;
				ImmSrc = 0;
				RegSrc2 = 0;
				RegSrc1 = 0;
			end
		
		// Instrucciones de Datos sin inmediato:
		if (instruction_type == 2'b01 && func[4] == 1'b0)
			begin
				BranchB = 0;
				BranchI = 0;
				BranchGEQ = 0;
				BranchLEQ = 0;
				MemToReg = 0;
				MemRead = 0;
				MemWrite = 0;
				ALUSrc = 0;
				RegWrite = 1;
				ImmSrc = 2'bxx;
				RegSrc2 = 1'b0;
				RegSrc1 = 1'b0;
				
				// suma
				if (func[4:0] == 5'b00000)
					begin
						ALUOp = 3'b000;
					end
				// resta
				else if (func[4:0] == 5'b00001)
					begin
						ALUOp = 3'b001;
					end
				// mult
				else if (func[4:0] == 5'b00010)
					begin
						ALUOp = 3'b010;
					end
				// div
				else if (func[4:0] == 5'b00011)
					begin
						ALUOp = 3'b011;
					end
				// union
				else if (func[4:0] == 5'b01011)
					begin
						ALUOp = 3'b110;
					end
			end
		
		// Instrucciones de Datos con inmediato:
		if (instruction_type == 2'b01 && func[4] == 1'b1)
			begin
				BranchB = 0;
				BranchI = 0;
				BranchGEQ = 0;
				BranchLEQ = 0;
				MemToReg = 0;
				MemRead = 0;
				MemWrite = 0;
				ALUSrc = 1;
				RegWrite = 1;
				ImmSrc = 2'b10;
				RegSrc2 = 1'bx;
				RegSrc1 = 1'b0;
				
				// sumita
				if (func[4:0] == 5'b10100)
					begin
						ALUOp = 3'b000;
					end
				// restita
				if (func[4:0] == 5'b10101)
					begin
						ALUOp = 3'b001;
					end
				// multi
				if (func[4:0] == 5'b10110)
					begin
						ALUOp = 3'b010;
					end
				// divi
				if (func[4:0] == 5'b10111)
					begin
						ALUOp = 3'b011;
					end
				// cad
				if (func[4:0] == 5'b11000)
					begin
						ALUOp = 3'b100;
					end
				// cld
				if (func[4:0] == 5'b11001)
					begin
						ALUOp = 3'b101;
					end
				// cli
				if (func[4:0] == 5'b11010)
					begin
						ALUOp = 3'b110;
					end
				// unioncita
				if (func[4:0] == 5'b11100)
					begin
						ALUOp = 3'b110;
					end        
			end
			
		// Instrucciones de Control:
		if (instruction_type == 2'b10)
			begin
				MemToReg = 0;
				MemRead = 0;
				MemWrite = 0;
				ALUSrc = 0;
				ALUOp = 3'b001;
				RegWrite = 0;
				ImmSrc = 2'b00;
				RegSrc2 = 1'b1;
				RegSrc1 = 1'b1;
				
				// brinco instruction
				if (func[4:3] == 2'b00)
					begin
						BranchB = 1;
						BranchI = 0;
						BranchLEQ = 0;
						BranchGEQ = 0;
					end
				// leq instruction
				if (func[4:3] == 2'b01)
					begin
						BranchB = 0;
						BranchI = 0;
						BranchLEQ = 1;
						BranchGEQ = 0;
					end
				// igual instruction	
				if (func[4:3] == 2'b10)
					begin
						BranchB = 0;
						BranchI = 1;
						BranchLEQ = 0;
						BranchGEQ = 0;
					end
				// geq instruction
				if (func[4:3] == 2'b11)
					begin
						BranchB = 0;
						BranchI = 0;
						BranchLEQ = 0;
						BranchGEQ = 1;
					end
					
			end
			
		// Instrucciones de Memoria:
		if (instruction_type == 2'b00)
			begin
				BranchB = 0;
				BranchI = 0;
				BranchLEQ = 0;
				BranchGEQ = 0;
				ALUSrc = 1;
				ALUOp = 3'b000;
				ImmSrc = 2'b01;
				RegSrc2 = 1'bx;
				RegSrc1 = 1'b0;
				
				// guardar instruction
				if (func[4:3] == 2'b01)
					begin
						MemToReg = 1'bx;
						MemRead = 0;
						MemWrite = 1;
						RegWrite = 0;
					end
				// cargar instruction	
				if (func[4:3] == 2'b00)
					begin
						MemToReg = 1;
						MemRead = 1;
						MemWrite = 0;
						RegWrite = 1;
					end
					
			end
			
	end
endmodule