module extend(input logic [27:0] Instr,
				  input logic [1:0] ImmSrc,
				  output logic [31:0] ExtImm);

	always_comb
		case(ImmSrc)
		
			// 27-bit unsigned immediate
			2'b00: ExtImm = { {12{Instr[19]}}, Instr[19:0]};
			
			// 17-bit unsigned immediate
			2'b01: ExtImm = { {14{Instr[17]}}, Instr[17:0]};
			
			// 24-bit two's complement shifted branch
			2'b10: ExtImm = { {15{Instr[16]}}, Instr[16:0]};
			
			default: ExtImm = 32'bx; // undefined
		endcase
	
endmodule