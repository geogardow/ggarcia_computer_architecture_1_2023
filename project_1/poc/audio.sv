module audio(input logic read_arduino_in, input logic data, output logic PC_out, output logic flag, output logic led);

    assign PC_out = read_arduino_in ? data : 1'b0;
    assign flag = read_arduino_in;
	 assign led = read_arduino_in;

endmodule