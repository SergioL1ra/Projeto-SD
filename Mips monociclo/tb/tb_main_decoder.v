`timescale 1ns / 1ps

module instr_mem_tb;

    reg [31:0] PC;
    wire [31:0] instr;

    instr_mem uut (
        .PC(PC),
        .instr(instr)
    );

    initial begin
        PC = 0;

        // Test instruction fetch
        #10 PC = 32'h00000000;
        #10 $display("Instruction at PC = %h: %h", PC, instr);

        #10 PC = 32'h00000004;
        #10 $display("Instruction at PC = %h: %h", PC, instr);

        #10 $finish;
    end

endmodule