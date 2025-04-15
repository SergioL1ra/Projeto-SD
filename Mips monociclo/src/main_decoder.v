module MainDecoder(
    input [5:0] op,
  	output reg mem_to_reg, mem_write, alu_src, reg_dst, reg_write, jump, branch,
    output reg[1:0] alu_op
);

    always @(*) begin    
        case(op)       
            6'b000000: begin // R-type
                reg_write = 1;
                reg_dst = 1;
                alu_src = 0;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b10;
            end
            6'b001000: begin // addi 
                reg_write = 1;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b00;
            end
            6'b000100: begin // beq 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 0;
                branch = 1;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b01;
            end
            6'b000010: begin // jump 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 0;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 0;
                jump = 1;
                alu_op = 2'b00;
            end
            6'b100011: begin // lw 
                reg_write = 1;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 0;
                mem_to_reg = 1;
                jump = 0;
                alu_op = 2'b00;
            end
            6'b101011: begin // sw 
                reg_write = 0;
                reg_dst = 0;
                alu_src = 1;
                branch = 0;
                mem_write = 1;
                mem_to_reg = 0;
                jump = 0;
                alu_op = 2'b00;
            end
            default: begin
                reg_write = 1'bx;
                reg_dst = 1'bx;
                alu_src = 1'bx;
                branch = 1'bx;
                mem_write = 1'bx;
                mem_to_reg = 1'bx;
                jump = 1'bx;
                alu_op = 2'bxx;
            end   
        endcase      
    end
endmodule
