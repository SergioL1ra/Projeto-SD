module AluDecoder(
    input [5:0] funct,
  	input [1:0] alu_op,
  	output reg [3:0] alu_control
);

    always @(*) begin
      	case (alu_op)
            2'b00: alu_control = 3'b010; // add
            2'b01: alu_control = 3'b110; // sub
            2'b10: begin // R-type
                case (funct) 
                    6'b100000: alu_control = 3'b010; // ADD
                    6'b100010: alu_control = 3'b110; // SUB
                    6'b101010: alu_control = 3'b111; // SLT
                    6'b011010: alu_control = 3'b101; // DIV
                    6'b100100: alu_control = 3'b000; // AND
                    6'b100101: alu_control = 3'b001; // OR
                    default: alu_control = 3'bxxx;
                endcase
            end
            default: alu_control = 3'b000;
        endcase
    end
endmodule