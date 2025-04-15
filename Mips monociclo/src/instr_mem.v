module InstructionMemory(
	input [31:0] PC, 
  	output reg[31:0] instruction
);

  reg[31:0] memory[0:63];

  initial begin
    $readmemb("instructions.txt", memory, 0, 5);
  end

  always @(*) begin
      instruction = memory[PC >> 2];
  end
  
endmodule