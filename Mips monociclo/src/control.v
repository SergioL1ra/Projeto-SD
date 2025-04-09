module control (
    input [5:0] opcode,
    output reg reg_dst,
    output reg alu_src,
    output reg mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg [1:0] alu_op
);

always @(*) begin
    case (opcode)
        6'b000000: begin // R-type
            reg_dst = 1;
            alu_src = 0;
            mem_to_reg = 0;
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            jump = 0;
            alu_op = 2'b10;
        end
        6'b100011: begin // LW
            reg_dst = 0;
            alu_src = 1;
            mem_to_reg = 1;
            reg_write = 1;
            mem_read = 1;
            mem_write = 0;
            branch = 0;
            jump = 0;
            alu_op = 2'b00;
        end
        6'b101011: begin // SW
            reg_dst = 0; // Don't care
            alu_src = 1;
            mem_to_reg = 0; // Don't care
            reg_write = 0;
            mem_read = 0;
            mem_write = 1;
            branch = 0;
            jump = 0;
            alu_op = 2'b00;
        end
        6'b000100: begin // BEQ
            reg_dst = 0; // Don't care
            alu_src = 0;
            mem_to_reg = 0; // Don't care
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 1;
            jump = 0;
            alu_op = 2'b01;
        end
        6'b000010: begin // JUMP
            reg_dst = 0; // Don't care
            alu_src = 0; // Don't care
            mem_to_reg = 0; // Don't care
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            jump = 1;
            alu_op = 2'b00; // Don't care
        end
        default: begin // Default case
            reg_dst = 0;
            alu_src = 0;
            mem_to_reg = 0;
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            jump = 0;
            alu_op = 2'b00;
        end
    endcase
end

endmodule