module alu_decoder (
    input [1:0] alu_op,
    input [5:0] funct,
    output reg [3:0] alu_control
);
    always @(*) 
    begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // lw/sw -> ADD
            2'b01: alu_control = 4'b0110; // beq   -> SUB
            2'b10: 
            begin                  // R-type
                case (funct)
                    6'b100000: alucontrol = 4'b0010; // ADD
                    6'b100010: alucontrol = 4'b0110; // SUB
                    6'b101010: alucontrol = 4'b0111; // SLT
                    6'b011010: alucontrol = 4'b1010; // DIV
                    6'b100100: alucontrol = 4'b0000; // AND
                    6'b100101: alucontrol = 4'b0001; // OR
                    default: alucontrol = 4'bxxxx;
                endcase
            end
            default: alu_control = 4'b0000;
        endcase
    end
endmodule
