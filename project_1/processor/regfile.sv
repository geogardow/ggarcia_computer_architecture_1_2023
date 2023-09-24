module regfile (input logic clk,
					 input logic we3,
					 input logic [3:0] ra1, ra2, wa3,
					 input logic [31:0] wd3, r15,
					 output logic [31:0] rd1, rd2);
					 
	logic [31:0] rf[14:0];
	
	// writing on wa3 (posedge)
	always_ff @(posedge clk) 
		if (we3) rf[wa3] <= wd3;
		
	// reading from ra1 and ra2 (negedge)
	always_ff @(negedge clk)
	begin
		assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
		assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
	end