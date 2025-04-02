module instr_mem(input [31:0] addr, output [31:0] instr);
    reg [31:0] memory [0:63]; // ROM com 64 palavras de 32 bits

    initial begin
        memory[0] = 32'h20080005; // addi $t0, $zero, 5
        memory[1] = 32'h2009000A; // addi $t1, $zero, 10
        memory[2] = 32'h01095020; // add  $t2, $t0, $t1
        memory[3] = 32'h00000000; // NOP
        memory[4] = 32'h00000000; // NOP
        memory[5] = 32'h00000000; // NOP
        memory[6] = 32'h00000000; // NOP
        memory[7] = 32'h00000000; // NOP
    end

    assign instr = (addr[31:2] < 64) ? memory[addr[31:2]] : 32'h00000000;
endmodule
