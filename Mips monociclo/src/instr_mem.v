module instr_mem(input [31:0] PC, output reg[31:0] instr);
    reg [31:0] memory [0:255]; // ROM com 64 palavras de 32 bits

    initial begin
        $readmemb("instructions.txt", memory, 0, 5);
    end
    always @(*) begin
        instr = memory[PC >> 2]; end
endmodule