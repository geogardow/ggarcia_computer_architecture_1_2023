module extend_mem(input logic [15:0] mem,
				  output logic [31:0] mem_out);

	always_comb begin
		
		mem_out = {{17{1'b0}}, mem};
	end
	
endmodule