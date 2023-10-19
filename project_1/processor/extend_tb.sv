module extend_tb();

    // Inputs
    logic [27:0] Instr;
    logic [1:0] ImmSrc;

    // Outputs
    logic [31:0] ExtImm;

    // Instantiate extend module
    extend uut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    // Testbench stimulus
    initial begin
        // Case 1: 27-bit unsigned immediate
        Instr = 28'hABCDEFA;
        ImmSrc = 2'b00;

        // Case 2: 17-bit unsigned immediate
        Instr = 28'hFAFAFAFA;
        ImmSrc = 2'b01;

        // Case 3: 24-bit two's complement shifted branch
        Instr = 28'hFFFAFAFA;
        ImmSrc = 2'b10;

        // Case 4: Default (undefined)
        Instr = 28'hFFFFFFFF;
        ImmSrc = 2'b11;

    end