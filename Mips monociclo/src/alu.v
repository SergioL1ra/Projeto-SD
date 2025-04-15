module ALU(
  	input [31:0] input1, input2,
  	input [3:0] alu_control,
  	output reg [31:0] alu_result,
    output zero
);
    always @(*) begin
      	case (alu_control)
            4'b0010: alu_result = input1 + input2; // add
            4'b0110: alu_result = input1 - input2; // sub
            4'b0000: alu_result = input1 & input2; // and
            4'b0001: alu_result = input1 | input2; // or
            4'b0111: alu_result = (input1 < input2) ? 1 : 0; // slt
            4'b0101: alu_result = input1 / input2; // div
            default: alu_result = 0;
        endcase
    end

  	assign zero = (alu_result == 0);
  
endmodule