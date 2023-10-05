module program_counter(input clk, rst, input logic [31:0] PC, output logic [31:0] PC_out);

	logic [31:0] state, next_state;

	//actual state logic
	always_ff @ (posedge clk or posedge rst)
		if (rst) state = 32'd0;
		else
			state = next_state;

	//next state logic
	always_comb begin
		next_state = state + 32'd1; 

	end 
	//output logic
	assign PC_out = state;	

endmodule