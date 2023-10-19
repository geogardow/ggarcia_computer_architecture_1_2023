module alu_tb();

    // Inputs
    logic [31:0] A, B;
    logic [2:0] sel;
	 
	 logic [31:0] result;

    // Outputs
    logic [31:0] C;
    logic flagZ, flagN;

    // Instantiate ALU module
    alu alu_inst (
        .A(A),
        .B(B),
        .sel(sel),
        .C(C),
        .flagZ(flagZ),
        .flagN(flagN)
    );


    // Testbench stimulus
    initial begin
	 
        // Case 1: Addition
        A = 32'h0000000A;
        B = 32'h00000005;
        sel = 3'b000;
		  assign result = C;
		  $display(A, "+", B, "=", result);
		  #10;
			
        // Case 2: Subtraction
        A = 32'h0000000A;
        B = 32'h00000005;
        sel = 3'b001;
		  #10;

        // Case 3: Multiplication
        A = 32'h0000000A;
        B = 32'h00000003;
        sel = 3'b010;
        #10;

        // Case 4: Division
        A = 32'h0000000F;
        B = 32'h00000003;
        sel = 3'b011;
        #10;

        // Case 5: Artihmetic Right Shift
        A = 32'h0000000F;
        B = 5;
        sel = 3'b100;
        #10;

        // Case 6: Logical Right Shift
        A = 32'h0000000F;
        B = 5;
        sel = 3'b101;
        #10;

        // Case 5: AND
        A = 32'h0000000F;
        B = 5;
        sel = 3'b110;
        #10;

    end
	 
endmodule