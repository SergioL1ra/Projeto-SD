`timescale 1ns / 1ps

module control_unity_tb;

    // Inputs
    reg [5:0] op;
    reg [5:0] funct;
    reg zero;
    reg branch;

    // Outputs
    wire memtoreg;
    wire memwrite;
    wire pcsrc;
    wire alusrc;
    wire regdst;
    wire regwrite;
    wire jump;
    wire [2:0] alu_control;

    // Instantiate the Unit Under Test (UUT)
    control_unity uut (
        .op(op),
        .funct(funct),
        .zero(zero),
        .branch(branch),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alu_control(alu_control)
    );

    initial begin
        // Initialize inputs
        op = 6'b000000;
        funct = 6'b000000;
        zero = 0;
        branch = 0;

        // Wait for global reset
        #10;

        // Test case 1: Branch and Zero active
        branch = 1;
        zero = 1;
        #10 $display("Test 1: pcsrc = %b (expected 1)", pcsrc);

        // Test case 2: Branch active, Zero inactive
        zero = 0;
        #10 $display("Test 2: pcsrc = %b (expected 0)", pcsrc);

        // Test case 3: Default operation
        op = 6'b100011; // Example opcode
        funct = 6'b100000; // Example funct
        branch = 0;
        zero = 0;
        #10 $display("Test 3: pcsrc = %b, alu_control = %b", pcsrc, alu_control);

        // Add more test cases as needed for other outputs

        // Finish simulation
        #10 $finish;
    end

endmodule