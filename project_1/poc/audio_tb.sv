`timescale 1 ps / 1 ps
module audio_tb();

logic read_arduino_in, data, PC_out, flag;

	audio dut (read_arduino_in, data, PC_out, flag);
	
initial begin
	flag = 1'b0;
	PC_out = 8'd0;
	read_arduino_in = 1'b0;
	data = 1'b0;

	#50;
	
	read_arduino_in = 1'b1;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b0;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b1;
	data = 1'b10;
	
	#50;
	
	read_arduino_in = 1'b0;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b1;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b0;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b1;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b0;
	data = 1'b1;
		#50;
	
	read_arduino_in = 1'b1;
	data = 1'b1;
	
	#50;
	
	read_arduino_in = 1'b0;
	data = 1'b1;
end

endmodule 