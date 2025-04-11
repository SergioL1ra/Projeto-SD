`timescale 1ns / 1ps

module alu_decoder_tb;

    reg [1:0] alu_op;
    reg [5:0] funct;
    wire [3:0] alu_control;

    alu_decoder uut (
        .alu_op(alu_op),
        .funct(funct),
        .alu_control(alu_control)
    );

    initial begin
        alu_op = 2'b00; funct = 6'b000000;

        // Test lw/sw -> ADD
        #10 alu_op = 2'b00; funct = 6'bxxxxxx;
        #10 $display("ADD: alu_control = %b", alu_control);

        // Test beq -> SUB
        #10 alu_op = 2'b01; funct = 6'bxxxxxx;
        #10 $display("SUB: alu_control = %b", alu_control);

        // Test R-type ADD
        #10 alu_op = 2'b10; funct = 6'b100000;
        #10 $display("R-type ADD: alu_control = %b", alu_control);

        // Test R-type SUB
        #10 alu_op = 2'b10; funct = 6'b100010;
        #10 $display("R-type SUB: alu_control = %b", alu_control);

        // Test R-type SLT
        #10 alu_op = 2'b10; funct = 6'b101010;
        #10 $display("R-type SLT: alu_control = %b", alu_control);

        #10 $finish;
    end

endmodule