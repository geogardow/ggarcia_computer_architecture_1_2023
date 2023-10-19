module regfile_Tb();

    // Inputs
    logic [3:0] RS1, RS2, RS3, RD;
    logic [31:0] WD;
    logic R13_flag, wr_enable, clk, rst;
    
    // Outputs
    logic [31:0] RD1, RD2, RD3;
    logic [10:0] R6_audio;
    logic R14_flag, R13_flag_out, finish;

    // Instantiate regfile module
    regfile uut (
        .RS1(RS1),
        .RS2(RS2),
        .RS3(RS3),
        .RD(RD),
        .WD(WD),
        .R13_flag(R13_flag),
        .wr_enable(wr_enable),
        .clk(clk),
        .rst(rst),
        .RD1(RD1),
        .RD2(RD2),
        .RD3(RD3),
        .R6_audio(R6_audio),
        .R14_flag(R14_flag),
        .R13_flag_out(R13_flag_out),
        .finish(finish)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize inputs
        RS1 = 4'd2;  // Example RS1 value
        RS2 = 4'd5;  // Example RS2 value
        RS3 = 4'd10; // Example RS3 value
        RD = 4'd7;   // Example RD value
        WD = 32'hAABBCCDD; // Example WD value
        R13_flag = 1'b1;    // Example R13_flag value
        wr_enable = 1'b1;   // Enable write operation
        clk = 1'b0;         // Initial clock state
        rst = 1'b1;         // Reset active (high) initially
        
        // Release reset after some time
        #20 rst = 1'b0;
        
        // Testbench logic
        #10 wr_enable = 1'b0; // Disable write operation
        #10 RS1 = 4'd3;  // Change RS1 value
        #10 RS2 = 4'd7;  // Change RS2 value
        #10 RS3 = 4'd15; // Change RS3 value
        #10 RD = 4'd1;   // Change RD value
        #10 WD = 32'h12345678; // Change WD value
    end

endmodule