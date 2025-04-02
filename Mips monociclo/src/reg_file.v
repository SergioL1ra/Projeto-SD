module reg_file (
    input clk,
    input reg_write,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [0:31]; // 32 registradores de 32 bits
    wire [31:0] reg_t2;
    assign reg_t2 = registers[10];

    // Leitura assíncrona
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // Escrita síncrona
    always @(posedge clk) begin
        if (reg_write && write_reg != 0) begin
            registers[write_reg] <= write_data;
            $display("[$time] registrador[%0d] <= %d", write_reg, write_data);
        end
        registers[0] <= 0; // <- Garante que $zero nunca muda e sempre retorna 0

    end

endmodule
