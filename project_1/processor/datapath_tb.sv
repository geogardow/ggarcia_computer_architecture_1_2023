`timescale 1 ps / 1 ps
module datapath_tb();

logic clkFPGA, rst, start, R14_flag;
logic [10:0] R6_audio;

datapath dut(clkFPGA, rst, start, R6_audio, R14_flag);
	

	 always begin
		#1 clkFPGA = ~clkFPGA;
	 end
	 
	
initial begin
	start = 1'b0;
	rst = 1'b0;
	clkFPGA = 1'b1;
	R14_flag = 1'b1;
	R6_audio = 10'd0;
	#1;
	rst = 1'b1;
	#1;
	rst = 1'b0;
	
	#200;
	
	start = 1'b1;

end

endmodule 