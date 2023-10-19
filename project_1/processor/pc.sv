module pc(
	input clk,
	input rst,
	input load,
	input [31:0] pc_in,
	output [31:0] pc_out
	);
	
	logic [31:0] pc;
	logic [31:0] pc_temp;
	
	always_ff @(posedge clk) begin
	
		pc_temp <= pc;
			
	end
	
	always_ff @(negedge clk, negedge rst) begin
	
		if (rst == 0)
			pc <= 0;
		else if (load == 1)	 
			pc <= pc_in;
		else
			pc <= pc;
	
	end
			
	//assign pc_out = pc_temp;
	assign pc_out = pc == 32'd1024 ? 32'd1023 : pc;
	
endmodule 