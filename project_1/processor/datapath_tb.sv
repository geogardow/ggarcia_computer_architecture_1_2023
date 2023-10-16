`timescale 1 ps / 1 ps
module datapath_tb();

logic clkFPGA, rst, start;

datapath dut(clkFPGA, rst, start);
	

	 always begin
		#1 clkFPGA = ~clkFPGA;
	 end
	 
	
initial begin
	start = 1'b0;
	rst = 1'b0;
	clkFPGA = 1'b1;
	#1;
	rst = 1'b1;
	#1;
	rst = 1'b0;
	
	#200;
	
	start = 1'b1;

end

endmodule 