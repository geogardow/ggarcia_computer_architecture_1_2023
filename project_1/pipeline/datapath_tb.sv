`timescale 1 ps / 1 ps
module datapath_tb();

logic clkFPGA, rst, R14_flag, R13_flag, R13_flag_out, finish;
logic [10:0] R6_audio;

datapath dut(clkFPGA, rst, R13_flag, R6_audio, R14_flag, R13_flag_out, finish);
	

	 always begin
		#1 clkFPGA = ~clkFPGA;
	 end
	 
	
initial begin
	// Inicialización de variables
	rst = 1'b0;
	clkFPGA = 1'b1;
	R14_flag = 1'b1;
	R13_flag = 1'b0;
	R13_flag_out = 1'b0;
	R6_audio = 10'd0;
	finish = 1'b0;
	#1;
	rst = 1'b1;
	#1;
	rst = 1'b0;
	
	// R13_flag = 0 --- debe saltar a la etiqueta end
	#200
	
	// Selección de algoritmo, no hay ningun cambio en el flujo del codigo porque no hay un reset 
	R13_flag = 1'b1;

	#200
	// Se hace el reset y se toma a R13_flag como 1, entonces no salta a la etiqueta end
	#1;
	rst = 1'b1;
	#1;
	rst = 1'b0;
	#200;



end

endmodule 