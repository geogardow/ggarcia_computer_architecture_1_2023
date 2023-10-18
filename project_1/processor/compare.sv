module compare(
   input logic signed [31 : 0] a,
	output logic signed [31 : 0] b
);

	assign b = (a > 0) & (a < 257605) ? a : 0;

endmodule
