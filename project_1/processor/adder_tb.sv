module adder_tb();
    // Inputs
    logic [31:0] A;
    logic [31:0] B;
    
    // Outputs
    logic [31:0] C;
    
    // Instantiate the adder module
    adder adder_inst (A,B,C);
    
    // Testbench
    initial begin
        // Initialize inputs
        A = 32'h0000000A;
        B = 32'h00000005;
        
        // Apply inputs and display outputs
        $display("Time\tA\tB\tC");
        $monitor("%t\t%h\t%h\t%h", $time, A, B, C);
        
    end
    
endmodule