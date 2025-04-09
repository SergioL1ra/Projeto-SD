module data_mem (
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:63]; // Memória com 64 palavras de 32 bits

    // Inicializa a memória com valores padrão (opcional)
    initial begin
        integer i;
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

    // Leitura assíncrona
    always @(*) begin
        if (mem_read) begin
            read_data = memory[addr[31:2]]; // Alinha o endereço à palavra
        end else begin
            read_data = 32'b0;
        end
    end

    // Escrita síncrona
    always @(posedge clk) begin
        if (mem_write) begin
            memory[addr[31:2]] <= write_data; // Alinha o endereço à palavra
        end
    end
endmodule