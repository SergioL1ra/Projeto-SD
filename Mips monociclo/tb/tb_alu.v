`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg [31:0] input1;
    reg [31:0] input2;
    reg [3:0] alu_control;

    // Outputs
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU module
    alu uut (
        .input1(input1),
        .input2(input2),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Initialize inputs
        input1 = 0;
        input2 = 0;
        alu_control = 0;

        // Test ADD
        #10 input1 = 32'd10; input2 = 32'd20; alu_control = 4'b0010; // ADD
        #10 $display("ADD: result = %d, zero = %b", result, zero);

        // Test SUB
        #10 input1 = 32'd30; input2 = 32'd10; alu_control = 4'b0110; // SUB
        #10 $display("SUB: result = %d, zero = %b", result, zero);

        // Test AND
        #10 input1 = 32'hF0F0F0F0; input2 = 32'h0F0F0F0F; alu_control = 4'b0000; // AND
        #10 $display("AND: result = %h, zero = %b", result, zero);

        // Test OR
        #10 input1 = 32'hF0F0F0F0; input2 = 32'h0F0F0F0F; alu_control = 4'b0001; // OR
        #10 $display("OR: result = %h, zero = %b", result, zero);

        // Test SLT
        #10 input1 = 32'd5; input2 = 32'd10; alu_control = 4'b0111; // SLT
        #10 $display("SLT: result = %d, zero = %b", result, zero);

        // Test DIV
        #10 input1 = 32'd100; input2 = 32'd5; alu_control = 4'b1010; // DIV
        #10 $display("DIV: result = %d, zero = %b", result, zero);

        // Test DIV by zero
        #10 input1 = 32'd100; input2 = 32'd0; alu_control = 4'b1010; // DIV by zero
        #10 $display("DIV by zero: result = %h, zero = %b", result, zero);

        // Test default case
        #10 input1 = 32'd15; input2 = 32'd25; alu_control = 4'b1111; // Default
        #10 $display("Default: result = %d, zero = %b", result, zero);

        // Finish simulation
        #10 $finish;
    end

endmodule