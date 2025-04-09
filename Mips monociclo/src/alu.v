module alu (
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] alu_control,

    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (alu_control)
            4'b0010: result = input1 + input2;                  // ADD, ADDI
            4'b0110: result = input1 - input2;                  // SUB
            4'b0000: result = input1 & input2;                  // AND
            4'b0001: result = input1 | input2;                  // OR
            4'b0111: result = (input1 < input2) ? 1 : 0;        //SLT
            4'b1010:
            begin
                if(input2!=0)result = input1 / input2;          //DIV
                else alu_result = 32'b11111111111111111111111111111111;
            end
            default: result = 0;
        endcase
    end
    assign zero = (result==0);
endmodule
