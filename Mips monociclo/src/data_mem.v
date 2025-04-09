// data_mem.v
module data_mem (
    input clk,
    input mem_write,
    input [31:0] alu_result,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:255]; // Memória com 64 palavras de 32 bits

always @(posedge clk) begin
  if(mem_write) memory[alu_result[11:2]] <= write_data;
    read_data <= memory[alu_result[11:2]]; 
end

endmodule