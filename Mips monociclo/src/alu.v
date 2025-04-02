module alu (
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);
    // Sinal de comparação para instruções tipo beq
    assign zero = (result === 32'b0);

    always @(*) begin
        case (alu_control)
            4'b0010: result = input1 + input2;                  // ADD, ADDI
            4'b0110: result = input1 - input2;                  // SUB
            4'b0000: result = input1 & input2;                  // AND
            4'b0001: result = input1 | input2;                  // OR
            4'b0111: result = (input1 < input2) ? 32'b1 : 32'b0; // SLT
            default: result = 32'b0;
        endcase
    end
endmodule
