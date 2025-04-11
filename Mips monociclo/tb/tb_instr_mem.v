`timescale 1ns / 1ps

module instr_mem_tb;

    // Inputs
    reg [31:0] PC;

    // Outputs
    wire [31:0] instr;

    // Instantiate the Unit Under Test (UUT)
    instr_mem uut (
        .PC(PC),
        .instr(instr)
    );

    initial begin
        // Initialize inputs
        PC = 0;

        // Wait for global reset
        #10;

        // Test case 1: Read instruction at address 0
        PC = 32'h00000000;
        #10;
        $display("Instruction at PC = %h: %h", PC, instr);

        // Test case 2: Read instruction at address 4
        PC = 32'h00000004;
        #10;
        $display("Instruction at PC = %h: %h", PC, instr);

        // Test case 3: Read instruction at address 8
        PC = 32'h00000008;
        #10;
        $display("Instruction at PC = %h: %h", PC, instr);

        // Test case 4: Read instruction at address 12
        PC = 32'h0000000C;
        #10;
        $display("Instruction at PC = %h: %h", PC, instr);

        // Test case 5: Read instruction at an invalid address
        PC = 32'h00000020; // Outside the range of loaded instructions
        #10;
        $display("Instruction at PC = %h: %h", PC, instr);

        // Finish simulation
        #10 $finish;
    end

endmodule